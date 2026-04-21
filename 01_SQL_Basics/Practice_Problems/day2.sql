-- SQL Practice – Day 2 (Filtering & Query Patterns)

-- 1. High Population Countries
SELECT name
FROM world
WHERE population > 100000000;

-- 2. Specific Countries
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

-- 3. Countries with 'United' in Name
SELECT name
FROM world
WHERE name LIKE '%United%';

-- 4. Population in Millions
SELECT name, population/1000000 AS population_millions
FROM world;

-- 5. Large Area OR Population
SELECT name
FROM world
WHERE area > 3000000 OR population > 250000000;

-- 6. Population Range
SELECT name, population
FROM world
WHERE population BETWEEN 50000000 AND 200000000;

-- 7. GDP Per Capita
SELECT name, gdp/population AS pc_gdp
FROM world;

-- 8. Same Length Name & Capital
SELECT name, capital
FROM world
WHERE LEN(name) = LEN(capital);

-- 9. XOR Condition
SELECT name
FROM world
WHERE (area > 3000000 OR population > 250000000)
AND NOT (area > 3000000 AND population > 250000000);

-- 10. Same Starting Letter
SELECT name, capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1);

-- 11. Rounded GDP Per Capita
SELECT name, ROUND((gdp/population), -3) AS pc_gdp
FROM world;

-- 12. Combined Filters
SELECT name, population
FROM world
WHERE population > 50000000
AND name LIKE '%a%';

-- 13. Multiple Conditions + Range
SELECT name
FROM world
WHERE area BETWEEN 1000000 AND 5000000
OR population > 200000000;
