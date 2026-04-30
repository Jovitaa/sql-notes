# SQL JOINS

## What is a JOIN?

A JOIN is used to combine rows from two or more tables based on a related column.

---

## Why JOIN is Needed

Data is often stored across multiple tables.

Example:

### Customers Table

| CustomerID | CustomerName |
|------------|--------------|
| 1 | John |
| 2 | Sarah |

### Orders Table

| OrderID | CustomerID |
|---------|------------|
| 101 | 1 |
| 102 | 2 |

To combine customer details with order details, JOIN is used.

---

# Types of JOIN

## 1. INNER JOIN

Returns only matching rows from both tables.

### Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;
````

### Example

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;
```

### Result

Only rows where CustomerID exists in both tables.

---

## 2. LEFT JOIN

Returns all rows from left table and matched rows from right table.

### Syntax

```sql
SELECT columns
FROM table1
LEFT JOIN table2
ON table1.column = table2.column;
```

### Example

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;
```

### Result

Shows all customers, even if they have no orders.

---

## 3. RIGHT JOIN

Returns all rows from right table and matched rows from left table.

### Syntax

```sql
SELECT columns
FROM table1
RIGHT JOIN table2
ON table1.column = table2.column;
```

---

## 4. FULL JOIN

Returns all rows from both tables.

### Syntax

```sql
SELECT columns
FROM table1
FULL JOIN table2
ON table1.column = table2.column;
```

---

## 5. SELF JOIN

A table joined with itself.

### Syntax

```sql
SELECT A.column, B.column
FROM table_name A
JOIN table_name B
ON A.column = B.column;
```

---

## Joining Multiple Tables

```sql
SELECT Orders.OrderID, Customers.CustomerName, Shippers.ShipperName
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID;
```

---

## JOIN Relationship Rule

Always identify:

```text
Primary Key → Foreign Key
```

Example:

```text
movie.id → casting.movieid
actor.id → casting.actorid
```

---

## JOIN Mental Model

Ask:

1. Which table contains base data?
2. Which table contains lookup data?
3. Which column connects them?
4. What rows must remain?

---

## Common JOIN Mistakes

### Wrong

```sql
SELECT *
FROM actor
JOIN movie ON actor.id = movie.id;
```

### Correct

```sql
SELECT *
FROM actor
JOIN casting ON actor.id = casting.actorid
JOIN movie ON casting.movieid = movie.id;
```

---

## JOIN Summary Table

| JOIN Type  | Returns                   |
| ---------- | ------------------------- |
| INNER JOIN | Matching rows only        |
| LEFT JOIN  | All left rows + matches   |
| RIGHT JOIN | All right rows + matches  |
| FULL JOIN  | All rows from both tables |
| SELF JOIN  | Table joined to itself    |

````

---
```
```
