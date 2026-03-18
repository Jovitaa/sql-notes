# Cohort Analysis

## 📌 What is it?
Cohort analysis groups users by a shared characteristic (usually when they first did something — signed up, made a purchase) and tracks their behavior over time. It answers: "Of users who joined in January, how many were still active in Month 2, Month 3?"

---

## 🔑 Key Concepts

### Why it matters for DA roles
- Reveals whether retention is improving or declining over time
- Compares behavior across different user groups
- Standard interview question at product/analytics companies
- Used in e-commerce, SaaS, mobile apps daily

### Key Terms
| Term | Meaning |
|---|---|
| **Cohort** | The group (usually defined by first event date) |
| **Cohort month** | When the user first appeared (signup month) |
| **Activity month** | The month being measured |
| **Period number** | Months since first activity (0 = first month) |
| **Retention rate** | % of cohort still active in a given period |

---

## 💻 Code Examples

### Step 1 — Find each user's cohort (first activity)
```sql
WITH user_cohorts AS (
    SELECT
        user_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM orders
    GROUP BY user_id
),
```

### Step 2 — Join back to get all activity
```sql
user_activity AS (
    SELECT
        o.user_id,
        uc.cohort_month,
        DATE_TRUNC('month', o.order_date) AS activity_month,
        -- How many months since they first appeared?
        EXTRACT(YEAR FROM AGE(
            DATE_TRUNC('month', o.order_date),
            uc.cohort_month
        )) * 12 +
        EXTRACT(MONTH FROM AGE(
            DATE_TRUNC('month', o.order_date),
            uc.cohort_month
        )) AS period_number
    FROM orders o
    JOIN user_cohorts uc ON o.user_id = uc.user_id
),
```

### Step 3 — Count retained users per cohort per period
```sql
cohort_counts AS (
    SELECT
        cohort_month,
        period_number,
        COUNT(DISTINCT user_id) AS retained_users
    FROM user_activity
    GROUP BY cohort_month, period_number
),

-- Get the original cohort size (period 0)
cohort_sizes AS (
    SELECT cohort_month, retained_users AS cohort_size
    FROM cohort_counts
    WHERE period_number = 0
)

-- Final: retention rate per cohort per period
SELECT
    cc.cohort_month,
    cc.period_number,
    cc.retained_users,
    cs.cohort_size,
    ROUND(cc.retained_users * 100.0 / cs.cohort_size, 1) AS retention_pct
FROM cohort_counts cc
JOIN cohort_sizes cs ON cc.cohort_month = cs.cohort_month
ORDER BY cohort_month, period_number;
```

### Result looks like:
```
cohort_month | period | retained | size | retention_pct
2026-01-01   |   0    |   500    | 500  |   100.0%
2026-01-01   |   1    |   310    | 500  |    62.0%
2026-01-01   |   2    |   210    | 500  |    42.0%
2026-02-01   |   0    |   450    | 450  |   100.0%
2026-02-01   |   1    |   290    | 450  |    64.4%
```

---

## ⚠️ Common Mistakes
- Using `order_date` directly instead of truncating to month — gives too many groups
- Not anchoring to first activity — using any activity date gives wrong cohort assignments
- Forgetting users who churned appear in 0 rows — they're absent, not NULL

---

## 🔗 Related Topics
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [CTEs](../07-advanced-querying/02-ctes.md)
- [Date Functions](../09-functions/03-date-functions.md)
- [Funnel Analysis](03-funnel-analysis.md)
