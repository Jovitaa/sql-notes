# String Functions

## 📌 What is it?
String functions let you manipulate, format, search, and transform text values directly inside SQL queries — without needing to process them in application code.

---

## 🔑 Key Concepts

### Most Used String Functions
| Function | What it does | Example |
|---|---|---|
| `LENGTH(str)` | Number of characters | `LENGTH('hello')` → 5 |
| `UPPER(str)` | Convert to uppercase | `UPPER('hello')` → `HELLO` |
| `LOWER(str)` | Convert to lowercase | `LOWER('HELLO')` → `hello` |
| `TRIM(str)` | Remove leading/trailing spaces | `TRIM('  hi  ')` → `hi` |
| `LTRIM(str)` | Remove leading spaces | — |
| `RTRIM(str)` | Remove trailing spaces | — |
| `CONCAT(a, b)` | Join strings together | `CONCAT('Hi', ' there')` → `Hi there` |
| `\|\|` | Concatenation operator | `'Hi' \|\| ' there'` → `Hi there` |
| `SUBSTRING(str, start, len)` | Extract part of a string | `SUBSTRING('hello', 2, 3)` → `ell` |
| `LEFT(str, n)` | First n characters | `LEFT('hello', 3)` → `hel` |
| `RIGHT(str, n)` | Last n characters | `RIGHT('hello', 3)` → `llo` |
| `REPLACE(str, from, to)` | Replace substring | `REPLACE('hi world', 'hi', 'hello')` → `hello world` |
| `POSITION(sub IN str)` | Find position of substring | `POSITION('lo' IN 'hello')` → 4 |
| `LIKE` | Pattern matching | `name LIKE 'A%'` |
| `ILIKE` | Case-insensitive LIKE (PostgreSQL) | `name ILIKE 'a%'` |
| `SPLIT_PART(str, delim, n)` | Split and get nth part | `SPLIT_PART('a,b,c', ',', 2)` → `b` |
| `LPAD(str, len, fill)` | Pad left to length | `LPAD('5', 3, '0')` → `005` |
| `RPAD(str, len, fill)` | Pad right to length | — |

---

## 💻 Code Examples

### Clean up messy data
```sql
-- Normalize names: trim spaces and fix casing
SELECT
    TRIM(UPPER(first_name)) AS first_name,
    TRIM(UPPER(last_name))  AS last_name
FROM customers;
```

### CONCAT — build full name
```sql
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

-- PostgreSQL alternative
SELECT first_name || ' ' || last_name AS full_name FROM employees;
```

### LIKE / ILIKE — pattern matching
```sql
-- Find all customers whose name starts with 'A'
SELECT * FROM customers WHERE name LIKE 'A%';

-- Case-insensitive (PostgreSQL)
SELECT * FROM customers WHERE name ILIKE 'a%';

-- Contains 'kumar' anywhere
SELECT * FROM customers WHERE name ILIKE '%kumar%';

-- Exactly 5 characters
SELECT * FROM customers WHERE name LIKE '_____';
```

### SUBSTRING — extract part of a string
```sql
-- Extract area code from phone number '022-12345678'
SELECT SUBSTRING(phone, 1, 3) AS area_code FROM contacts;

-- Or using SPLIT_PART
SELECT SPLIT_PART(phone, '-', 1) AS area_code FROM contacts;
```

### REPLACE — clean up data
```sql
-- Remove dashes from phone numbers
SELECT REPLACE(phone_number, '-', '') AS clean_phone
FROM contacts;
```

### LPAD — format numbers as strings
```sql
-- Pad invoice numbers with leading zeros: '42' → '000042'
SELECT LPAD(invoice_id::TEXT, 6, '0') AS formatted_id FROM invoices;
```

---

## ⚠️ Common Mistakes
- Using `=` for pattern matching instead of `LIKE` — `=` is exact match only
- Forgetting `ILIKE` (or `LOWER()`) for case-insensitive search — `LIKE 'john%'` won't match `'John'`
- `LIKE '%value%'` on large tables is slow — can't use a regular index (consider full-text search for this)

```sql
-- ❌ This won't find 'John' or 'JOHN'
WHERE name LIKE 'john%'

-- ✅ Use ILIKE (PostgreSQL) or LOWER()
WHERE LOWER(name) LIKE 'john%'
WHERE name ILIKE 'john%'
```

---

## 🔗 Related Topics
- [NULL Handling](04-null-handling.md)
- [SELECT Statement](../02-querying/01-select-statement.md)
- [CASE Statements](../07-advanced-querying/03-case-statements.md)
