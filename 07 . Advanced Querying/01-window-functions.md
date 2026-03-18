# Window Functions

## 📌 What is it?
Window functions perform calculations across a set of rows related to the current row — without collapsing them into a single output row like `GROUP BY` does. They are one of the most powerful features in modern SQL.

---

## 🔑 Key Concepts

### Window Function vs GROUP BY
| | GROUP BY | Window Function |
|---|---|---|
| Output rows | One per group | Same number as input |
| Collapses rows? | ✅ Yes | ❌ No |
| Can see individual rows? | ❌ No | ✅ Yes |
| Use for | Totals, counts | Rankings, running totals, comparisons |

### Syntax
```sql
function_name() OVER (
    PARTITION BY column   -- divide into groups (optional)
    ORDER BY column       -- order within each group
    ROWS/RANGE BETWEEN ... -- define the window frame (optional)
)
```

### Common Window Functions
| Function | What it does |
|---|---|
| `ROW_NUMBER()` | Unique row number per partition (no ties) |
| `RANK()` | Rank with gaps for ties (1, 2, 2, 4) |
| `DENSE_RANK()` | Rank without gaps for ties (1, 2, 2, 3) |
| `NTILE(n)` | Divide rows into n equal buckets |
| `LAG(col, n)` | Value from n rows before current row |
| `LEAD(col, n)` | Value from n rows after current row |
| `SUM() OVER` | Running total |
| `AVG() OVER` | Moving average |
| `FIRST_VALUE()` | First value in the window |
| `LAST_VALUE()` | Last value in the window |

---

## 💻 Code Examples

### ROW_NUMBER — unique rank per partition
```sql
-- Rank employees by salary within each department
SELECT
    emp_name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;
```

### RANK vs DENSE_RANK — handling ties
```sql
SELECT
    emp_name,
    salary,
    RANK()       OVER (ORDER BY salary DESC) AS rank,        -- 1,2,2,4
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank   -- 1,2,2,3
FROM employees;
```

### LAG and LEAD — compare with previous/next row
```sql
-- Month-over-month revenue change
SELECT
    month,
    revenue,
    LAG(revenue, 1) OVER (ORDER BY month) AS prev_month_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY month) AS change
FROM monthly_sales;
```

### Running Total with SUM OVER
```sql
SELECT
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date) AS running_total
FROM orders;
```

### Moving Average
```sql
-- 3-day moving average
SELECT
    sale_date,
    daily_sales,
    AVG(daily_sales) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3day
FROM daily_sales;
```

### Top-N per group (common interview question)
```sql
-- Top 2 earners per department
SELECT * FROM (
    SELECT
        emp_name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn <= 2;
```

---

## ⚠️ Common Mistakes
- Confusing `RANK()` and `DENSE_RANK()` — `RANK()` skips numbers after ties, `DENSE_RANK()` doesn't
- Forgetting that window functions run after `WHERE` and `GROUP BY` — you can't filter on them directly, wrap in a subquery
- Using `LAST_VALUE()` without a proper frame — by default it only looks at current row, add `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`

```sql
-- ❌ This won't work — can't use window function in WHERE
SELECT emp_name FROM employees
WHERE ROW_NUMBER() OVER (ORDER BY salary) = 1;

-- ✅ Wrap in a subquery or CTE
SELECT emp_name FROM (
    SELECT emp_name, ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
    FROM employees
) t WHERE rn = 1;
```

---

## 🔗 Related Topics
- [GROUP BY](../02-querying/03-group-by.md)
- [CTEs](02-ctes.md)
- [ORDER BY](../02-querying/04-order-by.md)
- [Subqueries](../02-querying/05-subqueries.md)
