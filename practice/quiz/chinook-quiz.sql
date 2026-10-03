/* ============================================================================
   SQL PRACTICE LAB  |  Chinook (a digital music store)  |  QUIZ (no answers)
   60 questions from easy to hard. Write your own query under each one.
   https://github.com/hesamworkshop/sql-practice-lab

   HOW TO USE THIS FILE IN DBEAVER
     1. File > Open File...  and choose this file.
     2. Click the "N/A" box in the top toolbar (or press Ctrl+9) and pick
        your Chinook connection.
     3. Type your query under a question and press Ctrl+Enter to run it.
     4. Compare what you get with the "Check:" line of the question.

   STUCK?
     The answers are in practice/chinook.sql.

   GOOD TO KNOW
     - Table names are singular: Track, Album, Invoice (not Tracks, Albums).
     - Dates are stored as text, for example '2011-03-15 00:00:00'.
     - The sales data runs from January 2009 to December 2013.

   DATA
     Chinook Database v1.4.5 for SQLite
     Copyright (c) 2008-2024 Luis Rocha. MIT License.
     https://github.com/lerocha/chinook-database

   QUESTIONS AND ANSWERS
     Copyright (c) 2026 AmirHesam Tech. All rights reserved. See LICENSE.md.
   ============================================================================ */


-- ============================================================================
-- LEVEL 1 of 6  |  SELECT basics                                      Q1 - Q10
-- You practice: SELECT, column lists, LIMIT, DISTINCT, ORDER BY, aliases,
--               simple math
-- ============================================================================

-- Q1. Show every column and every row of the Artist table.
--     Check: 275 rows. First row: 1 | AC/DC




-- Q2. Show only the first name, last name and email of every customer.
--     Check: 59 rows. First row: Luís | Gonçalves | luisg@embraer.com.br




-- Q3. Show just the first 10 rows of the Track table.
--     Hint: LIMIT
--     Check: 10 rows. First row: 1 | For Those About To Rock (We Salute You) | 1 | 1 | 1 | ...




-- Q4. List the countries our customers come from, A to Z. Each country should
--     appear only once.
--     Hint: DISTINCT
--     Check: 24 rows. First row: Argentina




-- Q5. List all employees by hire date, earliest first. Show first name, last
--     name, title and hire date.
--     Hint: ORDER BY
--     Check: 8 rows. First row: Jane | Peacock | Sales Support Agent | 2002-04-01 00:00:00




-- Q6. Show each customer's full name in ONE column called FullName.
--     Hint: In SQLite, || glues text together.
--     Check: 59 rows. First row: Luís Gonçalves




-- Q7. Which 5 tracks are the longest? Show the name and the length in minutes
--     (1 decimal).
--     Hint: There are 60000 milliseconds in a minute.
--     Check: 5 rows. First row: Occupation / Precipice | 88.1




-- Q8. Show the name and price of the first 10 tracks, plus a new column with
--     the price including 10% tax.
--     Check: 10 rows. First row: For Those About To Rock (We Salute You) | 0.99 | 1.09




-- Q9. How many tracks does the store have?
--     Hint: COUNT(*)
--     Check: 3503




-- Q10. Paging: sort the invoices by date, skip the first 10 and show the next
--      10.
--      Hint: LIMIT ... OFFSET ...
--      Check: 10 rows. First row: 11 | 2009-02-06 00:00:00 | 8.91






-- ============================================================================
-- LEVEL 2 of 6  |  Filtering with WHERE                              Q11 - Q20
-- You practice: comparison operators, AND / OR, IN, BETWEEN, LIKE, IS NULL
-- ============================================================================

-- Q11. Find all customers from Brazil.
--      Check: 5 rows. First row: Luís | Gonçalves | São José dos Campos | Brazil




-- Q12. Which tracks are longer than 10 minutes? Show name and minutes, longest
--      first.
--      Hint: 10 minutes = 600000 milliseconds
--      Check: 260 rows. First row: Occupation / Precipice | 88.1




-- Q13. Find the invoices with a total between $10 and $15, biggest first.
--      Hint: BETWEEN ... AND ...
--      Check: 53 rows. First row: 193 | 2011-04-23 00:00:00 | Germany | 14.91




-- Q14. Find the customers who live in the USA or Canada.
--      Hint: IN (...)
--      Check: 21 rows. First row: Robert | Brown | Canada




-- Q15. Show all invoices from the year 2011.
--      Hint: Dates are stored as text like '2011-03-15 00:00:00'.
--      Check: 83 rows. First row: 167 | 2011-01-02 00:00:00 | 0.99




-- Q16. Find every track with the word "love" in its name.
--      Hint: LIKE with % wildcards
--      Check: 114 rows. First row: (I Can't Help) Falling In Love With You




-- Q17. Which customers did NOT give a company name?
--      Hint: Missing values are NULL.
--      Check: 49 rows. First row: Leonie | Köhler | NULL




-- Q18. Find the invoices billed to Germany or France that have a total of at
--      least $10.
--      Hint: Mixing AND with OR needs parentheses.
--      Check: 10 rows. First row: 313 | France | 16.86




-- Q19. List every employee who is NOT a Sales Support Agent.
--      Hint: <> means "not equal"
--      Check: 5 rows. First row: Andrew | Adams | General Manager




-- Q20. Find the albums that have "Greatest" or "Best" in the title.
--      Check: 23 rows. First row: 20th Century Masters - The Millennium Col...






-- ============================================================================
-- LEVEL 3 of 6  |  Totals and groups                                 Q21 - Q30
-- You practice: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- ============================================================================

-- Q21. In one row, show: the number of invoices, total revenue, the average
--      invoice, the smallest and the largest invoice.
--      Check: 1 row: 412 | 2328.6 | 5.65 | 0.99 | 25.86




-- Q22. How many customers are there in each country? Most customers first.
--      Hint: GROUP BY
--      Check: 24 rows. First row: USA | 13




-- Q23. Which 10 albums have the most tracks? Show the AlbumId and the number of
--      tracks.
--      Check: 10 rows. First row: 141 | 57




-- Q24. What are the top 10 countries by revenue?
--      Hint: Use BillingCountry from the Invoice table.
--      Check: 10 rows. First row: USA | 523.06




-- Q25. Show the number of invoices and the revenue for each year.
--      Hint: strftime('%Y', InvoiceDate) pulls the year out of a date.
--      Check: 5 rows. First row: 2009 | 83 | 449.46




-- Q26. Which countries have at least 4 customers?
--      Hint: HAVING filters groups.
--      Check: 5 rows. First row: USA | 13




-- Q27. Which customers (CustomerId) have spent more than $45 in total?
--      Check: 5 rows. First row: 6 | 49.62




-- Q28. How many tracks have a composer, and how many do not?
--      Hint: COUNT(column) skips NULLs. COUNT(*) does not.
--      Check: 1 row: 3503 | 2525 | 978




-- Q29. How many different cities have we sent invoices to?
--      Hint: COUNT(DISTINCT ...)
--      Check: 53




-- Q30. For each price (UnitPrice), show how many tracks cost that much and
--      their average length in minutes.
--      Check: 2 rows. First row: 0.99 | 3290 | 4.4






-- ============================================================================
-- LEVEL 4 of 6  |  JOINs                                             Q31 - Q40
-- You practice: INNER JOIN, LEFT JOIN, joining 3-4 tables, self-join
-- ============================================================================

-- Q31. List every album together with its artist's name. Sort by artist, then
--      album.
--      Hint: Album.ArtistId points to Artist.ArtistId.
--      Check: 347 rows. First row: AC/DC | For Those About To Rock We Salute You




-- Q32. Show the first 20 tracks with their album title and genre name.
--      Hint: Two joins.
--      Check: 20 rows. First row: For Those About To Rock (We Salute You) | ...




-- Q33. How many tracks are there in each genre? Most first.
--      Check: 25 rows. First row: Rock | 1297




-- Q34. Which artists have NO albums in the store?
--      Hint: LEFT JOIN keeps artists without a match. Then look for NULL.
--      Check: 71 rows. First row: A Cor Do Som




-- Q35. Show each customer next to the name of their support rep (an employee).
--      Hint: Customer.SupportRepId points to Employee.EmployeeId.
--      Check: 59 rows. First row: Edward Francis | Jane Peacock




-- Q36. Who are the top 10 customers by total spending?
--      Check: 10 rows. First row: Helena Holý | Czech Republic | 49.62




-- Q37. Show every employee with the name of their manager. Keep the boss, who
--      has no manager.
--      Hint: Join the Employee table to itself.
--      Check: 8 rows. First row: Andrew Adams | General Manager | NULL




-- Q38. How many tracks are in each playlist? Include empty playlists and show 0
--      for them.
--      Check: 18 rows. First row: 1 | Music | 3290




-- Q39. How many tracks have never been sold?
--      Hint: LEFT JOIN from Track to InvoiceLine.
--      Check: 1519




-- Q40. Which 10 artists earned the most revenue?
--      Hint: InvoiceLine -> Track -> Album -> Artist
--      Check: 10 rows. First row: Iron Maiden | 138.6






-- ============================================================================
-- LEVEL 5 of 6  |  Subqueries, CTEs, CASE, dates and text            Q41 - Q50
-- You practice: subqueries, WITH, CASE, UNION, strftime, substr, COALESCE
-- ============================================================================

-- Q41. How many tracks are longer than the average track?
--      Hint: Put a small query inside the WHERE.
--      Check: 494




-- Q42. Which customers have bought at least one Jazz track?
--      Hint: WHERE CustomerId IN (a query that returns customer ids)
--      Check: 32 rows. First row: Camille | Bernard | France




-- Q43. Label every track Short (under 3 minutes), Medium (3 to 5 minutes) or
--      Long (over 5 minutes), then count each group.
--      Hint: CASE WHEN ... THEN ... END
--      Check: 3 rows. First row: Medium | 1954




-- Q44. Which customers spent more than the average customer?
--      Hint: First build a list of spending per customer with WITH.
--      Check: 22 rows. First row: Helena Holý | 49.62




-- Q45. Show the revenue for each month of 2012.
--      Hint: strftime('%Y-%m', InvoiceDate)
--      Check: 12 rows. First row: 2012-01 | 37.62




-- Q46. Which 5 email providers (the part after the @) are most popular with
--      customers?
--      Hint: instr() finds the @, substr() cuts the text.
--      Check: 5 rows. First row: gmail.com | 8




-- Q47. Make ONE list of all people in the database, customers and employees,
--      with a column that says which is which.
--      Hint: UNION ALL stacks two results on top of each other.
--      Check: 67 rows. First row: Andrew | Adams | Employee




-- Q48. For each customer, show their most recent invoice (date and total).
--      Hint: Compare each invoice with that customer's latest date.
--      Check: 59 rows. First row: Manoj Pareek | 2013-12-22 00:00:00 | 1.99




-- Q49. Print the company org chart: every employee with their level below the
--      General Manager (level 0).
--      Hint: A recursive CTE: start with the boss, then keep adding the people
--            who report to the rows you already have.
--      Check: 8 rows. First row: 0 | Andrew Adams | General Manager




-- Q50. Build a contact list: customer name, company (or 'Individual' when there
--      is none), state (or '-' when there is none) and country.
--      Hint: COALESCE(a, b) returns b when a is NULL.
--      Check: 59 rows. First row: Diego Gutiérrez | Individual | - | Argentina






-- ============================================================================
-- LEVEL 6 of 6  |  Window functions and interview classics           Q51 - Q60
-- You practice: ROW_NUMBER, RANK, DENSE_RANK, NTILE, LAG, running totals, top-N
--               per group
-- ============================================================================

-- Q51. Number the customers from biggest spender to smallest and show the top
--      10.
--      Hint: ROW_NUMBER() OVER (ORDER BY ...)
--      Check: 10 rows. First row: 1 | Helena Holý | 49.62




-- Q52. Rank the countries by revenue. Countries with the same revenue must
--      share the same rank.
--      Hint: Try RANK() and DENSE_RANK() side by side.
--      Check: 24 rows. First row: USA | 523.06 | 1 | 1




-- Q53. For each genre, find its 3 longest tracks.
--      Hint: PARTITION BY restarts the numbering for every genre.
--      Check: 73 rows. First row: Alternative | Reach Down | 11.2




-- Q54. Show the revenue of every month together with a running total.
--      Hint: SUM(...) OVER (ORDER BY ...)
--      Check: 60 rows. First row: 2009-01 | 35.64 | 35.64




-- Q55. Show the revenue of each year and how much it changed compared with the
--      year before.
--      Hint: LAG() reads the value from the previous row.
--      Check: 5 rows. First row: 2009 | 449.46 | NULL




-- Q56. What share of the total revenue does each genre bring in?
--      Hint: SUM(...) OVER () with empty brackets gives the grand total on
--            every row.
--      Check: 24 rows. First row: Rock | 826.65 | 35.5




-- Q57. Split the customers into 4 equal groups by spending (group 1 = the
--      biggest spenders).
--      Hint: NTILE(4)
--      Check: 59 rows. First row: Helena Holý | 49.62 | 1




-- Q58. Interview classic: which customer has the SECOND highest total spending?
--      Hint: Rank the customers first, then keep rank 2.
--      Check: 1 row: Richard Cunningham | 47.62




-- Q59. Show each month's revenue next to the average of that month and the two
--      months before it (a 3-month moving average).
--      Hint: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
--      Check: 60 rows. First row: 2009-01 | 35.64 | 35.64




-- Q60. Boss level: what is the most popular genre in each country (by number of
--      tracks bought)? If two genres tie, show both.
--      Hint: Count per country and genre first, then RANK() inside each
--            country.
--      Check: 25 rows. First row: Argentina | Alternative & Punk | 9
