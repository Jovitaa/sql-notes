# NULL Handling

## 📌 What is it?
`NULL` in SQL means "unknown" or "no value" — it is not zero, not an empty string, and not `FALSE`. NULL has special behavior that trips up even experienced developers if not handled carefully.

---

## 🔑 Key Concepts

### The Golden Rules of NULL
1. `NULL = NULL` is **not TRUE** — it's `NULL` (unknown)
2. Any arithmetic with NULL returns `NULL` → `5 + NULL = NULL`
3. Any comparison with NULL returns `NULL` → `salary > NULL = NULL`
4. Use `IS NULL` / `IS NOT NULL` to check for NULL — never `= NULL`
5. Most aggregate functions **ignore NULLs** (except `COUNT(*)`)

### NULL-Handling Functions
| Function | What it does | Example |
|---|---|---|
| `COALESCE(a, b, c)` | Return first non-NULL value | `COALESCE(NULL, NULL, 5)` → `5` |
| `NULLIF(a, b)` | Return NULL if a = b, else return a | `NULLIF(0, 0)` → `NULL` |
| `IS NULL` | Check if value is NULL | `WHERE col IS NULL` |
| `IS NOT NULL` | Check if value is not NULL | `WHERE col IS NOT NULL` |
| `IS DISTINCT FROM` | NULL-safe equality check | `a IS DISTINCT FROM b` |

---

## 💻 Code Examples

### IS NULL / IS NOT NULL — the correct way to check
```sql
-- ❌ This never returns rows (NULL = NULL is not TRUE)
SELECT * FROM employees WHERE manager_id = NULL;

-- ✅ Always use IS NULL
SELECT * FROM employees WHERE manager_id IS NULL;
```

### COALESCE — provide a fallback value
```sql
-- Show 'N/A' when department is missing
SELECT
    emp_name,
    COALESCE(department, 'N/A') AS department
FROM employees;

-- Use first available contact method
SELECT
    customer_name,
    COALESCE(mobile, phone, email, 'No contact') AS contact
FROM customers;
```

### COALESCE in calculations — avoid NULL propagation
```sql
-- Without COALESCE: if bonus is NULL, total becomes NULL
SELECT salary + bonus AS total FROM employees;

-- With COALESCE: treat NULL bonus as 0
SELECT salary + COALESCE(bonus, 0) AS total FROM employees;
```

### NULLIF — turn a value into NULL conditionally
```sql
-- Avoid division by zero
SELECT
    total_sales / NULLIF(total_orders, 0) AS avg_order_value
FROM summary;
-- Returns NULL instead of crashing when total_orders = 0
```

### NULL in aggregate functions
```sql
-- COUNT(*) counts all rows; COUNT(col) skips NULLs
SELECT
    COUNT(*)           AS total_rows,
    COUNT(bonus)       AS rows_with_bonus,    -- NULLs not counted
    AVG(bonus)         AS avg_bonus,          -- NULLs excluded from avg
    SUM(COALESCE(bonus, 0)) AS total_bonus    -- treat NULL as 0
FROM employees;
```

### NULL-safe comparison with IS DISTINCT FROM
```sql
-- Regular = returns NULL (not FALSE) when either side is NULL
-- IS DISTINCT FROM treats NULL as a comparable value

SELECT * FROM employees
WHERE manager_id IS DISTINCT FROM 5;
-- Returns rows where manager_id != 5, INCLUDING rows where manager_id IS NULL
```

---

## ⚠️ Common Mistakes
- Comparing with `= NULL` instead of `IS NULL` — always returns no rows
- Forgetting NULL propagation in math — `salary + NULL = NULL`, always use `COALESCE`
- Assuming `NOT IN` with NULLs works as expected — it doesn't
- `ORDER BY col ASC` — NULLs sort differently per database; use `NULLS LAST` / `NULLS FIRST`

```sql
-- ❌ Dangerous: NOT IN with NULLs returns no rows
SELECT * FROM employees
WHERE dept_id NOT IN (1, 2, NULL);   -- Returns nothing! NULL poisons the list

-- ✅ Safe: use NOT EXISTS or exclude NULLs explicitly
SELECT * FROM employees
WHERE dept_id NOT IN (1, 2)
  AND dept_id IS NOT NULL;
```

---

## 🔗 Related Topics
- [Constraints](../08-data-integrity/02-constraints.md)
- [Aggregate Functions](01-aggregate-functions.md)
- [CASE Statements](../07-advanced-querying/03-case-statements.md)
- [Data Types](../01-fundamentals/04-data-types.md)
