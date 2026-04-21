# SQL Query Patterns (Day 2)

## 📌 Overview
These patterns are commonly used in real-world data analysis to filter, transform, and analyze data.

---

## 🔹 Filtering Data (WHERE)

Used to filter rows based on conditions.

```sql
SELECT name
FROM world
WHERE population >= 200000000;
```
---

## 🔹 Using IN (Multiple Values)

```sql
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');
```
---

## 🔹 Pattern Matching (LIKE)

```sql
SELECT name
FROM world
WHERE name LIKE '%United%';
```
---
## 🔹 Calculations in SQL

```sql
SELECT name, (gdp/population) AS pc_gdp
FROM world;
```

---

## 🔹 Unit Conversion

```sql
SELECT name, (population/1000000) AS population_millions
FROM world;
```
---

## 🔹 Logical Conditions (AND, OR)

```sql
SELECT name
FROM world
WHERE area > 3000000 OR population > 250000000;
```
---

## 🔹 Complex Logic (XOR Condition)

```sql
SELECT name
FROM world
WHERE (area > 3000000 OR population > 250000000)
AND NOT (area > 3000000 AND population > 250000000);
```
---

## 🔹 Rounding Values

```sql
SELECT name, ROUND((gdp/population), -3) AS pc_gdp
FROM world;
```
---

## 🔹 String Functions

```sql
SELECT name, capital
FROM world
WHERE LEN(name) = LEN(capital);
```
---

## 🔹 Character Matching

```sql
SELECT name, capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1);

---
