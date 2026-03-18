# Regex & Pattern Matching in SQL

## 📌 What is it?
Pattern matching lets you search, validate, and extract text using patterns — not just exact strings. SQL supports simple patterns with `LIKE` and powerful regular expressions with `REGEXP` / `~`. Essential for cleaning messy real-world data like phone numbers, emails, and codes.

---

## 🔑 Key Concepts

### Pattern Matching Options
| Method | Syntax | Supports | Speed |
|---|---|---|---|
| `LIKE` | `col LIKE 'A%'` | `%` (any chars), `_` (one char) | ✅ Fast (can use index) |
| `ILIKE` | `col ILIKE 'a%'` | Same as LIKE but case-insensitive | ✅ Fast |
| `SIMILAR TO` | `col SIMILAR TO '[A-Z]%'` | SQL regex (limited) | Medium |
| `~` (PostgreSQL) | `col ~ '^[A-Z]'` | Full POSIX regex | Medium |
| `~*` (PostgreSQL) | `col ~* '^[a-z]'` | Case-insensitive regex | Medium |
| `REGEXP_MATCH` | `REGEXP_MATCH(col, pattern)` | Full regex, returns matches | Medium |
| `REGEXP_REPLACE` | `REGEXP_REPLACE(col, pattern, replacement)` | Replace using regex | Medium |

### Key Regex Patterns
| Pattern | Matches |
|---|---|
| `^` | Start of string |
| `$` | End of string |
| `.` | Any single character |
| `*` | Zero or more of previous |
| `+` | One or more of previous |
| `?` | Zero or one of previous |
| `[abc]` | Any one of a, b, c |
| `[A-Z]` | Any uppercase letter |
| `[0-9]` or `\d` | Any digit |
| `\s` | Whitespace |
| `{n,m}` | Between n and m repetitions |
| `(abc\|def)` | Either "abc" or "def" |

---

## 💻 Code Examples

### LIKE — simple pattern matching
```sql
-- Names starting with 'A'
SELECT * FROM customers WHERE name LIKE 'A%';

-- Names ending with 'Kumar'
SELECT * FROM customers WHERE name LIKE '%Kumar';

-- 10-digit numbers (exactly 10 characters)
SELECT * FROM customers WHERE phone LIKE '__________';   -- 10 underscores

-- Case-insensitive (PostgreSQL)
SELECT * FROM customers WHERE name ILIKE 'priya%';
```

### Validate email format
```sql
-- Find rows with invalid emails (no @ or no domain)
SELECT customer_id, email
FROM customers
WHERE email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
```

### Validate phone numbers
```sql
-- Find phones that are NOT 10 digits (after stripping spaces/dashes)
SELECT customer_id, phone
FROM customers
WHERE REGEXP_REPLACE(phone, '[\s\-\(\)]', '', 'g') !~ '^\+?[0-9]{10,13}$';
```

### Extract parts of a string using regex
```sql
-- Extract the domain from email addresses
SELECT
    email,
    REGEXP_MATCH(email, '@(.+)$') AS domain_array,        -- returns array
    (REGEXP_MATCH(email, '@(.+)$'))[1] AS domain          -- get first capture group
FROM customers;

-- Extract year from a mixed text field like 'Report 2026 Final'
SELECT
    title,
    (REGEXP_MATCH(title, '\d{4}'))[1]::INT AS year_extracted
FROM reports;
```

### Clean data with REGEXP_REPLACE
```sql
-- Remove all non-numeric characters from phone numbers
SELECT
    phone,
    REGEXP_REPLACE(phone, '[^0-9]', '', 'g') AS clean_phone
FROM customers;
-- '(022) 123-4567' → '0221234567'

-- Remove extra whitespace
SELECT
    REGEXP_REPLACE(TRIM(name), '\s+', ' ', 'g') AS clean_name
FROM customers;
-- 'Priya   Sharma' → 'Priya Sharma'
```

### Flag or categorize using regex
```sql
-- Categorize product codes by format
SELECT
    product_code,
    CASE
        WHEN product_code ~ '^[A-Z]{2}-\d{4}$'   THEN 'Standard (e.g. AB-1234)'
        WHEN product_code ~ '^[A-Z]{3}\d{3}$'     THEN 'Legacy (e.g. ABC123)'
        WHEN product_code ~ '^\d{8}$'             THEN 'Numeric (e.g. 12345678)'
        ELSE 'Unknown format'
    END AS code_type
FROM products;
```

### Full-text search (PostgreSQL tsvector)
```sql
-- Create a full-text search index
CREATE INDEX idx_products_fts ON products USING GIN(to_tsvector('english', description));

-- Search for products mentioning 'wireless' and 'bluetooth'
SELECT product_name, description
FROM products
WHERE to_tsvector('english', description) @@ to_tsquery('wireless & bluetooth');

-- Search with ranking
SELECT
    product_name,
    TS_RANK(to_tsvector('english', description),
            to_tsquery('wireless & bluetooth')) AS relevance
FROM products
WHERE to_tsvector('english', description) @@ to_tsquery('wireless & bluetooth')
ORDER BY relevance DESC;
```

---

## ⚠️ Common Mistakes
- Using `LIKE '%value%'` on large tables — leading wildcard disables index, causes full scan
- Forgetting the `'g'` flag in `REGEXP_REPLACE` — without it, only the first match is replaced
- Writing overly complex regex when `LIKE` would do — keep it simple unless you need the power
- Not anchoring regex with `^` and `$` — `'[0-9]+'` matches any string containing digits, not only digit strings

```sql
-- ❌ Matches '123abc' and 'abc123' — not just numbers
WHERE phone ~ '[0-9]+'

-- ✅ Anchored — only matches strings that are ALL digits
WHERE phone ~ '^\d+$'
```

---

## 🔗 Related Topics
- [String Functions](../09-functions/02-string-functions.md)
- [Data Cleaning](01-data-cleaning.md)
- [Duplicate Detection](../12-real-world-sql/01-duplicate-detection.md)
- [Indexes](../05-performance/01-indexes.md)
