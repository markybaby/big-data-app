# Load required package
if (!requireNamespace("RMySQL", quietly = TRUE)) {
  install.packages("RMySQL", repos = "https://cloud.r-project.org")
}
library(RMySQL)

# Connect to MySQL
con <- dbConnect(
  MySQL(),
  user = 'root',
  password = 'root',
  dbname = 'mydb',
  host = Sys.getenv("MYSQL_HOST"),
  port = 3306
)

# Run test query
result <- dbGetQuery(con, "SELECT COUNT(*) AS count FROM coe_results")
print(result)

# Debug output
print("FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUCK")

# Clean up
dbDisconnect(con)
