# SELECT Statement

## 📌 What is it?
`SELECT` is the primary command for retrieving data from a database. It projects, filters, sorts, and transforms data from one or more tables.

---

## 🔑 Key Concepts

### Logical Execution Order
The database does NOT run your query top-to-bottom. It follows this order internally:

```
1. FROM / JOIN     → identify source tables
2. WHERE           → filter individual rows
3. GROUP BY        → group rows for aggregation
4. HAVING          → filter groups
5. SELECT          → pick and calculate columns
6. DISTINCT        → remove duplicates
7. ORDER BY        → sort results
8. LIMIT / OFFSET  → restrict result count
```

> 💡 This is why you can't use a column alias defined in SELECT inside a WHERE clause — WHERE runs before SELECT!

### Key Clauses
| Clause | Purpose |
|---|---|
| `FROM` | Source table(s) |
| `WHERE` | Row-level filter (before aggregation) |
| `GROUP BY` | Aggregate rows into groups |
| `HAVING` | Filter after aggregation |
| `ORDER BY` | Sort results |
| `LIMIT` | Restrict number of rows returned |
| `DISTINCT` | Remove duplicate rows |

---

## 💻 Code Examples

### Basic Query
```sql
SELECT emp_name, salary
FROM employees
WHERE salary > 50000
ORDER BY salary DESC
LIMIT 10;
```

### With JOIN and CTE
```sql
WITH OrderSummary AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        c.CustomerName,
        SUM(od.UnitPrice * od.Quantity) AS TotalValue
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY 1, 2, 3
)
SELECT *
FROM OrderSummary
WHERE TotalValue > 1000
ORDER BY OrderDate DESC
LIMIT 100;
```

### Window Function (modern alternative to subqueries)
```sql
-- Rank employees by salary within each department
SELECT
    emp_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
FROM employees;
```

### Vector Search (modern SQL)
```sql
-- Find top 5 most semantically similar documents
SELECT content
FROM docs
ORDER BY embedding <=> '[0.1, 0.3, ...]'
LIMIT 5;
```

---

## ⚠️ Common Mistakes
- Using `SELECT *` in production — specify only the columns you need
- Filtering with `HAVING` when `WHERE` would work — `WHERE` is faster (uses indexes)
- Forgetting that `ORDER BY` is expensive on large datasets without an index

---

## 🔗 Related Topics
- [WHERE vs HAVING](02-where-vs-having.md)
- [GROUP BY](03-group-by.md)
- [ORDER BY](04-order-by.md)
- [Subqueries](05-subqueries.md)
- [Indexes](../05-performance/01-indexes.md)
