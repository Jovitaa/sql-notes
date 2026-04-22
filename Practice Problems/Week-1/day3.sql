-- =========================================
-- DAY 3 (SELECT, WHERE, OPERATORS)
-- Concepts: Filtering, Logical Operators, Pattern Matching, IN, BETWEEN, ORDER BY, Escaping Characters
-- Source: SQLZoo
-- =========================================

-- =========================================
-- PRACTICE PROBLEMS
-- =========================================

-- Q1: Change the query shown so that it displays Nobel prizes for 1950.
-- Concept: SELECT, WHERE
-- Difficulty: Easy
-- Tip: Use WHERE to filter rows for a specific year.
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950;

-- Q2: Show who won the 1962 prize for literature.
-- Concept: WHERE with multiple conditions
-- Difficulty: Easy
-- Tip: Combine year and subject using AND.
SELECT winner
FROM nobel
WHERE yr = 1962
  AND subject = 'literature';

-- Q3: Show the year and subject that won 'Albert Einstein' his prize.
-- Concept: Filtering text values
-- Difficulty: Easy
-- Tip: Match the exact winner name in the WHERE clause.
SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein';

-- Q4: Give the name of the 'Peace' winners since the year 2000, including 2000.
-- Concept: WHERE, AND, comparison operators
-- Difficulty: Easy
-- Tip: "Including 2000" means use >= 2000.
SELECT winner
FROM nobel
WHERE subject = 'Peace'
  AND yr >= 2000;

-- Q5: Show all details (yr, subject, winner) of the literature prize winners for 1980 to 1989 inclusive.
-- Concept: Range filtering
-- Difficulty: Easy
-- Tip: Inclusive range can be written using >= and <= or BETWEEN.
SELECT yr, subject, winner
FROM nobel
WHERE subject = 'literature'
  AND yr >= 1980
  AND yr <= 1989;

-- Q6: Show all details of the presidential winners:
-- Theodore Roosevelt
-- Thomas Woodrow Wilson
-- Jimmy Carter
-- Barack Obama
-- Concept: IN operator
-- Difficulty: Easy
-- Tip: Use IN when checking multiple exact values.
SELECT *
FROM nobel
WHERE winner IN (
    'Theodore Roosevelt',
    'Thomas Woodrow Wilson',
    'Jimmy Carter',
    'Barack Obama'
);

-- Q7: Show the winners with first name John.
-- Concept: LIKE
-- Difficulty: Easy
-- Tip: 'John%' finds names starting with John.
SELECT winner
FROM nobel
WHERE winner LIKE 'John%';

-- Q8: Show the year, subject, and name of physics winners for 1980 together with the chemistry winners for 1984.
-- Concept: OR with grouped conditions
-- Difficulty: Medium
-- Tip: Use brackets to combine each year-subject pair correctly.
SELECT yr, subject, winner
FROM nobel
WHERE (subject = 'physics' AND yr = 1980)
   OR (subject = 'chemistry' AND yr = 1984);

-- Q9: Show the year, subject, and name of winners for 1980 excluding chemistry and medicine.
-- Concept: NOT EQUAL, AND
-- Difficulty: Medium
-- Tip: Exclude both subjects using separate conditions with AND.
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980
  AND subject <> 'chemistry'
  AND subject <> 'medicine';

-- Q10: Show year, subject, and name of people who won a 'Medicine' prize in an early year
-- (before 1910, not including 1910) together with winners of a 'Literature' prize
-- in a later year (after 2004, including 2004).
-- Concept: OR with mixed filters
-- Difficulty: Medium
-- Tip: Split the logic into two bracketed conditions.
SELECT yr, subject, winner
FROM nobel
WHERE (subject = 'medicine' AND yr < 1910)
   OR (subject = 'literature' AND yr >= 2004);

-- Q11: Find all details of the prize won by PETER GRÜNBERG.
-- Concept: Exact text filtering with non-ASCII characters
-- Difficulty: Medium
-- Tip: Copy the name exactly, including special characters.
SELECT *
FROM nobel
WHERE winner = 'PETER GRÜNBERG';

-- Q12: Find all details of the prize won by EUGENE O'NEILL.
-- Concept: Escaping single quotes
-- Difficulty: Medium
-- Tip: Escape a single quote inside a string by doubling it.
SELECT *
FROM nobel
WHERE winner = "EUGENE O'NEILL";

-- Q13: List the winners, year and subject where the winner starts with Sir.
-- Show the most recent first, then by name order.
-- Concept: LIKE, ORDER BY
-- Difficulty: Medium
-- Tip: Sort year descending first, then winner ascending.
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner ASC;

-- Q14: The expression subject IN ('chemistry','physics') can be used as a value - it will be 0 or 1.
-- Show the 1984 winners and subject ordered by subject and winner name;
-- but list chemistry and physics last.
-- Concept: Custom sorting using boolean expression
-- Difficulty: Hard
-- Tip: In ORDER BY, FALSE/0 comes before TRUE/1.
SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN ('physics', 'chemistry'), subject, winner;

-- =========================================
-- QUIZ QUESTIONS
-- =========================================

-- Quiz 1: Pick the code which shows the winner names beginning with C and ending in n.
-- Concept: LIKE pattern matching
-- Difficulty: Medium
-- Tip: Use one pattern to match both start and end conditions.
SELECT winner
FROM nobel
WHERE winner LIKE 'C%n';

-- Quiz 2: Select the code that shows how many Chemistry awards were given between 1950 and 1960.
-- Concept: COUNT, WHERE, BETWEEN
-- Difficulty: Easy
-- Tip: Match the subject text exactly as stored in the table.
SELECT COUNT(subject)
FROM nobel
WHERE subject = 'Chemistry'
  AND yr BETWEEN 1950 AND 1960;

-- Quiz 3: Pick the code that shows the number of years where no Medicine awards were given.
-- Concept: COUNT DISTINCT, subquery
-- Difficulty: Hard
-- Tip: First find years with Medicine awards, then exclude them.
SELECT COUNT(DISTINCT yr)
FROM nobel
WHERE yr NOT IN (
    SELECT DISTINCT yr
    FROM nobel
    WHERE subject = 'Medicine'
);

-- Quiz 4: Select the result that would be obtained from the following code:
-- SELECT subject, winner
-- FROM nobel
-- WHERE winner LIKE 'Sir%'
--   AND yr LIKE '196%';
-- Concept: LIKE with year values
-- Difficulty: Medium
-- Tip: This filters winners starting with Sir in the 1960s.
-- Expected Result:
-- Medicine | Sir John Eccles
-- Medicine | Sir Frank Macfarlane Burnet

-- Quiz 5: Select the code which would show the year when neither a Physics or Chemistry award was given.
-- Concept: NOT IN, subquery
-- Difficulty: Hard
-- Tip: Exclude years that appear for either Physics or Chemistry.
SELECT yr
FROM nobel
WHERE yr NOT IN (
    SELECT yr
    FROM nobel
    WHERE subject IN ('Chemistry', 'Physics')
);

-- Quiz 6: Select the code which shows the years when a Medicine award was given
-- but no Peace or Literature award was.
-- Concept: DISTINCT, NOT IN, subqueries
-- Difficulty: Hard
-- Tip: Start with Medicine years, then remove years containing Literature and Peace.
SELECT DISTINCT yr
FROM nobel
WHERE subject = 'Medicine'
  AND yr NOT IN (
      SELECT yr
      FROM nobel
      WHERE subject = 'Literature'
  )
  AND yr NOT IN (
      SELECT yr
      FROM nobel
      WHERE subject = 'Peace'
  );

-- Quiz 7: Pick the result that would be obtained from the following code:
-- SELECT subject, COUNT(subject)
-- FROM nobel
-- WHERE yr = '1960'
-- GROUP BY subject;
-- Concept: GROUP BY, COUNT
-- Difficulty: Medium
-- Tip: This counts awards by subject for the year 1960.
-- Expected Result:
-- Chemistry  | 1
-- Literature | 1
-- Medicine   | 1
-- Peace      | 1
-- Physics    | 1
