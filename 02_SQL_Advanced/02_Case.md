# SQL CASE Statement

## What is CASE?

CASE works like an IF-ELSE statement in SQL.

It returns different values based on conditions.

---

## CASE Syntax

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE result3
END
````

---

## Basic Example

```sql
SELECT name,
       CASE
           WHEN salary > 100000 THEN 'High'
           WHEN salary > 50000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_category
FROM employees;
```

---

## CASE in SELECT

Used to create conditional columns.

### Example

```sql
SELECT player,
       CASE
           WHEN teamid = 'GER' THEN 'Germany Goal'
           ELSE 'Other Team Goal'
       END AS goal_type
FROM goal;
```

---

## CASE with Aggregation

Used with SUM or COUNT.

### Example

```sql
SELECT team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY team1;
```

---

## Why CASE is Powerful

CASE allows:

* Conditional labels
* Dynamic categories
* Conditional aggregation
* Score calculation
* Custom grouping

---

## CASE Mental Model

```text
IF condition TRUE → return value
ELSE → return another value
```

---

## CASE Example with SQLZoo

```sql
SELECT mdate,
       team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
FROM game
LEFT JOIN goal ON game.id = goal.matchid
WHERE team1 = 'ENG' OR team2 = 'ENG'
GROUP BY mdate, team1, team2;
```

---

## CASE Flow

```text
Condition Check
→ First TRUE condition wins
→ Returns value
→ Stops checking remaining conditions
```

---

## Common CASE Mistakes

### Wrong

```sql
CASE teamid = 'GER' THEN 'Germany'
```

### Correct

```sql
CASE
    WHEN teamid = 'GER' THEN 'Germany'
END
```

---

## CASE Summary

| Component | Purpose               |
| --------- | --------------------- |
| CASE      | Starts logic block    |
| WHEN      | Defines condition     |
| THEN      | Returns value if true |
| ELSE      | Default value         |
| END       | Closes CASE statement |
