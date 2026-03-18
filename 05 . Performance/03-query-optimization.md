# Query Optimization

## 📌 What is it?
Query optimization is the process of making SQL queries run faster by understanding how the database executes them, using indexes effectively, and rewriting queries to reduce unnecessary work.

---

## 🔑 Key Concepts

### How to Read an Execution Plan
`EXPLAIN ANALYZE` shows you exactly how the database runs your query — which indexes it uses, how many rows it processes, and where time is spent.

```sql
EXPLAIN ANALYZE
SELECT * FROM employees WHERE department = 'Engineering';
```

### Key terms in execution plans
| Term | What it means |
|---|---|
| `Seq Scan` | Full table scan — reads every row. Slow on large tables |
| `Index Scan` | Uses an index to find rows. Fast |
| `Index Only Scan` | Reads directly from index, never touches the table. Fastest |
| `Hash Join` | Efficient join for large tables — builds a hash table |
| `Nested Loop` | Good for small tables, slow for large ones |
| `rows=` | Estimated number of rows processed |
| `actual time=` | Real execution time in milliseconds |
| `cost=` | Planner's estimated cost (relative, not milliseconds) |

### Golden Rules for Fast Queries
1. **Index columns used in WHERE, JOIN, and ORDER BY**
2. **Avoid functions on indexed columns in WHERE** — they disable the index
3. **Use LIMIT** — don't fetch more rows than you need
4. **Avoid SELECT \*** — fetch only the columns you need
5. **Use EXISTS instead of COUNT** when checking for row existence
6. **Prefer JOINs over subqueries** for large datasets
7. **Keep transactions short** — long transactions hold locks

---

## 💻 Code Examples

### EXPLAIN ANALYZE — read the plan
```sql
EXPLAIN ANALYZE
SELECT e.emp_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 60000;
```
Look for: `Seq Scan` on large tables (may need an index), high `actual time`, large `rows=` estimates.

### Avoid functions on indexed columns
```sql
-- ❌ Disables index on created_at — forces full table scan
SELECT * FROM orders WHERE YEAR(created_at) = 2026;

-- ✅ Range query uses the index
SELECT * FROM orders
WHERE created_at >= '2026-01-01' AND created_at < '2027-01-01';
```

### Use EXISTS instead of COUNT for existence checks
```sql
-- ❌ Slow — counts all matching rows before returning
SELECT * FROM customers
WHERE (SELECT COUNT(*) FROM orders WHERE customer_id = customers.id) > 0;

-- ✅ Fast — stops as soon as one row is found
SELECT * FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
);
```

### Avoid SELECT * in production
```sql
-- ❌ Fetches all columns — more data over the wire, harder to maintain
SELECT * FROM employees;

-- ✅ Fetch only what you need
SELECT emp_id, emp_name, salary FROM employees;
```

### Use LIMIT for large tables
```sql
-- ❌ Returns 10 million rows to the application
SELECT * FROM logs WHERE level = 'ERROR';

-- ✅ Limit the result set
SELECT * FROM logs WHERE level = 'ERROR'
ORDER BY created_at DESC
LIMIT 100;
```

### Check table statistics are fresh
```sql
-- PostgreSQL: update statistics so the planner makes good decisions
ANALYZE employees;

-- See when statistics were last updated
SELECT relname, last_analyze, last_autoanalyze
FROM pg_stat_user_tables
WHERE relname = 'employees';
```

### Find slow queries (PostgreSQL)
```sql
-- Enable pg_stat_statements extension first
SELECT
    query,
    calls,
    total_exec_time / calls AS avg_ms,
    rows / calls AS avg_rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
```

---

## ⚠️ Common Mistakes
- Ignoring execution plans — always `EXPLAIN ANALYZE` slow queries before optimizing
- Adding indexes to every column — too many indexes slow down writes
- Using `LIKE '%value%'` with a leading wildcard — can't use a B-Tree index
- Not updating statistics — the planner makes bad decisions with stale stats

```sql
-- ❌ Leading wildcard = no index possible
WHERE name LIKE '%kumar%'

-- ✅ Trailing wildcard only = index works
WHERE name LIKE 'kumar%'

-- For contains search on large tables, use full-text search instead
WHERE to_tsvector(name) @@ to_tsquery('kumar')
```

---

## 🔗 Related Topics
- [Indexes](01-indexes.md)
- [Views & Materialized Views](02-views.md)
- [JOIN Types](../03-joins/01-join-types.md)
- [Subqueries](../02-querying/05-subqueries.md)
