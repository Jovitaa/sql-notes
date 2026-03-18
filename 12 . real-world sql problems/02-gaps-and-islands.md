# Gaps and Islands

## 📌 What is it?
"Gaps and islands" is a classic SQL problem about finding consecutive sequences (islands) and breaks in those sequences (gaps) in ordered data. It appears in real DA work whenever you need to find consecutive active days, uninterrupted subscriptions, login streaks, or session boundaries.

---

## 🔑 Key Concepts

### The Problem
Given a series of dates or IDs, find:
- **Islands** — consecutive groups (e.g., a user logged in 5 days in a row)
- **Gaps** — breaks between groups (e.g., a subscription lapsed for 3 days)

### Real examples
- Find users with login streaks of 7+ days
- Find periods when a sensor was continuously active
- Find subscription gaps (to calculate churn duration)
- Find consecutive order days for loyalty rewards

---

## 💻 Code Examples

### Find consecutive login days (the classic problem)
```sql
-- Step 1: Get distinct login dates per user
WITH login_dates AS (
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('day', login_time)::DATE AS login_date
    FROM user_sessions
),

-- Step 2: Subtract a row number from the date — same value = consecutive group
grouped AS (
    SELECT
        user_id,
        login_date,
        login_date - ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY login_date
        )::INTEGER AS grp   -- same value for consecutive dates
),

-- Step 3: Group by user + grp to find each streak
streaks AS (
    SELECT
        user_id,
        MIN(login_date) AS streak_start,
        MAX(login_date) AS streak_end,
        COUNT(*)        AS streak_length
    FROM grouped
    GROUP BY user_id, grp
)

-- Step 4: Find streaks >= 7 days
SELECT *
FROM streaks
WHERE streak_length >= 7
ORDER BY streak_length DESC;
```

### Find gaps in a date sequence
```sql
-- Find periods when a user was NOT active
WITH login_dates AS (
    SELECT DISTINCT user_id, login_date::DATE
    FROM user_sessions
    WHERE user_id = 1001
    ORDER BY login_date
),
with_next AS (
    SELECT
        login_date,
        LEAD(login_date) OVER (ORDER BY login_date) AS next_login
    FROM login_dates
)
SELECT
    login_date              AS last_active,
    next_login              AS returned,
    next_login - login_date AS gap_days
FROM with_next
WHERE next_login - login_date > 1   -- gap of more than 1 day
ORDER BY gap_days DESC;
```

### Find subscription gaps (active periods and lapses)
```sql
WITH sub_periods AS (
    SELECT
        customer_id,
        start_date,
        end_date,
        LAG(end_date) OVER (
            PARTITION BY customer_id ORDER BY start_date
        ) AS prev_end
    FROM subscriptions
)
SELECT
    customer_id,
    prev_end     AS lapsed_on,
    start_date   AS reactivated_on,
    start_date - prev_end AS gap_days
FROM sub_periods
WHERE prev_end IS NOT NULL
  AND start_date > prev_end   -- there's a gap between periods
ORDER BY gap_days DESC;
```

### Count active records on a given date (overlapping ranges)
```sql
-- How many subscriptions were active on 2026-03-01?
SELECT COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE start_date <= '2026-03-01'
  AND (end_date >= '2026-03-01' OR end_date IS NULL);
```

---

## ⚠️ Common Mistakes
- Forgetting `DISTINCT` before finding sequences — duplicate dates break the row number trick
- Using `DATEDIFF` or subtraction without accounting for timezone — can give off-by-one errors
- The row_number subtraction trick only works for **dates** (or integer sequences), not timestamps

```sql
-- ❌ Won't work for timestamps — use DATE_TRUNC first
login_timestamp - ROW_NUMBER() OVER (ORDER BY login_timestamp)

-- ✅ Truncate to day first
DATE_TRUNC('day', login_timestamp)::DATE - ROW_NUMBER() OVER (...)::INTEGER
```

---

## 🔗 Related Topics
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [Date Functions](../09-functions/03-date-functions.md)
- [Date Range Problems](03-date-range-problems.md)
- [KPI Metrics](../11-data-analysis/05-kpi-metrics.md)
