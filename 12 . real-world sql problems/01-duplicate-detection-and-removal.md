# Duplicate Detection & Removal

## 📌 What is it?
Duplicate rows are one of the most common real-world data problems — caused by CSV imports, API re-runs, system bugs, or multiple data sources being merged. Finding and handling them correctly is a core DA skill.

---

## 🔑 Key Concepts

### Types of Duplicates
| Type | Description | Example |
|---|---|---|
| **Exact duplicate** | Every column is identical | Same row inserted twice |
| **Key duplicate** | Same business key, different other columns | Same email, different name casing |
| **Near duplicate** | Slightly different but represents same entity | 'Priya Sharma' vs 'P. Sharma' |

### Approach
1. **Detect** — find duplicates before touching data
2. **Investigate** — understand why they exist
3. **Decide** — which one to keep (latest, most complete, etc.)
4. **Remove** — safely delete or deduplicate

---

## 💻 Code Examples

### Find exact duplicate rows
```sql
SELECT *, COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id, email, first_name, last_name, phone
HAVING COUNT(*) > 1;
```

### Find duplicates by a specific key (e.g., email)
```sql
-- Just find which emails are duplicated
SELECT email, COUNT(*) AS count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY count DESC;

-- See the full rows of duplicates
SELECT *
FROM customers
WHERE email IN (
    SELECT email FROM customers
    GROUP BY email HAVING COUNT(*) > 1
)
ORDER BY email, created_at;
```

### Keep only the most recent row per key
```sql
-- Method 1: Using ROW_NUMBER (most flexible)
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY email          -- group by the key
            ORDER BY created_at DESC    -- keep the latest
        ) AS rn
    FROM customers
)
SELECT * FROM ranked WHERE rn = 1;
```

### Permanently delete duplicates (keep latest)
```sql
-- Step 1: Preview what will be deleted
WITH ranked AS (
    SELECT customer_id,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn
    FROM customers
)
SELECT customer_id FROM ranked WHERE rn > 1;

-- Step 2: Delete after confirming
DELETE FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM (
        SELECT customer_id,
            ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn
        FROM customers
    ) ranked
    WHERE rn > 1
);
```

### Deduplicate during INSERT (prevent future duplicates)
```sql
-- ON CONFLICT: if email already exists, update instead of duplicating
INSERT INTO customers (email, first_name, last_name, created_at)
VALUES ('priya@example.com', 'Priya', 'Sharma', NOW())
ON CONFLICT (email)
DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name  = EXCLUDED.last_name,
    updated_at = NOW();
```

### Add a unique constraint to prevent future duplicates
```sql
-- First verify no existing duplicates
SELECT email, COUNT(*) FROM customers GROUP BY email HAVING COUNT(*) > 1;

-- Then add the constraint
ALTER TABLE customers ADD CONSTRAINT uq_customer_email UNIQUE (email);
```

### Find near-duplicates (fuzzy matching on name)
```sql
-- Find customers with the same name within 1 character difference
-- Using PostgreSQL trigram similarity
CREATE EXTENSION IF NOT EXISTS pg_trgm;

SELECT
    a.customer_id AS id1,
    a.full_name   AS name1,
    b.customer_id AS id2,
    b.full_name   AS name2,
    SIMILARITY(a.full_name, b.full_name) AS similarity_score
FROM customers a
JOIN customers b
    ON a.customer_id < b.customer_id
    AND SIMILARITY(a.full_name, b.full_name) > 0.8
ORDER BY similarity_score DESC;
```

---

## ⚠️ Common Mistakes
- Deleting duplicates without a backup — always check with a `SELECT` first, then `DELETE`
- Assuming the first row is the "real" one — often the latest row has the most complete data
- Using `DISTINCT` as a band-aid — it hides duplicates in results but doesn't fix the underlying data

```sql
-- ❌ This hides the problem, doesn't fix it
SELECT DISTINCT * FROM customers;

-- ✅ Find root cause, then properly deduplicate the source table
```

---

## 🔗 Related Topics
- [Data Cleaning](../11-data-analysis/01-data-cleaning.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [Constraints](../08-data-integrity/02-constraints.md)
- [NULL Handling](../09-functions/04-null-handling.md)
