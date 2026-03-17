# SQL vs NoSQL

## 📌 What is it?
SQL databases store data in structured tables with strict schemas. NoSQL databases store data in flexible formats (documents, key-value, graphs) optimized for scale and speed. Both are widely used — choosing depends on your use case.

---

## 🔑 Key Concepts

### Fundamental Difference
| Feature | SQL (Relational) | NoSQL (Non-Relational) |
|---|---|---|
| Structure | Tables with rows & columns | Documents, key-value, graphs, columns |
| Schema | Fixed (schema-on-write) | Flexible (schema-on-read) |
| Integrity | Enforced via constraints/FKs | Application-layer validation |
| Joins | Efficient via relational algebra | Often discouraged / denormalized |
| Scaling | Vertical (+ Distributed SQL) | Native Horizontal (Sharding) |
| Consistency | ACID compliant | Tunable (eventual or strong) |
| Query Language | Standard SQL | Proprietary APIs / SQL-like |

### NoSQL Types
| Type | How it works | Best for |
|---|---|---|
| **Document Store** | Stores BSON/JSON documents | Flexible content, RAG workflows |
| **Key-Value Store** | Hash table (key → value) | Caching, sessions, ML feature stores |
| **Wide-Column Store** | Sparse multidimensional maps | Write-heavy, time-series, IoT |
| **Graph Database** | Nodes and edges | Relationships, knowledge graphs, LLMs |

### 2026 Reality: The Lines are Blurring
- **PostgreSQL** now supports JSONB — semi-structured data inside an ACID database
- **MongoDB** now supports multi-document ACID transactions
- **Distributed SQL** (CockroachDB, TiDB) brings horizontal scaling to SQL — the old rule "SQL = vertical only" is no longer true

---

## 💻 When to Use What

```
Use SQL when:
✅ Data integrity is critical
✅ Complex transactions are needed
✅ Schema is well-defined and stable
✅ Reporting and analytics are important

Use NoSQL when:
✅ High-velocity streaming or IoT data
✅ Schema needs to evolve frequently
✅ Horizontal scaling from day one
✅ Sparse or unstructured data (e.g., logs)

Use Distributed SQL when:
✅ You want SQL familiarity + NoSQL scalability
```

---

## ⚠️ Common Mistakes
- Thinking NoSQL = no transactions — many enterprise NoSQL databases now support ACID
- Picking NoSQL just because it sounds "modern" — SQL is often the right choice
- Ignoring the cost of distributed joins in NoSQL systems

---

## 🔗 Related Topics
- [What is SQL](01-what-is-sql.md)
- [Normalization](../04-database-design/03-normalization.md)
- [Denormalization](../04-database-design/04-denormalization.md)
