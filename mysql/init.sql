CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE IF NOT EXISTS coe_revalidation (
    month DATE,
    type VARCHAR(10),
    category VARCHAR(10),
    number_revalidated INT,
    PRIMARY KEY (month, type, category)
);

CREATE TABLE IF NOT EXISTS coe_results (
    month DATE,
    bidding_no INT,
    category VARCHAR(10),
    quota INT,
    bids_success INT,
    bids_received INT,
    premium INT,
    PRIMARY KEY (month, bidding_no, category)
);

CREATE TABLE IF NOT EXISTS monthly_analysis (
    month DATE,
    category VARCHAR(10),
    number_revalidated INT,
    avg_premium INT,
    PRIMARY KEY (month, category)
);