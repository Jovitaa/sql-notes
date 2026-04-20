# SQL Operators

## 📌 What are Operators?
Operators are used to perform operations on data.

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

## 🔹 Other Operators
- BETWEEN → Range
- LIKE → Pattern matching
- IN → Multiple values

Example:
SELECT * FROM Employees
WHERE Department IN ('IT', 'HR');
