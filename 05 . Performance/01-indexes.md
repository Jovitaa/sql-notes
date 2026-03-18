# Indexes

## 📌 What is it?
An index is a separate data structure that allows the database to find rows quickly without scanning the entire table. Think of it like a book's index — instead of reading every page, you jump straight to what you need.

---

## 🔑 Key Concepts

### Without vs With an Index
| | No Index | With Index |
|---|---|---|
| Search complexity | O(n) — full table scan | O(log n) — tree traversal |
| Analogy | Reading every page of a book | Using the book's index |
| Best for | Tiny tables | Large tables with frequent lookups |

### Index Types
| Type | Best for | Notes |
|---|---|---|
| **B+Tree** | Range queries, equality, sorting | Default in most databases |
| **Hash** | Exact lookups only (=) | O(1) but no range support |
| **GIN** | Full-text search, JSONB, arrays | PostgreSQL |
| **BRIN** | Time-series / sequential data | Very small, but less precise |
| **Partial** | Filtered subsets (e.g., active=true) | Smaller, faster |
| **Composite** | Multi-column queries | Order matters! |
| **Covering** | Include extra columns in index | Avoids table lookup |

### The Trade-off
```
More indexes → Faster reads
More indexes → Slower writes (INSERT/UPDATE/DELETE must update all indexes)
```
> 💡 Only index columns you actually query on. Don't add indexes "just in case."

---

## 💻 Code Examples

### Basic Index
```sql
-- Speed up lookups on last_name
CREATE INDEX idx_employees_last_name ON employees(last_name);
```

### Composite Index
```sql
-- Good for queries filtering on BOTH department AND salary
CREATE INDEX idx_emp_dept_salary ON employees(department_id, salary);

-- ✅ This query uses the index:
SELECT * FROM employees WHERE department_id = 3 AND salary > 60000;

-- ❌ This does NOT use the index (missing the leading column):
SELECT * FROM employees WHERE salary > 60000;
```
> 💡 **Left-prefix rule**: a composite index on `(a, b)` can be used for queries on `a` or `(a, b)`, but NOT `b` alone.

### Partial Index
```sql
-- Only index active employees — much smaller than a full index
CREATE INDEX idx_active_employees ON employees(last_name)
WHERE status = 'active';
```

### Covering Index (INCLUDE)
```sql
-- Stores extra columns in the index so the query never needs to touch the main table
CREATE INDEX idx_emp_covering ON employees(department_id)
INCLUDE (emp_name, salary);
```

### Check How Your Query Uses Indexes
```sql
-- See the execution plan
EXPLAIN ANALYZE
SELECT * FROM employees WHERE department_id = 5;
```
Look for `Index Scan` (good) vs `Seq Scan` (full table scan — may need an index).

---

## ⚠️ Common Mistakes
- Indexing every column — write performance suffers, storage bloats
- Forgetting to index **FK columns** — JOINs become very slow
- Creating indexes on low-cardinality columns (e.g., `gender`, `boolean`) — database often ignores them
- Ignoring index fragmentation — run `REINDEX` or `VACUUM` periodically in PostgreSQL

---

## 🔗 Related Topics
- [Primary Keys](../04-database-design/01-primary-keys.md)
- [Foreign Keys](../04-database-design/02-foreign-keys.md)
- [JOIN Types](../03-joins/01-join-types.md)
- [SELECT Statement](../02-querying/01-select-statement.md)
