# Week 2 / Day 2 SQL Practice

Format used:

```sql
-- Concept: SQL concept used
-- Difficulty: Easy / Medium / Hard
-- Question:
-- Problem statement
```

## SQLZoo – Movie Database JOIN Exercises

---

### Q1. List the films where the year is 1962 and the budget is over 2000000.

```sql
-- Concept: SELECT + WHERE + AND Condition
-- Difficulty: Easy
-- Question:
-- List the films where the year is 1962 and the budget is over 2000000.
```

```sql
SELECT id, title
FROM movie
WHERE yr = 1962
  AND budget > 2000000;
```

---

### Q2. Give the year of 'Citizen Kane'.

```sql
-- Concept: SELECT + WHERE
-- Difficulty: Easy
-- Question:
-- Give the year of 'Citizen Kane'.
```

```sql
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';
```

---

### Q3. List all Star Trek movies.

```sql
-- Concept: LIKE Operator + ORDER BY
-- Difficulty: Easy
-- Question:
-- List all Star Trek movies.
```

```sql
SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr;
```

---

### Q4. What id number does the actor 'Glenn Close' have?

```sql
-- Concept: SELECT + WHERE
-- Difficulty: Easy
-- Question:
-- Find the ID of actor 'Glenn Close'.
```

```sql
SELECT id
FROM actor
WHERE name = 'Glenn Close';
```

---

### Q5. What is the id of the 1942 film 'Casablanca'?

```sql
-- Concept: WHERE with Multiple Conditions
-- Difficulty: Easy
-- Question:
-- Find the movie ID for Casablanca released in 1942.
```

```sql
SELECT id
FROM movie
WHERE yr = 1942
  AND title = 'Casablanca';
```

---

### Q6. Obtain the cast list for 1942's 'Casablanca'.

```sql
-- Concept: JOIN Multiple Tables
-- Difficulty: Medium
-- Question:
-- Obtain the cast list for Casablanca (1942).
```

```sql
SELECT actor.name
FROM actor
JOIN casting ON actor.id = casting.actorid
JOIN movie ON casting.movieid = movie.id
WHERE movie.title = 'Casablanca'
  AND movie.yr = 1942;
```

---

### Q7. Obtain the cast list for the film 'Alien'.

```sql
-- Concept: JOIN Tables + Filtering
-- Difficulty: Medium
-- Question:
-- Obtain the cast list for the film Alien.
```

```sql
SELECT actor.name
FROM actor
JOIN casting ON actor.id = casting.actorid
JOIN movie ON casting.movieid = movie.id
WHERE movie.title = 'Alien';
```

---

### Q8. List the films in which 'Harrison Ford' has appeared.

```sql
-- Concept: JOIN + WHERE
-- Difficulty: Medium
-- Question:
-- List the films in which Harrison Ford appeared.
```

```sql
SELECT movie.title
FROM movie
JOIN casting ON casting.movieid = movie.id
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford';
```

---

### Q9. List the films where 'Harrison Ford' appeared but not in the starring role.

```sql
-- Concept: JOIN + Filtering by ord
-- Difficulty: Medium
-- Question:
-- List films where Harrison Ford appeared but was not the lead actor.
```

```sql
SELECT movie.title
FROM movie
JOIN casting ON casting.movieid = movie.id
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford'
  AND ord <> 1;
```

---

### Q10. List the films together with the leading star for all 1962 films.

```sql
-- Concept: JOIN + Lead Actor Identification
-- Difficulty: Medium
-- Question:
-- Show film title and leading actor for all 1962 movies.
```

```sql
SELECT movie.title, actor.name
FROM movie
JOIN casting ON casting.movieid = movie.id
JOIN actor ON casting.actorid = actor.id
WHERE movie.yr = 1962
  AND casting.ord = 1;
```

---

### Q11. Show the busiest years for 'Rock Hudson'.

```sql
-- Concept: GROUP BY + HAVING + Aggregate Functions
-- Difficulty: Medium
-- Question:
-- Show the years where Rock Hudson acted in more than 2 films.
```

```sql
SELECT yr, COUNT(title)
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;
```

---

### Q12. List the film title and the leading actor for all films Julie Andrews played in.

```sql
-- Concept: Subquery + JOIN + IN Clause
-- Difficulty: Hard
-- Question:
-- Show movie title and leading actor for films Julie Andrews appeared in.
```

```sql
SELECT movie.title, actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE casting.ord = 1
  AND movie.id IN (
    SELECT casting.movieid
    FROM casting
    JOIN actor ON casting.actorid = actor.id
    WHERE actor.name = 'Julie Andrews'
  );
```

---

### Q13. Obtain a list of actors with at least 15 starring roles.

```sql
-- Concept: GROUP BY + HAVING + ORDER BY
-- Difficulty: Medium
-- Question:
-- List actors who have at least 15 starring roles.
```

```sql
SELECT actor.name
FROM actor
JOIN casting ON casting.actorid = actor.id
WHERE ord = 1
GROUP BY actor.name
HAVING COUNT(*) >= 15
ORDER BY actor.name;
```

---

### Q14. List films released in 1978 ordered by cast size, then title.

```sql
-- Concept: GROUP BY + COUNT + ORDER BY
-- Difficulty: Hard
-- Question:
-- List films from 1978 ordered by number of actors in the cast, then title.
```

```sql
SELECT movie.title, COUNT(actor.id)
FROM movie
JOIN casting ON casting.movieid = movie.id
JOIN actor ON actor.id = casting.actorid
WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY COUNT(actor.id) DESC, movie.title;
```

---

### Q15. List all people who worked with 'Art Garfunkel'.

```sql
-- Concept: Subquery + DISTINCT + IN Clause
-- Difficulty: Hard
-- Question:
-- List actors who worked in the same films as Art Garfunkel.
```

```sql
SELECT DISTINCT actor.name
FROM actor
JOIN casting ON casting.actorid = actor.id
WHERE casting.movieid IN (
    SELECT casting.movieid
    FROM casting
    JOIN actor ON casting.actorid = actor.id
    WHERE actor.name = 'Art Garfunkel'
)
AND actor.name <> 'Art Garfunkel';
```

---

# Quiz Notes

### 1. Directors of movies that made financial losses

```sql
SELECT name
FROM actor
JOIN movie ON actor.id = director
WHERE gross < budget;
```

---

### 2. Correct example of joining three tables

```sql
SELECT *
FROM actor
JOIN casting ON actor.id = actorid
JOIN movie ON movie.id = movieid;
```

---

### 3. Actors named John ordered by number of movies

```sql
SELECT name, COUNT(movieid)
FROM casting
JOIN actor ON actorid = actor.id
WHERE name LIKE 'John %'
GROUP BY name
ORDER BY COUNT(movieid) DESC;
```

---

### 4. Query Result

```text
"Crocodile" Dundee
Crocodile Dundee in Los Angeles
Flipper
Lightning Jack
```

---

### 5. Actors starring in Ridley Scott movies

```sql
SELECT name
FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE ord = 1
  AND director = 351;
```

---

### 6. Two sensible ways to connect movie and actor

```text
1. Link director column in movie with actor primary key
2. Connect movie and actor through casting table
```

---

### 7. Query Result

```sql
SELECT title, yr
FROM movie, casting, actor
WHERE name = 'Robert De Niro'
  AND movieid = movie.id
  AND actorid = actor.id
  AND ord = 3;
```

Result:

```text
A Bronx Tale                1993
Bang the Drum Slowly        1973
Limitless                   2011
```
