-- =========================================
-- DAY 1 SQL PRACTICE (BASICS)
-- Concepts: SELECT, WHERE, ORDER BY, Operators
-- =========================================


-- ==================================================
-- PRACTICE PROBLEMS
-- ==================================================


-- Source: SQLZoo
-- Concept: SELECT + WHERE
-- Difficulty: Easy
-- Question:
-- Modify the query to show the population of Germany.

SELECT population
FROM world
WHERE name = 'Germany';

-- Tip:
-- WHERE clause filters rows based on a condition.
-- Use quotes for text/string values.


--------------------------------------------------


-- Source: SQLZoo
-- Concept: SELECT + IN Operator
-- Difficulty: Easy
-- Question:
-- Show the name and population for Sweden, Norway, and Denmark.

SELECT name, population
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- Tip:
-- IN is cleaner than multiple OR conditions.
-- Useful when matching multiple values.


--------------------------------------------------


-- Source: SQLZoo
-- Concept: BETWEEN Operator
-- Difficulty: Easy
-- Question:
-- Show country name and area for countries with area between 200000 and 250000.

SELECT name, area
FROM world
WHERE area BETWEEN 200000 AND 250000;

-- Tip:
-- BETWEEN includes boundary values.
-- Equivalent to:
-- area >= 200000 AND area <= 250000


--------------------------------------------------


-- ==================================================
-- QUIZ QUESTIONS
-- ==================================================


-- Source: SQLZoo
-- Concept: BETWEEN + Filtering
-- Difficulty: Easy
-- Question:
-- Show countries with population between 1,000,000 and 1,250,000.

SELECT name, population
FROM world
WHERE population BETWEEN 1000000 AND 1250000;

-- Tip:
-- BETWEEN works for numeric ranges.
-- Very useful in filtering grouped ranges.


--------------------------------------------------


-- Source: SQLZoo
-- Concept: LIKE Operator
-- Difficulty: Easy
-- Question:
-- Show countries whose name starts with 'Al'.

SELECT name, population
FROM world
WHERE name LIKE 'Al%';

-- Tip:
-- % = wildcard for multiple characters.
-- 'Al%' means starts with Al.


--------------------------------------------------


-- Source: SQLZoo
-- Concept: LIKE + OR
-- Difficulty: Medium
-- Question:
-- Show countries ending in A or L.

SELECT name
FROM world
WHERE name LIKE '%a'
OR name LIKE '%l';

-- Tip:
-- '%a' = ends with a
-- '%l' = ends with l


--------------------------------------------------


-- Source: SQLZoo
-- Concept: String Functions + Filtering
-- Difficulty: Medium
-- Question:
-- Show European countries with exactly 5-letter names.

SELECT name, LENGTH(name)
FROM world
WHERE LENGTH(name) = 5
AND region = 'Europe';

-- Tip:
-- LENGTH() counts number of characters.
-- Combine functions with filters.


--------------------------------------------------


-- Source: SQLZoo
-- Concept: Calculated Columns
-- Difficulty: Easy
-- Question:
-- Show country name and doubled area where population = 64000.

SELECT name, area * 2
FROM world
WHERE population = 64000;

-- Tip:
-- SQL allows calculations directly inside SELECT.


--------------------------------------------------


-- Source: SQLZoo
-- Concept: AND Operator
-- Difficulty: Medium
-- Question:
-- Show countries with area > 50000 and population < 10000000.

SELECT name, area, population
FROM world
WHERE area > 50000
AND population < 10000000;

-- Tip:
-- AND requires both conditions to be true.


--------------------------------------------------


-- Source: SQLZoo
-- Concept: Derived Metrics
-- Difficulty: Medium
-- Question:
-- Show population density for China, Australia, Nigeria, and France.

SELECT name, population / area
FROM world
WHERE name IN ('China', 'Nigeria', 'France', 'Australia');

-- Tip:
-- Population density = population / area.
-- Derived metrics are common in analytics.
