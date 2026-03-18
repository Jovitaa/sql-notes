# Reporting Patterns in SQL

## 📌 What is it?
Reporting patterns are reusable SQL structures that power dashboards and stakeholder reports. As a DA, you'll write the same types of queries repeatedly — summary tables, scorecards, ranked lists, exception reports. Knowing these patterns saves time and produces consistent, reliable outputs.

---

## 🔑 Key Concepts

### Common Report Types
| Report Type | What it shows | SQL Pattern |
|---|---|---|
| **Scorecard** | Single KPI value | Aggregate + filter |
| **Ranked list** | Top/bottom N | `ORDER BY` + `LIMIT` or `ROW_NUMBER` |
| **Summary table** | Metrics by dimension | `GROUP BY` |
| **Comparison report** | Current vs previous period | `LAG` or self-JOIN |
| **Exception report** | Items outside normal range | `WHERE` + threshold |
| **Distribution report** | How values spread | `NTILE`, `PERCENTILE_CONT`, histogram buckets |

---

## 💻 Code Examples

### Scorecard — single KPI with comparison
```sql
WITH current_month AS (
    SELECT SUM(amount) AS revenue
    FROM orders
    WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE)
      AND status = 'completed'
),
last_month AS (
    SELECT SUM(amount) AS revenue
    FROM orders
    WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
      AND order_date <  DATE_TRUNC('month', CURRENT_DATE)
      AND status = 'completed'
)
SELECT
    c.revenue                                       AS current_revenue,
    l.revenue                                       AS last_month_revenue,
    c.revenue - l.revenue                           AS absolute_change,
    ROUND((c.revenue - l.revenue) * 100.0
          / l.revenue, 1)                           AS pct_change
FROM current_month c, last_month l;
```

### Top N ranked list with % of total
```sql
-- Top 10 products by revenue with share of total
SELECT
    p.product_name,
    SUM(o.amount)                                          AS revenue,
    ROUND(SUM(o.amount) * 100.0 / SUM(SUM(o.amount))
          OVER(), 1)                                       AS pct_of_total,
    RANK() OVER (ORDER BY SUM(o.amount) DESC)              AS rank
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'completed'
  AND o.order_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;
```

### Multi-metric summary table by dimension
```sql
-- Full business summary by region
SELECT
    c.region,
    COUNT(DISTINCT o.order_id)                             AS total_orders,
    COUNT(DISTINCT o.customer_id)                          AS unique_customers,
    SUM(o.amount)                                          AS total_revenue,
    ROUND(AVG(o.amount), 2)                                AS avg_order_value,
    COUNT(DISTINCT CASE WHEN o.status = 'refunded'
        THEN o.order_id END)                               AS refunds,
    ROUND(COUNT(DISTINCT CASE WHEN o.status = 'refunded'
        THEN o.order_id END) * 100.0
        / COUNT(DISTINCT o.order_id), 1)                   AS refund_rate_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date BETWEEN '2026-01-01' AND '2026-03-31'
GROUP BY c.region
ORDER BY total_revenue DESC;
```

### Exception report — flag underperforming items
```sql
-- Products with below-average sales this month
WITH product_sales AS (
    SELECT
        p.product_name,
        SUM(o.amount) AS revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    WHERE o.order_date >= DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY p.product_name
),
avg_sales AS (
    SELECT AVG(revenue) AS avg_revenue FROM product_sales
)
SELECT
    ps.product_name,
    ps.revenue,
    a.avg_revenue,
    ROUND((ps.revenue - a.avg_revenue) * 100.0 / a.avg_revenue, 1) AS pct_vs_avg,
    '⚠️ Below average' AS flag
FROM product_sales ps, avg_sales a
WHERE ps.revenue < a.avg_revenue * 0.7   -- more than 30% below average
ORDER BY pct_vs_avg ASC;
```

### Distribution report — histogram buckets
```sql
-- Distribute order values into buckets
SELECT
    CASE
        WHEN amount < 500           THEN '< 500'
        WHEN amount BETWEEN 500 AND 999   THEN '500 - 999'
        WHEN amount BETWEEN 1000 AND 4999 THEN '1000 - 4999'
        WHEN amount >= 5000         THEN '5000+'
    END AS order_bucket,
    COUNT(*)                        AS orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct
FROM orders
WHERE status = 'completed'
GROUP BY 1
ORDER BY MIN(amount);
```

### Week-over-week comparison table
```sql
WITH weekly AS (
    SELECT
        DATE_TRUNC('week', order_date)::DATE AS week_start,
        SUM(amount)     AS revenue,
        COUNT(*)        AS orders,
        COUNT(DISTINCT customer_id) AS customers
    FROM orders
    WHERE status = 'completed'
    GROUP BY 1
)
SELECT
    week_start,
    revenue,
    orders,
    customers,
    LAG(revenue) OVER (ORDER BY week_start)  AS prev_week_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY week_start))
        * 100.0 / LAG(revenue) OVER (ORDER BY week_start), 1) AS wow_pct
FROM weekly
ORDER BY week_start DESC;
```

---

## ⚠️ Common Mistakes
- Hardcoding date ranges — use `CURRENT_DATE` and `INTERVAL` so reports stay fresh
- Not labelling columns clearly — output column names should be self-explanatory for stakeholders
- Mixing different date grains in the same report — weekly and monthly numbers in one table confuses readers
- Forgetting to exclude cancelled/refunded orders from revenue — always filter on `status`

---

## 🔗 Related Topics
- [KPI Metrics](../11-data-analysis/05-kpi-metrics.md)
- [Running Totals & Cumulative](../11-data-analysis/07-running-totals-cumulative.md)
- [Pivot Tables & Crosstab](../11-data-analysis/06-pivot-crosstab.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [Views & Materialized Views](../05-performance/02-views.md)
