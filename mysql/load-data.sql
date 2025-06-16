
USE mydb;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/M10-Monthly_COE_Revalidation.csv'
INTO TABLE coe-revalidation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@month, @type, @category, @number_revalidated)
SET
    month = STR_TO_DATE(CONCAT(@month, '-01'), '%Y-%m-%d'),
    number_revalidated = @number,
    type = @type,
    category = @category;

LOAD DATA INFILE '/docker-entrypoint-initdb.d/M11-coe_results.csv'
INTO TABLE coe-results
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@month, @bidding_no, @vehicle_class, @quota, @bids_success, @bids_received, @premium)
SET
    month = STR_TO_DATE(CONCAT(@month, '-01'), '%Y-%m-%d'),
    bidding_no = @bidding_no,
    category = @vehicle_class,
    quota = @quota,
    bids_success = @bids_success,
    bids_received = @bids_received,
    premium = @premium;