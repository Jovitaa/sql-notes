# Table Partitioning

## 📌 What is it?
Partitioning splits a large table into smaller physical pieces (partitions) based on a column value — usually a date or category. Queries that filter on the partition key only scan the relevant partition instead of the entire table, dramatically improving performance on large datasets.

---

## 🔑 Key Concepts

### Types of Partitioning
| Type | Split by | Best for |
|---|---|---|
| **Range** | Ranges of values (date ranges, number ranges) | Time-series data, logs, orders |
| **List** | Discrete values (country, region, status) | Known categories |
| **Hash** | Hash of a column value | Evenly distributing rows when no natural range |

### Why it matters for DA roles
- Tables with millions of rows (logs, events, orders) become slow without partitioning
- A query on `WHERE order_date >= '2026-01-01'` scans only 2026 data — not 10 years of history
- **Partition pruning** = the query planner skips irrelevant partitions automatically
- Older data can be archived or dropped by dropping an entire partition (fast vs row-by-row `DELETE`)

---

## 💻 Code Examples

### Range partitioning by year (PostgreSQL)
```sql
-- Create a partitioned parent table
CREATE TABLE orders (
    order_id    BIGINT,
    order_date  DATE NOT NULL,
    customer_id INT,
    amount      DECIMAL(12,2),
    status      VARCHAR(20)
) PARTITION BY RANGE (order_date);

-- Create individual partitions
CREATE TABLE orders_2024
    PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE orders_2025
    PARTITION OF orders
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE orders_2026
    PARTITION OF orders
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- Index on each partition (automatically inherited)
CREATE INDEX idx_orders_2026_date ON orders_2026(order_date);
```

### Query automatically uses partition pruning
```sql
-- This only scans orders_2026, not the full table
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date >= '2026-01-01' AND order_date < '2026-04-01';

-- Look for "Partitions: orders_2026" in the output
-- NOT "orders_2024, orders_2025, orders_2026"
```

### List partitioning by region
```sql
CREATE TABLE sales (
    sale_id  BIGINT,
    region   VARCHAR(20) NOT NULL,
    amount   DECIMAL(12,2),
    sale_date DATE
) PARTITION BY LIST (region);

CREATE TABLE sales_north PARTITION OF sales FOR VALUES IN ('North', 'Northeast');
CREATE TABLE sales_south PARTITION OF sales FOR VALUES IN ('South', 'Southeast');
CREATE TABLE sales_west  PARTITION OF sales FOR VALUES IN ('West', 'Northwest');
```

### Default partition (catch-all for unexpected values)
```sql
-- Rows that don't match any partition go here
CREATE TABLE orders_default
    PARTITION OF orders
    DEFAULT;
```

### Drop old data by dropping a partition (very fast)
```sql
-- Drop all 2022 data instantly — no slow row-by-row DELETE
DROP TABLE orders_2022;

-- Or detach it (keeps the data as a standalone table)
ALTER TABLE orders DETACH PARTITION orders_2022;
```

### Check which partitions exist
```sql
-- PostgreSQL: list partitions of a table
SELECT
    child.relname   AS partition_name,
    pg_get_expr(child.relpartbound, child.oid) AS partition_range
FROM pg_inherits
JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN pg_class child  ON pg_inherits.inhrelid  = child.oid
WHERE parent.relname = 'orders';
```

---

## ⚠️ Common Mistakes
- Partitioning small tables — adds overhead, only worth it for millions of rows
- Not indexing partition key columns — partitioning alone doesn't speed up unindexed scans within a partition
- Forgetting a default partition — rows that don't match any partition cause an error if no default exists
- Querying without the partition key in `WHERE` — forces a full scan of all partitions, no benefit

```sql
-- ❌ No partition pruning — scans ALL partitions
SELECT * FROM orders WHERE customer_id = 1001;

-- ✅ Partition pruning kicks in
SELECT * FROM orders WHERE order_date >= '2026-01-01' AND customer_id = 1001;
```

---

## 🔗 Related Topics
- [Indexes](01-indexes.md)
- [Query Optimization](03-query-optimization.md)
- [Views & Materialized Views](02-views.md)
- [Denormalization](../04-database-design/04-denormalization.md)
