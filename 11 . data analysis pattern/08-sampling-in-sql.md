# Sampling in SQL

## 📌 What is it?
Sampling is pulling a representative subset of data from a large table — for exploratory analysis, building ML training datasets, running quick checks, or testing queries before running on the full dataset. SQL has several ways to do this, each with different trade-offs.

---

## 🔑 Key Concepts

### Sampling Methods
| Method | How it works | Speed | Truly random? |
|---|---|---|---|
| `LIMIT N` | Takes the first N rows | ✅ Fast | ❌ Not random (biased to insert order) |
| `ORDER BY RANDOM() LIMIT N` | Shuffles all rows then takes N | ❌ Slow (full scan) | ✅ Yes |
| `WHERE random() < 0.1` | Keeps each row with 10% probability | ✅ Fast | ✅ Approximately |
| `TABLESAMPLE BERNOULLI(%)` | Samples each row independently | ✅ Fast | ✅ Yes |
| `TABLESAMPLE SYSTEM(%)` | Samples whole data pages | ✅✅ Fastest | ⚠️ Less random (page-level) |
| `MOD(id, N) = 0` | Takes every Nth row by ID | ✅ Fast | ⚠️ Systematic, not random |

---

## 💻 Code Examples

### Quick look — NOT truly random (biased)
```sql
-- Fast but returns earliest rows, not a representative sample
SELECT * FROM orders LIMIT 1000;
```

### True random sample — small tables only
```sql
-- Shuffles entire table, then takes 1000 rows — slow on large tables
SELECT * FROM orders
ORDER BY RANDOM()
LIMIT 1000;
```

### Fast approximate sample using random()
```sql
-- Each row has a 10% chance of being included — fast, close to random
SELECT * FROM orders
WHERE random() < 0.10;   -- ~10% of rows

-- 1% sample of a very large table
SELECT * FROM events
WHERE random() < 0.01;
```

### TABLESAMPLE — PostgreSQL built-in
```sql
-- BERNOULLI: each row independently has a 5% chance (slower but more accurate)
SELECT * FROM orders TABLESAMPLE BERNOULLI(5);

-- SYSTEM: samples entire data pages at 5% (faster, less accurate)
SELECT * FROM orders TABLESAMPLE SYSTEM(5);

-- With a fixed seed for reproducibility
SELECT * FROM orders TABLESAMPLE BERNOULLI(10) REPEATABLE(42);
```

### Systematic sampling — every Nth row
```sql
-- Take every 10th order (good for evenly-spaced samples)
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY order_id) AS rn
    FROM orders
) numbered
WHERE MOD(rn, 10) = 0;
```

### Stratified sampling — proportional by category
```sql
-- Take 100 samples per region, maintaining proportions
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY RANDOM()
        ) AS rn
    FROM customers
)
SELECT * FROM ranked WHERE rn <= 100;
```

### Reproducible sample — same result every time
```sql
-- Using a hash for deterministic sampling (useful for ML train/test splits)
-- Always includes the same rows for a given seed
SELECT *
FROM orders
WHERE MOD(ABS(HASHTEXT(order_id::TEXT)), 10) < 8;   -- ~80% train

-- The remaining 20% for test
SELECT *
FROM orders
WHERE MOD(ABS(HASHTEXT(order_id::TEXT)), 10) >= 8;  -- ~20% test
```

---

## ⚠️ Common Mistakes
- Using `LIMIT` without `ORDER BY RANDOM()` and calling it a sample — you're getting the first inserted rows, not a representative sample
- Using `ORDER BY RANDOM()` on millions of rows — full table sort, very slow
- Not setting a seed for ML workflows — your train/test split changes every run, making experiments non-reproducible
- Using `TABLESAMPLE SYSTEM` for precise statistics — page-level sampling can miss whole segments of data

```sql
-- ❌ This is NOT a random sample — just the first 500 rows inserted
SELECT * FROM orders LIMIT 500;

-- ✅ Proper random sample for small/medium tables
SELECT * FROM orders ORDER BY RANDOM() LIMIT 500;

-- ✅ Fast approximate sample for large tables
SELECT * FROM orders WHERE random() < 0.05;
```

---

## 🔗 Related Topics
- [Data Cleaning](../11-data-analysis/01-data-cleaning.md)
- [Query Optimization](../05-performance/03-query-optimization.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [Date Range Problems](../12-real-world-sql/03-date-range-problems.md)
