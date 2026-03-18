# Data Types

## 📌 What is it?
A data type defines what kind of value a column can store. Choosing the right data type affects storage size, query performance, and data integrity.

---

## 🔑 Key Concepts

### Numeric Types
| Type | Storage | Range | Use for |
|---|---|---|---|
| `SMALLINT` | 2 bytes | -32,768 to 32,767 | Small counters |
| `INT` / `INTEGER` | 4 bytes | -2.1B to 2.1B | General integers |
| `BIGINT` | 8 bytes | Very large numbers | IDs, row counts |
| `DECIMAL(p,s)` / `NUMERIC` | Variable | Exact precision | Money, financials |
| `FLOAT` / `REAL` | 4-8 bytes | Approximate | Scientific data |

> 💡 Never use `FLOAT` for money — it introduces rounding errors. Use `DECIMAL(12,2)` instead.

### String Types
| Type | Best for |
|---|---|
| `CHAR(n)` | Fixed-length strings (e.g., country codes: `CHAR(2)`) |
| `VARCHAR(n)` | Variable-length strings with a known max |
| `TEXT` | Unlimited length strings (no max needed) |

> 💡 In PostgreSQL, `TEXT` and `VARCHAR` have identical performance. Use `TEXT` when you don't need a length limit.

### Date & Time Types
| Type | Stores | Use for |
|---|---|---|
| `DATE` | Date only (YYYY-MM-DD) | Birthdays, deadlines |
| `TIME` | Time only | Schedules |
| `TIMESTAMP` | Date + time (no timezone) | Local timestamps |
| `TIMESTAMPTZ` | Date + time + timezone | ✅ Recommended for most cases |
| `INTERVAL` | Duration | Time differences |

> 💡 Always use `TIMESTAMPTZ` over `TIMESTAMP` in production — it stores timezone info and prevents bugs when your server or users are in different timezones.

### Boolean
| Type | Values |
|---|---|
| `BOOLEAN` | `TRUE`, `FALSE`, `NULL` |

### Special Types (PostgreSQL)
| Type | Use for |
|---|---|
| `UUID` | Unique IDs across distributed systems |
| `JSONB` | Semi-structured JSON data (indexed, queryable) |
| `ARRAY` | Lists of values in a single column |
| `SERIAL` / `BIGSERIAL` | Legacy auto-increment (prefer `GENERATED ALWAYS AS IDENTITY`) |

---

## 💻 Code Examples

### Choosing types in a real table
```sql
CREATE TABLE users (
    user_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_uuid   UUID DEFAULT gen_random_uuid(),
    username    VARCHAR(50) NOT NULL,
    bio         TEXT,
    age         SMALLINT CHECK (age >= 0 AND age <= 150),
    balance     DECIMAL(12, 2) DEFAULT 0.00,
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
```

### JSONB column
```sql
CREATE TABLE products (
    product_id  INT PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    attributes  JSONB   -- store flexible data like {"color": "red", "size": "M"}
);

-- Query inside JSONB
SELECT name FROM products
WHERE attributes->>'color' = 'red';
```

### Casting between types
```sql
-- Cast a string to integer
SELECT CAST('42' AS INT);
SELECT '42'::INT;          -- PostgreSQL shorthand

-- Cast a timestamp to date
SELECT created_at::DATE FROM users;
```

---

## ⚠️ Common Mistakes
- Using `FLOAT` for currency — always use `DECIMAL`
- Using `TIMESTAMP` instead of `TIMESTAMPTZ` — timezone bugs in production
- Making `VARCHAR(255)` the default for everything — choose sizes that reflect actual data
- Using `CHAR(n)` for variable-length data — pads with spaces, wastes storage

---

## 🔗 Related Topics
- [Primary Keys](../04-database-design/01-primary-keys.md)
- [Constraints](../08-data-integrity/02-constraints.md)
- [NULL Handling](../09-functions/04-null-handling.md)
