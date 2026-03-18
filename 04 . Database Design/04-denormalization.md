# Denormalization

## 📌 What is it?
Denormalization is the intentional introduction of redundancy into a schema to speed up read queries. It trades write efficiency and storage for faster reads — the opposite of normalization.

---

## 🔑 Key Concepts

### Normalization vs Denormalization
| | Normalization | Denormalization |
|---|---|---|
| **Goal** | Eliminate redundancy | Speed up reads |
| **Best for** | OLTP (transactions) | OLAP (analytics) |
| **Data integrity** | Enforced by DB | Managed by application |
| **Joins** | More joins needed | Fewer joins needed |
| **Storage** | Less | More |
| **Write speed** | Faster | Slower (update multiple places) |

### When to Denormalize
- **OLAP / Analytics** — reports and dashboards that query millions of rows
- **Distributed systems** — avoid cross-node joins that are expensive over a network
- **High-read, low-write data** — product catalogs, read-heavy APIs
- **Pre-computed aggregates** — storing totals so you don't recalculate every time

### Common Techniques
| Technique | What it does |
|---|---|
| **Flattening** | Combine related tables into one to avoid joins |
| **Pre-aggregation** | Store `total_orders`, `total_spend` directly on customer row |
| **Materialized Views** | Cache query results; refresh periodically |
| **Star Schema** | Fact table + dimension tables for analytics (OLAP standard) |
| **Redundant columns** | Copy `customer_region` into orders table to avoid joining customers |

---

## 💻 Code Examples

### Pre-aggregated column
```sql
-- Instead of JOIN + SUM every time, store the total directly
ALTER TABLE customers ADD COLUMN total_orders INT DEFAULT 0;

-- Update it via a trigger or background job when orders change
UPDATE customers
SET total_orders = (
    SELECT COUNT(*) FROM orders WHERE customer_id = customers.customer_id
);
```

### Materialized View (PostgreSQL)
```sql
-- Cache a complex aggregation
CREATE MATERIALIZED VIEW monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS revenue,
    COUNT(*) AS order_count
FROM orders
GROUP BY 1;

-- Refresh it periodically (won't block reads)
REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_sales;
```

### Star Schema (Analytics)
```sql
-- Fact table: one row per event
CREATE TABLE fact_sales (
    sale_id     INT PRIMARY KEY,
    customer_id INT,
    product_id  INT,
    region      VARCHAR(50),   -- denormalized from customers
    amount      DECIMAL(12,2),
    sale_date   DATE
);

-- Dimension table: descriptive data
CREATE TABLE dim_product (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(200),
    category     VARCHAR(100)
);
```

---

## ⚠️ Common Mistakes
- Denormalizing too early — profile first, optimize when you have evidence of a bottleneck
- Forgetting to keep redundant columns in sync — stale data causes bugs
- Using denormalization in OLTP systems where update anomalies can cause data corruption

> 💡 **Rule of thumb:** Keep your OLTP database in 3NF. Use Materialized Views or a separate analytics schema for denormalized reporting data.

---

## 🔗 Related Topics
- [Normalization](03-normalization.md)
- [Indexes](../05-performance/01-indexes.md)
- [SQL vs NoSQL](../01-fundamentals/02-sql-vs-nosql.md)
