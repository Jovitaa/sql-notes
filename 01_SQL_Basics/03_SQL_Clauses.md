# SQL Clauses

## 📌 What is a Clause?
A clause is used to define conditions or modify SQL queries.

---

## 🔹 WHERE Clause
Used to filter rows based on conditions

SELECT * 
FROM Employees
WHERE Salary > 50000;

---

## 🔹 ORDER BY Clause
Used to sort the result set

SELECT * 
FROM Employees
ORDER BY Salary DESC;

---

## 🔹 GROUP BY Clause
Used to group rows based on a column

SELECT Department, COUNT(*) 
FROM Employees
GROUP BY Department;

---

## 🔹 HAVING Clause
Used to filter grouped data (after aggregation)

SELECT Department, COUNT(*) 
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 5;

---

## 🔹 DISTINCT Clause
Used to return unique values

SELECT DISTINCT Department
FROM Employees;

---

## 🔹 LIMIT / TOP Clause
Used to restrict number of rows returned

-- MySQL
SELECT * FROM Employees
LIMIT 5;

-- SQL Server
SELECT TOP 5 * FROM Employees;

---

## 🧠 Key Points
- WHERE → filters rows before grouping
- GROUP BY → groups data
- HAVING → filters grouped data
- ORDER BY → sorts results
- DISTINCT → removes duplicates
