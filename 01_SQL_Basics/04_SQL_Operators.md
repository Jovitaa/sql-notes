# SQL Operators

## 📌 What are Operators?

Operators are used to perform operations on data values.

---

## 🔹 Comparison Operators

Used to compare one value with another.

### Operators

```text
=   Equal
>   Greater Than
<   Less Than
>=  Greater Than or Equal
<=  Less Than or Equal
<>  Not Equal
!=  Not Equal
```

### Example

```sql
SELECT *
FROM Employees
WHERE Salary > 50000;
```

---

## 🔹 Logical Operators

Used to combine multiple conditions.

### Operators

```text
AND
OR
NOT
```

### Example

```sql
SELECT *
FROM Employees
WHERE Salary > 50000
  AND Department = 'IT';
```

---

## 🔹 BETWEEN Operator

Used to filter values within a range.

### Syntax

```sql
SELECT *
FROM Employees
WHERE Salary BETWEEN 30000 AND 60000;
```

---

## 🔹 IN Operator

Used to match multiple values.

### Syntax

```sql
SELECT *
FROM Employees
WHERE Department IN ('IT', 'HR');
```

---

## 🔹 LIKE Operator

Used for pattern matching.

### Wildcards

```text
%  Any number of characters
_  Single character
```

### Example

```sql
SELECT *
FROM Employees
WHERE Name LIKE 'A%';
```

---

## 🔹 IS NULL Operator

Used to check missing values.

### Example

```sql
SELECT *
FROM Employees
WHERE Manager IS NULL;
```

---

## 🔹 Arithmetic Operators

Used for mathematical operations.

### Operators

```text
+   Addition
-   Subtraction
*   Multiplication
/   Division
%   Modulus
```

### Example

```sql
SELECT Salary + 1000 AS UpdatedSalary
FROM Employees;
```

---

## 🔹 EXISTS Operator

Used to check whether a subquery returns rows.

Returns TRUE if subquery has at least one result.

### Syntax

```sql
SELECT column_name(s)
FROM table_name
WHERE EXISTS (
    SELECT column_name
    FROM another_table
    WHERE condition
);
```

### Example

```sql
SELECT CustomerName
FROM Customers
WHERE EXISTS (
    SELECT OrderID
    FROM Orders
    WHERE Orders.CustomerID = Customers.CustomerID
);
```

### Meaning

```text
Return customers who have at least one order.
```

---

## 🔹 ANY Operator

Used to compare a value against at least one value from a subquery.

Returns TRUE if condition matches any value.

### Syntax

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name operator ANY (
    SELECT column_name
    FROM another_table
);
```

### Example

```sql
SELECT ProductName
FROM Products
WHERE Price > ANY (
    SELECT Price
    FROM Products
    WHERE CategoryID = 2
);
```

### Meaning

```text
Returns products whose price is greater than at least one product in category 2.
```

---

## 🔹 ALL Operator

Used to compare a value against all values from a subquery.

Returns TRUE only if condition is true for every returned value.

### Syntax

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name operator ALL (
    SELECT column_name
    FROM another_table
);
```

### Example

```sql
SELECT ProductName
FROM Products
WHERE Price > ALL (
    SELECT Price
    FROM Products
    WHERE CategoryID = 2
);
```

### Meaning

```text
Returns products whose price is greater than every product in category 2.
```

---

## 🔹 Advanced / Less Used Operators

### Compound Operators

```text
+=
-=
*=
/=
```

Used in updates or procedural SQL.

---

### Bitwise Operators

```text
&
|
^
~
```

Used for binary-level operations.

Rare in analytics work.

---

## 🧠 Operator Mental Model

```text
Comparison → compare values
Logical → combine filters
BETWEEN → range filtering
IN → multiple values
LIKE → pattern search
IS NULL → missing values
EXISTS → subquery returns rows
ANY → compare with at least one value
ALL → compare with every value
Arithmetic → calculations
```

---

## 📌 Operator Summary Table

| Operator Type | Purpose                      |
| ------------- | ---------------------------- |
| Comparison    | Compare values               |
| Logical       | Combine conditions           |
| BETWEEN       | Filter range                 |
| IN            | Match list                   |
| LIKE          | Pattern matching             |
| IS NULL       | Detect missing values        |
| EXISTS        | Check subquery rows          |
| ANY           | Compare against one or more  |
| ALL           | Compare against every result |
| Arithmetic    | Perform calculations         |
