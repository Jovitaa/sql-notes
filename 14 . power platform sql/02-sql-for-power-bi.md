# SQL for Power BI

## 📌 What is it?
Power BI connects to SQL databases to pull data for dashboards and reports. Understanding how SQL and Power BI interact — specifically DirectQuery vs Import mode, query folding, and writing efficient source queries — determines whether your reports are fast or painfully slow.

---

## 🔑 Key Concepts

### How Power BI gets data from SQL
| Mode | How it works | Best for |
|---|---|---|
| **Import** | Pulls data into Power BI memory at refresh time | Most cases — fast dashboards |
| **DirectQuery** | Runs SQL live every time a visual loads | Large data, real-time needs |
| **Composite** | Mix of Import and DirectQuery | Complex scenarios |

### Query Folding
Query folding means Power BI pushes your Power Query transformations back to the SQL server as a single SQL query — instead of loading all data and transforming it in memory.

> 💡 Query folding = fast. No query folding = slow. Always design SQL source queries to enable folding.

### Best Practices for Power BI SQL
1. Write a clean SQL query as your data source — don't rely on Power Query to do heavy transformations
2. Filter data at the SQL level — `WHERE` in SQL is faster than filtering in Power BI
3. Pre-aggregate where possible — fewer rows = faster refresh
4. Avoid `SELECT *` — load only the columns your report needs
5. Use views or stored procedures for complex logic — keeps Power BI clean

---

## 💻 Code Examples

### Writing a SQL query as Power BI data source
```sql
-- Instead of loading the whole orders table and filtering in Power BI:

-- ✅ Pre-filter and pre-aggregate in SQL
SELECT
    DATE_TRUNC('month', order_date)::DATE   AS month,
    c.customer_segment,
    p.category                              AS product_category,
    COUNT(DISTINCT o.order_id)              AS orders,
    COUNT(DISTINCT o.customer_id)           AS customers,
    SUM(o.amount)                           AS revenue,
    ROUND(AVG(o.amount), 2)                 AS avg_order_value
FROM orders o
JOIN customers c  ON o.customer_id  = c.customer_id
JOIN products p   ON o.product_id   = p.product_id
WHERE o.status = 'completed'
  AND o.order_date >= '2024-01-01'    -- filter early, don't bring 10 years of history
GROUP BY 1, 2, 3
ORDER BY 1 DESC;
```

### Creating a Date Dimension table for Power BI
```sql
-- Power BI needs a proper date table for time intelligence (YTD, MoM, etc.)
CREATE VIEW dim_date AS
SELECT
    d::DATE                             AS date_key,
    d::DATE                             AS full_date,
    EXTRACT(YEAR  FROM d)::INT          AS year,
    EXTRACT(MONTH FROM d)::INT          AS month_num,
    TO_CHAR(d, 'Month')                 AS month_name,
    TO_CHAR(d, 'Mon')                   AS month_short,
    EXTRACT(QUARTER FROM d)::INT        AS quarter,
    EXTRACT(DOW FROM d)::INT            AS day_of_week,
    TO_CHAR(d, 'Day')                   AS day_name,
    EXTRACT(DOY FROM d)::INT            AS day_of_year,
    EXTRACT(WEEK FROM d)::INT           AS week_number,
    CASE WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN FALSE ELSE TRUE END AS is_weekday,
    DATE_TRUNC('month', d)::DATE        AS first_of_month,
    (DATE_TRUNC('month', d) + INTERVAL '1 month - 1 day')::DATE AS last_of_month
FROM generate_series('2020-01-01'::DATE, '2030-12-31'::DATE, '1 day') d;
```

### KPI query optimized for Power BI cards
```sql
-- Flat summary table — one row per period — great for KPI cards
SELECT
    'Current Month'                                  AS period,
    SUM(CASE WHEN order_date >= DATE_TRUNC('month', CURRENT_DATE)
             THEN amount END)                        AS revenue,
    COUNT(DISTINCT CASE WHEN order_date >= DATE_TRUNC('month', CURRENT_DATE)
             THEN order_id END)                      AS orders,
    COUNT(DISTINCT CASE WHEN order_date >= DATE_TRUNC('month', CURRENT_DATE)
             THEN customer_id END)                   AS customers
FROM orders
WHERE status = 'completed';
```

### Creating a flattened view for Power BI (avoid complex joins in DirectQuery)
```sql
-- In DirectQuery, Power BI runs this for every filter interaction
-- Pre-joining in a view keeps it fast
CREATE VIEW vw_sales_report AS
SELECT
    o.order_id,
    o.order_date,
    o.amount,
    o.status,
    c.customer_id,
    c.name      AS customer_name,
    c.segment   AS customer_segment,
    c.city,
    c.region,
    p.product_id,
    p.name      AS product_name,
    p.category,
    p.brand
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p  ON o.product_id  = p.product_id;
```

### Row-Level Security (RLS) — filter data per user in Power BI
```sql
-- In SQL Server: restrict data based on the logged-in user
-- This feeds into Power BI's RLS feature

CREATE FUNCTION fn_user_region_filter()
RETURNS TABLE
AS RETURN (
    SELECT region
    FROM user_region_access
    WHERE username = USER_NAME()  -- current SQL Server user
);

-- Apply it as a security policy
CREATE SECURITY POLICY RegionFilter
ADD FILTER PREDICATE dbo.fn_user_region_filter() ON dbo.sales_data;
```

---

## ⚠️ Common Mistakes
- Loading full raw tables into Power BI — always pre-filter and pre-aggregate in SQL
- Using `SELECT *` as the data source — brings in unused columns, slows refresh
- Not creating a proper Date Dimension table — Power BI time intelligence breaks without it
- Doing complex transformations in Power Query that could be done in SQL — breaks query folding

---

## 🔗 Related Topics
- [T-SQL Specifics](01-t-sql-specifics.md)
- [Views & Materialized Views](../05-performance/02-views.md)
- [Query Optimization](../05-performance/03-query-optimization.md)
- [KPI Metrics](../11-data-analysis/05-kpi-metrics.md)
