SET GLOBAL local_infile = 1;
USE mydb;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/M10-Monthly_COE_Revalidation.csv'
INTO TABLE coe_revalidation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@month, @type, @category, @number)
SET
    month = STR_TO_DATE(CONCAT(@month, '-01'), '%Y-%m-%d'),
    number_revalidated = CAST(REPLACE(@number, ',', '') AS UNSIGNED),
    type = @type,
    category = @category;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/M11-coe_results.csv'
INTO TABLE coe_results
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@month, @bidding_no, @vehicle_class, @quota, @bids_success, @bids_received, @premium)
SET
    month = STR_TO_DATE(CONCAT(@month, '-01'), '%Y-%m-%d'),
    bidding_no = @bidding_no,
    category = @vehicle_class,
    quota = CAST(REPLACE(@quota, ',', '') AS UNSIGNED),
    bids_success = CAST(REPLACE(@bids_success, ',', '') AS UNSIGNED),
    bids_received = CAST(REPLACE(@bids_received, ',', '') AS UNSIGNED),
    premium = CAST(REPLACE(@premium, ',', '') AS UNSIGNED);