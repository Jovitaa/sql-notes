# Week 2 / Day 1 SQL Practice

## SQLZoo – JOIN Exercises

---

### Q1. Modify it to show the matchid and player name for all goals scored by Germany.

```sql
SELECT matchid, player
FROM goal
WHERE teamid = 'GER';
```

---

### Q2. Show id, stadium, team1, team2 for just game 1012

```sql
SELECT id, stadium, team1, team2
FROM game
WHERE id = 1012;
```

---

### Q3. Show the player, teamid, stadium and mdate for every German goal.

```sql
SELECT player, teamid, stadium, mdate
FROM game
JOIN goal ON game.id = goal.matchid
WHERE teamid = 'GER';
```

---

### Q4. Show the team1, team2 and player for every goal scored by a player called Mario.

```sql
SELECT team1, team2, player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE player LIKE 'Mario%';
```

---

### Q5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes.

```sql
SELECT player, teamid, coach, gtime
FROM goal
JOIN eteam ON teamid = id
WHERE gtime <= 10;
```

---

### Q6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

```sql
SELECT mdate, teamname
FROM game
JOIN eteam ON game.team1 = eteam.id
WHERE coach = 'Fernando Santos';
```

---

### Q7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'.

```sql
SELECT player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE stadium = 'National Stadium, Warsaw';
```

---

### Q8. Show the name of all players who scored a goal against Germany.

```sql
SELECT DISTINCT player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE (team1 = 'GER' OR team2 = 'GER')
  AND teamid <> 'GER';
```

---

### Q9. Show teamname and the total number of goals scored.

```sql
SELECT teamname, COUNT(*) AS total_goals
FROM eteam
JOIN goal ON eteam.id = goal.teamid
GROUP BY teamname;
```

---

### Q10. Show the stadium and the number of goals scored in each stadium.

```sql
SELECT stadium, COUNT(gtime) AS goals
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY stadium;
```

---

### Q11. For every match involving 'POL', show the matchid, date and the number of goals scored.

```sql
SELECT matchid, mdate, COUNT(gtime) AS goals
FROM game
JOIN goal ON game.id = goal.matchid
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY matchid, mdate;
```

---

### Q12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'.

```sql
SELECT matchid, mdate, COUNT(gtime) AS goals
FROM game
JOIN goal ON game.id = goal.matchid
WHERE teamid = 'GER'
GROUP BY matchid, mdate;
```

---

### Q13. List every match with the goals scored by each team for all ENG games.

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

# Quiz Notes

## Table Structures

### game

| id   | mdate       | stadium                   | team1 | team2 |
| ---- | ----------- | ------------------------- | ----- | ----- |
| 1001 | 8 June 2012 | National Stadium, Warsaw  | POL   | GRE   |
| 1002 | 8 June 2012 | Stadion Miejski (Wroclaw) | RUS   | CZE   |

### goal

| matchid | teamid | player               | gtime |
| ------- | ------ | -------------------- | ----- |
| 1001    | POL    | Robert Lewandowski   | 17    |
| 1001    | GRE    | Dimitris Salpingidis | 51    |

### eteam

| id  | teamname | coach            |
| --- | -------- | ---------------- |
| POL | Poland   | Franciszek Smuda |
| GRE | Greece   | Fernando Santos  |

---

## Quiz Answers

### 1. JOIN condition for stadium where Dimitris Salpingidis scored

```sql
game JOIN goal ON (id = matchid)
```

---

### 2. Columns available after JOIN between goal and eteam

```text
matchid, teamid, player, gtime, id, teamname, coach
```

---

### 3. Players, team and number of goals scored against Greece

```sql
SELECT player, teamid, COUNT(*)
FROM game
JOIN goal ON matchid = id
WHERE (team1 = 'GRE' OR team2 = 'GRE')
  AND teamid != 'GRE'
GROUP BY player, teamid;
```

---

### 4. Query Result

```sql
SELECT DISTINCT teamid, mdate
FROM goal
JOIN game ON matchid = id
WHERE mdate = '9 June 2012';
```

Result:

```text
DEN   9 June 2012
GER   9 June 2012
```

---

### 5. Player and team who scored against Poland in National Stadium, Warsaw

```sql
SELECT DISTINCT player, teamid
FROM game
JOIN goal ON matchid = id
WHERE stadium = 'National Stadium, Warsaw'
  AND (team1 = 'POL' OR team2 = 'POL')
  AND teamid != 'POL';
```

---

### 6. Player, team and time in Stadion Miejski (Wroclaw) but not against Italy

```sql
SELECT DISTINCT player, teamid, gtime
FROM game
JOIN goal ON matchid = id
WHERE stadium = 'Stadion Miejski (Wroclaw)'
  AND ((teamid = team2 AND team1 != 'ITA')
    OR (teamid = team1 AND team2 != 'ITA'));
```

---

### 7. Query Result

```sql
SELECT teamname, COUNT(*)
FROM eteam
JOIN goal ON teamid = id
GROUP BY teamname
HAVING COUNT(*) < 3;
```

Result:

```text
Netherlands           2
Poland                2
Republic of Ireland   1
Ukraine               2
```
