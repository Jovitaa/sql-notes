# Data Cleaning in SQL

## 📌 What is it?
Data cleaning is the process of identifying and fixing problems in raw data before analysis — missing values, duplicates, inconsistent formats, wrong data types, and outliers. In real DA work, this is 50%+ of your actual SQL time.

---

## 🔑 Key Concepts

### The Most Common Data Problems
| Problem | What it looks like | Fix |
|---|---|---|
| Missing values | `NULL`, empty string `''`, `'N/A'` | `COALESCE`, `NULLIF`, filter out |
| Duplicates | Same record appears multiple times | `ROW_NUMBER()`, `DISTINCT` |
| Inconsistent casing | `'mumbai'`, `'Mumbai'`, `'MUMBAI'` | `LOWER()`, `UPPER()`, `INITCAP()` |
| Trailing spaces | `'Priya '` ≠ `'Priya'` | `TRIM()` |
| Wrong data type | Date stored as `'2026-03-18'` string | `CAST()`, `::DATE` |
| Outliers | Salary = 999999999 | `WHERE` + `PERCENTILE_CONT` |
| Inconsistent values | `'M'`, `'Male'`, `'male'`, `1` all mean the same | `CASE WHEN` standardization |

---

## 💻 Code Examples

### Check for NULLs across all key columns
```sql
SELECT
    COUNT(*)                          AS total_rows,
    COUNT(customer_id)                AS has_customer_id,
    COUNT(email)                      AS has_email,
    COUNT(phone)                      AS has_phone,
    total_rows - COUNT(customer_id)   AS missing_customer_id,
    total_rows - COUNT(email)         AS missing_email
FROM customers;
```

### Replace empty strings with NULL (common in CSV imports)
```sql
UPDATE customers
SET email = NULL
WHERE TRIM(email) = '' OR email = 'N/A' OR email = 'n/a';
```

### Standardize inconsistent text values
```sql
-- Fix gender column with inconsistent values
UPDATE customers
SET gender = CASE
    WHEN LOWER(TRIM(gender)) IN ('m', 'male', '1')   THEN 'Male'
    WHEN LOWER(TRIM(gender)) IN ('f', 'female', '2') THEN 'Female'
    ELSE NULL
END;
```

### Trim and fix casing
```sql
-- Clean up a names column
SELECT
    INITCAP(TRIM(LOWER(first_name))) AS clean_first_name,
    INITCAP(TRIM(LOWER(last_name)))  AS clean_last_name
FROM customers;
```

### Fix wrong data types — date stored as string
```sql
-- Check if it parses correctly before converting
SELECT order_date_str
FROM orders
WHERE order_date_str !~ '^\d{4}-\d{2}-\d{2}$';   -- find non-standard formats

-- Cast after cleaning
SELECT
    order_id,
    order_date_str::DATE AS order_date
FROM orders
WHERE order_date_str ~ '^\d{4}-\d{2}-\d{2}$';
```

### Detect and remove duplicates
```sql
-- Find duplicates by email
SELECT email, COUNT(*) AS occurrences
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Keep only the most recent row per email
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn
    FROM customers
)
DELETE FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM ranked WHERE rn > 1
);
```

### Detect outliers using percentiles
```sql
-- Find records outside the expected salary range
SELECT *
FROM employees
WHERE salary > (
    SELECT PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY salary)
    FROM employees
)
OR salary < 0;
```

### Validate phone number format
```sql
-- Flag phone numbers that don't match expected format
SELECT customer_id, phone
FROM customers
WHERE phone !~ '^\+?[0-9]{10,13}$';
```

---

## ⚠️ Common Mistakes
- Assuming `COUNT(*)` and `COUNT(col)` are the same — `COUNT(col)` skips NULLs
- Deleting outliers without investigating — they might be real data or data entry errors
- Cleaning in the wrong order — standardize casing before deduplicating
- Modifying production data directly — always clean into a staging table first

```sql
-- ✅ Best practice: clean into a new table, don't modify raw data
CREATE TABLE customers_clean AS
SELECT
    customer_id,
    INITCAP(TRIM(first_name)) AS first_name,
    LOWER(TRIM(email)) AS email,
    NULLIF(TRIM(phone), '') AS phone
FROM customers_raw;
```

---

## 🔗 Related Topics
- [NULL Handling](../09-functions/04-null-handling.md)
- [String Functions](../09-functions/02-string-functions.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [Duplicate Detection](../12-real-world-sql/01-duplicate-detection.md)
