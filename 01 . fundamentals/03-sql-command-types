# SQL Command Types

## 📌 What is it?
SQL commands are grouped into 5 categories based on what they do — from defining structure to controlling transactions and security.

---

## 🔑 Key Concepts

### The 5 Categories at a Glance
| Category | Stands For | What it does | Key Commands |
|---|---|---|---|
| **DQL** | Data Query Language | Retrieve data | `SELECT` |
| **DDL** | Data Definition Language | Define/change structure | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML** | Data Manipulation Language | Add/change/delete rows | `INSERT`, `UPDATE`, `DELETE`, `MERGE` |
| **TCL** | Transaction Control Language | Manage transactions | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |
| **DCL** | Data Control Language | Manage permissions | `GRANT`, `REVOKE` |

---

## 💻 Code Examples

### DQL — Querying Data
```sql
SELECT emp_name, salary
FROM employees
WHERE salary > 50000
ORDER BY salary DESC;
```

### DDL — Defining Structure
```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL
);

ALTER TABLE employees ADD COLUMN department VARCHAR(50);

DROP TABLE old_table;
```

### DML — Manipulating Rows
```sql
INSERT INTO employees (emp_name, salary) VALUES ('Riya', 75000);

UPDATE employees SET salary = 80000 WHERE emp_id = 1;

DELETE FROM employees WHERE emp_id = 5;

-- MERGE: Insert or update in one step (great for ETL)
MERGE INTO employees AS target
USING new_data AS source ON target.emp_id = source.emp_id
WHEN MATCHED THEN UPDATE SET salary = source.salary
WHEN NOT MATCHED THEN INSERT (emp_id, emp_name) VALUES (source.emp_id, source.emp_name);
```

### TCL — Transaction Control
```sql
BEGIN;

UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

SAVEPOINT transfer_done;

-- If something goes wrong:
ROLLBACK TO transfer_done;

-- If everything is fine:
COMMIT;
```

### DCL — Access Control
```sql
GRANT SELECT, INSERT ON employees TO analyst_role;

REVOKE INSERT ON employees FROM analyst_role;
```

---

## ⚠️ Common Mistakes
- `TRUNCATE` looks like DML but is actually DDL — it cannot always be rolled back
- Forgetting `COMMIT` after DML in databases without auto-commit enabled
- Using `DROP` when you meant `DELETE` — `DROP` removes the entire table structure

---

## 🔗 Related Topics
- [What is SQL](01-what-is-sql.md)
- [SELECT Statement](../02-querying/01-select-statement.md)
- [Primary Keys](../04-database-design/01-primary-keys.md)
