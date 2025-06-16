CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE IF NOT EXISTS coe-revalidation (
    month VARCHAR(7),
    type VARCHAR(10),
    category VARCHAR(10),
    number_revalidated INT,
    PRIMARY KEY (month, type, category)
);

CREATE TABLE IF NOT EXISTS coe-results (
    month VARCHAR(7),
    bidding_no INT,
    category VARCHAR(10),
    quota INT,
    bids_success INT,
    bids_received INT,
    premium INT,
    PRIMARY KEY (month, bidding_no, category)
);

CREATE TABLE IF NOT EXISTS monthly-analysis (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10,2)
);