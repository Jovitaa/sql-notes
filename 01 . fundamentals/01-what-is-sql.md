# What is SQL?

## 📌 What is it?
SQL (Structured Query Language) is the standard language for managing and querying Relational Database Management Systems (RDBMS). It lets you create, read, update, and delete data stored in tables.

---

## 🔑 Key Concepts

### Core Components
| Component | Full Name | Purpose |
|---|---|---|
| DDL | Data Definition Language | Define schema objects (`CREATE`, `ALTER`, `DROP`) |
| DML | Data Manipulation Language | Manage row-level data (`INSERT`, `UPDATE`, `DELETE`) |
| DCL | Data Control Language | Manage security (`GRANT`, `REVOKE`) |
| TCL | Transaction Control Language | Ensure consistency (`COMMIT`, `ROLLBACK`) |
| DQL | Data Query Language | Retrieve data (`SELECT`) |

### What SQL is used for
- **Data Retrieval** — complex queries, aggregations, analytics
- **ACID Compliance** — ensures data stays consistent even with many users
- **Normalization** — organizing data to remove redundancy
- **Distributed Scaling** — sharding and replication for large datasets
- **Vector Search** — modern SQL supports AI-driven similarity queries (e.g., pgvector)

---

## 💻 Code Example

```sql
-- Schema Definition
CREATE TABLE Department (
    dept_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    emp_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    dept_id INT REFERENCES Department(dept_id)
);

-- Query using CTE (Common Table Expression)
WITH DepartmentStats AS (
    SELECT dept_id, COUNT(*) AS emp_count
    FROM Employee
    GROUP BY dept_id
)
SELECT
    e.emp_name,
    d.dept_name,
    ds.emp_count
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id
JOIN DepartmentStats ds ON d.dept_id = ds.dept_id
WHERE ds.emp_count > 0;
```

---

## ⚠️ Common Mistakes
- Confusing SQL with a programming language — it's a **query language**, not procedural
- Forgetting that SQL has a **logical execution order** (FROM → WHERE → GROUP BY → SELECT)
- Using `SELECT *` in production — always specify the columns you need

---

## 🔗 Related Topics
- [SQL Command Types](03-sql-command-types.md)
- [SELECT Statement](../02-querying/01-select-statement.md)
- [SQL vs NoSQL](02-sql-vs-nosql.md)
