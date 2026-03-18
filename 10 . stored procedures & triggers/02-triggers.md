# Triggers

## 📌 What is it?
A trigger is a stored procedure that automatically runs in response to a specific event on a table — such as `INSERT`, `UPDATE`, or `DELETE`. Triggers enforce rules and automate actions without relying on application code.

---

## 🔑 Key Concepts

### When Triggers Fire
| Timing | What it means |
|---|---|
| `BEFORE` | Runs before the operation — can modify or cancel it |
| `AFTER` | Runs after the operation — good for logging, syncing |
| `INSTEAD OF` | Replaces the operation entirely (used on views) |

### Trigger Scope
| Scope | What it means |
|---|---|
| `FOR EACH ROW` | Runs once per affected row |
| `FOR EACH STATEMENT` | Runs once per SQL statement (even if 0 rows affected) |

### Special Variables in Triggers (PostgreSQL)
| Variable | Available in | Contains |
|---|---|---|
| `NEW` | INSERT, UPDATE | The new row being inserted/updated |
| `OLD` | UPDATE, DELETE | The old row before the change |
| `TG_OP` | All | Operation type: `'INSERT'`, `'UPDATE'`, `'DELETE'` |

---

## 💻 Code Examples

### Audit log trigger — track all changes
```sql
-- 1. Create the audit log table
CREATE TABLE employee_audit (
    audit_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emp_id      INT,
    operation   VARCHAR(10),   -- INSERT, UPDATE, DELETE
    old_salary  DECIMAL,
    new_salary  DECIMAL,
    changed_at  TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    changed_by  VARCHAR(100) DEFAULT CURRENT_USER
);

-- 2. Create the trigger function
CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.salary <> NEW.salary THEN
        INSERT INTO employee_audit (emp_id, operation, old_salary, new_salary)
        VALUES (OLD.emp_id, 'UPDATE', OLD.salary, NEW.salary);
    END IF;
    RETURN NEW;
END;
$$;

-- 3. Attach the trigger to the table
CREATE TRIGGER trg_salary_audit
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();
```

### BEFORE trigger — auto-set updated_at timestamp
```sql
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_set_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
```

### BEFORE trigger — prevent negative balance
```sql
CREATE OR REPLACE FUNCTION check_balance()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.balance < 0 THEN
        RAISE EXCEPTION 'Balance cannot be negative. Got: %', NEW.balance;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_balance
BEFORE INSERT OR UPDATE ON accounts
FOR EACH ROW
EXECUTE FUNCTION check_balance();
```

### Managing Triggers
```sql
-- Disable a trigger temporarily
ALTER TABLE employees DISABLE TRIGGER trg_salary_audit;

-- Re-enable
ALTER TABLE employees ENABLE TRIGGER trg_salary_audit;

-- Drop a trigger
DROP TRIGGER IF EXISTS trg_salary_audit ON employees;
```

---

## ⚠️ Common Mistakes
- Triggers calling other triggers — can create cascading chains that are hard to debug
- Heavy logic in triggers — they run on every row, so slow triggers slow down all writes
- Forgetting `RETURN NEW` in `BEFORE` triggers — the row won't be saved
- Using triggers for business logic that belongs in the application — makes the system harder to test and reason about

```sql
-- ❌ Forgetting RETURN NEW in a BEFORE trigger = row is silently not saved
CREATE OR REPLACE FUNCTION my_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    -- Missing RETURN NEW!
END;
$$ LANGUAGE plpgsql;

-- ✅ Always return NEW (or OLD for DELETE triggers)
CREATE OR REPLACE FUNCTION my_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;  -- Required!
END;
$$ LANGUAGE plpgsql;
```

---

## 🔗 Related Topics
- [Stored Procedures](01-stored-procedures.md)
- [Transactions & ACID](../08-data-integrity/01-transactions-acid.md)
- [Constraints](../08-data-integrity/02-constraints.md)
