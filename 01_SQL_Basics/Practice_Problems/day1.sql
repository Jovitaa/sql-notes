-- =========================================
-- DAY 1 SQL PRACTICE (BASICS)
-- Concepts: SELECT, WHERE, ORDER BY, Operators
-- =========================================

-- Q1: Select all columns from Employees table
-- Concept: SELECT
SELECT * 
FROM Employees;

--------------------------------------------------

-- Q2: Select only Name and Salary from Employees
-- Concept: SELECT specific columns
SELECT Name, Salary
FROM Employees;

--------------------------------------------------

-- Q3: Get employees with salary greater than 50000
-- Concept: WHERE
SELECT * 
FROM Employees
WHERE Salary > 50000;

--------------------------------------------------

-- Q4: Get employees from 'IT' department
-- Concept: WHERE (text filter)
SELECT * 
FROM Employees
WHERE Department = 'IT';

--------------------------------------------------

-- Q5: Get employees with salary greater than 50000 AND from IT department
-- Concept: AND operator
SELECT * 
FROM Employees
WHERE Salary > 50000 
AND Department = 'IT';

--------------------------------------------------

-- Q6: Get employees from 'HR' OR 'Finance' department
-- Concept: OR operator
SELECT * 
FROM Employees
WHERE Department = 'HR' 
OR Department = 'Finance';

--------------------------------------------------

-- Q7: Get employees whose salary is between 30000 and 60000
-- Concept: BETWEEN
SELECT * 
FROM Employees
WHERE Salary BETWEEN 30000 AND 60000;

--------------------------------------------------

-- Q8: Get employees from departments 'IT', 'HR', 'Sales'
-- Concept: IN operator
SELECT * 
FROM Employees
WHERE Department IN ('IT', 'HR', 'Sales');

--------------------------------------------------

-- Q9: Get employees whose name starts with 'A'
-- Concept: LIKE
SELECT * 
FROM Employees
WHERE Name LIKE 'A%';

--------------------------------------------------

-- Q10: Get employees whose name ends with 'n'
-- Concept: LIKE
SELECT * 
FROM Employees
WHERE Name LIKE '%n';

--------------------------------------------------

-- Q11: Get employees sorted by salary in descending order
-- Concept: ORDER BY
SELECT * 
FROM Employees
ORDER BY Salary DESC;

--------------------------------------------------

-- Q12: Get employees sorted by Department (ASC) and Salary (DESC)
-- Concept: ORDER BY multiple columns
SELECT * 
FROM Employees
ORDER BY Department ASC, Salary DESC;

--------------------------------------------------

-- Q13: Get employees NOT from 'IT' department
-- Concept: NOT operator
SELECT * 
FROM Employees
WHERE NOT Department = 'IT';

--------------------------------------------------

-- Q14: Get employees with salary less than 40000 OR greater than 80000
-- Concept: OR + conditions
SELECT * 
FROM Employees
WHERE Salary < 40000 
OR Salary > 80000;

--------------------------------------------------

-- Q15: Get employees whose name contains 'ar'
-- Concept: LIKE pattern
SELECT * 
FROM Employees
WHERE Name LIKE '%ar%';
