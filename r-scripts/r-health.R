library(DBI)
library(RMySQL)
library(httpuv)

max_attempts <- 30
attempt <- 1
connected <- FALSE

# Debug output
print("[DEBUG] entered r-health.R file")

# Wait for MySQL to be ready
while (attempt <= max_attempts && !connected) {
  cat(sprintf("[WAIT] Attempt %d: Checking for 'mydb'...\n", attempt))
  tryCatch({
    con <- dbConnect(
      RMySQL::MySQL(),
      host = "mysql",
      user = "root",
      password = "root"
    )
    dbs <- dbGetQuery(con, "SHOW DATABASES;")
    if ("mydb" %in% dbs[[1]]) {
      connected <- TRUE
      cat("[SUCCESS] 'mydb' is now available.\n")
    } else {
      dbDisconnect(con)
      Sys.sleep(2)
      attempt <<- attempt + 1
    }
  }, error = function(e) {
    Sys.sleep(2)
    attempt <<- attempt + 1
  })
}

cat("[WAIT] Waiting for test.R to run and insert data...\n")
Sys.sleep(10)  # Give test.R some time to run and insert data

cat("[CHECK] Now checking if monthly_analysis table has data...\n")
check_ready <- function() {
  tryCatch({
    con <- dbConnect(
      RMySQL::MySQL(),
      dbname = "mydb",
      host = "mysql",
      user = "root",
      password = "root"
    )
    
    result <- dbGetQuery(con, "SELECT COUNT(*) AS count FROM monthly_analysis;")
    dbDisconnect(con)
    
    return(result$count[1] > 0)
  }, error = function(e) {
    return(FALSE)  # Return FALSE on connection or query failure
  })
}

app <- list(
  call = function(req) {
    if (check_ready()) {
      list(status = 200L, headers = list("Content-Type" = "text/plain"), body = "OK")
    } else {
      list(status = 503L, headers = list("Content-Type" = "text/plain"), body = "Data not ready")
    }
  }
)

cat("Starting MySQL health-check server on port 8000...\n")
runServer("0.0.0.0", 8000, app)

# End process after grafana is running
cat("Waiting for 30 seconds before ending the process...\n")
Sys.sleep(30)
cat("Ending the process now...\n")
q("no")