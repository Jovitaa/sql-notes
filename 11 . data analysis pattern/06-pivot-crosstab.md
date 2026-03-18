# Pivot Tables & Crosstab in SQL

## 📌 What is it?
Pivoting converts rows into columns — turning a long/narrow table into a wide table. It's used constantly in reporting to show metrics side-by-side across categories (months, regions, products). SQL doesn't have a built-in PIVOT in all databases, but you can replicate it with `CASE + GROUP BY`.

---

## 🔑 Key Concepts

### The Pattern: Long → Wide
```
BEFORE (long format):          AFTER (wide/pivot format):
month    | metric  | value     month | revenue | orders | users
---------+---------+------     ------+---------+--------+------
Jan 2026 | revenue | 50000     Jan   | 50000   | 120    | 80
Jan 2026 | orders  | 120       Feb   | 65000   | 145    | 95
Jan 2026 | users   | 80
Feb 2026 | revenue | 65000
```

### Two approaches
| Approach | When to use |
|---|---|
| `CASE + GROUP BY` | Works in all databases — PostgreSQL, MySQL, SQL Server |
| `CROSSTAB()` (PostgreSQL) | Cleaner syntax, use when columns are known |
| `PIVOT` keyword (SQL Server / Oracle) | Native pivot syntax |

---

## 💻 Code Examples

### Method 1 — CASE + GROUP BY (universal, most common)
```sql
-- Pivot monthly sales by region
SELECT
    DATE_TRUNC('month', order_date)                                           AS month,
    SUM(CASE WHEN region = 'North' THEN amount ELSE 0 END)                   AS north_revenue,
    SUM(CASE WHEN region = 'South' THEN amount ELSE 0 END)                   AS south_revenue,
    SUM(CASE WHEN region = 'East'  THEN amount ELSE 0 END)                   AS east_revenue,
    SUM(CASE WHEN region = 'West'  THEN amount ELSE 0 END)                   AS west_revenue,
    SUM(amount)                                                               AS total_revenue
FROM orders
GROUP BY 1
ORDER BY 1;
```

### Count-based pivot — orders by status per month
```sql
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) AS completed,
    COUNT(CASE WHEN status = 'pending'   THEN 1 END) AS pending,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled,
    COUNT(CASE WHEN status = 'refunded'  THEN 1 END) AS refunded,
    COUNT(*)                                          AS total
FROM orders
GROUP BY 1
ORDER BY 1 DESC;
```

### Method 2 — PostgreSQL CROSSTAB
```sql
-- Enable the tablefunc extension first
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- Pivot using crosstab
SELECT *
FROM CROSSTAB(
    -- Source query: must return (row_id, category, value)
    $$
    SELECT
        DATE_TRUNC('month', order_date)::TEXT AS month,
        region,
        SUM(amount)::NUMERIC AS revenue
    FROM orders
    GROUP BY 1, 2
    ORDER BY 1, 2
    $$,
    -- Column categories
    $$ SELECT UNNEST(ARRAY['North', 'South', 'East', 'West']) $$
) AS pivot_table (
    month TEXT,
    north NUMERIC,
    south NUMERIC,
    east  NUMERIC,
    west  NUMERIC
);
```

### Method 3 — SQL Server PIVOT syntax
```sql
SELECT month, [North], [South], [East], [West]
FROM (
    SELECT
        FORMAT(order_date, 'yyyy-MM') AS month,
        region,
        amount
    FROM orders
) src
PIVOT (
    SUM(amount) FOR region IN ([North], [South], [East], [West])
) pvt
ORDER BY month;
```

### Unpivot — wide back to long (useful for normalizing spreadsheet imports)
```sql
-- Wide table with separate columns per month → long format
SELECT customer_id, 'Jan' AS month, jan_sales AS sales FROM quarterly_sales
UNION ALL
SELECT customer_id, 'Feb',          feb_sales          FROM quarterly_sales
UNION ALL
SELECT customer_id, 'Mar',          mar_sales          FROM quarterly_sales
ORDER BY customer_id, month;
```

---

## ⚠️ Common Mistakes
- Using `SUM` when you want `COUNT` — they look similar but give very different results
- Hardcoding categories that change over time — consider dynamic SQL for truly dynamic pivots
- Null vs zero — use `COALESCE(SUM(...), 0)` to avoid NULLs in pivot cells

---

## 🔗 Related Topics
- [CASE Statements](../07-advanced-querying/03-case-statements.md)
- [UNION, INTERSECT, EXCEPT](../07-advanced-querying/04-unions.md)
- [GROUP BY](../02-querying/03-group-by.md)
- [Aggregate Functions](../09-functions/01-aggregate-functions.md)
