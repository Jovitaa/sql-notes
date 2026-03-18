# Constraints

## 📌 What is it?
Constraints are rules enforced at the database level to ensure data quality and integrity. They prevent invalid data from being inserted or updated — catching errors at the source rather than in application code.

---

## 🔑 Key Concepts

### Types of Constraints
| Constraint | What it enforces |
|---|---|
| `NOT NULL` | Column must always have a value |
| `UNIQUE` | No two rows can have the same value in this column |
| `PRIMARY KEY` | Unique + Not Null — identifies each row |
| `FOREIGN KEY` | Value must exist in another table's column |
| `CHECK` | Value must satisfy a custom condition |
| `DEFAULT` | Sets a fallback value when none is provided |

### Column-level vs Table-level Constraints
```sql
-- Column-level (defined inline)
CREATE TABLE employees (
    salary DECIMAL(10,2) CHECK (salary > 0)
);

-- Table-level (defined separately — required for multi-column constraints)
CREATE TABLE order_items (
    order_id   INT,
    product_id INT,
    PRIMARY KEY (order_id, product_id)   -- composite constraint
);
```

---

## 💻 Code Examples

### All constraints in one table
```sql
CREATE TABLE employees (
    -- PRIMARY KEY: unique + not null
    emp_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- NOT NULL: must always have a value
    emp_name    VARCHAR(100) NOT NULL,

    -- UNIQUE: no two employees share an email
    email       VARCHAR(255) NOT NULL UNIQUE,

    -- FOREIGN KEY: must reference a valid department
    dept_id     INT REFERENCES departments(dept_id) ON DELETE SET NULL,

    -- CHECK: salary must be positive
    salary      DECIMAL(10,2) CHECK (salary >= 0),

    -- DEFAULT: if not provided, defaults to TRUE
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,

    -- CHECK: end_date must be after start_date
    start_date  DATE NOT NULL,
    end_date    DATE,

    CONSTRAINT chk_dates CHECK (end_date IS NULL OR end_date >= start_date)
);
```

### Adding constraints after table creation
```sql
-- Add a NOT NULL constraint
ALTER TABLE employees ALTER COLUMN emp_name SET NOT NULL;

-- Add a UNIQUE constraint
ALTER TABLE employees ADD CONSTRAINT uq_email UNIQUE (email);

-- Add a CHECK constraint
ALTER TABLE products ADD CONSTRAINT chk_price CHECK (price > 0);

-- Drop a constraint
ALTER TABLE employees DROP CONSTRAINT chk_dates;
```

### Named constraints — best practice
```sql
-- Naming constraints makes error messages much clearer
CREATE TABLE orders (
    order_id    INT,
    customer_id INT,
    amount      DECIMAL(10,2),

    CONSTRAINT pk_orders        PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_cust   FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_order_amount CHECK (amount > 0)
);
```

---

## ⚠️ Common Mistakes
- Not naming constraints — database generates cryptic names, hard to debug errors
- Putting all validation only in application code — DB constraints are the last line of defense
- Using `CHECK` for complex business logic — keep checks simple; complex rules belong in application or triggers
- Forgetting that `UNIQUE` allows multiple `NULL` values (NULL ≠ NULL in SQL)

```sql
-- ❌ UNIQUE does not prevent multiple NULLs
CREATE TABLE users (email VARCHAR(255) UNIQUE);
INSERT INTO users VALUES (NULL);  -- OK
INSERT INTO users VALUES (NULL);  -- Also OK! NULL != NULL

-- ✅ If you want only one NULL, add NOT NULL too
CREATE TABLE users (email VARCHAR(255) UNIQUE NOT NULL);
```

---

## 🔗 Related Topics
- [Primary Keys](../04-database-design/01-primary-keys.md)
- [Foreign Keys](../04-database-design/02-foreign-keys.md)
- [Data Types](../01-fundamentals/04-data-types.md)
- [Transactions & ACID](01-transactions-acid.md)
