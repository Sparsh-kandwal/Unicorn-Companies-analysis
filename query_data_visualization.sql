USE UnicornCompanies;

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
SELECT COUNT(1) AS Unicorn
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0;



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
SELECT COUNT(DISTINCT Country) AS Country
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0;

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
SELECT Company,Country
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0


SELECT inf.Company, (CAST(uf.Valuation AS SIGNED) - CAST(uf.Funding AS SIGNED)) * 1.0 / CAST(uf.Funding AS SIGNED) AS Roi
FROM unicorn_finance as uf
INNER JOIN unicorn_info as inf
    ON uf.ID = inf.ID
ORDER BY Roi DESC

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
SELECT Company,(YearUnicorn - YearFounded) AS Unicornyear
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0


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
SELECT (YearUnicorn - YearFounded) AS Unicornyear, COUNT(1) AS Frequency
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0
GROUP BY Unicornyear
ORDER BY Count(1) DESC

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
SELECT Industry, COUNT(1) AS Frequency,CAST(COUNT(1) * 100.0 / (SELECT COUNT(1) FROM UnicornCom WHERE (YearUnicorn - YearFounded) >= 0) AS DECIMAL(5,2)) AS Percentage
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
SELECT Country, COUNT(1) AS Frequency,CAST(COUNT(1) * 100.0 / (SELECT COUNT(*) FROM UnicornCom)AS DECIMAL(5,2)) AS Percentage
FROM UnicornCom
WHERE (YearUnicorn - YearFounded) >= 0
GROUP BY Country
ORDER BY COUNT(1) DESC


-- Query to count the number of unicorns invested by each investor
CREATE TEMPORARY TABLE investors_unicorns AS
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(SelectInvestors, ',', numbers.n), ',', -1)) AS Investor, 
    COUNT(*) AS UnicornsInvested
FROM unicorn_finance
JOIN (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers
ON CHAR_LENGTH(SelectInvestors) - CHAR_LENGTH(REPLACE(SelectInvestors, ',', '')) >= numbers.n - 1
GROUP BY Investor
ORDER BY UnicornsInvested DESC;

SELECT * FROM investors_unicorns;
