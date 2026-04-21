-- SQL Practice – Week 1 Day 1
-- Topic: SQL Basics (SELECT, Clauses, Operators)

-- Q1: Retrieve all columns from the world table
SELECT *
FROM world;

-- Q2: Retrieve name, population, and area of all countries
SELECT name, population, area
FROM world;

-- Q3: Find countries with population greater than 100 million
SELECT name, population
FROM world
WHERE population > 100000000;

-- Q4: Find countries with area less than 500,000
SELECT name, area
FROM world
WHERE area < 500000;

-- Q5: Find countries with population > 50M AND area > 1M
SELECT name, population, area
FROM world
WHERE population > 50000000 AND area > 1000000;

-- Q6: Find countries with population > 200M OR area > 3M
SELECT name, population
FROM world
WHERE population > 200000000 OR area > 3000000;

-- Q7: Retrieve details for specific countries (India, China, United States)
SELECT name, population
FROM world
WHERE name IN ('India', 'China', 'United States');

-- Q8: Find countries with population between 50M and 200M
SELECT name, population
FROM world
WHERE population BETWEEN 50000000 AND 200000000;

-- Q9: Find countries whose name starts with 'A'
SELECT name
FROM world
WHERE name LIKE 'A%';

-- Q10: Find countries whose population is NOT greater than 100M
SELECT name, population
FROM world
WHERE NOT population > 100000000;

-- Q11: Calculate GDP per capita for each country
SELECT name, (gdp/population) AS gdp_per_capita
FROM world;

-- Q12: Convert population into millions
SELECT name, population/1000000 AS population_millions
FROM world;

-- Q13: List countries sorted by population (descending)
SELECT name, population
FROM world
ORDER BY population DESC;

-- Q14: Show top 10 most populated countries
SELECT name, population
FROM world
ORDER BY population DESC
LIMIT 10;

-- Q15: Find countries with population > 50M and name containing 'a', sorted by population
SELECT name, population, area
FROM world
WHERE population > 50000000
AND name LIKE '%a%'
ORDER BY population DESC;
