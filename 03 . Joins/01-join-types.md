# JOIN Types

## 📌 What is it?
A JOIN combines rows from two or more tables based on a related column. JOINs are the foundation of relational databases — they let you split data into clean tables and bring it back together when needed.

---

## 🔑 Key Concepts

### All JOIN Types at a Glance
| JOIN Type | Returns |
|---|---|
| `INNER JOIN` | Only rows where the condition matches in **both** tables |
| `LEFT JOIN` | All rows from the left table + matching rows from right (NULLs if no match) |
| `RIGHT JOIN` | All rows from the right table + matching rows from left (NULLs if no match) |
| `FULL JOIN` | All rows from **both** tables (NULLs where no match) |
| `CROSS JOIN` | Every combination of rows from both tables (Cartesian product) |
| `SELF JOIN` | A table joined with itself |

### Visual Reference
```
Table A:  1, 2, 3
Table B:  2, 3, 4

INNER JOIN  → 2, 3           (only matches)
LEFT JOIN   → 1, 2, 3        (all of A)
RIGHT JOIN  → 2, 3, 4        (all of B)
FULL JOIN   → 1, 2, 3, 4     (everything)
```

---

## 💻 Code Examples

### INNER JOIN
```sql
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

### LEFT JOIN
```sql
-- All employees, including those with no department assigned
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
```

### FULL JOIN with COALESCE
```sql
-- All employees and departments, even if unmatched
SELECT COALESCE(e.emp_name, 'No Employee') AS emp,
       COALESCE(d.dept_name, 'No Department') AS dept
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;
```

### CROSS JOIN
```sql
-- All combinations of sizes and colors (use carefully — grows fast!)
SELECT s.size, c.color
FROM sizes s
CROSS JOIN colors c;
```

### SELF JOIN — employee and their manager
```sql
SELECT e.emp_name AS Employee, m.emp_name AS Manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;
```

### Recursive CTE (modern alternative to self joins for hierarchies)
```sql
WITH RECURSIVE OrgChart AS (
    -- Start from top-level (no manager)
    SELECT emp_id, emp_name, manager_id FROM employees WHERE manager_id IS NULL
    UNION ALL
    -- Recursively add direct reports
    SELECT e.emp_id, e.emp_name, e.manager_id
    FROM employees e
    INNER JOIN OrgChart o ON e.manager_id = o.emp_id
)
SELECT * FROM OrgChart;
```

---

## ⚠️ Common Mistakes
- Using `CROSS JOIN` by accident (forgetting an `ON` condition) — can produce millions of rows
- Confusing `LEFT JOIN` and `RIGHT JOIN` — just flip the table order and use LEFT JOIN consistently
- Not indexing foreign key columns — JOINs become slow without indexes

---

## 🔗 Related Topics
- [Primary Keys](../04-database-design/01-primary-keys.md)
- [Foreign Keys](../04-database-design/02-foreign-keys.md)
- [Subqueries](../02-querying/05-subqueries.md)
- [Indexes](../05-performance/01-indexes.md)
