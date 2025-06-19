# Load required package
if (!requireNamespace("RMySQL", quietly = TRUE)) {
  install.packages("RMySQL", repos = "https://cloud.r-project.org")
}
library(RMySQL)
library(dplyr)
library(DBI)

max_attempts <- 30
attempt <- 1
connected <- FALSE

# Debug output
print("[DEBUG] entered test.R file")

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

# Connect to MySQL
con <- dbConnect(
  MySQL(),
  user = "root",
  password = "root",
  dbname = "mydb",
  host = "mysql",
  port = 3306
)

# Debug output
print("[DEBUG] successfully connected to MySQL")
print("[DEBUG] running test query now...")

# Run test query
result <- dbGetQuery(con, "SELECT COUNT(*) AS count FROM coe_results")
print(result)

# Truncate monthly_analysis table
dbExecute(con, "TRUNCATE TABLE monthly_analysis;")

cat("Inserting test data into monthly_analysis table...\n")

# Insert some test data into monthly_analysis table
dbExecute(con, "
  INSERT INTO monthly_analysis (month, category, number_revalidated, premium) VALUES
  ('2005-01-01', 'Category A', 100, 50),
  ('2005-02-01', 'Category B', 150, 75),
  ('2005-03-01', 'Category C', 200, 100);
")

cat("Inserted test data into monthly_analysis table.\n")

# Verify
result <- dbGetQuery(con, "SELECT * FROM monthly_analysis;")
print(result)

# Clean up
dbDisconnect(con)
