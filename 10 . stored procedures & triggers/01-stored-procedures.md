# Stored Procedures

## 📌 What is it?
A stored procedure is a named, reusable block of SQL (and procedural logic) saved in the database. You call it by name instead of writing the same SQL repeatedly — useful for complex multi-step operations, business logic, or batch jobs.

---

## 🔑 Key Concepts

### Stored Procedure vs Function
| | Stored Procedure | Function |
|---|---|---|
| Returns a value? | Optional | ✅ Must return a value |
| Can be used in SELECT? | ❌ No | ✅ Yes |
| Can have transactions? | ✅ Yes | Limited |
| Called with | `CALL` | `SELECT` |
| Best for | Multi-step operations | Calculations, transformations |

### When to use stored procedures
- Complex multi-step business logic (e.g., process an order)
- Batch operations (e.g., archive old records)
- Enforcing security — grant `EXECUTE` on procedure instead of direct table access
- Reducing network round-trips in high-performance scenarios

> 💡 In modern apps, most developers prefer handling business logic in application code (using ORMs like Prisma, SQLAlchemy) for better testability and maintainability. Use stored procedures for performance-critical or security-sensitive operations.

---

## 💻 Code Examples

### Basic Stored Procedure (PostgreSQL)
```sql
-- Create a procedure to give all employees in a dept a raise
CREATE OR REPLACE PROCEDURE give_raise(
    p_department VARCHAR,
    p_percent    DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary = salary * (1 + p_percent / 100)
    WHERE department = p_department;

    COMMIT;
END;
$$;

-- Call it
CALL give_raise('Engineering', 10);  -- 10% raise for Engineering
```

### Procedure with error handling
```sql
CREATE OR REPLACE PROCEDURE transfer_funds(
    p_from_account INT,
    p_to_account   INT,
    p_amount       DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_balance DECIMAL;
BEGIN
    -- Check balance
    SELECT balance INTO v_balance
    FROM accounts WHERE account_id = p_from_account;

    IF v_balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient funds: balance is %', v_balance;
    END IF;

    -- Perform transfer
    UPDATE accounts SET balance = balance - p_amount WHERE account_id = p_from_account;
    UPDATE accounts SET balance = balance + p_amount WHERE account_id = p_to_account;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;  -- Re-raise the error
END;
$$;

-- Call it
CALL transfer_funds(1, 2, 500.00);
```

### Procedure with output parameter
```sql
CREATE OR REPLACE PROCEDURE get_employee_count(
    p_department VARCHAR,
    OUT p_count  INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(*) INTO p_count
    FROM employees
    WHERE department = p_department;
END;
$$;

-- Call and get output
CALL get_employee_count('Engineering', NULL);
```

### Drop a procedure
```sql
DROP PROCEDURE IF EXISTS give_raise;
```

---

## ⚠️ Common Mistakes
- Writing dynamic SQL inside procedures without parameterization — still vulnerable to SQL injection
- Making procedures do too much — keep them focused on one task
- Not handling exceptions — unhandled errors leave transactions open
- Over-using stored procedures for everything — application code is easier to test and version control

---

## 🔗 Related Topics
- [Triggers](02-triggers.md)
- [Transactions & ACID](../08-data-integrity/01-transactions-acid.md)
- [SQL Injection](../06-security/01-sql-injection.md)
