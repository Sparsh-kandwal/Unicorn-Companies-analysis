USE UnicornCompanies;

-- Drop the existing companies table
DROP TABLE IF EXISTS companies;

-- Recreate the companies table with all columns from the CSV file
CREATE TABLE companies (
    Company VARCHAR(20),
    Valuation VARCHAR(25),
    Date_Joined DATE,
    Industry VARCHAR(25),
    City VARCHAR(25),
    Country VARCHAR(25),
    Continent VARCHAR(25),
    Year_Founded INT,
    Funding VARCHAR(25),
    Select_Investors TEXT
);

-- Check the secure file path setting
SHOW VARIABLES LIKE 'secure_file_priv';

-- Load data from CSV file into the companies table
LOAD DATA LOCAL INFILE 'e:\\Unicorn+Companies\\Unicorn_Companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS
(Company, Valuation, Date_Joined, Industry, City, Country, Continent, Year_Founded, Funding, Select_Investors);

-- Verify the number of rows loaded
SELECT COUNT(*) AS total_rows_loaded FROM companies;

SHOW COLUMNS FROM companies;

SELECT COUNT(*) FROM companies;

SELECT COUNT(DISTINCT Company) AS total_distinct_companies FROM companies;

SELECT *
FROM companies
ORDER BY 1 ASC;

SELECT Company, COUNT(Company)
FROM companies
GROUP BY Company
HAVING COUNT(Company) > 1;

ALTER TABLE companies
CHANGE COLUMN Date_Joined DateJoined DATE;

ALTER TABLE companies
CHANGE COLUMN Year_Founded YearFounded INT,
CHANGE COLUMN Select_Investors SelectInvestors TEXT;

ALTER TABLE companies
ADD DateJoinedConverted DATE;

UPDATE companies
SET DateJoinedConverted = STR_TO_DATE(DateJoined, '%Y-%m-%d');

ALTER TABLE companies
ADD Year INT;

UPDATE companies
SET Year = YEAR(DateJoinedConverted);

ALTER TABLE companies
ADD Month INT;

UPDATE companies
SET Month = MONTH(DateJoinedConverted);

ALTER TABLE companies
ADD Day INT;

UPDATE companies
SET Day = DAY(DateJoinedConverted);

SELECT * 
FROM companies;

DELETE FROM companies
WHERE Funding IN ('$0M', 'Unknown');

SELECT DISTINCT Funding
FROM companies
ORDER BY Funding DESC;

UPDATE companies
SET Valuation = RIGHT(Valuation, LENGTH(Valuation) - 1);

UPDATE companies
SET Valuation = REPLACE(REPLACE(Valuation, 'B', '000000000'), 'M', '000000');

UPDATE companies
SET Funding = RIGHT(Funding, LENGTH(Funding) - 1);

UPDATE companies
SET Funding = REPLACE(REPLACE(Funding, 'B', '000000000'), 'M', '000000');

SELECT *
FROM companies;

ALTER TABLE companies
DROP COLUMN DateJoined;

ALTER TABLE companies
CHANGE COLUMN DateJoinedConverted DateJoined DATE;

SELECT * 
FROM companies;









