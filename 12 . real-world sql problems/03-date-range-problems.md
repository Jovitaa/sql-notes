# Date Range Problems

## 📌 What is it?
Date range problems involve working with intervals — overlapping periods, finding what was active on a given date, calculating duration, and handling edge cases like open-ended ranges. These appear constantly in subscription analytics, scheduling, HR systems, and billing.

---

## 🔑 Key Concepts

### Common Date Range Scenarios
| Scenario | Real example |
|---|---|
| **Point-in-time lookup** | How many subscriptions were active on March 1? |
| **Overlap detection** | Are any two bookings for the same room overlapping? |
| **Duration calculation** | How long was each subscription active? |
| **Open-ended ranges** | Subscriptions with no end date (still active) |
| **Filling missing dates** | A calendar table to fill in days with no data |

### The Overlap Rule
Two ranges (A_start, A_end) and (B_start, B_end) overlap when:
```
A_start <= B_end AND A_end >= B_start
```

---

## 💻 Code Examples

### Who was active on a specific date?
```sql
-- Active subscriptions on March 1, 2026
SELECT customer_id, plan, start_date, end_date
FROM subscriptions
WHERE start_date <= '2026-03-01'
  AND (end_date >= '2026-03-01' OR end_date IS NULL);  -- NULL = still active
```

### Count active records per day (over a period)
```sql
-- Active subscriptions for each day in March 2026
WITH calendar AS (
    -- Generate a series of dates
    SELECT generate_series(
        '2026-03-01'::DATE,
        '2026-03-31'::DATE,
        '1 day'::INTERVAL
    )::DATE AS day
)
SELECT
    c.day,
    COUNT(s.customer_id) AS active_subscriptions
FROM calendar c
LEFT JOIN subscriptions s
    ON s.start_date <= c.day
    AND (s.end_date >= c.day OR s.end_date IS NULL)
GROUP BY c.day
ORDER BY c.day;
```

### Detect overlapping bookings
```sql
-- Find any two bookings for the same room that overlap
SELECT
    a.booking_id AS booking1,
    b.booking_id AS booking2,
    a.room_id,
    a.check_in  AS booking1_start,
    a.check_out AS booking1_end,
    b.check_in  AS booking2_start,
    b.check_out AS booking2_end
FROM bookings a
JOIN bookings b
    ON a.room_id = b.room_id
    AND a.booking_id < b.booking_id     -- avoid self-join and duplicate pairs
    AND a.check_in  < b.check_out       -- overlap condition
    AND a.check_out > b.check_in;
```

### Calculate duration of each subscription
```sql
SELECT
    customer_id,
    plan,
    start_date,
    end_date,
    COALESCE(end_date, CURRENT_DATE) - start_date AS days_active,
    AGE(COALESCE(end_date, CURRENT_DATE), start_date) AS duration
FROM subscriptions
ORDER BY days_active DESC;
```

### Generate a date series (calendar table)
```sql
-- PostgreSQL: generate every day in 2026
SELECT generate_series(
    '2026-01-01'::DATE,
    '2026-12-31'::DATE,
    '1 day'::INTERVAL
)::DATE AS calendar_date;

-- Use this to fill in missing dates in reporting
WITH calendar AS (
    SELECT generate_series('2026-01-01'::DATE, '2026-12-31'::DATE, '1 day')::DATE AS day
),
daily_sales AS (
    SELECT DATE_TRUNC('day', order_date)::DATE AS day, SUM(amount) AS revenue
    FROM orders GROUP BY 1
)
SELECT
    c.day,
    COALESCE(ds.revenue, 0) AS revenue   -- 0 for days with no sales
FROM calendar c
LEFT JOIN daily_sales ds ON c.day = ds.day
ORDER BY c.day;
```

### Find customers whose subscription lapsed and restarted
```sql
WITH ordered_subs AS (
    SELECT
        customer_id,
        start_date,
        end_date,
        LAG(end_date) OVER (PARTITION BY customer_id ORDER BY start_date) AS prev_end
    FROM subscriptions
)
SELECT
    customer_id,
    prev_end    AS churned_on,
    start_date  AS reactivated_on,
    start_date - prev_end AS days_churned
FROM ordered_subs
WHERE prev_end IS NOT NULL
  AND start_date > prev_end + INTERVAL '1 day'   -- gap of more than 1 day = churn
ORDER BY days_churned DESC;
```

---

## ⚠️ Common Mistakes
- Using `BETWEEN` for date ranges — it's inclusive on both ends; a subscription ending Dec 31 and one starting Jan 1 could both match Dec 31
- Not handling `NULL` end dates — open-ended subscriptions need `COALESCE(end_date, CURRENT_DATE)` or `OR end_date IS NULL`
- Forgetting timezone differences — use `TIMESTAMPTZ` and convert consistently

```sql
-- ❌ BETWEEN is fully inclusive — can double-count boundary dates
WHERE event_date BETWEEN '2026-01-01' AND '2026-01-31'

-- ✅ Explicit range avoids boundary issues
WHERE event_date >= '2026-01-01' AND event_date < '2026-02-01'
```

---

## 🔗 Related Topics
- [Gaps and Islands](02-gaps-and-islands.md)
- [Date Functions](../09-functions/03-date-functions.md)
- [KPI Metrics](../11-data-analysis/05-kpi-metrics.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
