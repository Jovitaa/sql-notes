# Self-Referencing Queries

## 📌 What is it?
Self-referencing queries compare rows within the same table to each other — finding records above/below average, ranking within groups, comparing a value to its peers, or identifying outliers relative to their segment. A common and tricky category in DA interviews.

---

## 🔑 Key Concepts

### When you need self-referencing
- "Find employees earning more than the average for their department"
- "Find customers who spent more than average for their region"
- "Find products priced above the median in their category"
- "Show each order alongside the customer's lifetime average"
- "Find the second highest salary in each department"

### Two approaches
| Approach | When to use |
|---|---|
| **Correlated subquery** | Simple, readable for small tables |
| **Window function** | ✅ Better — efficient, one pass over data |

---

## 💻 Code Examples

### Employees earning above their department average
```sql
-- Method 1: Window function (preferred)
SELECT
    emp_name,
    department,
    salary,
    ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS dept_avg,
    salary - ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS above_avg_by
FROM employees
WHERE salary > AVG(salary) OVER (PARTITION BY department);
-- ❌ This actually fails — can't use window function in WHERE directly

-- ✅ Correct: wrap in subquery or CTE
WITH dept_stats AS (
    SELECT
        *,
        AVG(salary) OVER (PARTITION BY department) AS dept_avg
    FROM employees
)
SELECT emp_name, department, salary, ROUND(dept_avg, 2) AS dept_avg
FROM dept_stats
WHERE salary > dept_avg
ORDER BY department, salary DESC;
```

### Method 2: Correlated subquery
```sql
SELECT emp_name, department, salary
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department = e.department   -- references outer query
);
```

### Nth highest salary per department (interview classic)
```sql
-- 2nd highest salary in each department
WITH ranked AS (
    SELECT
        emp_name,
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT emp_name, department, salary
FROM ranked
WHERE rnk = 2;
```

### Customers who spent more than their segment average
```sql
WITH customer_totals AS (
    SELECT
        customer_id,
        SUM(amount) AS total_spend
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
segment_stats AS (
    SELECT
        ct.*,
        c.segment,
        AVG(ct.total_spend) OVER (PARTITION BY c.segment) AS segment_avg
    FROM customer_totals ct
    JOIN customers c ON ct.customer_id = c.customer_id
)
SELECT
    customer_id,
    segment,
    total_spend,
    ROUND(segment_avg, 2) AS segment_avg,
    ROUND((total_spend - segment_avg) * 100.0 / segment_avg, 1) AS pct_above_avg
FROM segment_stats
WHERE total_spend > segment_avg
ORDER BY pct_above_avg DESC;
```

### Each order vs the customer's own average
```sql
SELECT
    o.order_id,
    o.customer_id,
    o.amount,
    ROUND(AVG(o.amount) OVER (PARTITION BY o.customer_id), 2) AS customer_avg_order,
    CASE
        WHEN o.amount > AVG(o.amount) OVER (PARTITION BY o.customer_id)
        THEN 'Above average'
        ELSE 'Below average'
    END AS vs_own_avg
FROM orders o
WHERE o.status = 'completed';
```

### Find products in top 10% of their category
```sql
WITH product_stats AS (
    SELECT
        product_id,
        product_name,
        category,
        price,
        NTILE(10) OVER (PARTITION BY category ORDER BY price DESC) AS price_decile
    FROM products
)
SELECT product_id, product_name, category, price
FROM product_stats
WHERE price_decile = 1   -- top 10%
ORDER BY category, price DESC;
```

---

## ⚠️ Common Mistakes
- Using correlated subqueries for large tables — runs once per row (O(n²)), use window functions instead
- Forgetting `DENSE_RANK` vs `RANK` for nth-highest queries — `RANK` skips numbers on ties, which can cause gaps
- Trying to use a window function directly in `WHERE` — always wrap in a CTE or subquery first

---

## 🔗 Related Topics
- [Window Functions](../07-advanced-querying/01-window-functions.md)
- [CTEs](../07-advanced-querying/02-ctes.md)
- [JOIN Types](../03-joins/01-join-types.md)
- [Subqueries](../02-querying/05-subqueries.md)
