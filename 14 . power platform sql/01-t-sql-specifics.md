# T-SQL vs Standard SQL (SQL Server / Azure SQL)

## 📌 What is it?
T-SQL (Transact-SQL) is Microsoft's SQL dialect used in SQL Server and Azure SQL — the primary databases behind Power Platform, Power BI, and most Microsoft enterprise environments. While 80% of SQL is the same everywhere, the 20% that differs will break your queries if you don't know the differences.

---

## 🔑 Key Concepts

### Key Differences at a Glance
| Feature | PostgreSQL / Standard | T-SQL (SQL Server) |
|---|---|---|
| Limit rows | `LIMIT 10` | `TOP 10` (before columns) |
| Current date/time | `NOW()`, `CURRENT_TIMESTAMP` | `GETDATE()`, `SYSDATETIME()` |
| Null coalesce | `COALESCE(a, b)` | `COALESCE(a, b)` ✅ same |
| Null check function | `COALESCE` | `ISNULL(a, b)` (2-arg only) |
| String concat | `\|\|` or `CONCAT()` | `+` or `CONCAT()` |
| Auto-increment | `GENERATED ALWAYS AS IDENTITY` | `IDENTITY(1,1)` |
| String length | `LENGTH()` | `LEN()` |
| Modulo | `%` | `%` ✅ same |
| Cast | `value::TYPE` or `CAST()` | `CAST()` or `CONVERT()` |
| Boolean | `BOOLEAN` (`TRUE`/`FALSE`) | `BIT` (1/0) |
| Date diff | `end - start` (days), `AGE()` | `DATEDIFF(unit, start, end)` |
| Date add | `date + INTERVAL '7 days'` | `DATEADD(day, 7, date)` |
| String substring | `SUBSTRING(str, start, len)` | `SUBSTRING(str, start, len)` ✅ same |
| Case sensitivity | Case-insensitive by default | Depends on collation |
| Temp tables | `CREATE TEMP TABLE` | `CREATE TABLE #temp` |

---

## 💻 Code Examples

### TOP instead of LIMIT
```sql
-- PostgreSQL
SELECT emp_name, salary FROM employees ORDER BY salary DESC LIMIT 10;

-- T-SQL
SELECT TOP 10 emp_name, salary FROM employees ORDER BY salary DESC;

-- T-SQL with ties (equivalent of LIMIT WITH TIES)
SELECT TOP 10 WITH TIES emp_name, salary FROM employees ORDER BY salary DESC;
```

### Date functions
```sql
-- PostgreSQL
SELECT NOW(), CURRENT_DATE, order_date + INTERVAL '7 days', AGE(order_date);

-- T-SQL equivalents
SELECT GETDATE(), CAST(GETDATE() AS DATE),
       DATEADD(day, 7, order_date),
       DATEDIFF(day, order_date, GETDATE());

-- T-SQL: extract year/month/day
SELECT
    YEAR(order_date)  AS yr,
    MONTH(order_date) AS mo,
    DAY(order_date)   AS dy
FROM orders;
-- OR
SELECT DATEPART(year, order_date) AS yr FROM orders;
```

### String functions
```sql
-- PostgreSQL
SELECT LENGTH('hello'), 'Hello' || ' World';

-- T-SQL
SELECT LEN('hello'), 'Hello' + ' World';

-- Same in both:
SELECT UPPER(name), LOWER(name), TRIM(name), SUBSTRING(name, 1, 3) FROM customers;
```

### ISNULL vs COALESCE
```sql
-- T-SQL: ISNULL (only 2 arguments)
SELECT ISNULL(phone, 'No phone') FROM customers;

-- COALESCE works in both and supports multiple fallbacks
SELECT COALESCE(mobile, phone, email, 'No contact') FROM customers;
```

### Temporary tables
```sql
-- PostgreSQL
CREATE TEMP TABLE temp_results AS
SELECT * FROM orders WHERE status = 'pending';

-- T-SQL (# prefix = session-scoped temp table)
SELECT * INTO #temp_results FROM orders WHERE status = 'pending';
-- Or:
CREATE TABLE #temp_results (order_id INT, amount DECIMAL(10,2));
INSERT INTO #temp_results SELECT order_id, amount FROM orders WHERE status = 'pending';

-- T-SQL: drop when done
DROP TABLE IF EXISTS #temp_results;
```

### CTEs and Window Functions — same syntax!
```sql
-- These work identically in PostgreSQL and T-SQL
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT * FROM ranked WHERE rn = 1;
```

### CONVERT — T-SQL only (type conversion with style)
```sql
-- T-SQL: format a date as string
SELECT CONVERT(VARCHAR, order_date, 103) AS formatted_date;   -- 103 = dd/mm/yyyy
SELECT CONVERT(VARCHAR, order_date, 120) AS formatted_date;   -- 120 = yyyy-mm-dd hh:mm:ss
SELECT FORMAT(order_date, 'dd/MM/yyyy') AS formatted_date;    -- newer T-SQL alternative
```

---

## ⚠️ Common Mistakes
- Using `LIMIT` in SQL Server — it doesn't exist, use `TOP`
- Using `NOW()` in SQL Server — it doesn't exist, use `GETDATE()`
- Using `||` for string concatenation in SQL Server — use `+` or `CONCAT()`
- Forgetting that `BIT` is the boolean type in T-SQL — `WHERE is_active = TRUE` fails; use `WHERE is_active = 1`

---

## 🔗 Related Topics
- [SQL for Power BI](02-sql-for-power-bi.md)
- [Date Functions](../09-functions/03-date-functions.md)
- [String Functions](../09-functions/02-string-functions.md)
- [SELECT Statement](../02-querying/01-select-statement.md)
