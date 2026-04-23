# Day 4 SQLZoo Practice — day4.sql

```sql
-- =========================================
-- DAY 4 SQL PRACTICE
-- Concepts: SELECT within SELECT, Subqueries, ALL, IN, Correlated Subqueries
-- Source: SQLZoo
-- =========================================

-- Q1. List each country name where the population is larger than that of Russia.
SELECT name
FROM world
WHERE population > (
    SELECT population
    FROM world
    WHERE name = 'Russia'
);

--------------------------------------------------

-- Q2. Show the countries in Europe with a per capita GDP greater than United Kingdom.
SELECT name
FROM world
WHERE continent = 'Europe'
  AND (gdp / population) > (
      SELECT (gdp / population)
      FROM world
      WHERE name = 'United Kingdom'
  );

--------------------------------------------------

-- Q3. List the name and continent of countries in the continents containing either Argentina or Australia.
SELECT name, continent
FROM world
WHERE continent IN (
    SELECT continent
    FROM world
    WHERE name IN ('Argentina', 'Australia')
)
ORDER BY name;

--------------------------------------------------

-- Q4. Which country has a population that is more than United Kingdom but less than Germany?
SELECT name, population
FROM world
WHERE population > (
    SELECT population
    FROM world
    WHERE name = 'United Kingdom'
)
AND population < (
    SELECT population
    FROM world
    WHERE name = 'Germany'
);

--------------------------------------------------

-- Q5. Show European countries as a percentage of Germany's population.
SELECT name,
       CONCAT(
           ROUND(population * 100 / (
               SELECT population
               FROM world
               WHERE name = 'Germany'
           )),
           '%'
       ) AS percentage
FROM world
WHERE continent = 'Europe';

--------------------------------------------------

-- Q6. Which countries have a GDP greater than every country in Europe?
SELECT name
FROM world
WHERE gdp > ALL (
    SELECT gdp
    FROM world
    WHERE continent = 'Europe'
      AND gdp IS NOT NULL
);

--------------------------------------------------

-- Q7. Find the largest country (by area) in each continent.
SELECT continent, name, area
FROM world x
WHERE area >= ALL (
    SELECT area
    FROM world y
    WHERE y.continent = x.continent
      AND area IS NOT NULL
);

--------------------------------------------------

-- Q8. List each continent and the first country alphabetically.
SELECT continent, name
FROM world x
WHERE name = (
    SELECT MIN(name)
    FROM world y
    WHERE y.continent = x.continent
);

--------------------------------------------------

-- Q9. Find continents where all countries have population <= 25M.
SELECT x.name, x.continent, x.population
FROM world x
WHERE 25000000 >= ALL (
    SELECT y.population
    FROM world y
    WHERE x.continent = y.continent
);

--------------------------------------------------

-- Q10. Countries with population more than three times all neighbours in same continent.
SELECT x.name, x.continent
FROM world x
WHERE x.population > ALL (
    SELECT 3 * y.population
    FROM world y
    WHERE y.continent = x.continent
      AND y.name <> x.name
);
```
