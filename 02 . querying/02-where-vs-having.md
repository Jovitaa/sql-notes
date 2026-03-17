# WHERE vs HAVING

## 📌 What is it?
Both `WHERE` and `HAVING` filter data, but at different stages of query execution. `WHERE` filters rows before grouping; `HAVING` filters groups after aggregation.

---

## 🔑 Key Concepts

### The Core Difference
| | WHERE | HAVING |
|---|---|---|
| **Runs at** | Before `GROUP BY` | After `GROUP BY` |
| **Filters** | Individual rows | Aggregated groups |
| **Can use aggregates?** | ❌ No | ✅ Yes |
| **Performance** | Faster (can use indexes) | Slower (scans aggregated results) |
| **Use when** | Filtering raw rows | Filtering summary results |

### Execution Pipeline
```
FROM / JOIN
    ↓
WHERE ← row-level filter happens here
    ↓
GROUP BY
    ↓
HAVING ← group-level filter happens here
    ↓
SELECT
    ↓
ORDER BY
```

---

## 💻 Code Examples

### WHERE — filter before grouping
```sql
-- Only include sales above 100 before counting
SELECT Region, COUNT(*) AS HighValueTransactions
FROM Sales
WHERE Amount > 100
GROUP BY Region;
```

### HAVING — filter after grouping
```sql
-- Only show regions with more than 50 high-value transactions
SELECT Region, COUNT(*) AS HighValueTransactions
FROM Sales
WHERE Amount > 100
GROUP BY Region
HAVING COUNT(*) > 50;
```

### Both together
```sql
SELECT department, AVG(salary) AS avg_salary
FROM employees
WHERE status = 'active'          -- filter rows first
GROUP BY department
HAVING AVG(salary) > 60000;      -- then filter groups
```

---

## ⚠️ Common Mistakes
- Using `HAVING` without `GROUP BY` — technically works in some databases but is confusing
- Trying to use an aggregate like `SUM()` inside a `WHERE` clause — this will throw an error
- Not realizing that `HAVING` without aggregates is wasteful — use `WHERE` instead

```sql
-- ❌ This fails — can't use SUM in WHERE
SELECT department FROM employees
WHERE SUM(salary) > 100000;

-- ✅ Correct — use HAVING for aggregates
SELECT department FROM employees
GROUP BY department
HAVING SUM(salary) > 100000;
```

---

## 🔗 Related Topics
- [SELECT Statement](01-select-statement.md)
- [GROUP BY](03-group-by.md)
- [Indexes](../05-performance/01-indexes.md)
