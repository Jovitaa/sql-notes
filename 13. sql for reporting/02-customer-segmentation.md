# Customer Segmentation in SQL

## 📌 What is it?
Customer segmentation divides customers into groups based on behavior, value, or demographics — so marketing, product, and sales teams can treat each group differently. The most important technique for DAs is **RFM Analysis**: Recency, Frequency, Monetary value.

---

## 🔑 Key Concepts

### RFM Model
| Dimension | Question | How to measure |
|---|---|---|
| **Recency (R)** | How recently did they buy? | Days since last order |
| **Frequency (F)** | How often do they buy? | Total number of orders |
| **Monetary (M)** | How much do they spend? | Total spend |

### Common Segments
| Segment | RFM Profile | Action |
|---|---|---|
| **Champions** | Bought recently, often, big spend | Reward, upsell |
| **Loyal Customers** | Buy often, decent spend | Offer loyalty program |
| **At Risk** | Used to buy a lot, but not recently | Win-back campaign |
| **Lost** | Low recency, low frequency | Low-cost re-engagement |
| **New Customers** | Bought once recently | Onboarding, nurture |
| **Big Spenders** | High monetary, low frequency | Convert to loyal |

---

## 💻 Code Examples

### Step 1 — Calculate raw RFM values
```sql
WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(order_date)                             AS last_order_date,
        COUNT(DISTINCT order_id)                    AS order_count,
        SUM(amount)                                 AS total_spend,
        CURRENT_DATE - MAX(order_date)::DATE        AS days_since_last_order
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
```

### Step 2 — Score each dimension 1–5 using NTILE
```sql
rfm_scores AS (
    SELECT
        customer_id,
        days_since_last_order,
        order_count,
        total_spend,
        -- Recency: lower days = better = higher score
        NTILE(5) OVER (ORDER BY days_since_last_order DESC) AS r_score,
        -- Frequency: higher orders = better = higher score
        NTILE(5) OVER (ORDER BY order_count ASC)            AS f_score,
        -- Monetary: higher spend = better = higher score
        NTILE(5) OVER (ORDER BY total_spend ASC)            AS m_score
    FROM rfm_base
),
```

### Step 3 — Assign segment based on scores
```sql
rfm_segments AS (
    SELECT
        customer_id,
        r_score,
        f_score,
        m_score,
        (r_score + f_score + m_score) AS rfm_total,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
            WHEN r_score >= 4 AND f_score >= 3                  THEN 'Loyal'
            WHEN r_score >= 4 AND f_score <= 2                  THEN 'New Customer'
            WHEN r_score <= 2 AND f_score >= 4                  THEN 'At Risk'
            WHEN r_score <= 2 AND f_score <= 2                  THEN 'Lost'
            WHEN m_score = 5  AND f_score <= 2                  THEN 'Big Spender'
            ELSE 'Needs Attention'
        END AS segment
    FROM rfm_scores
)

-- Final output
SELECT
    segment,
    COUNT(*)                        AS customers,
    ROUND(AVG(rfm_total), 1)        AS avg_rfm_score,
    ROUND(AVG(days_since_last_order)) AS avg_days_since_purchase
FROM rfm_segments
GROUP BY segment
ORDER BY avg_rfm_score DESC;
```

### Demographic segmentation — age groups
```sql
SELECT
    CASE
        WHEN age < 25                THEN 'Gen Z (< 25)'
        WHEN age BETWEEN 25 AND 34   THEN 'Millennial (25-34)'
        WHEN age BETWEEN 35 AND 44   THEN 'Millennial (35-44)'
        WHEN age BETWEEN 45 AND 54   THEN 'Gen X (45-54)'
        ELSE 'Boomer (55+)'
    END AS age_group,
    COUNT(*)                         AS customers,
    ROUND(AVG(total_spend), 2)       AS avg_spend,
    ROUND(AVG(order_count), 1)       AS avg_orders
FROM customer_summary
GROUP BY age_group
ORDER BY avg_spend DESC;
```

### Revenue contribution by segment (Pareto / 80-20 check)
```sql
WITH segment_revenue AS (
    SELECT
        s.segment,
        SUM(o.amount) AS segment_revenue
    FROM rfm_segments s
    JOIN orders o ON s.customer_id = o.customer_id
    GROUP BY s.segment
)
SELECT
    segment,
    segment_revenue,
    ROUND(segment_revenue * 100.0 / SUM(segment_revenue) OVER(), 1) AS pct_of_total,
    ROUND(SUM(segment_revenue) OVER (ORDER BY segment_revenue DESC)
          * 100.0 / SUM(segment_revenue) OVER(), 1) AS cumulative_pct
FROM segment_revenue
ORDER BY segment_revenue DESC;
```

---

## ⚠️ Common Mistakes
- Including cancelled or returned orders in spend calculations — always filter to `status = 'completed'`
- Using rigid score thresholds for all businesses — RFM cutoffs depend on your industry and purchase cycle
- Not updating segments regularly — RFM is a snapshot, run it weekly or monthly

---

## 🔗 Related Topics
- [Cohort Analysis](../11-data-analysis/02-cohort-analysis.md)
- [KPI Metrics](../11-data-analysis/05-kpi-metrics.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [CASE Statements](../07-advanced-querying/03-case-statements.md)
