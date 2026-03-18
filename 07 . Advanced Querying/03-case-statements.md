# CASE Statements

## 📌 What is it?
`CASE` is SQL's way of writing conditional logic (like `if/else`) inside a query. It can be used in `SELECT`, `WHERE`, `ORDER BY`, and `GROUP BY` clauses to transform or categorize data on the fly.

---

## 🔑 Key Concepts

### Two Forms of CASE

**Searched CASE** — evaluates conditions (most flexible):
```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

**Simple CASE** — compares one value to many options:
```sql
CASE column
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END
```

### Rules
- Evaluated top to bottom — first matching `WHEN` wins
- `ELSE` is optional — returns `NULL` if no condition matches and `ELSE` is missing
- Can be nested (but keep it readable)
- Must `END` every `CASE`

---

## 💻 Code Examples

### Basic CASE — label salary ranges
```sql
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'Senior'
        WHEN salary >= 60000  THEN 'Mid-level'
        WHEN salary >= 30000  THEN 'Junior'
        ELSE 'Entry'
    END AS salary_band
FROM employees;
```

### Simple CASE — map status codes
```sql
SELECT
    order_id,
    CASE status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Shipped'
        WHEN 4 THEN 'Delivered'
        ELSE 'Unknown'
    END AS status_label
FROM orders;
```

### CASE in aggregate — pivot / conditional count
```sql
-- Count orders by status in a single row
SELECT
    COUNT(CASE WHEN status = 'Pending'   THEN 1 END) AS pending_count,
    COUNT(CASE WHEN status = 'Shipped'   THEN 1 END) AS shipped_count,
    COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered_count
FROM orders;
```

### CASE in ORDER BY — custom sort order
```sql
-- Sort by priority: High → Medium → Low
SELECT task_name, priority
FROM tasks
ORDER BY
    CASE priority
        WHEN 'High'   THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Low'    THEN 3
        ELSE 4
    END;
```

### CASE in WHERE — conditional filtering
```sql
-- If role is 'admin', show all; otherwise show only active users
SELECT * FROM users
WHERE
    CASE
        WHEN :role = 'admin' THEN TRUE
        ELSE is_active = TRUE
    END;
```

---

## ⚠️ Common Mistakes
- Forgetting `END` — every `CASE` must close with `END`
- Not handling `NULL` — `WHEN column = NULL` never matches; use `WHEN column IS NULL`
- Writing overlapping conditions — only the first match fires, so order matters

```sql
-- ❌ NULL check with = never works
CASE WHEN score = NULL THEN 'No Score' END

-- ✅ Use IS NULL
CASE WHEN score IS NULL THEN 'No Score' END
```

---

## 🔗 Related Topics
- [SELECT Statement](../02-querying/01-select-statement.md)
- [NULL Handling](../09-functions/04-null-handling.md)
- [GROUP BY](../02-querying/03-group-by.md)
