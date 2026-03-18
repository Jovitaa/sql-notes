# Transactions & ACID

## 📌 What is it?
A transaction is a group of SQL operations that are treated as a single unit — either all succeed together or all fail together. ACID is the set of four properties that guarantee transactions are reliable, even when things go wrong (crashes, errors, concurrent users).

---

## 🔑 Key Concepts

### ACID Properties
| Property | Meaning | Example |
|---|---|---|
| **Atomicity** | All or nothing — partial success is not allowed | A bank transfer either moves money from both accounts, or neither |
| **Consistency** | Data moves from one valid state to another | Account balance can't go below zero if that's a rule |
| **Isolation** | Concurrent transactions don't interfere with each other | Two users booking the last seat don't both succeed |
| **Durability** | Committed changes survive crashes | After `COMMIT`, the data is on disk permanently |

### Transaction Commands
| Command | What it does |
|---|---|
| `BEGIN` | Start a transaction |
| `COMMIT` | Save all changes permanently |
| `ROLLBACK` | Undo all changes since `BEGIN` |
| `SAVEPOINT name` | Set a checkpoint within a transaction |
| `ROLLBACK TO name` | Undo back to a savepoint (not full rollback) |

### Isolation Levels
Higher isolation = safer, but slower. Choose based on your needs:

| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|---|---|---|---|
| `READ UNCOMMITTED` | ✅ Possible | ✅ Possible | ✅ Possible |
| `READ COMMITTED` | ❌ Prevented | ✅ Possible | ✅ Possible |
| `REPEATABLE READ` | ❌ Prevented | ❌ Prevented | ✅ Possible |
| `SERIALIZABLE` | ❌ Prevented | ❌ Prevented | ❌ Prevented |

> 💡 Most databases default to `READ COMMITTED`. Use `SERIALIZABLE` when absolute consistency is critical (e.g., financial systems).

---

## 💻 Code Examples

### Basic Transaction — bank transfer
```sql
BEGIN;

UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;

-- If both succeed:
COMMIT;
```

### With error handling and ROLLBACK
```sql
BEGIN;

UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;

-- Simulate checking for an error condition
DO $$
BEGIN
    IF (SELECT balance FROM accounts WHERE account_id = 1) < 0 THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;
END $$;

UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;

COMMIT;

-- If any error occurs above, run:
-- ROLLBACK;
```

### SAVEPOINT — partial rollback
```sql
BEGIN;

INSERT INTO orders (customer_id, amount) VALUES (1, 500);

SAVEPOINT order_placed;

INSERT INTO payments (order_id, amount) VALUES (1, 500);

-- If payment insert fails, rollback only the payment, keep the order
ROLLBACK TO order_placed;

-- Try alternative payment method
INSERT INTO payments (order_id, amount, method) VALUES (1, 500, 'credit');

COMMIT;
```

### Setting isolation level
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT balance FROM accounts WHERE account_id = 1;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;

COMMIT;
```

---

## ⚠️ Common Mistakes
- Forgetting `COMMIT` — changes stay in a pending state and block other transactions
- Long-running transactions — hold locks, block other users, cause performance issues
- Not handling errors — always have a `ROLLBACK` path in application code
- Assuming auto-commit is always on — some clients require explicit `COMMIT`

```sql
-- ❌ No rollback path — if second UPDATE fails, first UPDATE stays
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

-- ✅ Wrap in a transaction
BEGIN;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;
COMMIT;
```

---

## 🔗 Related Topics
- [SQL Command Types](../01-fundamentals/03-sql-command-types.md)
- [Constraints](02-constraints.md)
- [SQL Injection](../06-security/01-sql-injection.md)
