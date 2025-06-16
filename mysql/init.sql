CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE IF NOT EXISTS coe-revalidation (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS coe-results (
    id INT PRIMARY KEY,
    product_id INT,
    quantity INT
);