# SQL Basics – Interview Questions

---

## 🔹 What is SQL?

SQL (Structured Query Language) is used to access, manage, and manipulate data stored in relational databases.

In real-world scenarios, SQL is used to retrieve, filter, and transform data for reporting and analysis.

---

## 🔹 What is RDBMS?

RDBMS (Relational Database Management System) is a system that stores data in tables (rows and columns) and allows relationships between them.

Examples include MySQL, SQL Server, and Oracle.

---

## 🔹 What are SQL statements?

SQL statements are commands used to interact with a database, such as retrieving, inserting, updating, or deleting data.

---

## 🔹 What are the types of SQL statements?

SQL statements are categorized as:

* **DQL** → SELECT (retrieve data)
* **DML** → INSERT, UPDATE, DELETE (modify data)
* **DDL** → CREATE, ALTER, DROP, TRUNCATE (define structure)
* **TCL** → COMMIT, ROLLBACK (control transactions)
* **DCL** → GRANT, REVOKE (control permissions)

---

## 🔹 What is the SELECT statement?

The SELECT statement is used to retrieve data from a table.

```sql
SELECT Name, Salary
FROM Employees;
```

---

## 🔹 What is the WHERE clause?

The WHERE clause is used to filter records based on conditions.

```sql
SELECT * FROM Employees
WHERE Salary > 50000;
```

In practice, it helps extract relevant data for analysis.

---

## 🔹 What is ORDER BY?

ORDER BY is used to sort query results in ascending or descending order.

```sql
SELECT * FROM Employees
ORDER BY Salary DESC;
```

It is useful for identifying trends such as highest or lowest values.

---

## 🔹 What is DISTINCT?

DISTINCT is used to return unique values from a column.

```sql
SELECT DISTINCT Department
FROM Employees;
```

---

## 🔹 What are SQL operators?

SQL operators are used to perform operations on data such as comparison, logical conditions, and filtering.

Examples include:

* Comparison → =, >, <
* Logical → AND, OR
* Special → IN, LIKE, BETWEEN

---

## 🔹 What is the difference between = and IN?

* `=` is used to compare a single value
* `IN` is used to match multiple values

```sql
SELECT * FROM Employees
WHERE Department IN ('IT', 'HR');
```

---

## 🔹 What is the LIKE operator?

LIKE is used for pattern matching in text data.

```sql
SELECT * FROM Employees
WHERE Name LIKE 'A%';
```

It is useful when searching partial or flexible matches.

---

## 🔹 What is BETWEEN?

BETWEEN is used to filter values within a range.

```sql
SELECT * FROM Employees
WHERE Salary BETWEEN 30000 AND 60000;
```

---

## 🔹 What is NULL?

NULL represents a missing or unknown value in a database.

```sql
SELECT * FROM Employees
WHERE Manager IS NULL;
```

Handling NULL correctly is important for accurate analysis.

---

## 🔹 Is SQL case sensitive?

SQL keywords are not case sensitive (SELECT = select), but data sensitivity depends on the database system.

---

## 🔹 Difference between WHERE and HAVING?

* WHERE filters rows before grouping
* HAVING filters after aggregation

---

## 💡 Summary

* SQL is used for managing and querying relational data
* WHERE filters data, ORDER BY sorts data
* Operators help define conditions
* Understanding NULL and filtering is critical for analysis

---
