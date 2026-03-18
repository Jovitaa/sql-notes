# Reading ERDs & Translating to SQL

## 📌 What is it?
An ERD (Entity Relationship Diagram) is a visual map of database tables and how they relate. In a real job, you'll rarely be given clean queries — you'll be handed an ERD and asked to figure out the joins yourself. This is the first skill you use every single day.

---

## 🔑 Key Concepts

### ERD Notation
```
[Customers] 1 ──────< [Orders] >────── 1 [Products]
               one        many    many        one
```

| Symbol | Meaning |
|---|---|
| `1` | One (exactly one) |
| `0..1` | Zero or one (optional) |
| `*` or `<` | Many |
| `PK` | Primary Key |
| `FK` | Foreign Key |

### Relationship Types
| Type | Example | Join type to use |
|---|---|---|
| **One-to-One** | Person ↔ Passport | `INNER JOIN` or `LEFT JOIN` |
| **One-to-Many** | Customer → Orders | `LEFT JOIN` (customer side), `INNER JOIN` |
| **Many-to-Many** | Students ↔ Courses (via Enrollments) | Two `JOIN`s through junction table |
| **Self-referencing** | Employee → Manager (same table) | `SELF JOIN` |

---

## 💻 Code Examples

### Reading a simple ERD → Writing the JOIN
```
ERD:
[Customers]        [Orders]           [Order_Items]      [Products]
 customer_id PK     order_id PK        order_item_id PK   product_id PK
 name               customer_id FK     order_id FK        name
 email              order_date         product_id FK      price
                    status             quantity
```

```sql
-- Translate ERD to SQL: full order report
SELECT
    c.customer_id,
    c.name          AS customer_name,
    o.order_id,
    o.order_date,
    p.name          AS product_name,
    oi.quantity,
    p.price,
    oi.quantity * p.price AS line_total
FROM customers c
JOIN orders o       ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.status = 'completed'
ORDER BY o.order_date DESC;
```

### Many-to-Many relationship → Two JOINs
```
ERD:
[Students]      [Enrollments]     [Courses]
 student_id PK   student_id FK     course_id PK
 name            course_id FK      course_name
 email           enrolled_at       instructor
```

```sql
-- Which students are enrolled in which courses?
SELECT
    s.name         AS student_name,
    c.course_name,
    c.instructor,
    e.enrolled_at
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c     ON e.course_id  = c.course_id
ORDER BY s.name, c.course_name;
```

### Self-referencing → Employee hierarchy
```
ERD:
[Employees]
 emp_id PK
 name
 manager_id FK → emp_id (same table)
```

```sql
-- Employee with their manager's name
SELECT
    e.emp_id,
    e.name          AS employee,
    m.name          AS manager,
    m.emp_id        AS manager_id
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;
```

### How to approach an unfamiliar database
```sql
-- Step 1: See all tables
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';

-- Step 2: See columns in a table
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'orders'
ORDER BY ordinal_position;

-- Step 3: See all foreign key relationships
SELECT
    tc.table_name       AS child_table,
    kcu.column_name     AS fk_column,
    ccu.table_name      AS parent_table,
    ccu.column_name     AS referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY';

-- Step 4: Quickly preview data
SELECT * FROM orders LIMIT 5;
```

### Checking JOIN logic — quick sanity checks
```sql
-- Check if a LEFT JOIN is filtering rows (shouldn't be)
SELECT COUNT(*) FROM customers;                           -- baseline
SELECT COUNT(*) FROM customers LEFT JOIN orders ON ...;   -- should be >= baseline

-- Check for unexpected NULLs after JOIN
SELECT COUNT(*) FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;   -- orphaned orders with no customer
```

---

## ⚠️ Common Mistakes
- Joining on the wrong column — always check which column is PK and which is FK
- Using `INNER JOIN` when you should use `LEFT JOIN` — silently loses rows where the child has no parent
- Not understanding the cardinality — joining Orders to Order_Items multiplies rows; always check row counts

---

## 🔗 Related Topics
- [JOIN Types](../03-joins/01-join-types.md)
- [Primary Keys](../04-database-design/01-primary-keys.md)
- [Foreign Keys](../04-database-design/02-foreign-keys.md)
- [Normalization](../04-database-design/03-normalization.md)
