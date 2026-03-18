# UNION, INTERSECT, EXCEPT

## 📌 What is it?
These are set operators that combine the results of two or more `SELECT` queries into a single result set. Unlike JOINs (which combine columns), set operators combine rows.

---

## 🔑 Key Concepts

### The Three Set Operators
| Operator | Returns |
|---|---|
| `UNION` | All rows from both queries, **duplicates removed** |
| `UNION ALL` | All rows from both queries, **duplicates kept** |
| `INTERSECT` | Only rows that appear in **both** queries |
| `EXCEPT` | Rows in the **first** query but **not** the second |

### Rules for all set operators
1. Both queries must return the **same number of columns**
2. Corresponding columns must have **compatible data types**
3. Column names come from the **first query**
4. `ORDER BY` goes at the **very end**, applies to the combined result

### UNION vs UNION ALL
| | UNION | UNION ALL |
|---|---|---|
| Removes duplicates | ✅ Yes | ❌ No |
| Performance | Slower (has to sort/deduplicate) | ✅ Faster |
| Use when | You need unique rows | You want everything (and it's already unique) |

> 💡 Prefer `UNION ALL` unless you specifically need deduplication — it's significantly faster on large datasets.

---

## 💻 Code Examples

### UNION — combine two lists, remove duplicates
```sql
-- All unique customers who either placed an order OR made an inquiry
SELECT customer_id FROM orders
UNION
SELECT customer_id FROM inquiries;
```

### UNION ALL — combine, keep duplicates
```sql
-- All transactions from two tables (archives + current)
SELECT order_id, amount, order_date FROM orders_2024
UNION ALL
SELECT order_id, amount, order_date FROM orders_2025
ORDER BY order_date DESC;
```

### INTERSECT — rows in both
```sql
-- Customers who have both placed an order AND written a review
SELECT customer_id FROM orders
INTERSECT
SELECT customer_id FROM reviews;
```

### EXCEPT — rows in first but not second
```sql
-- Customers who placed an order but have NOT written a review
SELECT customer_id FROM orders
EXCEPT
SELECT customer_id FROM reviews;
```

### Practical use: full report from multiple sources
```sql
SELECT 'Current Employee' AS type, emp_name, department FROM employees
UNION ALL
SELECT 'Former Employee',          emp_name, department FROM ex_employees
UNION ALL
SELECT 'Contractor',               name,     department FROM contractors
ORDER BY department, emp_name;
```

---

## ⚠️ Common Mistakes
- Column count mismatch — both queries must select the same number of columns
- Using `UNION` when `UNION ALL` is sufficient — unnecessary deduplication adds cost
- Trying to `ORDER BY` in individual parts of a `UNION` — put `ORDER BY` only at the end

```sql
-- ❌ Column count mismatch
SELECT id, name FROM customers
UNION
SELECT id FROM suppliers;  -- only 1 column vs 2

-- ✅ Match the columns
SELECT id, name FROM customers
UNION
SELECT id, company_name FROM suppliers;
```

---

## 🔗 Related Topics
- [SELECT Statement](../02-querying/01-select-statement.md)
- [JOIN Types](../03-joins/01-join-types.md)
- [Subqueries](../02-querying/05-subqueries.md)
