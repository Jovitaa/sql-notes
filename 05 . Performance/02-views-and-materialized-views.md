# Views & Materialized Views

## 📌 What is it?
A **view** is a saved SQL query that you can treat like a table. A **materialized view** is a view whose results are physically stored on disk and periodically refreshed — trading freshness for speed.

---

## 🔑 Key Concepts

### Regular View vs Materialized View
| | View | Materialized View |
|---|---|---|
| Data stored? | ❌ No — runs query each time | ✅ Yes — cached on disk |
| Always up to date? | ✅ Yes | ❌ No — needs manual/scheduled refresh |
| Query speed | Depends on underlying query | ✅ Fast — reads from cache |
| Can be indexed? | ❌ No | ✅ Yes |
| Best for | Simplifying complex queries | Heavy analytical queries |

### Why use a View?
- **Simplicity** — hide complex joins behind a clean name
- **Security** — expose only certain columns to certain users
- **Reusability** — write a query once, use it everywhere
- **Abstraction** — change underlying tables without breaking dependent queries

---

## 💻 Code Examples

### Creating a View
```sql
-- Hide the complexity of a multi-table join
CREATE VIEW employee_details AS
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary,
    m.emp_name AS manager_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN employees m  ON e.manager_id = m.emp_id;

-- Now query it like a table
SELECT * FROM employee_details WHERE dept_name = 'Engineering';
```

### Updating a View
```sql
CREATE OR REPLACE VIEW employee_details AS
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary,
    e.email,          -- added new column
    m.emp_name AS manager_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN employees m  ON e.manager_id = m.emp_id;
```

### Dropping a View
```sql
DROP VIEW IF EXISTS employee_details;
```

### Materialized View — cache for performance
```sql
-- Create a materialized view for a heavy aggregation
CREATE MATERIALIZED VIEW monthly_revenue AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount)                     AS revenue,
    COUNT(*)                        AS order_count
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

-- Add an index to make queries even faster
CREATE INDEX idx_monthly_revenue_month ON monthly_revenue(month);

-- Refresh the cache (run this on a schedule)
REFRESH MATERIALIZED VIEW monthly_revenue;

-- Refresh without blocking reads (PostgreSQL)
REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_revenue;
```

### Security use case — restrict column access
```sql
-- Create a view that hides salary from regular users
CREATE VIEW public_employee_info AS
SELECT emp_id, emp_name, department, email
FROM employees;   -- salary column intentionally excluded

-- Grant access to the view, not the base table
GRANT SELECT ON public_employee_info TO hr_readonly_role;
```

---

## ⚠️ Common Mistakes
- Treating views as a performance optimization — a regular view reruns the query every time
- Forgetting to `REFRESH` materialized views — stale data causes reporting errors
- Making views too complex — views on top of views become hard to debug and maintain
- Expecting to always UPDATE through a view — views with JOINs or aggregates are usually not updatable

---

## 🔗 Related Topics
- [Indexes](01-indexes.md)
- [Normalization](../04-database-design/03-normalization.md)
- [Denormalization](../04-database-design/04-denormalization.md)
- [Query Optimization](03-query-optimization.md)
