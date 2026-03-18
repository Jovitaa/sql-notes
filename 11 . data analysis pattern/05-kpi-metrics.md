# KPI Metrics in SQL

## 📌 What is it?
KPIs (Key Performance Indicators) are the standard metrics every business tracks. As a DA, you'll write these queries daily — for dashboards, stakeholder reports, and ad-hoc analysis. Knowing the standard SQL patterns for each metric saves hours of reinventing every time.

---

## 🔑 Key Concepts

### The Most Common Business KPIs
| Category | KPI | Abbreviation |
|---|---|---|
| User activity | Daily/Weekly/Monthly Active Users | DAU, WAU, MAU |
| Growth | New users per period | — |
| Retention | Users who return after first use | — |
| Churn | Users who stop using the product | — |
| Revenue | Total, average, per user | GMV, ARPU |
| E-commerce | Conversion rate, AOV, refund rate | CVR, AOV |

---

## 💻 Code Examples

### DAU, WAU, MAU — active users
```sql
-- Daily Active Users
SELECT
    DATE_TRUNC('day', event_date) AS day,
    COUNT(DISTINCT user_id)       AS dau
FROM user_events
WHERE event_type = 'login'
GROUP BY 1
ORDER BY 1 DESC;

-- Monthly Active Users
SELECT
    DATE_TRUNC('month', event_date) AS month,
    COUNT(DISTINCT user_id)         AS mau
FROM user_events
GROUP BY 1
ORDER BY 1 DESC;

-- DAU/MAU ratio (engagement quality — higher = better)
WITH dau AS (
    SELECT event_date, COUNT(DISTINCT user_id) AS daily_users
    FROM user_events GROUP BY event_date
),
mau AS (
    SELECT
        DATE_TRUNC('month', event_date) AS month,
        COUNT(DISTINCT user_id)         AS monthly_users
    FROM user_events GROUP BY 1
)
SELECT
    d.event_date,
    d.daily_users,
    m.monthly_users,
    ROUND(d.daily_users * 100.0 / m.monthly_users, 1) AS dau_mau_ratio
FROM dau d
JOIN mau m ON DATE_TRUNC('month', d.event_date) = m.month
ORDER BY d.event_date DESC;
```

### New vs Returning users
```sql
WITH first_seen AS (
    SELECT user_id, MIN(event_date) AS first_date
    FROM user_events GROUP BY user_id
)
SELECT
    e.event_date,
    COUNT(DISTINCT CASE WHEN e.event_date = f.first_date THEN e.user_id END) AS new_users,
    COUNT(DISTINCT CASE WHEN e.event_date > f.first_date  THEN e.user_id END) AS returning_users
FROM user_events e
JOIN first_seen f ON e.user_id = f.user_id
GROUP BY e.event_date
ORDER BY e.event_date DESC;
```

### Retention rate (Day 1, Day 7, Day 30)
```sql
WITH first_seen AS (
    SELECT user_id, MIN(event_date) AS first_date
    FROM user_events GROUP BY user_id
)
SELECT
    f.first_date AS cohort_date,
    COUNT(DISTINCT f.user_id)                                       AS cohort_size,
    COUNT(DISTINCT CASE
        WHEN e.event_date = f.first_date + INTERVAL '1 day'
        THEN e.user_id END)                                         AS day1_retained,
    COUNT(DISTINCT CASE
        WHEN e.event_date = f.first_date + INTERVAL '7 days'
        THEN e.user_id END)                                         AS day7_retained,
    COUNT(DISTINCT CASE
        WHEN e.event_date = f.first_date + INTERVAL '30 days'
        THEN e.user_id END)                                         AS day30_retained,
    ROUND(COUNT(DISTINCT CASE
        WHEN e.event_date = f.first_date + INTERVAL '1 day'
        THEN e.user_id END) * 100.0 / COUNT(DISTINCT f.user_id), 1) AS day1_pct
FROM first_seen f
LEFT JOIN user_events e ON f.user_id = e.user_id
GROUP BY f.first_date
ORDER BY f.first_date DESC;
```

### Churn rate
```sql
-- Users active last month but NOT this month = churned
WITH last_month AS (
    SELECT DISTINCT user_id FROM user_events
    WHERE event_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
      AND event_date <  DATE_TRUNC('month', CURRENT_DATE)
),
this_month AS (
    SELECT DISTINCT user_id FROM user_events
    WHERE event_date >= DATE_TRUNC('month', CURRENT_DATE)
)
SELECT
    COUNT(DISTINCT lm.user_id)                    AS last_month_users,
    COUNT(DISTINCT tm.user_id)                    AS this_month_users,
    COUNT(DISTINCT lm.user_id) -
    COUNT(DISTINCT tm.user_id)                    AS churned_users,
    ROUND(
        (COUNT(DISTINCT lm.user_id) -
         COUNT(DISTINCT tm.user_id)) * 100.0
        / COUNT(DISTINCT lm.user_id), 1
    )                                             AS churn_rate_pct
FROM last_month lm
LEFT JOIN this_month tm ON lm.user_id = tm.user_id;
```

### Revenue KPIs — GMV, ARPU, AOV
```sql
SELECT
    DATE_TRUNC('month', order_date)          AS month,
    SUM(amount)                              AS gmv,             -- Gross Merchandise Value
    COUNT(DISTINCT user_id)                  AS paying_users,
    ROUND(SUM(amount) / COUNT(DISTINCT user_id), 2) AS arpu,    -- Avg Revenue Per User
    COUNT(*)                                 AS total_orders,
    ROUND(SUM(amount) / COUNT(*), 2)         AS aov,            -- Average Order Value
    COUNT(CASE WHEN status = 'refunded' THEN 1 END) AS refunds,
    ROUND(COUNT(CASE WHEN status = 'refunded' THEN 1 END)
          * 100.0 / COUNT(*), 1)             AS refund_rate_pct
FROM orders
WHERE status != 'cancelled'
GROUP BY 1
ORDER BY 1 DESC;
```

---

## ⚠️ Common Mistakes
- Not defining "active" clearly — does it mean logged in, or took a specific action?
- Double-counting users who appear in multiple sessions on the same day — always use `COUNT(DISTINCT user_id)`
- Forgetting to exclude test/internal users from metrics — filter them out with a known user list or flag

---

## 🔗 Related Topics
- [Funnel Analysis](03-funnel-analysis.md)
- [Cohort Analysis](02-cohort-analysis.md)
- [Running Totals & Cumulative](07-running-totals-cumulative.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
