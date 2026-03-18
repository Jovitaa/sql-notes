# Funnel Analysis

## 📌 What is it?
Funnel analysis tracks how many users complete each step of a multi-step process — like a signup flow, checkout, or onboarding sequence. It identifies where users drop off so product and marketing teams can fix it.

---

## 🔑 Key Concepts

### Typical funnels in DA work
- **E-commerce**: Visit → Product View → Add to Cart → Checkout → Purchase
- **SaaS onboarding**: Signup → Email Verified → Profile Complete → First Feature Used
- **Marketing**: Ad Click → Landing Page → Form Submit → Converted

### What you calculate
| Metric | Formula |
|---|---|
| **Step count** | Users who reached this step |
| **Step conversion rate** | Users at step N / Users at step N-1 |
| **Overall conversion rate** | Users at final step / Users at first step |
| **Drop-off rate** | 1 - conversion rate |

---

## 💻 Code Examples

### Method 1 — CASE + SUM (most common, easiest to read)
```sql
-- Each row in events table has: user_id, event_name, event_time
SELECT
    COUNT(DISTINCT user_id)                                              AS visited,
    COUNT(DISTINCT CASE WHEN event_name = 'product_viewed'  THEN user_id END) AS viewed_product,
    COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart'     THEN user_id END) AS added_to_cart,
    COUNT(DISTINCT CASE WHEN event_name = 'checkout_started' THEN user_id END) AS started_checkout,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase'        THEN user_id END) AS purchased
FROM events
WHERE event_date >= '2026-01-01';
```

### Method 2 — With conversion rates
```sql
WITH funnel AS (
    SELECT
        COUNT(DISTINCT user_id)                                                   AS step1_visit,
        COUNT(DISTINCT CASE WHEN event_name = 'product_viewed'   THEN user_id END) AS step2_view,
        COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart'      THEN user_id END) AS step3_cart,
        COUNT(DISTINCT CASE WHEN event_name = 'purchase'         THEN user_id END) AS step4_purchase
    FROM events
    WHERE event_date BETWEEN '2026-01-01' AND '2026-01-31'
)
SELECT
    step1_visit,
    step2_view,
    step3_cart,
    step4_purchase,
    ROUND(step2_view   * 100.0 / step1_visit,   1) AS visit_to_view_pct,
    ROUND(step3_cart   * 100.0 / step2_view,    1) AS view_to_cart_pct,
    ROUND(step4_purchase * 100.0 / step3_cart,  1) AS cart_to_purchase_pct,
    ROUND(step4_purchase * 100.0 / step1_visit, 1) AS overall_conversion_pct
FROM funnel;
```

### Method 3 — Strict ordered funnel (user must complete steps in order)
```sql
-- Users who reached each step only if they completed all previous steps
WITH user_steps AS (
    SELECT
        user_id,
        MAX(CASE WHEN event_name = 'visit'          THEN 1 ELSE 0 END) AS did_visit,
        MAX(CASE WHEN event_name = 'product_viewed' THEN 1 ELSE 0 END) AS did_view,
        MAX(CASE WHEN event_name = 'add_to_cart'    THEN 1 ELSE 0 END) AS did_cart,
        MAX(CASE WHEN event_name = 'purchase'       THEN 1 ELSE 0 END) AS did_purchase
    FROM events
    GROUP BY user_id
)
SELECT
    SUM(did_visit)                                         AS step1,
    SUM(CASE WHEN did_visit = 1   THEN did_view    END)   AS step2,
    SUM(CASE WHEN did_view = 1    THEN did_cart    END)   AS step3,
    SUM(CASE WHEN did_cart = 1    THEN did_purchase END)  AS step4
FROM user_steps;
```

### Funnel broken down by segment (e.g., device type)
```sql
SELECT
    device_type,
    COUNT(DISTINCT user_id)                                                    AS visitors,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_id END)        AS purchasers,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_id END)
        * 100.0 / COUNT(DISTINCT user_id), 1
    ) AS conversion_pct
FROM events
WHERE event_date >= '2026-01-01'
GROUP BY device_type
ORDER BY conversion_pct DESC;
```

---

## ⚠️ Common Mistakes
- Counting events instead of distinct users — one user can trigger the same event multiple times
- Not setting a time window — funnels should be measured over a consistent period
- Ignoring order of steps — a user who purchased before viewing isn't a valid funnel completion

---

## 🔗 Related Topics
- [Cohort Analysis](02-cohort-analysis.md)
- [KPI Metrics](05-kpi-metrics.md)
- [CASE Statements](../07-advanced-querying/03-case-statements.md)
- [Aggregate Functions](../09-functions/01-aggregate-functions.md)
