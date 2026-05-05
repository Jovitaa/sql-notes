-- =========================================
-- WEEK 3 / DAY 1 SQL PRACTICE
-- Topic: Using NULL, COALESCE, OUTER JOIN, COUNT, GROUP BY, CASE
-- Source: SQLZoo
-- =========================================


-- ==================================================
-- PRACTICE PROBLEMS
-- ==================================================


-- Concept: IS NULL
-- Difficulty: Easy
-- Question 1:
-- List the teachers who have NULL for their department.

SELECT name
FROM teacher
WHERE dept IS NULL;

-- Tip:
-- Use IS NULL to check missing values.
-- Do not use dept = NULL.


--------------------------------------------------


-- Concept: INNER JOIN
-- Difficulty: Easy
-- Question 2:
-- Note the INNER JOIN misses the teachers with no department
-- and the departments with no teacher.

SELECT teacher.name, dept.name
FROM teacher
INNER JOIN dept
ON teacher.dept = dept.id;

-- Tip:
-- INNER JOIN only returns matching rows from both tables.


--------------------------------------------------


-- Concept: LEFT JOIN
-- Difficulty: Easy
-- Question 3:
-- Use a different JOIN so that all teachers are listed.

SELECT teacher.name, dept.name
FROM teacher
LEFT JOIN dept
ON teacher.dept = dept.id;

-- Tip:
-- LEFT JOIN keeps all rows from the left table, here teacher.


--------------------------------------------------


-- Concept: RIGHT JOIN
-- Difficulty: Easy
-- Question 4:
-- Use a different JOIN so that all departments are listed.

SELECT teacher.name, dept.name
FROM teacher
RIGHT JOIN dept
ON teacher.dept = dept.id;

-- Tip:
-- RIGHT JOIN keeps all rows from the right table, here dept.


--------------------------------------------------


-- Concept: COALESCE
-- Difficulty: Easy
-- Question 5:
-- Use COALESCE to print the mobile number.
-- Use the number '07986 444 2266' if there is no number given.
-- Show teacher name and mobile number or '07986 444 2266'.

SELECT teacher.name,
       COALESCE(teacher.mobile, '07986 444 2266') AS mobile
FROM teacher;

-- Tip:
-- COALESCE returns the first non-NULL value.


--------------------------------------------------


-- Concept: COALESCE + LEFT JOIN
-- Difficulty: Easy
-- Question 6:
-- Use the COALESCE function and a LEFT JOIN to print the teacher name
-- and department name. Use the string 'None' where there is no department.

SELECT teacher.name,
       COALESCE(dept.name, 'None') AS dept
FROM teacher
LEFT JOIN dept
ON teacher.dept = dept.id;

-- Tip:
-- LEFT JOIN keeps all teachers.
-- COALESCE replaces missing department names with 'None'.


--------------------------------------------------


-- Concept: COUNT
-- Difficulty: Easy
-- Question 7:
-- Use COUNT to show the number of teachers and the number of mobile phones.

SELECT COUNT(teacher.name) AS teacher_count,
       COUNT(teacher.mobile) AS mobile_count
FROM teacher;

-- Tip:
-- COUNT(column) ignores NULL values.
-- COUNT(mobile) counts only teachers who have a mobile number.


--------------------------------------------------


-- Concept: COUNT + GROUP BY + RIGHT JOIN
-- Difficulty: Medium
-- Question 8:
-- Use COUNT and GROUP BY dept.name to show each department and the number of staff.
-- Use a RIGHT JOIN to ensure that the Engineering department is listed.

SELECT dept.name,
       COUNT(teacher.name) AS staff_count
FROM teacher
RIGHT JOIN dept
ON dept.id = teacher.dept
GROUP BY dept.name;

-- Tip:
-- GROUP BY is used when counting per category.
-- RIGHT JOIN keeps all departments, even departments with no teachers.


--------------------------------------------------


-- Concept: CASE
-- Difficulty: Easy
-- Question 9:
-- Use CASE to show the name of each teacher followed by 'Sci'
-- if the teacher is in dept 1 or 2 and 'Art' otherwise.

SELECT teacher.name,
       CASE
           WHEN teacher.dept = 1 THEN 'Sci'
           WHEN teacher.dept = 2 THEN 'Sci'
           ELSE 'Art'
       END AS subject_group
FROM teacher;

-- Tip:
-- CASE works like IF-ELSE logic in SQL.
-- Always close CASE with END.


--------------------------------------------------


-- Concept: CASE + IN
-- Difficulty: Easy
-- Question 10:
-- Use CASE to show the name of each teacher followed by 'Sci'
-- if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3
-- and 'None' otherwise.

SELECT teacher.name,
       CASE
           WHEN teacher.dept IN (1, 2) THEN 'Sci'
           WHEN teacher.dept = 3 THEN 'Art'
           ELSE 'None'
       END AS subject_group
FROM teacher;

-- Tip:
-- IN is cleaner than writing multiple OR conditions.


-- ==================================================
-- QUIZ NOTES
-- ==================================================


-- Quiz 1:
-- Select the code which uses an outer join correctly.

SELECT teacher.name, dept.name
FROM teacher
LEFT OUTER JOIN dept
ON teacher.dept = dept.id;

-- Note:
-- LEFT OUTER JOIN and LEFT JOIN mean the same thing.


--------------------------------------------------


-- Quiz 2:
-- Select the correct statement that shows the name of department
-- which employs Cutflower.

SELECT dept.name
FROM teacher
JOIN dept
ON dept.id = teacher.dept
WHERE teacher.name = 'Cutflower';

-- Note:
-- JOIN connects teacher to dept using matching department id.


--------------------------------------------------


-- Quiz 3:
-- Select the code which uses a JOIN to show a list of all departments
-- and the number of employed teachers.

SELECT dept.name,
       COUNT(teacher.name) AS staff_count
FROM teacher
RIGHT JOIN dept
ON dept.id = teacher.dept
GROUP BY dept.name;

-- Note:
-- RIGHT JOIN ensures all departments are shown.


--------------------------------------------------


-- Quiz 4:
-- Query:
-- SELECT name, dept, COALESCE(dept, 0) AS result FROM teacher;
-- Result:
-- Displays 0 in the result column for all teachers without department.

SELECT name,
       dept,
       COALESCE(dept, 0) AS result
FROM teacher;

-- Note:
-- COALESCE(dept, 0) replaces NULL dept values with 0.


--------------------------------------------------


-- Quiz 5:
-- Query result explanation:
-- The CASE statement shows 'four' for Throd when phone = 2754.

SELECT name,
       CASE
           WHEN phone = 2752 THEN 'two'
           WHEN phone = 2753 THEN 'three'
           WHEN phone = 2754 THEN 'four'
       END AS digit
FROM teacher;

-- Note:
-- If no CASE condition matches and there is no ELSE, the result is NULL.


--------------------------------------------------


-- Quiz 6:
-- Query result:
-- Teachers in dept 1 are shown as 'Computing'.
-- All other teachers are shown as 'Other'.

SELECT name,
       CASE
           WHEN dept IN (1) THEN 'Computing'
           ELSE 'Other'
       END AS department_group
FROM teacher;

-- Expected result:
-- Shrivell    Computing
-- Throd       Computing
-- Splint      Computing
-- Spiregrain  Other
-- Cutflower   Other
-- Deadyawn    Other


-- ==================================================
-- END OF WEEK 3 / DAY 1
-- ==================================================
