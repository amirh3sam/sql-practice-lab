/* ============================================================================
   SQL PRACTICE LAB  |  Employees (a company with 300,024 people)  |  QUIZ (no answers)
   40 questions from easy to hard. Write your own query under each one.
   https://github.com/hesamworkshop/sql-practice-lab

   HOW TO USE THIS FILE IN DBEAVER
     1. File > Open File...  and choose this file.
     2. Click the "N/A" box in the top toolbar (or press Ctrl+9) and pick
        your Employees connection.
     3. Type your query under a question and press Ctrl+Enter to run it.
     4. Compare what you get with the "Check:" line of the question.

   STUCK?
     The answers are in practice/employees.sql.

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
--     Hint: This table has 300,024 rows, so always add LIMIT when you are just
--           looking.
--     Check: 10 rows. First row: 10001 | 1953-09-02 | Georgi | Facello | M | 1986-06-26




-- Q2. How many employees are in the table?
--     Check: 300024




-- Q3. List all departments, A to Z by name.
--     Check: 9 rows. First row: d009 | Customer Service




-- Q4. Which job titles exist in the company?
--     Hint: DISTINCT on the titles table.
--     Check: 7 rows. First row: Assistant Engineer




-- Q5. How many employees were hired in 1999?
--     Hint: Dates are text like '1999-03-15'.
--     Check: 1514




-- Q6. Find women whose first name is Georgi. Show the first 10 by employee
--     number.
--     Check: 10 rows. First row: 15220 | Georgi | Panienski | F | 1995-07-23




-- Q7. List the 5 youngest employees. When two people share a birth date, show
--     the lower employee number first.
--     Hint: Youngest = latest birth date. You can sort by two columns.
--     Check: 5 rows. First row: 11157 | Mario | Cochrane | 1965-02-01




-- Q8. What are the highest and the lowest salary ever paid?
--     Check: 1 row: 158220 | 38623




-- Q9. How many different last names start with "Mc"?
--     Check: 8




-- Q10. Show the full salary history of employee 10001, oldest first.
--      Check: 17 rows. First row: 60117 | 1986-06-26 | 1987-06-26






-- ============================================================================
-- LEVEL 2 of 4  |  Counting and grouping at scale                    Q11 - Q20
-- You practice: GROUP BY, HAVING, date parts, bands, a subquery in FROM
-- ============================================================================

-- Q11. How many men and how many women are in the employees table?
--      Check: 2 rows. First row: F | 120051




-- Q12. How many people were hired in each year?
--      Hint: strftime('%Y', hire_date)
--      Check: 16 rows. First row: 1985 | 35316




-- Q13. What are the 10 most common last names?
--      Check: 10 rows. First row: Baba | 226




-- Q14. How many rows does the titles table hold for each job title?
--      Check: 7 rows. First row: Engineer | 115003




-- Q15. Which first names are shared by more than 270 employees?
--      Hint: HAVING
--      Check: 9 rows. First row: Shahab | 295




-- Q16. Which calendar month has had the most hires, all years together?
--      Hint: strftime('%m', hire_date) gives the month as '01' to '12'.
--      Check: 12 rows. First row: 03 | 26917




-- Q17. Put today's salaries into bands that are 20,000 wide (40,000-59,999,
--      60,000-79,999, ...) and count the people in each band.
--      Hint: Today's salaries are the rows where to_date = '9999-01-01'.
--      Check: 7 rows. First row: 20000 | 85




-- Q18. On average, how many salary records does one employee have? Also show
--      the fewest and the most.
--      Hint: First count the records per employee, then summarise that result.
--      Check: 1 row: 9.48 | 1 | 18




-- Q19. How many employees were born in each year?
--      Check: 14 rows. First row: 1952 | 21209




-- Q20. In one row, compare the average of ALL salary records with the average
--      of today's salaries only.
--      Hint: CASE inside AVG
--      Check: 1 row: 63810.74 | 72012.24






-- ============================================================================
-- LEVEL 3 of 4  |  JOINs and "current" rows                          Q21 - Q30
-- You practice: joining 2-5 tables, the '9999-01-01' rule, history tables, NOT
--               EXISTS
-- ============================================================================

-- Q21. Which department does employee 10001 work in today?
--      Hint: employees -> dept_emp -> departments
--      Check: 1 row: Georgi | Facello | Development




-- Q22. How many people work in each department today?
--      Check: 9 rows. First row: Development | 61386




-- Q23. Who manages each department today, and since when?
--      Check: 9 rows. First row: Customer Service | Yuchang Weedman | 1996-01-03




-- Q24. Show the current title and current salary of employees 10001 to 10010.
--      Hint: Join titles and salaries, and keep only the current row of each.
--      Check: 9 rows. First row: 10001 | Georgi Facello | Senior Engineer | 88958




-- Q25. What is the average current salary in each department?
--      Check: 9 rows. First row: Sales | 37701 | 88852.97




-- Q26. What is the average current salary for each job title?
--      Check: 7 rows. First row: Senior Staff | 82024 | 80706.5




-- Q27. List every manager each department has ever had, with the dates.
--      Check: 24 rows. First row: Customer Service | Tonny Butterworth | 1985-01-01 | 1988-10-17




-- Q28. How many employees have worked in more than one department?
--      Check: 31579




-- Q29. How many employees have left the company?
--      Hint: They have no dept_emp row that is still current. Try NOT EXISTS.
--      Check: 59900




-- Q30. Who are the 10 highest-paid people today? Show their name, department,
--      title and salary.
--      Hint: Five tables.
--      Check: 10 rows. First row: Tokuyasu Pesch | Sales | Senior Staff | 158220






-- ============================================================================
-- LEVEL 4 of 4  |  Advanced analysis                                 Q31 - Q40
-- You practice: window functions, CTEs, pivoting with CASE, date math,
--               recursive CTE, median
-- ============================================================================

-- Q31. Find the 3 highest-paid people in every department today.
--      Hint: ROW_NUMBER() with PARTITION BY
--      Check: 27 rows. First row: Customer Service | Vidya Hanabata | 144866




-- Q32. Show every pay change of employee 10001: the salary, the salary before
--      it, and the difference.
--      Hint: LAG()
--      Check: 17 rows. First row: 1986-06-26 | 60117 | NULL | NULL




-- Q33. Rank the departments by average current salary.
--      Hint: RANK() can sit on top of GROUP BY.
--      Check: 9 rows. First row: Sales | 88852.97 | 1




-- Q34. For each department, show the average current salary of women and of men
--      side by side.
--      Hint: One AVG(CASE ...) per column.
--      Check: 9 rows. First row: Customer Service | 67409.49 | 67202.79




-- Q35. In each department, how many people earn more than that department's
--      average, and what percentage is that?
--      Hint: AVG(...) OVER (PARTITION BY ...) puts the department average on
--            every row.
--      Check: 9 rows. First row: Customer Service | 17569 | 7818 | 44.5




-- Q36. Whose pay has grown the most? Compare each current employee's FIRST
--      salary with their CURRENT salary and show the top 10 by growth in
--      percent.
--      Hint: FIRST_VALUE() OVER (PARTITION BY emp_no ORDER BY from_date)
--      Check: 10 rows. First row: Magy Aamodt | 40000 | 91762 | 129.4




-- Q37. For the people who left the company: how many are there, and how many
--      years did they stay on average?
--      Hint: julianday(date) turns a date into a day number, so two dates can
--            be subtracted.
--      Check: 1 row: 59900 | 7.35




-- Q38. How many Engineers were promoted to Senior Engineer, and how many years
--      did the promotion take on average?
--      Hint: Join the titles table to itself: the Senior Engineer row starts on
--            the day the Engineer row ends.
--      Check: 1 row: 67700 | 6.73




-- Q39. How many people were employed at the end of each year from 1985 to 2002?
--      Hint: Build the list of years with a recursive CTE, then join each year
--            to the dept_emp rows that were active on 31 December.
--      Check: 18 rows. First row: 1985 | 18204




-- Q40. Interview classic: what is the median current salary?
--      Hint: SQLite has no MEDIAN(). Number the salaries in order and pick the
--            middle one (or the two middle ones).
--      Check: 69805.0
