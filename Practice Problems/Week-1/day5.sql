-- =========================================
-- DAY 5 SQL PRACTICE
-- Topic: Aggregate Functions, GROUP BY, HAVING
-- Source: SQLZoo
-- Table: world(name, continent, area, population, gdp)
-- =========================================


-- ==================================================
-- PRACTICE PROBLEMS
-- ==================================================


-- Q1. Show the total population of the world.
SELECT SUM(population) AS total_population
FROM world;


-- Q2. List all the continents - just once each.
SELECT DISTINCT continent
FROM world;


-- Q3. Give the total GDP of Africa.
SELECT SUM(gdp) AS total_gdp_africa
FROM world
WHERE continent = 'Africa';


-- Q4. How many countries have an area of at least 1,000,000?
SELECT COUNT(name) AS country_count
FROM world
WHERE area >= 1000000;


-- Q5. What is the total population of Estonia, Latvia, and Lithuania?
SELECT SUM(population) AS total_population
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania');


-- Q6. For each continent, show the continent and number of countries.
SELECT continent, COUNT(name) AS num_countries
FROM world
GROUP BY continent;


-- Q7. For each continent, show the continent and number of countries
-- with populations of at least 10 million.
SELECT continent, COUNT(name) AS num_countries
FROM world
WHERE population >= 10000000
GROUP BY continent;


-- Q8. List the continents that have a total population of at least 100 million.
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;


-- ==================================================
-- QUIZ
-- Table: bbc(name, region, area, population, gdp)
-- ==================================================


-- Quiz 1. Select the statement that shows the sum of population
-- of all countries in Europe.
SELECT SUM(population)
FROM bbc
WHERE region = 'Europe';


-- Quiz 2. Select the statement that shows the number of countries
-- with population smaller than 150,000.
SELECT COUNT(name)
FROM bbc
WHERE population < 150000;


-- Quiz 3. Core SQL aggregate functions:
-- AVG(), COUNT(), MAX(), MIN(), SUM()


-- Quiz 4. Invalid query example:
-- SELECT region, SUM(area)
-- FROM bbc
-- WHERE SUM(area) > 15000000
-- GROUP BY region;
-- Reason: Aggregate functions cannot be used in WHERE.
-- Use HAVING instead.


-- Correct version of Quiz 4:
SELECT region, SUM(area) AS total_area
FROM bbc
GROUP BY region
HAVING SUM(area) > 15000000;


-- Quiz 5. Select the statement that shows the average population
-- of Poland, Germany, and Denmark.
SELECT AVG(population)
FROM bbc
WHERE name IN ('Poland', 'Germany', 'Denmark');


-- Quiz 6. Select the statement that shows the population density
-- of each region.
SELECT region, SUM(population) / SUM(area) AS density
FROM bbc
GROUP BY region;


-- Quiz 7. Select the statement that shows the name and population density
-- of the country with the largest population.
SELECT name, population / area AS density
FROM bbc
WHERE population = (
    SELECT MAX(population)
    FROM bbc
);


-- Quiz 8. Query:
SELECT region, SUM(area) AS total_area
FROM bbc
GROUP BY region
HAVING SUM(area) <= 20000000;

-- Expected result:
-- Americas       732240
-- Middle East    13403102
-- South America  17740392
-- South Asia     9437710

