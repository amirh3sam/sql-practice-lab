/* ============================================================================
   SQL PRACTICE LAB  |  Employees (a company with 300,024 people)
   40 questions from easy to hard, each one with a tested answer.
   https://github.com/amirh3sam/sql-practice-lab

   HOW TO USE THIS FILE IN DBEAVER
     1. File > Open File...  and choose this file.
     2. Click the "N/A" box in the top toolbar (or press Ctrl+9) and pick
        your Employees connection.
     3. Click anywhere inside a query and press Ctrl+Enter. Only that query
        runs, and the result appears at the bottom.

   WANT TO TEST YOURSELF FIRST?
     Open practice/quiz/employees-quiz.sql
     It has the same questions without the answers.

   GOOD TO KNOW
     - This database is big: 300,024 employees and 2,844,047 salary rows.
       Add LIMIT while you explore.
     - A to_date of '9999-01-01' means "still valid today". Use it to get the
       CURRENT salary, title or department.
     - Dates are stored as text, for example '1999-03-15'.
     - The data is made up and ends in 2002. It has a few odd spots on
       purpose, which makes it good for practice.

   DATA
     Employees sample database, SQLite port v1.0.6 by Peter Reutemann (fracpete)
     Original data by Fusheng Wang and Carlo Zaniolo (Siemens Corporate
     Research), relational schema by Giuseppe Maxia, relational export by
     Patrick Crews. Licensed CC BY-SA 3.0.
     https://github.com/fracpete/employees-db-sqlite
     https://github.com/datacharmer/test_db

   QUESTIONS AND ANSWERS
     Copyright (c) 2026 AmirHesam Tech. All rights reserved. See LICENSE.md.
   ============================================================================ */


-- ============================================================================
-- LEVEL 1 of 4  |  Warm-up on big tables                              Q1 - Q10
-- You practice: LIMIT, COUNT, WHERE, DISTINCT, ORDER BY on tables with hundreds
--               of thousands of rows
-- ============================================================================

-- Q1. Look at the first 10 employees.
SELECT *
FROM employees
LIMIT 10;
-- Result: 10 rows. First row: 10001 | 1953-09-02 | Georgi | Facello | M | 1986-06-26

-- Q2. How many employees are in the table?
SELECT COUNT(*) AS employees
FROM employees;
-- Result: 300024

-- Q3. List all departments, A to Z by name.
SELECT dept_no, dept_name
FROM departments
ORDER BY dept_name;
-- Result: 9 rows. First row: d009 | Customer Service

-- Q4. Which job titles exist in the company?
SELECT DISTINCT title
FROM titles
ORDER BY title;
-- Result: 7 rows. First row: Assistant Engineer

-- Q5. How many employees were hired in 1999?
SELECT COUNT(*) AS hired_in_1999
FROM employees
WHERE hire_date BETWEEN '1999-01-01' AND '1999-12-31';
-- Result: 1514

-- Q6. Find women whose first name is Georgi. Show the first 10 by employee
--     number.
SELECT emp_no, first_name, last_name, gender, hire_date
FROM employees
WHERE first_name = 'Georgi'
  AND gender = 'F'
ORDER BY emp_no
LIMIT 10;
-- Result: 10 rows. First row: 15220 | Georgi | Panienski | F | 1995-07-23

-- Q7. List the 5 youngest employees. When two people share a birth date, show
--     the lower employee number first.
SELECT emp_no, first_name, last_name, birth_date
FROM employees
ORDER BY birth_date DESC, emp_no
LIMIT 5;
-- Result: 5 rows. First row: 11157 | Mario | Cochrane | 1965-02-01
-- Note: 49 people share the latest birth date. Without the second sort column,
--       which 5 of them you get would be up to chance.

-- Q8. What are the highest and the lowest salary ever paid?
SELECT MAX(salary) AS highest,
       MIN(salary) AS lowest
FROM salaries;
-- Result: 1 row: 158220 | 38623

-- Q9. How many different last names start with "Mc"?
SELECT COUNT(DISTINCT last_name) AS mc_names
FROM employees
WHERE last_name LIKE 'Mc%';
-- Result: 8

-- Q10. Show the full salary history of employee 10001, oldest first.
SELECT salary, from_date, to_date
FROM salaries
WHERE emp_no = 10001
ORDER BY from_date;
-- Result: 17 rows. First row: 60117 | 1986-06-26 | 1987-06-26
-- Note: A to_date of '9999-01-01' is this database's way of saying "still valid
--       today".



-- ============================================================================
-- LEVEL 2 of 4  |  Counting and grouping at scale                    Q11 - Q20
-- You practice: GROUP BY, HAVING, date parts, bands, a subquery in FROM
-- ============================================================================

-- Q11. How many men and how many women are in the employees table?
SELECT gender,
       COUNT(*) AS employees
FROM employees
GROUP BY gender;
-- Result: 2 rows. First row: F | 120051

-- Q12. How many people were hired in each year?
SELECT strftime('%Y', hire_date) AS year,
       COUNT(*)                  AS hires
FROM employees
GROUP BY year
ORDER BY year;
-- Result: 16 rows. First row: 1985 | 35316

-- Q13. What are the 10 most common last names?
SELECT last_name,
       COUNT(*) AS people
FROM employees
GROUP BY last_name
ORDER BY people DESC, last_name
LIMIT 10;
-- Result: 10 rows. First row: Baba | 226

-- Q14. How many rows does the titles table hold for each job title?
SELECT title,
       COUNT(*) AS records
FROM titles
GROUP BY title
ORDER BY records DESC;
-- Result: 7 rows. First row: Engineer | 115003

-- Q15. Which first names are shared by more than 270 employees?
SELECT first_name,
       COUNT(*) AS people
FROM employees
GROUP BY first_name
HAVING COUNT(*) > 270
ORDER BY people DESC, first_name;
-- Result: 9 rows. First row: Shahab | 295

-- Q16. Which calendar month has had the most hires, all years together?
SELECT strftime('%m', hire_date) AS month,
       COUNT(*)                  AS hires
FROM employees
GROUP BY month
ORDER BY hires DESC;
-- Result: 12 rows. First row: 03 | 26917

-- Q17. Put today's salaries into bands that are 20,000 wide (40,000-59,999,
--      60,000-79,999, ...) and count the people in each band.
SELECT (salary / 20000) * 20000 AS band_from,
       COUNT(*)                 AS employees
FROM salaries
WHERE to_date = '9999-01-01'
GROUP BY band_from
ORDER BY band_from;
-- Result: 7 rows. First row: 20000 | 85
-- Note: salary / 20000 is whole-number division (65000 / 20000 = 3).
--       Multiplying back gives the start of the band.

-- Q18. On average, how many salary records does one employee have? Also show
--      the fewest and the most.
SELECT ROUND(AVG(records), 2) AS avg_records,
       MIN(records)           AS fewest,
       MAX(records)           AS most
FROM (
    SELECT emp_no,
           COUNT(*) AS records
    FROM salaries
    GROUP BY emp_no
);
-- Result: 1 row: 9.48 | 1 | 18
-- Note: A query inside FROM works like a temporary table.

-- Q19. How many employees were born in each year?
SELECT strftime('%Y', birth_date) AS birth_year,
       COUNT(*)                   AS employees
FROM employees
GROUP BY birth_year
ORDER BY birth_year;
-- Result: 14 rows. First row: 1952 | 21209

-- Q20. In one row, compare the average of ALL salary records with the average
--      of today's salaries only.
SELECT ROUND(AVG(salary), 2)                                           AS avg_all_records,
       ROUND(AVG(CASE WHEN to_date = '9999-01-01' THEN salary END), 2) AS avg_current
FROM salaries;
-- Result: 1 row: 63810.74 | 72012.24
-- Note: A CASE without ELSE returns NULL, and AVG simply skips NULLs.



-- ============================================================================
-- LEVEL 3 of 4  |  JOINs and "current" rows                          Q21 - Q30
-- You practice: joining 2-5 tables, the '9999-01-01' rule, history tables, NOT
--               EXISTS
-- ============================================================================

-- Q21. Which department does employee 10001 work in today?
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN dept_emp de   ON de.emp_no = e.emp_no
JOIN departments d ON d.dept_no = de.dept_no
WHERE e.emp_no = 10001
  AND de.to_date = '9999-01-01';
-- Result: 1 row: Georgi | Facello | Development

-- Q22. How many people work in each department today?
SELECT d.dept_name,
       COUNT(*) AS employees
FROM dept_emp de
JOIN departments d ON d.dept_no = de.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name
ORDER BY employees DESC;
-- Result: 9 rows. First row: Development | 61386

-- Q23. Who manages each department today, and since when?
SELECT d.dept_name,
       e.first_name || ' ' || e.last_name AS manager,
       dm.from_date                       AS manager_since
FROM dept_manager dm
JOIN departments d ON d.dept_no = dm.dept_no
JOIN employees e   ON e.emp_no  = dm.emp_no
WHERE dm.to_date = '9999-01-01'
ORDER BY d.dept_name;
-- Result: 9 rows. First row: Customer Service | Yuchang Weedman | 1996-01-03

-- Q24. Show the current title and current salary of employees 10001 to 10010.
SELECT e.emp_no,
       e.first_name || ' ' || e.last_name AS employee,
       t.title,
       s.salary
FROM employees e
JOIN titles t   ON t.emp_no = e.emp_no AND t.to_date = '9999-01-01'
JOIN salaries s ON s.emp_no = e.emp_no AND s.to_date = '9999-01-01'
WHERE e.emp_no BETWEEN 10001 AND 10010
ORDER BY e.emp_no;
-- Result: 9 rows. First row: 10001 | Georgi Facello | Senior Engineer | 88958
-- Note: Only 9 rows come back. Employee 10008 has left the company, so there is
--       no current row to join.

-- Q25. What is the average current salary in each department?
SELECT d.dept_name             AS department,
       COUNT(*)                AS employees,
       ROUND(AVG(s.salary), 2) AS avg_salary
FROM departments d
JOIN dept_emp de ON de.dept_no = d.dept_no
JOIN salaries s  ON s.emp_no  = de.emp_no
WHERE de.to_date = '9999-01-01'
  AND s.to_date  = '9999-01-01'
GROUP BY d.dept_name
ORDER BY avg_salary DESC;
-- Result: 9 rows. First row: Sales | 37701 | 88852.97

-- Q26. What is the average current salary for each job title?
SELECT t.title,
       COUNT(*)                AS employees,
       ROUND(AVG(s.salary), 2) AS avg_salary
FROM titles t
JOIN salaries s ON s.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01'
  AND s.to_date = '9999-01-01'
GROUP BY t.title
ORDER BY avg_salary DESC;
-- Result: 7 rows. First row: Senior Staff | 82024 | 80706.5

-- Q27. List every manager each department has ever had, with the dates.
SELECT d.dept_name,
       e.first_name || ' ' || e.last_name AS manager,
       dm.from_date,
       dm.to_date
FROM dept_manager dm
JOIN departments d ON d.dept_no = dm.dept_no
JOIN employees e   ON e.emp_no  = dm.emp_no
ORDER BY d.dept_name, dm.from_date;
-- Result: 24 rows. First row: Customer Service | Tonny Butterworth | 1985-01-01 | 1988-10-17

-- Q28. How many employees have worked in more than one department?
SELECT COUNT(*) AS employees
FROM (
    SELECT emp_no
    FROM dept_emp
    GROUP BY emp_no
    HAVING COUNT(*) > 1
);
-- Result: 31579

-- Q29. How many employees have left the company?
SELECT COUNT(*) AS left_company
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM dept_emp de
    WHERE de.emp_no = e.emp_no
      AND de.to_date = '9999-01-01'
);
-- Result: 59900

-- Q30. Who are the 10 highest-paid people today? Show their name, department,
--      title and salary.
SELECT e.first_name || ' ' || e.last_name AS employee,
       d.dept_name,
       t.title,
       s.salary
FROM salaries s
JOIN employees e   ON e.emp_no  = s.emp_no
JOIN dept_emp de   ON de.emp_no = s.emp_no AND de.to_date = '9999-01-01'
JOIN departments d ON d.dept_no = de.dept_no
JOIN titles t      ON t.emp_no  = s.emp_no AND t.to_date  = '9999-01-01'
WHERE s.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 10;
-- Result: 10 rows. First row: Tokuyasu Pesch | Sales | Senior Staff | 158220



-- ============================================================================
-- LEVEL 4 of 4  |  Advanced analysis                                 Q31 - Q40
-- You practice: window functions, CTEs, pivoting with CASE, date math,
--               recursive CTE, median
-- ============================================================================

-- Q31. Find the 3 highest-paid people in every department today.
WITH ranked AS (
    SELECT d.dept_name,
           e.first_name || ' ' || e.last_name AS employee,
           s.salary,
           ROW_NUMBER() OVER (
               PARTITION BY d.dept_no
               ORDER BY s.salary DESC, e.emp_no
           )                                  AS rn
    FROM dept_emp de
    JOIN departments d ON d.dept_no = de.dept_no
    JOIN salaries s    ON s.emp_no  = de.emp_no AND s.to_date = '9999-01-01'
    JOIN employees e   ON e.emp_no  = de.emp_no
    WHERE de.to_date = '9999-01-01'
)
SELECT dept_name, employee, salary
FROM ranked
WHERE rn <= 3
ORDER BY dept_name, salary DESC;
-- Result: 27 rows. First row: Customer Service | Vidya Hanabata | 144866

-- Q32. Show every pay change of employee 10001: the salary, the salary before
--      it, and the difference.
SELECT from_date,
       salary,
       LAG(salary) OVER (ORDER BY from_date)          AS previous_salary,
       salary - LAG(salary) OVER (ORDER BY from_date) AS increase
FROM salaries
WHERE emp_no = 10001
ORDER BY from_date;
-- Result: 17 rows. First row: 1986-06-26 | 60117 | NULL | NULL

-- Q33. Rank the departments by average current salary.
SELECT d.dept_name,
       ROUND(AVG(s.salary), 2)                   AS avg_salary,
       RANK() OVER (ORDER BY AVG(s.salary) DESC) AS salary_rank
FROM dept_emp de
JOIN departments d ON d.dept_no = de.dept_no
JOIN salaries s    ON s.emp_no  = de.emp_no
WHERE de.to_date = '9999-01-01'
  AND s.to_date  = '9999-01-01'
GROUP BY d.dept_name
ORDER BY salary_rank;
-- Result: 9 rows. First row: Sales | 88852.97 | 1

-- Q34. For each department, show the average current salary of women and of men
--      side by side.
SELECT d.dept_name,
       ROUND(AVG(CASE WHEN e.gender = 'F' THEN s.salary END), 2) AS avg_women,
       ROUND(AVG(CASE WHEN e.gender = 'M' THEN s.salary END), 2) AS avg_men
FROM dept_emp de
JOIN departments d ON d.dept_no = de.dept_no
JOIN employees e   ON e.emp_no  = de.emp_no
JOIN salaries s    ON s.emp_no  = de.emp_no
WHERE de.to_date = '9999-01-01'
  AND s.to_date  = '9999-01-01'
GROUP BY d.dept_name
ORDER BY d.dept_name;
-- Result: 9 rows. First row: Customer Service | 67409.49 | 67202.79
-- Note: Turning rows into columns like this is called a pivot.

-- Q35. In each department, how many people earn more than that department's
--      average, and what percentage is that?
WITH current_pay AS (
    SELECT de.dept_no,
           s.salary,
           AVG(s.salary) OVER (PARTITION BY de.dept_no) AS dept_avg
    FROM dept_emp de
    JOIN salaries s ON s.emp_no = de.emp_no
    WHERE de.to_date = '9999-01-01'
      AND s.to_date  = '9999-01-01'
)
SELECT d.dept_name,
       COUNT(*)                                                    AS employees,
       SUM(CASE WHEN cp.salary > cp.dept_avg THEN 1 ELSE 0 END)    AS above_average,
       ROUND(100.0 * SUM(CASE WHEN cp.salary > cp.dept_avg THEN 1 ELSE 0 END)
             / COUNT(*), 1)                                        AS percent_above
FROM current_pay cp
JOIN departments d ON d.dept_no = cp.dept_no
GROUP BY d.dept_name
ORDER BY d.dept_name;
-- Result: 9 rows. First row: Customer Service | 17569 | 7818 | 44.5

-- Q36. Whose pay has grown the most? Compare each current employee's FIRST
--      salary with their CURRENT salary and show the top 10 by growth in
--      percent.
WITH pay AS (
    SELECT emp_no,
           salary,
           to_date,
           FIRST_VALUE(salary) OVER (
               PARTITION BY emp_no
               ORDER BY from_date
           ) AS first_salary
    FROM salaries
)
SELECT e.first_name || ' ' || e.last_name                              AS employee,
       p.first_salary,
       p.salary                                                        AS current_salary,
       ROUND(100.0 * (p.salary - p.first_salary) / p.first_salary, 1)  AS growth_percent
FROM pay p
JOIN employees e ON e.emp_no = p.emp_no
WHERE p.to_date = '9999-01-01'
ORDER BY growth_percent DESC, e.emp_no
LIMIT 10;
-- Result: 10 rows. First row: Magy Aamodt | 40000 | 91762 | 129.4
-- Note: This one reads all 2.8 million salary rows, so give it a few seconds.

-- Q37. For the people who left the company: how many are there, and how many
--      years did they stay on average?
WITH last_day AS (
    SELECT emp_no,
           MAX(to_date) AS left_on
    FROM dept_emp
    GROUP BY emp_no
    HAVING MAX(to_date) <> '9999-01-01'
)
SELECT COUNT(*)                                                                AS people_who_left,
       ROUND(AVG((julianday(l.left_on) - julianday(e.hire_date)) / 365.25), 2) AS avg_years_stayed
FROM last_day l
JOIN employees e ON e.emp_no = l.emp_no;
-- Result: 1 row: 59900 | 7.35

-- Q38. How many Engineers were promoted to Senior Engineer, and how many years
--      did the promotion take on average?
SELECT COUNT(*)                                                                    AS promotions,
       ROUND(AVG((julianday(sr.from_date) - julianday(en.from_date)) / 365.25), 2) AS avg_years
FROM titles en
JOIN titles sr ON sr.emp_no    = en.emp_no
              AND sr.title     = 'Senior Engineer'
              AND sr.from_date = en.to_date
WHERE en.title = 'Engineer';
-- Result: 1 row: 67700 | 6.73

-- Q39. How many people were employed at the end of each year from 1985 to 2002?
WITH RECURSIVE years(y) AS (
    SELECT 1985
    UNION ALL
    SELECT y + 1
    FROM years
    WHERE y < 2002
)
SELECT y                         AS year,
       COUNT(DISTINCT de.emp_no) AS headcount
FROM years
JOIN dept_emp de ON de.from_date <= y || '-12-31'
                AND de.to_date   >  y || '-12-31'
GROUP BY y
ORDER BY y;
-- Result: 18 rows. First row: 1985 | 18204
-- Note: These numbers do not line up with the hires per year from Q12. In this
--       made-up data, about half of the people have a first department row that
--       starts after their hire date. Real data is often messy like this.

-- Q40. Interview classic: what is the median current salary?
WITH ordered AS (
    SELECT salary,
           ROW_NUMBER() OVER (ORDER BY salary) AS rn,
           COUNT(*) OVER ()                    AS total
    FROM salaries
    WHERE to_date = '9999-01-01'
)
SELECT AVG(salary) AS median_salary
FROM ordered
WHERE rn IN ((total + 1) / 2, (total + 2) / 2);
-- Result: 69805.0
-- Note: With an odd number of rows both expressions point to the same middle
--       row. With an even number they point to the two middle rows.
