# Aggregate Functions

## 📌 What is it?
Aggregate functions perform a calculation on a set of rows and return a single value. They are almost always used with `GROUP BY` to summarize data by category.

---

## 🔑 Key Concepts

### Core Aggregate Functions
| Function | What it returns | Ignores NULLs? |
|---|---|---|
| `COUNT(*)` | Total number of rows | ❌ Counts NULLs too |
| `COUNT(col)` | Rows where column is not NULL | ✅ Yes |
| `COUNT(DISTINCT col)` | Unique non-NULL values | ✅ Yes |
| `SUM(col)` | Total of all values | ✅ Yes |
| `AVG(col)` | Mean value | ✅ Yes |
| `MIN(col)` | Smallest value | ✅ Yes |
| `MAX(col)` | Largest value | ✅ Yes |
| `STRING_AGG(col, sep)` | Concatenate values into a string | ✅ Yes |
| `ARRAY_AGG(col)` | Collect values into an array | ✅ Yes |

> 💡 `COUNT(*)` and `COUNT(col)` behave differently — `COUNT(*)` counts all rows including NULLs; `COUNT(col)` only counts non-NULL values in that column.

---

## 💻 Code Examples

### Basic aggregates
```sql
SELECT
    COUNT(*)                  AS total_employees,
    COUNT(dept_id)            AS employees_with_dept,
    COUNT(DISTINCT dept_id)   AS unique_departments,
    SUM(salary)               AS total_payroll,
    AVG(salary)               AS avg_salary,
    MIN(salary)               AS lowest_salary,
    MAX(salary)               AS highest_salary
FROM employees;
```

### Aggregates with GROUP BY
```sql
SELECT
    department,
    COUNT(*)        AS headcount,
    AVG(salary)     AS avg_salary,
    MAX(salary)     AS top_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;
```

### Filter before aggregating with WHERE
```sql
-- Only count active employees
SELECT department, COUNT(*) AS active_count
FROM employees
WHERE is_active = TRUE
GROUP BY department;
```

### Filter after aggregating with HAVING
```sql
-- Only show departments with 5+ employees
SELECT department, COUNT(*) AS headcount
FROM employees
GROUP BY department
HAVING COUNT(*) >= 5;
```

### STRING_AGG — concatenate values
```sql
-- List all employees per department as a comma-separated string
SELECT
    department,
    STRING_AGG(emp_name, ', ' ORDER BY emp_name) AS employee_list
FROM employees
GROUP BY department;
```

### Aggregate with CASE — conditional count
```sql
-- Count active vs inactive in one query
SELECT
    department,
    COUNT(CASE WHEN is_active = TRUE  THEN 1 END) AS active,
    COUNT(CASE WHEN is_active = FALSE THEN 1 END) AS inactive
FROM employees
GROUP BY department;
```

---

## ⚠️ Common Mistakes
- Using `COUNT(col)` when you want `COUNT(*)` — if the column has NULLs, the count will be lower than expected
- `AVG` on integer columns returns a rounded integer in some databases — cast to `DECIMAL` for precision
- Forgetting that all non-aggregated columns in `SELECT` must be in `GROUP BY`

```sql
-- ❌ AVG on INT may lose precision
SELECT AVG(salary) FROM employees;  -- might return 55000, not 55432.75

-- ✅ Cast to DECIMAL for accurate average
SELECT AVG(salary::DECIMAL) FROM employees;
```

---

## 🔗 Related Topics
- [GROUP BY](../02-querying/03-group-by.md)
- [WHERE vs HAVING](../02-querying/02-where-vs-having.md)
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [NULL Handling](04-null-handling.md)
