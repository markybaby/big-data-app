CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE IF NOT EXISTS coe-revalidation (
    month VARCHAR(7),
    type VARCHAR(10),
    category VARCHAR(10),
    number INT,
    PRIMARY KEY (month, type, category)
);

CREATE TABLE IF NOT EXISTS coe-results (
    id INT PRIMARY KEY,
    product_id INT,
    quantity INT
);

CREATE TABLE IF NOT EXISTS monthly-analysis (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10,2)
);