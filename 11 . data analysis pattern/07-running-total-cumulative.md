# Running Totals & Cumulative Metrics

## 📌 What is it?
Running totals (cumulative sums) accumulate values over time — showing not just what happened today, but the total so far. These appear in almost every business dashboard: cumulative revenue, running user count, month-to-date sales, period-over-period growth.

---

## 🔑 Key Concepts

### Types of cumulative calculations
| Metric | Description |
|---|---|
| **Running total** | Sum of all values up to and including current row |
| **Cumulative distinct count** | Unique users/customers seen so far |
| **Period-over-period** | This week vs last week, this month vs last month |
| **Month-to-date (MTD)** | Total from start of current month to today |
| **Year-to-date (YTD)** | Total from start of current year to today |
| **Rolling average** | Average over a moving window (e.g., last 7 days) |

---

## 💻 Code Examples

### Running total — cumulative revenue
```sql
SELECT
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM (
    SELECT
        DATE_TRUNC('day', order_date) AS order_date,
        SUM(amount) AS daily_revenue
    FROM orders
    GROUP BY 1
) daily
ORDER BY order_date;
```

### Running total — reset each month (month-to-date)
```sql
SELECT
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (
        PARTITION BY DATE_TRUNC('month', order_date)  -- reset each month
        ORDER BY order_date
    ) AS mtd_revenue
FROM (
    SELECT DATE_TRUNC('day', order_date) AS order_date, SUM(amount) AS daily_revenue
    FROM orders GROUP BY 1
) daily;
```

### Year-to-date revenue
```sql
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS monthly_revenue,
    SUM(SUM(amount)) OVER (
        PARTITION BY DATE_TRUNC('year', order_date)
        ORDER BY DATE_TRUNC('month', order_date)
    ) AS ytd_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
```

### Period-over-period — MoM revenue growth
```sql
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(amount) AS revenue
    FROM orders
    GROUP BY 1
)
SELECT
    month,
    revenue,
    LAG(revenue, 1) OVER (ORDER BY month)    AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue, 1) OVER (ORDER BY month))
        * 100.0 / LAG(revenue, 1) OVER (ORDER BY month),
    1) AS mom_growth_pct
FROM monthly
ORDER BY month;
```

### 7-day rolling average
```sql
SELECT
    event_date,
    daily_users,
    ROUND(AVG(daily_users) OVER (
        ORDER BY event_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 0) AS rolling_7day_avg
FROM (
    SELECT DATE_TRUNC('day', event_date) AS event_date, COUNT(DISTINCT user_id) AS daily_users
    FROM user_events GROUP BY 1
) daily
ORDER BY event_date;
```

### Cumulative new users over time
```sql
WITH daily_new_users AS (
    SELECT
        MIN(event_date) AS first_seen,
        user_id
    FROM user_events
    GROUP BY user_id
),
daily_counts AS (
    SELECT
        first_seen AS date,
        COUNT(*) AS new_users
    FROM daily_new_users
    GROUP BY 1
)
SELECT
    date,
    new_users,
    SUM(new_users) OVER (ORDER BY date) AS total_users_ever
FROM daily_counts
ORDER BY date;
```

### Same period last year comparison
```sql
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(amount) AS revenue
    FROM orders
    GROUP BY 1
)
SELECT
    this_year.month,
    this_year.revenue AS this_year_revenue,
    last_year.revenue AS last_year_revenue,
    ROUND(
        (this_year.revenue - last_year.revenue) * 100.0
        / last_year.revenue, 1
    ) AS yoy_growth_pct
FROM monthly this_year
LEFT JOIN monthly last_year
    ON this_year.month = last_year.month + INTERVAL '1 year'
ORDER BY this_year.month DESC;
```

---

## ⚠️ Common Mistakes
- Forgetting `PARTITION BY` when you want the total to reset — without it, the running total never resets across months/years
- Using `RANGE BETWEEN` vs `ROWS BETWEEN` — they behave differently when there are ties in the ORDER BY column; prefer `ROWS BETWEEN` for predictable results
- Not handling missing dates — if a day has no sales, it won't appear in the result; use a calendar table to fill gaps

---

## 🔗 Related Topics
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [KPI Metrics](05-kpi-metrics.md)
- [Date Functions](../09-functions/03-date-functions.md)
- [Cohort Analysis](02-cohort-analysis.md)
