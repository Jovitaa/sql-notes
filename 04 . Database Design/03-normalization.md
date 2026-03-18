# Normalization

## 📌 What is it?
Normalization is the process of organizing a database to reduce redundancy and prevent data anomalies. It works by splitting data into related tables according to specific rules called Normal Forms.

---

## 🔑 Key Concepts

### Why Normalize?
Without normalization, you get **anomalies**:
- **Insert anomaly** — can't add data without adding unrelated data
- **Update anomaly** — changing one fact requires updating many rows
- **Delete anomaly** — deleting a row accidentally removes unrelated data

### The Normal Forms
| Form | Rule | Eliminates |
|---|---|---|
| **1NF** | All values are atomic (no lists/arrays in a cell) | Repeating groups |
| **2NF** | Every non-key column depends on the whole PK | Partial dependencies |
| **3NF** | No non-key column depends on another non-key column | Transitive dependencies |
| **BCNF** | Every determinant is a superkey | Stricter anomalies |
| **4NF** | No multi-valued dependencies | Independent multi-value facts |

> 💡 For most applications, reaching **3NF is the goal**. BCNF and 4NF are for complex schemas.

---

## 💻 Step-by-Step Example

### Starting point — Unnormalized (0NF)
Everything in one messy table:
```
CustomerID | Name  | Invoice# | Item# | Description | Price
1          | Priya | INV-01   | A     | Laptop      | 80000
1          | Priya | INV-01   | B     | Mouse       | 500
```
Problems: Priya's name is repeated, description repeats across invoices.

### 1NF — Make values atomic, identify a key
```sql
-- Each cell has one value, composite key: (InvoiceNo, ItemNo)
InvoiceItems: (InvoiceNo, ItemNo, CustomerID, Description, Price)
```

### 2NF — Remove partial dependencies
```sql
-- Description depends only on ItemNo, not the full key
-- Split it out:
Products: (ItemNo [PK], Description, Price)
InvoiceItems: (InvoiceNo, ItemNo [FK], Quantity)
```

### 3NF — Remove transitive dependencies
```sql
-- CustomerAddress depends on CustomerID, not InvoiceNo
-- Move it to its own table:
Customers: (CustomerID [PK], Name, Address)
Invoices:  (InvoiceNo [PK], CustomerID [FK], InvoiceDate)
```

### Final normalized schema
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL
);

CREATE TABLE products (
    product_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description TEXT NOT NULL,
    unit_price  DECIMAL(12,2) CHECK (unit_price >= 0)
);

CREATE TABLE invoices (
    invoice_no  INT PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    invoice_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE invoice_items (
    invoice_no INT REFERENCES invoices(invoice_no),
    product_id INT REFERENCES products(product_id),
    quantity   INT CHECK (quantity > 0),
    PRIMARY KEY (invoice_no, product_id)
);
```

---

## ⚠️ Common Mistakes
- Over-normalizing simple apps — sometimes a bit of redundancy is fine
- Forgetting to normalize after adding new columns — schemas evolve and drift
- Confusing 2NF and 3NF — 2NF is about the PK; 3NF is about non-key columns depending on each other

---

## 🔗 Related Topics
- [Denormalization](04-denormalization.md)
- [Primary Keys](01-primary-keys.md)
- [Foreign Keys](02-foreign-keys.md)
- [Indexes](../05-performance/01-indexes.md)
