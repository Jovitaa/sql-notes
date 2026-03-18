# Date & Time Functions

## 📌 What is it?
Date and time functions let you work with dates and timestamps in queries — extracting parts, calculating differences, formatting output, and filtering by time ranges.

---

## 🔑 Key Concepts

### Getting the Current Date/Time
| Function | Returns |
|---|---|
| `NOW()` | Current date + time + timezone |
| `CURRENT_TIMESTAMP` | Same as `NOW()` (SQL standard) |
| `CURRENT_DATE` | Today's date only |
| `CURRENT_TIME` | Current time only |

### Extracting Parts of a Date
| Function | Example | Result |
|---|---|---|
| `EXTRACT(part FROM date)` | `EXTRACT(YEAR FROM NOW())` | `2026` |
| `DATE_PART(part, date)` | `DATE_PART('month', NOW())` | `3` |
| `DATE_TRUNC(unit, date)` | `DATE_TRUNC('month', NOW())` | `2026-03-01 00:00:00` |

### Parts you can extract
`YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `SECOND`, `DOW` (day of week), `DOY` (day of year), `WEEK`, `QUARTER`

### Date Arithmetic
```sql
-- Add/subtract intervals
date + INTERVAL '7 days'
date - INTERVAL '1 month'
date + INTERVAL '2 years 3 months'

-- Difference between two dates
AGE(end_date, start_date)       -- returns an interval
end_date - start_date           -- returns number of days (PostgreSQL)
```

---

## 💻 Code Examples

### Get current date and time
```sql
SELECT
    NOW()             AS current_timestamp,
    CURRENT_DATE      AS today,
    CURRENT_TIME      AS right_now;
```

### Extract parts from a date
```sql
SELECT
    order_date,
    EXTRACT(YEAR  FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    EXTRACT(DAY   FROM order_date) AS day,
    TO_CHAR(order_date, 'Month YYYY') AS formatted   -- e.g., 'March 2026'
FROM orders;
```

### DATE_TRUNC — group by time period
```sql
-- Monthly sales totals
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS monthly_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
```

### Date arithmetic
```sql
-- Orders placed in the last 30 days
SELECT * FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';

-- Orders placed this month
SELECT * FROM orders
WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE);

-- Calculate age / days since signup
SELECT
    customer_name,
    created_at,
    AGE(CURRENT_DATE, created_at::DATE) AS account_age,
    CURRENT_DATE - created_at::DATE     AS days_since_signup
FROM customers;
```

### Format dates for display
```sql
SELECT
    TO_CHAR(order_date, 'DD Mon YYYY')        AS formatted,    -- '18 Mar 2026'
    TO_CHAR(order_date, 'YYYY-MM-DD')         AS iso_format,   -- '2026-03-18'
    TO_CHAR(order_date, 'Day, DD Month YYYY') AS full_format   -- 'Wednesday, 18 March 2026'
FROM orders;
```

### Filtering by date range
```sql
-- Between two specific dates
SELECT * FROM orders
WHERE order_date BETWEEN '2026-01-01' AND '2026-03-31';

-- Current year only
SELECT * FROM orders
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE);

-- Last 7 days
SELECT * FROM orders
WHERE order_date >= NOW() - INTERVAL '7 days';
```

---

## ⚠️ Common Mistakes
- Using `TIMESTAMP` instead of `TIMESTAMPTZ` — loses timezone context, causes bugs across regions
- Comparing dates as strings (`WHERE date = '2026-03-18'`) — works sometimes but is fragile; use proper date types
- `BETWEEN` is inclusive on both ends — `BETWEEN '2026-01-01' AND '2026-01-31'` includes all of Jan 31st up to midnight only
- Forgetting that `DATE_TRUNC` rounds down — `DATE_TRUNC('month', '2026-03-18')` → `2026-03-01`

```sql
-- ❌ Misses orders on 2026-01-31 after midnight if using TIMESTAMP
WHERE order_date BETWEEN '2026-01-01' AND '2026-01-31'

-- ✅ Use < next day for full day coverage
WHERE order_date >= '2026-01-01' AND order_date < '2026-02-01'
```

---

## 🔗 Related Topics
- [Data Types](../01-fundamentals/04-data-types.md)
- [SELECT Statement](../02-querying/01-select-statement.md)
- [GROUP BY](../02-querying/03-group-by.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
