# GROUP BY

## 📌 What is it?
`GROUP BY` partitions rows into groups based on one or more columns, so aggregate functions like `SUM()`, `COUNT()`, `AVG()` can be applied to each group independently.

---

## 🔑 Key Concepts

- Without `GROUP BY`, aggregate functions apply to the **entire table**
- With `GROUP BY`, they apply to **each group separately**
- Every column in `SELECT` must either be in `GROUP BY` or wrapped in an aggregate function
- Use `HAVING` to filter groups after aggregation (not `WHERE`)

### How it works internally
```
Input rows → sorted/hashed by GROUP BY columns → collapsed into one row per group → aggregates calculated
```

---

## 💻 Code Examples

### Basic Grouping
```sql
-- Total sales per region
SELECT Region, SUM(Amount) AS TotalSales
FROM Sales
GROUP BY Region;
```

### With WHERE and HAVING
```sql
-- Count transactions above 100, only show regions with more than 50 such transactions
SELECT Region, COUNT(*) AS HighValueTransactions
FROM Sales
WHERE Amount > 100
GROUP BY Region
HAVING COUNT(*) > 50;
```

### Multiple Columns
```sql
-- Sales by region AND product
SELECT Region, Product, SUM(Amount) AS TotalSales
FROM Sales
GROUP BY Region, Product
ORDER BY TotalSales DESC;
```

### Window Function vs GROUP BY
```sql
-- ❌ Old way: subquery to get relative contribution
-- ✅ Modern way: window function (much faster)
SELECT
    Region,
    Product,
    SUM(Amount) / SUM(SUM(Amount)) OVER (PARTITION BY Region) AS RelativeContribution
FROM Sales
GROUP BY Region, Product;
```
> 💡 Window functions run AFTER `GROUP BY`, so you can combine both in the same query.

---

## ⚠️ Common Mistakes
- Selecting a non-aggregated column that isn't in `GROUP BY` — this causes an error (or random results in older MySQL)
- Filtering groups with `WHERE` instead of `HAVING`
- Using `GROUP BY` when a window function would give more flexibility

```sql
-- ❌ Error: emp_name is not in GROUP BY or an aggregate
SELECT department, emp_name, COUNT(*)
FROM employees
GROUP BY department;

-- ✅ Fixed
SELECT department, COUNT(*)
FROM employees
GROUP BY department;
```

---

## 🔗 Related Topics
- [WHERE vs HAVING](02-where-vs-having.md)
- [SELECT Statement](01-select-statement.md)
- [ORDER BY](04-order-by.md)
