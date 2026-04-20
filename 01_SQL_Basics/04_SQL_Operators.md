# SQL Operators

## 📌 What are Operators?
Operators are used to perform operations on data values.

---

## 🔹 Comparison Operators
=, >, <, >=, <=, <>

Example:
SELECT * FROM Employees
WHERE Salary > 50000;

---

## 🔹 Logical Operators
AND, OR, NOT

Example:
SELECT * FROM Employees
WHERE Salary > 50000 AND Department = 'IT';

---

## 🔹 BETWEEN Operator
Used to filter within a range

SELECT * FROM Employees
WHERE Salary BETWEEN 30000 AND 60000;

---

## 🔹 IN Operator
Used to match multiple values

SELECT * FROM Employees
WHERE Department IN ('IT', 'HR');

---

## 🔹 LIKE Operator
Used for pattern matching

SELECT * FROM Employees
WHERE Name LIKE 'A%';

---

## 🔹 IS NULL Operator
Used to check NULL values

SELECT * FROM Employees
WHERE Manager IS NULL;

---

## 🔹 Arithmetic Operators
+, -, *, /, %

Example:
SELECT Salary + 1000 AS UpdatedSalary
FROM Employees;

---
## 🔹 Advanced / Less Used Operators

### Compound Operators
+=, -=, *=, /=

Used in updating values (rare in analytics)

---

### Bitwise Operators
&, |, ^, ~

Used for binary operations (not common in data analysis)
---
## 🧠 Key Points
- Comparison → compare values
- Logical → combine conditions
- BETWEEN → range filtering
- IN → multiple values
- LIKE → pattern matching
- IS NULL → check missing values
