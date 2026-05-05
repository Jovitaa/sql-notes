# SQL NULL Functions

## 📌 What is NULL?
- NULL represents **missing or unknown data**
- It is NOT:
  - 0
  - empty string ''
  - false

---

## ⚠️ Important Behavior
- Any operation with NULL → results in NULL
- Example:
  SELECT 5 + NULL → NULL

---

## 🔹 Common NULL Functions

### 1. COALESCE() ✅ (Standard)
Returns the first non-NULL value

```sql
SELECT COALESCE(mobile, 'No Number')
FROM teacher;
