
USE mydb;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
