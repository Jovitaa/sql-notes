# Foreign Keys

## 📌 What is it?
A Foreign Key (FK) is a column in one table that references the Primary Key of another table. It enforces **referential integrity** — ensuring that relationships between tables stay consistent.

---

## 🔑 Key Concepts

### What a FK does
- Ensures every value in the FK column exists in the referenced parent table
- Prevents orphaned records (e.g., an order without a customer)
- Enables efficient JOIN operations between related tables
- Can automate cleanup with `ON DELETE` and `ON UPDATE` actions

### ON DELETE / ON UPDATE Options
| Option | Behavior |
|---|---|
| `RESTRICT` | Block the delete/update if child rows exist |
| `CASCADE` | Automatically delete/update child rows too |
| `SET NULL` | Set FK column to NULL when parent is deleted |
| `NO ACTION` | Same as RESTRICT (default in most databases) |

### Important: FK columns are NOT auto-indexed
In most databases (PostgreSQL, SQL Server), creating a FK does **not** automatically create an index on that column. You must add one manually for good JOIN performance.

---

## 💻 Code Examples

### Basic Foreign Key
```sql
-- Parent table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- Child table with FK
CREATE TABLE employees (
    employee_id   INT PRIMARY KEY,
    emp_name      VARCHAR(100) NOT NULL,
    department_id INT,
    CONSTRAINT fk_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ✅ Always add an index on the FK column for JOIN performance
CREATE INDEX idx_employees_dept ON employees(department_id);
```

### FK with SET NULL
```sql
-- If a department is deleted, set employee's dept to NULL (instead of blocking)
FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
    ON DELETE SET NULL
```

### FK with CASCADE
```sql
-- If a customer is deleted, automatically delete their orders too
FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
```

---

## ⚠️ Common Mistakes
- Forgetting to index the FK column — JOINs become slow without it
- Using `CASCADE` without thinking — can accidentally delete large amounts of data
- Assuming FK values must be unique — they don't have to be (many employees can share a department)
- Not defining `ON DELETE` behavior — can cause confusing errors when trying to delete parent rows

```sql
-- ❌ Common mistake: no index on FK column
CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id)
    -- Missing index! Slow JOINs and FK checks
);

-- ✅ Always add the index
CREATE INDEX idx_orders_customer ON orders(customer_id);
```

---

## 🔗 Related Topics
- [Primary Keys](01-primary-keys.md)
- [Normalization](03-normalization.md)
- [JOIN Types](../03-joins/01-join-types.md)
- [Indexes](../05-performance/01-indexes.md)
