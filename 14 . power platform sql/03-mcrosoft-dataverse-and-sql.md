# Microsoft Dataverse & SQL

## 📌 What is it?
Microsoft Dataverse (formerly Common Data Service) is the database that powers Power Apps, Power Automate, and Dynamics 365. It's not traditional SQL — it uses a proprietary schema and query language — but understanding how data is stored and retrieved is essential for Power Platform roles.

---

## 🔑 Key Concepts

### Dataverse vs Traditional SQL
| Feature | Traditional SQL | Microsoft Dataverse |
|---|---|---|
| Tables | Tables | **Tables** (formerly Entities) |
| Columns | Columns | **Columns** (formerly Fields/Attributes) |
| Rows | Rows | **Rows** (formerly Records) |
| Primary Key | Custom PK column | Auto-generated GUID (`TableNameId`) |
| Query language | SQL | **FetchXML**, **OData**, **Dataverse SQL (preview)** |
| Relationships | Foreign Keys | **Lookups** (1:N), **Many-to-Many** |
| Access | Direct DB connection | API only (no direct DB access) |

### Ways to Query Dataverse
| Method | Used in | Supports |
|---|---|---|
| **FetchXML** | Power Apps, Plug-ins, API | Full query capability |
| **OData** | REST API, Power Automate | Filtering, sorting, selecting |
| **Dataverse SQL** | Power BI, TDS endpoint | Standard SQL syntax (limited) |
| **Power Query / M** | Power BI, Excel | Visual query builder |

---

## 💻 Code Examples

### Connecting Power BI to Dataverse via TDS endpoint
```
Server: orgname.crm.dynamics.com,5558
Database: (leave blank or use org name)
Authentication: Microsoft Account
```

```sql
-- Once connected, query Dataverse tables with SQL
SELECT
    accountid,
    name,
    revenue,
    createdon,
    statecode
FROM account
WHERE statecode = 0    -- 0 = Active
ORDER BY revenue DESC;
```

### Common Dataverse system columns to know
```sql
SELECT
    -- Every Dataverse table has these system columns
    createdon,          -- When the row was created
    modifiedon,         -- When last modified
    createdby,          -- Who created it (lookup to systemuser)
    modifiedby,         -- Who last modified it
    statecode,          -- 0 = Active, 1 = Inactive
    statuscode,         -- Substatus (varies by table)
    ownerid,            -- Who owns the record
    owningbusinessunit  -- Which business unit owns it
FROM account;
```

### Query with JOINs using TDS endpoint
```sql
-- Accounts with their primary contact
SELECT
    a.name          AS account_name,
    a.revenue,
    c.fullname      AS primary_contact,
    c.emailaddress1 AS contact_email
FROM account a
LEFT JOIN contact c ON a.primarycontactid = c.contactid
WHERE a.statecode = 0
ORDER BY a.revenue DESC;
```

### FetchXML — the native Dataverse query language
```xml
<!-- Equivalent to: SELECT name, revenue FROM account WHERE statecode = 0 -->
<fetch top="100">
  <entity name="account">
    <attribute name="name" />
    <attribute name="revenue" />
    <filter>
      <condition attribute="statecode" operator="eq" value="0" />
    </filter>
    <order attribute="revenue" descending="true" />
  </entity>
</fetch>
```

### OData query via REST API
```
GET https://orgname.crm.dynamics.com/api/data/v9.2/accounts
    ?$select=name,revenue,createdon
    &$filter=statecode eq 0 and revenue gt 100000
    &$orderby=revenue desc
    &$top=100
```

### Key Dataverse standard tables
```sql
-- These are the most commonly queried tables
SELECT * FROM account;       -- Companies / Organizations
SELECT * FROM contact;       -- Individual people
SELECT * FROM lead;          -- Potential customers
SELECT * FROM opportunity;   -- Sales deals
SELECT * FROM incident;      -- Customer service cases
SELECT * FROM systemuser;    -- Platform users
SELECT * FROM team;          -- User teams
SELECT * FROM businessunit;  -- Organizational units
```

### Filtering active records (always do this)
```sql
-- statecode = 0 means Active in ALL Dataverse tables
SELECT name, revenue FROM account WHERE statecode = 0;
SELECT fullname, emailaddress1 FROM contact WHERE statecode = 0;

-- statuscode gives more granular status (varies per table)
-- For opportunities: 1=Open, 2=Won, 3=Lost
SELECT name FROM opportunity WHERE statuscode = 1;   -- Open opportunities only
```

---

## ⚠️ Common Mistakes
- Forgetting to filter `statecode = 0` — inactive records are kept in Dataverse, not deleted
- Expecting direct database access — Dataverse only exposes data through APIs and the TDS endpoint
- Confusing `ownerid` type — it's a polymorphic lookup to either `systemuser` or `team`
- Not handling GUIDs — all PKs are GUIDs like `{3A5B8C2D-...}`, not integers

---

## 🔗 Related Topics
- [T-SQL Specifics](01-t-sql-specifics.md)
- [SQL for Power BI](02-sql-for-power-bi.md)
- [JOIN Types](../03-joins/01-join-types.md)
- [Foreign Keys](../04-database-design/02-foreign-keys.md)
