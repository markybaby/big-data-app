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

print("[DEBUG] successfully connected to MySQL")

# Debug output
# print("[DEBUG] running test query now...")

# Run test query
# result <- dbGetQuery(con, "SELECT COUNT(*) AS count FROM coe_results")
# print(result)

# Truncate monthly_analysis table
dbExecute(con, "TRUNCATE TABLE monthly_analysis;")

# cat("Inserted test data into monthly_analysis table.\n")

# Load data from coe_revalidation and coe_results tables
reval <- dbReadTable(con, "coe_revalidation")
results <- dbReadTable(con, "coe_results")

# === Data Processing ===
print("[DEBUG] Processing data...")

# Sum of number_revalidated by month and category
reval_summary <- reval %>%
    group_by(month, category) %>%
    summarise(number_revalidated = sum(number_revalidated), .groups = "drop")

# Average premium by month and category
results_summary <- results %>%
    group_by(month, category) %>%
    summarise(avg_premium = round(mean(premium), 2), .groups = "drop")

# Ensure month is Date and category is uppercase (or lowercase, just consistent)
reval_summary <- reval_summary %>%
    mutate(
        month = as.Date(month),
        category = toupper(trimws(category))
)

results_summary <- results_summary %>%
    mutate(
        month = as.Date(month),
        category = toupper(trimws(category))
)

# Debug output for processed data
# print("[DEBUG] reval_summary sample:")
# print(head(reval_summary, 10))

# print("[DEBUG] results_summary sample:")
# print(head(results_summary, 10))

# === Merging Data ===
print("[DEBUG] Merging data...")
analysis <- reval_summary %>%
    inner_join(results_summary, by = c("month", "category")) %>%
    arrange(month, category)

# Debug output for merged data
print("[DEBUG] analysis sample after join:")
print(head(analysis, 10))

# Replace NULLs with 0s if needed
analysis$number_revalidated[is.na(analysis$number_revalidated)] <- 0
analysis$avg_premium[is.na(analysis$avg_premium)] <- 0

# === Adding processed data to monthly_analysis Table ===

# Clear the table
dbExecute(con, "DELETE FROM monthly_analysis")

# Insert rows
print("[DEBUG] Inserting processed data into monthly_analysis table...")
#dbWriteTable(con, "monthly_analysis", analysis, append = TRUE, row.names = FALSE)
for (i in 1:nrow(analysis)) {
  # Safely build the SQL string using sprintf
  row <- analysis[i, ]
  sql <- sprintf(
    "INSERT INTO monthly_analysis (month, category, number_revalidated, avg_premium) VALUES ('%s', '%s', %d, %.2f)",
    row$month,
    row$category,
    as.integer(row$number_revalidated),
    row$avg_premium
  )
  
  dbExecute(con, sql)
}

# Verify
print("[DEBUG] Verifying data in monthly_analysis table...")
result <- dbGetQuery(con, "SELECT * FROM monthly_analysis LIMIT 20;")
print(result)

# Clean up
dbDisconnect(con)
