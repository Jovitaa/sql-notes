# A/B Testing in SQL

## 📌 What is it?
A/B testing (split testing) compares two versions of something — a webpage, feature, or email — by randomly assigning users to groups and measuring outcomes. SQL is used to set up the experiment table, calculate results, and determine statistical significance.

---

## 🔑 Key Concepts

### A/B Test Structure
```
experiment_assignments table:
  user_id | variant | assigned_at
  --------+---------+------------
  1001    | control | 2026-01-01
  1002    | test    | 2026-01-01
  1003    | control | 2026-01-01
```

### What to Calculate
| Metric | What it tells you |
|---|---|
| **Sample size per variant** | Are groups roughly equal? |
| **Conversion rate** | % of users who completed the goal |
| **Lift** | How much better/worse is test vs control |
| **Average metric** | Average revenue, clicks, time-on-page per user |

---

## 💻 Code Examples

### Basic A/B results — conversion rate per variant
```sql
SELECT
    ea.variant,
    COUNT(DISTINCT ea.user_id)                              AS users,
    COUNT(DISTINCT o.user_id)                               AS converters,
    ROUND(COUNT(DISTINCT o.user_id) * 100.0
          / COUNT(DISTINCT ea.user_id), 2)                  AS conversion_rate_pct
FROM experiment_assignments ea
LEFT JOIN orders o
    ON ea.user_id = o.user_id
    AND o.order_date >= ea.assigned_at   -- only orders AFTER assignment
WHERE ea.experiment_name = 'checkout_button_color'
  AND ea.assigned_at BETWEEN '2026-01-01' AND '2026-01-31'
GROUP BY ea.variant;
```

### Revenue per user per variant
```sql
SELECT
    ea.variant,
    COUNT(DISTINCT ea.user_id)                          AS users,
    SUM(COALESCE(o.amount, 0))                          AS total_revenue,
    ROUND(AVG(COALESCE(o.amount, 0)), 2)                AS avg_revenue_per_user,
    ROUND(SUM(COALESCE(o.amount, 0))
          / COUNT(DISTINCT ea.user_id), 2)              AS revenue_per_user
FROM experiment_assignments ea
LEFT JOIN orders o
    ON ea.user_id = o.user_id
    AND o.order_date >= ea.assigned_at
WHERE ea.experiment_name = 'checkout_button_color'
GROUP BY ea.variant;
```

### Check for sample ratio mismatch (SRM)
```sql
-- SRM: if your 50/50 split is actually 60/40, the test is invalid
SELECT
    variant,
    COUNT(*) AS users,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_total
FROM experiment_assignments
WHERE experiment_name = 'checkout_button_color'
GROUP BY variant;
-- If pct_of_total is not ~50/50, your randomization has a bug
```

### Lift calculation
```sql
WITH results AS (
    SELECT
        variant,
        ROUND(COUNT(DISTINCT o.user_id) * 100.0
              / COUNT(DISTINCT ea.user_id), 2) AS conversion_rate
    FROM experiment_assignments ea
    LEFT JOIN orders o ON ea.user_id = o.user_id
        AND o.order_date >= ea.assigned_at
    WHERE ea.experiment_name = 'checkout_button_color'
    GROUP BY variant
)
SELECT
    MAX(CASE WHEN variant = 'test'    THEN conversion_rate END) AS test_rate,
    MAX(CASE WHEN variant = 'control' THEN conversion_rate END) AS control_rate,
    ROUND(
        (MAX(CASE WHEN variant = 'test'    THEN conversion_rate END) -
         MAX(CASE WHEN variant = 'control' THEN conversion_rate END))
        / MAX(CASE WHEN variant = 'control' THEN conversion_rate END) * 100,
    2) AS lift_pct
FROM results;
```

### Multi-variant test (A/B/C)
```sql
SELECT
    variant,
    COUNT(DISTINCT ea.user_id) AS users,
    COUNT(DISTINCT o.user_id)  AS converters,
    ROUND(COUNT(DISTINCT o.user_id) * 100.0
          / COUNT(DISTINCT ea.user_id), 2) AS cvr
FROM experiment_assignments ea
LEFT JOIN orders o ON ea.user_id = o.user_id
    AND o.order_date >= ea.assigned_at
WHERE ea.experiment_name = 'pricing_page_test'
GROUP BY variant
ORDER BY cvr DESC;
```

---

## ⚠️ Common Mistakes
- Including orders from before the assignment date — always filter `order_date >= assigned_at`
- Not checking for Sample Ratio Mismatch (SRM) — a biased split invalidates the test
- Ending the test too early — random variation can look like a winner with small sample sizes
- Counting the same user in multiple variants — users should only be in one group

---

## 🔗 Related Topics
- [Funnel Analysis](03-funnel-analysis.md)
- [KPI Metrics](05-kpi-metrics.md)
- [CASE Statements](../07-advanced-querying/03-case-statements.md)
- [Aggregate Functions](../09-functions/01-aggregate-functions.md)
