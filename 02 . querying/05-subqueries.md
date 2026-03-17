# Subqueries

## 📌 What is it?
A subquery is a `SELECT` statement nested inside another query. It can appear in `SELECT`, `FROM`, `WHERE`, or `HAVING` clauses. Modern SQL prefers CTEs and LATERAL joins over deeply nested subqueries.

---

## 🔑 Key Concepts

### Two Types
| Type | Description | Performance |
|---|---|---|
| **Non-correlated** | Independent of outer query, runs once | Faster |
| **Correlated** | References outer query, runs once per row | Slower — O(n × m) |

### Modern Alternatives
| Old Pattern | Modern Replacement | Why |
|---|---|---|
| Nested subquery | CTE (`WITH`) | More readable, reusable |
| Correlated subquery | `LATERAL JOIN` | More efficient |
| Self-join for running totals | Window Function | O(n log n) vs O(n²) |

---

## 💻 Code Examples

### Scalar Subquery — single value comparison
```sql
-- Employees earning above company average
SELECT emp_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

### Same query using CTE (preferred)
```sql
WITH AvgSalary AS (
    SELECT AVG(salary) AS global_avg FROM employees
)
SELECT emp_name, salary
FROM employees, AvgSalary
WHERE salary > AvgSalary.global_avg;
```

### Subquery in FROM clause
```sql
-- Treat a subquery as a temporary table
SELECT dept, avg_sal
FROM (
    SELECT department AS dept, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department
) dept_summary
WHERE avg_sal > 60000;
```

### IN with subquery
```sql
-- Find customers who have placed at least one order
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);
```

### LATERAL JOIN — modern replacement for correlated subqueries
```sql
-- Most recent order for each customer
SELECT c.customer_name, o.order_date
FROM customers c
CROSS JOIN LATERAL (
    SELECT order_date
    FROM orders
    WHERE customer_id = c.id
    ORDER BY order_date DESC
    LIMIT 1
) o;
```

---

## ⚠️ Common Mistakes
- Writing correlated subqueries where a JOIN or window function would be faster
- Nesting more than 2-3 levels deep — use CTEs instead for readability
- Forgetting that a scalar subquery must return exactly one row and one column

```sql
-- ❌ This fails if subquery returns more than one row
SELECT * FROM employees
WHERE salary = (SELECT salary FROM employees WHERE department = 'Sales');

-- ✅ Use MAX/MIN or add LIMIT 1
SELECT * FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees WHERE department = 'Sales');
```

---

## 🔗 Related Topics
- [SELECT Statement](01-select-statement.md)
- [JOIN Types](../03-joins/01-join-types.md)
- [GROUP BY](03-group-by.md)
