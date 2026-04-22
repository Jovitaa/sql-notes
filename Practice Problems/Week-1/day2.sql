-- =========================================
-- DAY 2 SQL PRACTICE (QUERY PATTERNS)
-- Concepts: SELECT, WHERE, LIKE, IN, BETWEEN, AND/OR, NOT, ORDER BY, LIMIT, Calculations
-- Source: SQLZoo
-- =========================================


-- ==================================================
-- PRACTICE PROBLEMS
-- ==================================================



-- Concept: SELECT *
-- Difficulty: Easy
-- Question:
-- Retrieve all columns from the world table.

SELECT *
FROM world;

-- Tip:
-- Use * to return all columns.
-- Good for exploring a table, but in real projects select only needed columns.


--------------------------------------------------


-- Concept: SELECT specific columns
-- Difficulty: Easy
-- Question:
-- Retrieve name, population, and area of all countries.

SELECT name, population, area
FROM world;

-- Tip:
-- Selecting only required columns improves readability and performance.


--------------------------------------------------


-- Concept: WHERE + Comparison Operator
-- Difficulty: Easy
-- Question:
-- Find countries with population greater than 100 million.

SELECT name, population
FROM world
WHERE population > 100000000;

-- Tip:
-- Use comparison operators such as >, <, >=, <= to filter numeric values.


--------------------------------------------------


-- Concept: WHERE + Less Than
-- Difficulty: Easy
-- Question:
-- Find countries with area less than 500,000.

SELECT name, area
FROM world
WHERE area < 500000;

-- Tip:
-- WHERE clause filters rows before displaying results.


--------------------------------------------------


-- Concept: AND Operator
-- Difficulty: Medium
-- Question:
-- Find countries with population greater than 50 million and area greater than 1 million.

SELECT name, population, area
FROM world
WHERE population > 50000000
AND area > 1000000;

-- Tip:
-- AND returns rows only when both conditions are true.


--------------------------------------------------


-- Concept: OR Operator
-- Difficulty: Medium
-- Question:
-- Find countries with population greater than 200 million or area greater than 3 million.

SELECT name, population
FROM world
WHERE population > 200000000
OR area > 3000000;

-- Tip:
-- OR returns rows when at least one condition is true.


--------------------------------------------------


-- Concept: IN Operator
-- Difficulty: Easy
-- Question:
-- Retrieve details for specific countries: India, China, and United States.

SELECT name, population
FROM world
WHERE name IN ('India', 'China', 'United States');

-- Tip:
-- IN is cleaner than writing multiple OR conditions for the same column.


--------------------------------------------------


-- Concept: BETWEEN Operator
-- Difficulty: Easy
-- Question:
-- Find countries with population between 50 million and 200 million.

SELECT name, population
FROM world
WHERE population BETWEEN 50000000 AND 200000000;

-- Tip:
-- BETWEEN includes both boundary values.
-- Equivalent to population >= 50000000 AND population <= 200000000.


--------------------------------------------------


-- Concept: LIKE Operator
-- Difficulty: Easy
-- Question:
-- Find countries whose name starts with 'A'.

SELECT name
FROM world
WHERE name LIKE 'A%';

-- Tip:
-- A% means starts with A.
-- % is a wildcard representing any number of characters.


--------------------------------------------------


-- Concept: NOT Operator
-- Difficulty: Easy
-- Question:
-- Find countries whose population is not greater than 100 million.

SELECT name, population
FROM world
WHERE NOT population > 100000000;

-- Tip:
-- NOT reverses a condition.
-- This is similar to population <= 100000000.


--------------------------------------------------


-- Concept: Calculated Column / Derived Metric
-- Difficulty: Medium
-- Question:
-- Calculate GDP per capita for each country.

SELECT name, (gdp / population) AS gdp_per_capita
FROM world;

-- Tip:
-- Derived metrics are created directly in SELECT.
-- GDP per capita = gdp / population.


--------------------------------------------------


-- Concept: Unit Conversion
-- Difficulty: Easy
-- Question:
-- Convert population into millions.

SELECT name, population / 1000000 AS population_millions
FROM world;

-- Tip:
-- Converting values improves readability in reports and dashboards.
-- In some SQL dialects, divide by 1000000.0 for decimal output.


--------------------------------------------------


-- Concept: ORDER BY
-- Difficulty: Easy
-- Question:
-- List countries sorted by population in descending order.

SELECT name, population
FROM world
ORDER BY population DESC;

-- Tip:
-- DESC sorts from highest to lowest.
-- ASC sorts from lowest to highest.


--------------------------------------------------


-- Concept: ORDER BY + LIMIT
-- Difficulty: Medium
-- Question:
-- Show the top 10 most populated countries.

SELECT name, population
FROM world
ORDER BY population DESC
LIMIT 10;

-- Tip:
-- LIMIT restricts the number of rows returned.
-- Common for top-N analysis.


--------------------------------------------------


-- Concept: WHERE + LIKE + ORDER BY
-- Difficulty: Medium
-- Question:
-- Find countries with population greater than 50 million and name containing 'a', sorted by population.

SELECT name, population, area
FROM world
WHERE population > 50000000
AND name LIKE '%a%'
ORDER BY population DESC;

-- Tip:
-- '%a%' means the name contains the letter a anywhere in the text.
-- Combining filters with sorting is common in real-world analysis.
