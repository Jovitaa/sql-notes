# Primary Keys

## 📌 What is it?
A Primary Key (PK) is a column (or set of columns) that uniquely identifies each row in a table. It is the foundation of data integrity in a relational database.

---

## 🔑 Key Concepts

### Three Rules of a Primary Key
1. **Unique** — no two rows can have the same PK value
2. **Not NULL** — every row must have a PK value
3. **Immutable** — PK values should not change after being set

### What a PK does
- Uniquely identifies each record (entity integrity)
- Acts as the target for Foreign Keys in other tables
- Automatically creates a **clustered index** — physically orders data on disk

### Surrogate vs Natural Keys
| Type | Example | Recommended? |
|---|---|---|
| **Surrogate Key** | Auto-generated ID (BIGINT, UUID) | ✅ Yes |
| **Natural Key** | Email, SSN, phone number | ❌ Avoid — business data changes |

> 💡 Never use email or other real-world data as a PK. Business rules change — a student's email might be updated, breaking every reference to that row.

### BIGINT vs UUID
| | BIGINT | UUIDv4 | UUIDv7 |
|---|---|---|---|
| Size | 8 bytes | 16 bytes | 16 bytes |
| Speed | Fast (sequential) | Slow (random inserts cause index fragmentation) | Fast (time-ordered, like BIGINT) |
| Best for | Single-server apps | Distributed systems (legacy) | Distributed systems (modern) |

---

## 💻 Code Examples

### Simple BIGINT Primary Key (single-server)
```sql
CREATE TABLE students (
    student_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
```

### UUID Primary Key (distributed systems)
```sql
CREATE TABLE students (
    student_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL
);
```

### Composite Primary Key (many-to-many junction table)
```sql
CREATE TABLE course_enrollments (
    student_id BIGINT REFERENCES students(student_id),
    course_id  BIGINT REFERENCES courses(course_id),
    enrolled_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, course_id)  -- composite PK
);
```

---

## ⚠️ Common Mistakes
- Using email or phone as a PK — these change and break referential integrity
- Using random UUIDv4 in high-write systems — causes B-Tree index fragmentation
- Creating composite PKs with too many columns — slows down joins and index lookups

---

## 🔗 Related Topics
- [Foreign Keys](02-foreign-keys.md)
- [Normalization](03-normalization.md)
- [Indexes](../05-performance/01-indexes.md)
- [JOIN Types](../03-joins/01-join-types.md)
