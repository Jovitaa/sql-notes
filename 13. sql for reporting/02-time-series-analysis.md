# Time Series Analysis in SQL

## 📌 What is it?
Time series analysis is about understanding how data changes over time — trends, seasonality, spikes, and anomalies. It's one of the most common tasks for a DA: revenue over time, user growth, performance degradation, seasonal patterns.

---

## 🔑 Key Concepts

### Common Time Series Tasks
| Task | Description |
|---|---|
| **Trend analysis** | Is the metric going up, down, or flat? |
| **Seasonality detection** | Does it spike every weekend, month-end, or Q4? |
| **Anomaly detection** | Did something unusual happen on a specific day? |
| **Forecasting inputs** | Pull clean historical data for ML models |
| **Period comparison** | This week vs last week, this month vs last year |

---

## 💻 Code Examples

### Daily trend with 7-day rolling average (smooths noise)
```sql
WITH daily AS (
    SELECT
        DATE_TRUNC('day', order_date)::DATE AS day,
        COUNT(*)        AS orders,
        SUM(amount)     AS revenue
    FROM orders
    GROUP BY 1
)
SELECT
    day,
    orders,
    revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY day
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7d_avg,
    ROUND(AVG(revenue) OVER (
        ORDER BY day
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_30d_avg
FROM daily
ORDER BY day DESC;
```

### Detect day-of-week seasonality
```sql
SELECT
    TO_CHAR(order_date, 'Day') AS day_of_week,
    EXTRACT(DOW FROM order_date) AS dow_num,   -- 0=Sunday, 6=Saturday
    COUNT(*) AS total_orders,
    ROUND(AVG(amount), 2) AS avg_order_value
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY 1, 2
ORDER BY dow_num;
```

### Month-over-month growth with trend direction
```sql
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(amount) AS revenue
    FROM orders
    GROUP BY 1
),
with_growth AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
        ROUND((revenue - LAG(revenue) OVER (ORDER BY month))
              * 100.0 / LAG(revenue) OVER (ORDER BY month), 1) AS mom_pct
    FROM monthly
)
SELECT
    month,
    revenue,
    prev_revenue,
    mom_pct,
    CASE
        WHEN mom_pct > 5  THEN '📈 Strong growth'
        WHEN mom_pct > 0  THEN '↗ Slight growth'
        WHEN mom_pct = 0  THEN '→ Flat'
        WHEN mom_pct > -5 THEN '↘ Slight decline'
        ELSE '📉 Strong decline'
    END AS trend
FROM with_growth
ORDER BY month DESC;
```

### Detect anomalies — days significantly above/below average
```sql
WITH daily AS (
    SELECT
        DATE_TRUNC('day', order_date)::DATE AS day,
        SUM(amount) AS revenue
    FROM orders
    GROUP BY 1
),
stats AS (
    SELECT
        AVG(revenue)    AS mean_revenue,
        STDDEV(revenue) AS stddev_revenue
    FROM daily
)
SELECT
    d.day,
    d.revenue,
    s.mean_revenue,
    ROUND((d.revenue - s.mean_revenue) / s.stddev_revenue, 2) AS z_score,
    CASE
        WHEN ABS((d.revenue - s.mean_revenue) / s.stddev_revenue) > 2
        THEN '⚠️ Anomaly'
        ELSE 'Normal'
    END AS flag
FROM daily d, stats s
WHERE ABS((d.revenue - s.mean_revenue) / s.stddev_revenue) > 2
ORDER BY ABS((d.revenue - s.mean_revenue) / s.stddev_revenue) DESC;
```

### Same day last week / last year comparison
```sql
SELECT
    curr.day,
    curr.revenue            AS today_revenue,
    last_week.revenue       AS last_week_revenue,
    last_year.revenue       AS last_year_revenue,
    ROUND((curr.revenue - last_week.revenue) * 100.0
          / last_week.revenue, 1) AS wow_pct,
    ROUND((curr.revenue - last_year.revenue) * 100.0
          / last_year.revenue, 1) AS yoy_pct
FROM daily_revenue curr
LEFT JOIN daily_revenue last_week ON curr.day - INTERVAL '7 days'  = last_week.day
LEFT JOIN daily_revenue last_year ON curr.day - INTERVAL '1 year'  = last_year.day
ORDER BY curr.day DESC;
```

### Fill missing dates in a time series
```sql
-- Without a calendar join, days with no orders simply disappear from results
WITH calendar AS (
    SELECT generate_series(
        (SELECT MIN(order_date) FROM orders)::DATE,
        CURRENT_DATE,
        '1 day'::INTERVAL
    )::DATE AS day
),
daily_orders AS (
    SELECT DATE_TRUNC('day', order_date)::DATE AS day, SUM(amount) AS revenue
    FROM orders GROUP BY 1
)
SELECT
    c.day,
    COALESCE(d.revenue, 0) AS revenue   -- 0 on days with no orders
FROM calendar c
LEFT JOIN daily_orders d ON c.day = d.day
ORDER BY c.day;
```

---

## ⚠️ Common Mistakes
- Missing dates in time series — always join to a calendar table to fill gaps with 0
- Rolling averages on incomplete windows — the first N-1 rows have fewer data points; decide whether to show or exclude them
- Comparing different time zones — a "day" is different across regions; use `TIMESTAMPTZ` and normalize

---

## 🔗 Related Topics
- [Running Totals & Cumulative](../11-data-analysis/07-running-totals-cumulative.md)
- [Date Functions](../09-functions/03-date-functions.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [Date Range Problems](02-gaps-and-islands.md)
