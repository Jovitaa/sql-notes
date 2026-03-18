# CTEs (Common Table Expressions)

## 📌 What is it?
A CTE is a temporary named result set defined with the `WITH` keyword at the start of a query. It makes complex queries easier to read, reuse, and debug — and is the modern replacement for deeply nested subqueries.

---

## 🔑 Key Concepts

### CTE vs Subquery vs Temp Table
| | Subquery | CTE | Temp Table |
|---|---|---|---|
| Readability | Low (nested) | ✅ High (named) | Medium |
| Reusable in same query | ❌ No | ✅ Yes | ✅ Yes |
| Supports recursion | ❌ No | ✅ Yes | ❌ No |
| Persists after query | ❌ No | ❌ No | ✅ Yes |
| Best for | Simple inline logic | Complex multi-step logic | Large intermediate datasets |

### Two Types of CTEs
| Type | Use for |
|---|---|
| **Non-recursive** | Breaking a query into readable named steps |
| **Recursive** | Traversing hierarchical/tree data (org charts, categories) |

---

## 💻 Code Examples

### Basic CTE — readable step-by-step logic
```sql
WITH HighEarners AS (
    SELECT emp_name, department, salary
    FROM employees
    WHERE salary > 70000
),
DeptSummary AS (
    SELECT department, COUNT(*) AS high_earner_count
    FROM HighEarners
    GROUP BY department
)
SELECT * FROM DeptSummary
ORDER BY high_earner_count DESC;
```

### Multiple CTEs chained together
```sql
WITH
OrderTotals AS (
    SELECT order_id, SUM(quantity * unit_price) AS total
    FROM order_items
    GROUP BY order_id
),
LargeOrders AS (
    SELECT order_id, total
    FROM OrderTotals
    WHERE total > 10000
)
SELECT o.customer_id, l.total
FROM orders o
JOIN LargeOrders l ON o.order_id = l.order_id;
```

### Recursive CTE — org chart traversal
```sql
-- Start from the CEO, walk down through all reports
WITH RECURSIVE OrgChart AS (
    -- Base case: top-level (no manager)
    SELECT emp_id, emp_name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: join each employee to their manager
    SELECT e.emp_id, e.emp_name, e.manager_id, o.level + 1
    FROM employees e
    INNER JOIN OrgChart o ON e.manager_id = o.emp_id
)
SELECT emp_id, emp_name, level
FROM OrgChart
ORDER BY level, emp_name;
```

### Recursive CTE — cumulative number series
```sql
-- Generate numbers 1 to 10
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 10
)
SELECT n FROM Numbers;
```

---

## ⚠️ Common Mistakes
- Treating CTEs as a performance optimization — in PostgreSQL, CTEs are not always materialized; the optimizer may inline them. Use `MATERIALIZED` keyword explicitly if you need caching
- Forgetting `UNION ALL` in recursive CTEs — `UNION` removes duplicates (slower); `UNION ALL` is almost always what you want
- Infinite recursion — always include a termination condition (`WHERE n < 10`, `WHERE manager_id IS NULL`, etc.)

```sql
-- ❌ Infinite recursion — no stop condition
WITH RECURSIVE Bad AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Bad   -- runs forever!
)

-- ✅ Always add a stop condition
WITH RECURSIVE Good AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Good WHERE n < 100
)
```

---

## 🔗 Related Topics
- [Subqueries](../02-querying/05-subqueries.md)
- [Window Functions](01-window-functions.md)
- [JOIN Types](../03-joins/01-join-types.md)
