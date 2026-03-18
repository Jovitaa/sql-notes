# SQL Injection

## 📌 What is it?
SQL Injection (SQLi) is an attack where malicious SQL code is inserted into an input field, tricking the database into running unintended commands. It's one of the most common and dangerous web vulnerabilities.

---

## 🔑 Key Concepts

### How it happens
```sql
-- Vulnerable code (Python string formatting):
query = "SELECT * FROM users WHERE username = '" + username + "'"

-- Attacker enters: ' OR '1'='1
-- Query becomes:
SELECT * FROM users WHERE username = '' OR '1'='1'
-- Result: returns ALL users — authentication bypassed!
```

### Defense Layers (use all of them)
| Layer | Method | Priority |
|---|---|---|
| 1st | Parameterized Queries | ✅ Must have |
| 2nd | Input Validation | ✅ Must have |
| 3rd | Least Privilege | ✅ Must have |
| 4th | Stored Procedures | ⚠️ Only if parameterized internally |
| ❌ | String sanitization/regex | Avoid — error-prone, bypassable |

---

## 💻 Code Examples

### ❌ Vulnerable — never do this
```python
# String concatenation = SQL injection risk
query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
cursor.execute(query)
```

### ✅ Safe — Parameterized Query (Python)
```python
# The DB driver separates code from data — input is never treated as SQL
from sqlalchemy import text

stmt = text("SELECT * FROM users WHERE username = :u AND password = :p")
result = session.execute(stmt, {"u": username, "p": password})
```

### ✅ Safe — Parameterized Query (Node.js)
```javascript
// Using pg (node-postgres)
const result = await client.query(
    'SELECT * FROM users WHERE username = $1 AND password = $2',
    [username, password]
);
```

### ✅ Input Validation (Python with Pydantic)
```python
from pydantic import BaseModel, StringConstraints
from typing import Annotated

class UserLogin(BaseModel):
    # Only allow alphanumeric usernames, 3-20 chars
    username: Annotated[str, StringConstraints(pattern=r'^[a-zA-Z0-9_]{3,20}$')]
    password: str
```

### ✅ Least Privilege — restrict the DB user
```sql
-- Create a restricted role for your app
CREATE ROLE app_user WITH LOGIN PASSWORD 'secure_password';

-- Only grant what the app actually needs
GRANT SELECT, INSERT, UPDATE ON orders TO app_user;
GRANT SELECT ON products TO app_user;

-- Never grant these to app users:
-- GRANT DROP, TRUNCATE, CREATE, SUPERUSER ...
```

---

## ⚠️ Common Mistakes
- Using string formatting or concatenation to build SQL queries
- Relying only on input sanitization — it can be bypassed with encoding tricks
- Giving the app's database user `superuser` or `db_owner` privileges
- Thinking ORMs automatically protect you — they do by default, but raw queries inside an ORM are still vulnerable

```python
# ❌ Still vulnerable — raw SQL inside an ORM
db.execute(f"SELECT * FROM users WHERE id = {user_id}")

# ✅ Safe — parameterized even with raw SQL
db.execute("SELECT * FROM users WHERE id = :id", {"id": user_id})
```

---

## 🔗 Related Topics
- [SQL Command Types](../01-fundamentals/03-sql-command-types.md)
- [Primary Keys](../04-database-design/01-primary-keys.md)
