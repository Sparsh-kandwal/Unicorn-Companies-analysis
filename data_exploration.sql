USE UnicornCompanies

SELECT *
FROM companies
ORDER BY 1 ASC;


DROP TABLE IF EXISTS unicorn_info;
DROP TABLE IF EXISTS unicorn_finance;



CREATE TABLE unicorn_info (
    ID INT PRIMARY KEY,
    Company VARCHAR(255),
    Industry VARCHAR(255),
    City VARCHAR(255),
    Country VARCHAR(255),
    Continent VARCHAR(255),
    YearFounded INT
);

INSERT INTO unicorn_info (ID, Company, Industry, City, Country, Continent, YearFounded)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Company) AS ID,  -- Generating unique ID
    Company, 
    Industry, 
    City, 
    Country, 
    Continent, 
    YearFounded
FROM companies;

CREATE TABLE unicorn_finance (
    ID INT PRIMARY KEY,
    Valuation DECIMAL(15,2),
    Funding DECIMAL(15,2),
    Year INT,
    SelectInvestors TEXT
);

INSERT INTO unicorn_finance (ID, Valuation, Funding, Year, SelectInvestors)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Company) AS ID,  -- Matching ID to unicorn_info
    Valuation, 
    Funding, 
    YEAR(DateJoined) AS Year,  -- Extracting year from Date_Joined
    SelectInvestors
FROM companies;



-- Total Unicorn Companies

WITH UnicornCom AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID
)
SELECT COUNT(*) AS TotalUnicorns
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0;


WITH UnicornCom AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID
)
SELECT COUNT(DISTINCT Country) AS Country
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0

SELECT 
    ui.Company, 
    (CAST(uf.Valuation AS SIGNED) - CAST(uf.Funding AS SIGNED)) * 1.0 / CAST(uf.Funding AS SIGNED) AS Roi
FROM unicorn_finance uf
JOIN unicorn_info ui ON uf.ID = ui.ID  -- Join to get 'Company' column
WHERE uf.Funding > 0  -- Prevent division by zero
ORDER BY Roi DESC
LIMIT 10;


WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, YearUnicorn, SelectInvestors) AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID)
SELECT CAST(AVG(YearUnicorn - YearFounded) AS DECIMAL(5,2)) AS AvgYearsToUnicorn
FROM UnicornCom

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, YearUnicorn, SelectInvestors) AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID)
SELECT YearUnicorn-YearFounded AS Unicorn_year,COUNT(1) AS Frequency
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0
GROUP BY YearUnicorn-YearFounded
ORDER BY COUNT(1) DESC
LIMIT 10;

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, YearUnicorn, SelectInvestors) AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID)
SELECT Industry, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0
GROUP BY Industry
ORDER BY COUNT(1) DESC

WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, YearUnicorn, SelectInvestors) AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID)
SELECT Industry,FLOOR((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM UnicornCom))) AS Percentage
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0
GROUP BY Industry
ORDER BY COUNT(1) DESC


WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, YearUnicorn, SelectInvestors) AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID)
SELECT Country, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0
GROUP BY Country
ORDER BY COUNT(1) DESC



WITH UnicornCom (ID, Company, Industry, City, Country, Continent, Valuation, Funding, YearFounded, YearUnicorn, SelectInvestors) AS (
    SELECT 
        inf.ID, 
        inf.Company, 
        inf.Industry, 
        inf.City, 
        inf.Country, 
        inf.Continent, 
        fin.Valuation, 
        fin.Funding, 
        inf.YearFounded, 
        fin.Year AS YearUnicorn,  -- Renamed for clarity
        fin.SelectInvestors
    FROM unicorn_info AS inf
    INNER JOIN unicorn_finance AS fin 
        ON inf.ID = fin.ID)
SELECT Country,COUNT(1) AS Frequency,FLOOR((COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom))) AS Percentage
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0
GROUP BY Country
ORDER BY COUNT(1) DESC
LIMIT 10;

SELECT *
FROM unicorn_finance
ORDER BY 1 ASC;

UPDATE unicorn_finance
SET SelectInvestors = REPLACE(SelectInvestors, ', ', ',');

SELECT 
    TRIM(investor) AS Investors, 
    COUNT(*) AS UnicornInvested
FROM unicorn_finance,
    JSON_TABLE(
        CONCAT('["', REPLACE(SelectInvestors, ',', '","'), '"]'),  -- Convert comma-separated string to JSON array
        "$[*]" COLUMNS (investor VARCHAR(255) PATH "$")
    ) AS SplitInvestors
GROUP BY Investors
ORDER BY UnicornInvested DESC
LIMIT 10;










