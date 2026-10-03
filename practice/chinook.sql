/* ============================================================================
   SQL PRACTICE LAB  |  Chinook (a digital music store)
   60 questions from easy to hard, each one with a tested answer.
   https://github.com/amirh3sam/sql-practice-lab

   HOW TO USE THIS FILE IN DBEAVER
     1. File > Open File...  and choose this file.
     2. Click the "N/A" box in the top toolbar (or press Ctrl+9) and pick
        your Chinook connection.
     3. Click anywhere inside a query and press Ctrl+Enter. Only that query
        runs, and the result appears at the bottom.

   WANT TO TEST YOURSELF FIRST?
     Open practice/quiz/chinook-quiz.sql
     It has the same questions without the answers.

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
SELECT *
FROM Artist;
-- Result: 275 rows. First row: 1 | AC/DC
-- Note: The star (*) means "all columns".

-- Q2. Show only the first name, last name and email of every customer.
SELECT FirstName, LastName, Email
FROM Customer;
-- Result: 59 rows. First row: Luís | Gonçalves | luisg@embraer.com.br

-- Q3. Show just the first 10 rows of the Track table.
SELECT *
FROM Track
LIMIT 10;
-- Result: 10 rows. First row: 1 | For Those About To Rock (We Salute You) | 1 | 1 | 1 | ...

-- Q4. List the countries our customers come from, A to Z. Each country should
--     appear only once.
SELECT DISTINCT Country
FROM Customer
ORDER BY Country;
-- Result: 24 rows. First row: Argentina

-- Q5. List all employees by hire date, earliest first. Show first name, last
--     name, title and hire date.
SELECT FirstName, LastName, Title, HireDate
FROM Employee
ORDER BY HireDate;
-- Result: 8 rows. First row: Jane | Peacock | Sales Support Agent | 2002-04-01 00:00:00

-- Q6. Show each customer's full name in ONE column called FullName.
SELECT FirstName || ' ' || LastName AS FullName
FROM Customer;
-- Result: 59 rows. First row: Luís Gonçalves
-- Note: AS gives a column a new name (an alias).

-- Q7. Which 5 tracks are the longest? Show the name and the length in minutes
--     (1 decimal).
SELECT Name,
       ROUND(Milliseconds / 60000.0, 1) AS Minutes
FROM Track
ORDER BY Milliseconds DESC
LIMIT 5;
-- Result: 5 rows. First row: Occupation / Precipice | 88.1
-- Note: Divide by 60000.0, not 60000. Two whole numbers give a whole-number
--       result in SQLite.

-- Q8. Show the name and price of the first 10 tracks, plus a new column with
--     the price including 10% tax.
SELECT Name,
       UnitPrice,
       ROUND(UnitPrice * 1.10, 2) AS PriceWithTax
FROM Track
LIMIT 10;
-- Result: 10 rows. First row: For Those About To Rock (We Salute You) | 0.99 | 1.09

-- Q9. How many tracks does the store have?
SELECT COUNT(*) AS TrackCount
FROM Track;
-- Result: 3503

-- Q10. Paging: sort the invoices by date, skip the first 10 and show the next
--      10.
SELECT InvoiceId, InvoiceDate, Total
FROM Invoice
ORDER BY InvoiceDate, InvoiceId
LIMIT 10 OFFSET 10;
-- Result: 10 rows. First row: 11 | 2009-02-06 00:00:00 | 8.91



-- ============================================================================
-- LEVEL 2 of 6  |  Filtering with WHERE                              Q11 - Q20
-- You practice: comparison operators, AND / OR, IN, BETWEEN, LIKE, IS NULL
-- ============================================================================

-- Q11. Find all customers from Brazil.
SELECT FirstName, LastName, City, Country
FROM Customer
WHERE Country = 'Brazil';
-- Result: 5 rows. First row: Luís | Gonçalves | São José dos Campos | Brazil
-- Note: Text values go inside single quotes.

-- Q12. Which tracks are longer than 10 minutes? Show name and minutes, longest
--      first.
SELECT Name,
       ROUND(Milliseconds / 60000.0, 1) AS Minutes
FROM Track
WHERE Milliseconds > 600000
ORDER BY Milliseconds DESC;
-- Result: 260 rows. First row: Occupation / Precipice | 88.1

-- Q13. Find the invoices with a total between $10 and $15, biggest first.
SELECT InvoiceId, InvoiceDate, BillingCountry, Total
FROM Invoice
WHERE Total BETWEEN 10 AND 15
ORDER BY Total DESC;
-- Result: 53 rows. First row: 193 | 2011-04-23 00:00:00 | Germany | 14.91
-- Note: BETWEEN includes both ends: 10 and 15 themselves would also match.

-- Q14. Find the customers who live in the USA or Canada.
SELECT FirstName, LastName, Country
FROM Customer
WHERE Country IN ('USA', 'Canada')
ORDER BY Country, LastName;
-- Result: 21 rows. First row: Robert | Brown | Canada

-- Q15. Show all invoices from the year 2011.
SELECT InvoiceId, InvoiceDate, Total
FROM Invoice
WHERE InvoiceDate >= '2011-01-01'
  AND InvoiceDate <  '2012-01-01'
ORDER BY InvoiceDate;
-- Result: 83 rows. First row: 167 | 2011-01-02 00:00:00 | 0.99
-- Note: Year-month-day text sorts in date order, so comparing it works.

-- Q16. Find every track with the word "love" in its name.
SELECT Name
FROM Track
WHERE Name LIKE '%love%'
ORDER BY Name;
-- Result: 114 rows. First row: (I Can't Help) Falling In Love With You
-- Note: In SQLite, LIKE ignores upper/lower case for the letters A-Z.

-- Q17. Which customers did NOT give a company name?
SELECT FirstName, LastName, Company
FROM Customer
WHERE Company IS NULL;
-- Result: 49 rows. First row: Leonie | Köhler | NULL
-- Note: "= NULL" never matches anything. Always write IS NULL or IS NOT NULL.

-- Q18. Find the invoices billed to Germany or France that have a total of at
--      least $10.
SELECT InvoiceId, BillingCountry, Total
FROM Invoice
WHERE (BillingCountry = 'Germany' OR BillingCountry = 'France')
  AND Total >= 10
ORDER BY Total DESC;
-- Result: 10 rows. First row: 313 | France | 16.86
-- Note: Without the parentheses you get 33 rows instead of 10, because AND is
--       checked before OR.

-- Q19. List every employee who is NOT a Sales Support Agent.
SELECT FirstName, LastName, Title
FROM Employee
WHERE Title <> 'Sales Support Agent';
-- Result: 5 rows. First row: Andrew | Adams | General Manager

-- Q20. Find the albums that have "Greatest" or "Best" in the title.
SELECT Title
FROM Album
WHERE Title LIKE '%Greatest%'
   OR Title LIKE '%Best%'
ORDER BY Title;
-- Result: 23 rows. First row: 20th Century Masters - The Millennium Col...



-- ============================================================================
-- LEVEL 3 of 6  |  Totals and groups                                 Q21 - Q30
-- You practice: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- ============================================================================

-- Q21. In one row, show: the number of invoices, total revenue, the average
--      invoice, the smallest and the largest invoice.
SELECT COUNT(*)             AS Invoices,
       ROUND(SUM(Total), 2) AS Revenue,
       ROUND(AVG(Total), 2) AS AvgInvoice,
       MIN(Total)           AS Smallest,
       MAX(Total)           AS Largest
FROM Invoice;
-- Result: 1 row: 412 | 2328.6 | 5.65 | 0.99 | 25.86

-- Q22. How many customers are there in each country? Most customers first.
SELECT Country,
       COUNT(*) AS Customers
FROM Customer
GROUP BY Country
ORDER BY Customers DESC, Country;
-- Result: 24 rows. First row: USA | 13

-- Q23. Which 10 albums have the most tracks? Show the AlbumId and the number of
--      tracks.
SELECT AlbumId,
       COUNT(*) AS Tracks
FROM Track
GROUP BY AlbumId
ORDER BY Tracks DESC, AlbumId
LIMIT 10;
-- Result: 10 rows. First row: 141 | 57

-- Q24. What are the top 10 countries by revenue?
SELECT BillingCountry,
       ROUND(SUM(Total), 2) AS Revenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY Revenue DESC
LIMIT 10;
-- Result: 10 rows. First row: USA | 523.06

-- Q25. Show the number of invoices and the revenue for each year.
SELECT strftime('%Y', InvoiceDate) AS Year,
       COUNT(*)                    AS Invoices,
       ROUND(SUM(Total), 2)        AS Revenue
FROM Invoice
GROUP BY Year
ORDER BY Year;
-- Result: 5 rows. First row: 2009 | 83 | 449.46

-- Q26. Which countries have at least 4 customers?
SELECT Country,
       COUNT(*) AS Customers
FROM Customer
GROUP BY Country
HAVING COUNT(*) >= 4
ORDER BY Customers DESC;
-- Result: 5 rows. First row: USA | 13
-- Note: WHERE filters rows before grouping. HAVING filters the groups
--       afterwards.

-- Q27. Which customers (CustomerId) have spent more than $45 in total?
SELECT CustomerId,
       ROUND(SUM(Total), 2) AS TotalSpent
FROM Invoice
GROUP BY CustomerId
HAVING SUM(Total) > 45
ORDER BY TotalSpent DESC;
-- Result: 5 rows. First row: 6 | 49.62

-- Q28. How many tracks have a composer, and how many do not?
SELECT COUNT(*)                   AS AllTracks,
       COUNT(Composer)            AS WithComposer,
       COUNT(*) - COUNT(Composer) AS WithoutComposer
FROM Track;
-- Result: 1 row: 3503 | 2525 | 978

-- Q29. How many different cities have we sent invoices to?
SELECT COUNT(DISTINCT BillingCity) AS Cities
FROM Invoice;
-- Result: 53

-- Q30. For each price (UnitPrice), show how many tracks cost that much and
--      their average length in minutes.
SELECT UnitPrice,
       COUNT(*)                              AS Tracks,
       ROUND(AVG(Milliseconds) / 60000.0, 1) AS AvgMinutes
FROM Track
GROUP BY UnitPrice;
-- Result: 2 rows. First row: 0.99 | 3290 | 4.4
-- Note: The $1.99 items are videos (TV episodes), which is why they are so
--       long.



-- ============================================================================
-- LEVEL 4 of 6  |  JOINs                                             Q31 - Q40
-- You practice: INNER JOIN, LEFT JOIN, joining 3-4 tables, self-join
-- ============================================================================

-- Q31. List every album together with its artist's name. Sort by artist, then
--      album.
SELECT ar.Name  AS Artist,
       al.Title AS Album
FROM Album al
JOIN Artist ar ON ar.ArtistId = al.ArtistId
ORDER BY ar.Name, al.Title;
-- Result: 347 rows. First row: AC/DC | For Those About To Rock We Salute You
-- Note: "al" and "ar" are table aliases: short nicknames that save typing.

-- Q32. Show the first 20 tracks with their album title and genre name.
SELECT t.Name   AS Track,
       al.Title AS Album,
       g.Name   AS Genre
FROM Track t
JOIN Album al ON al.AlbumId = t.AlbumId
JOIN Genre g  ON g.GenreId  = t.GenreId
ORDER BY t.TrackId
LIMIT 20;
-- Result: 20 rows. First row: For Those About To Rock (We Salute You) | ...

-- Q33. How many tracks are there in each genre? Most first.
SELECT g.Name   AS Genre,
       COUNT(*) AS Tracks
FROM Track t
JOIN Genre g ON g.GenreId = t.GenreId
GROUP BY g.Name
ORDER BY Tracks DESC;
-- Result: 25 rows. First row: Rock | 1297

-- Q34. Which artists have NO albums in the store?
SELECT ar.Name AS Artist
FROM Artist ar
LEFT JOIN Album al ON al.ArtistId = ar.ArtistId
WHERE al.AlbumId IS NULL
ORDER BY ar.Name;
-- Result: 71 rows. First row: A Cor Do Som

-- Q35. Show each customer next to the name of their support rep (an employee).
SELECT c.FirstName || ' ' || c.LastName AS Customer,
       e.FirstName || ' ' || e.LastName AS SupportRep
FROM Customer c
JOIN Employee e ON e.EmployeeId = c.SupportRepId
ORDER BY SupportRep, Customer;
-- Result: 59 rows. First row: Edward Francis | Jane Peacock

-- Q36. Who are the top 10 customers by total spending?
SELECT c.FirstName || ' ' || c.LastName AS Customer,
       c.Country,
       ROUND(SUM(i.Total), 2)           AS TotalSpent
FROM Customer c
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Country
ORDER BY TotalSpent DESC, c.CustomerId
LIMIT 10;
-- Result: 10 rows. First row: Helena Holý | Czech Republic | 49.62

-- Q37. Show every employee with the name of their manager. Keep the boss, who
--      has no manager.
SELECT e.FirstName || ' ' || e.LastName AS Employee,
       e.Title,
       m.FirstName || ' ' || m.LastName AS Manager
FROM Employee e
LEFT JOIN Employee m ON m.EmployeeId = e.ReportsTo
ORDER BY e.EmployeeId;
-- Result: 8 rows. First row: Andrew Adams | General Manager | NULL
-- Note: This is a self-join: the same table used twice, once as "e" (employee)
--       and once as "m" (manager).

-- Q38. How many tracks are in each playlist? Include empty playlists and show 0
--      for them.
SELECT p.PlaylistId,
       p.Name,
       COUNT(pt.TrackId) AS Tracks
FROM Playlist p
LEFT JOIN PlaylistTrack pt ON pt.PlaylistId = p.PlaylistId
GROUP BY p.PlaylistId, p.Name
ORDER BY Tracks DESC, p.PlaylistId;
-- Result: 18 rows. First row: 1 | Music | 3290
-- Note: COUNT(pt.TrackId) counts only real matches, so empty playlists get 0.
--       COUNT(*) would wrongly give 1.

-- Q39. How many tracks have never been sold?
SELECT COUNT(*) AS NeverSold
FROM Track t
LEFT JOIN InvoiceLine il ON il.TrackId = t.TrackId
WHERE il.InvoiceLineId IS NULL;
-- Result: 1519

-- Q40. Which 10 artists earned the most revenue?
SELECT ar.Name                                   AS Artist,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS Revenue
FROM InvoiceLine il
JOIN Track t   ON t.TrackId   = il.TrackId
JOIN Album al  ON al.AlbumId  = t.AlbumId
JOIN Artist ar ON ar.ArtistId = al.ArtistId
GROUP BY ar.ArtistId, ar.Name
ORDER BY Revenue DESC, ar.Name
LIMIT 10;
-- Result: 10 rows. First row: Iron Maiden | 138.6



-- ============================================================================
-- LEVEL 5 of 6  |  Subqueries, CTEs, CASE, dates and text            Q41 - Q50
-- You practice: subqueries, WITH, CASE, UNION, strftime, substr, COALESCE
-- ============================================================================

-- Q41. How many tracks are longer than the average track?
SELECT COUNT(*) AS LongerThanAverage
FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds) FROM Track);
-- Result: 494

-- Q42. Which customers have bought at least one Jazz track?
SELECT FirstName, LastName, Country
FROM Customer
WHERE CustomerId IN (
    SELECT i.CustomerId
    FROM Invoice i
    JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
    JOIN Track t        ON t.TrackId    = il.TrackId
    JOIN Genre g        ON g.GenreId    = t.GenreId
    WHERE g.Name = 'Jazz'
)
ORDER BY LastName, FirstName;
-- Result: 32 rows. First row: Camille | Bernard | France

-- Q43. Label every track Short (under 3 minutes), Medium (3 to 5 minutes) or
--      Long (over 5 minutes), then count each group.
SELECT CASE
           WHEN Milliseconds < 180000  THEN 'Short'
           WHEN Milliseconds <= 300000 THEN 'Medium'
           ELSE 'Long'
       END      AS Length,
       COUNT(*) AS Tracks
FROM Track
GROUP BY Length
ORDER BY Tracks DESC;
-- Result: 3 rows. First row: Medium | 1954

-- Q44. Which customers spent more than the average customer?
WITH spending AS (
    SELECT CustomerId,
           SUM(Total) AS TotalSpent
    FROM Invoice
    GROUP BY CustomerId
)
SELECT c.FirstName || ' ' || c.LastName AS Customer,
       ROUND(s.TotalSpent, 2)           AS TotalSpent
FROM spending s
JOIN Customer c ON c.CustomerId = s.CustomerId
WHERE s.TotalSpent > (SELECT AVG(TotalSpent) FROM spending)
ORDER BY s.TotalSpent DESC, c.CustomerId;
-- Result: 22 rows. First row: Helena Holý | 49.62
-- Note: WITH creates a named, temporary result (a CTE) that the main query can
--       use like a table.

-- Q45. Show the revenue for each month of 2012.
SELECT strftime('%Y-%m', InvoiceDate) AS Month,
       ROUND(SUM(Total), 2)           AS Revenue
FROM Invoice
WHERE strftime('%Y', InvoiceDate) = '2012'
GROUP BY Month
ORDER BY Month;
-- Result: 12 rows. First row: 2012-01 | 37.62

-- Q46. Which 5 email providers (the part after the @) are most popular with
--      customers?
SELECT substr(Email, instr(Email, '@') + 1) AS Domain,
       COUNT(*)                             AS Customers
FROM Customer
GROUP BY Domain
ORDER BY Customers DESC, Domain
LIMIT 5;
-- Result: 5 rows. First row: gmail.com | 8

-- Q47. Make ONE list of all people in the database, customers and employees,
--      with a column that says which is which.
SELECT FirstName, LastName, 'Customer' AS Role
FROM Customer
UNION ALL
SELECT FirstName, LastName, 'Employee' AS Role
FROM Employee
ORDER BY LastName, FirstName;
-- Result: 67 rows. First row: Andrew | Adams | Employee

-- Q48. For each customer, show their most recent invoice (date and total).
SELECT c.FirstName || ' ' || c.LastName AS Customer,
       i.InvoiceDate,
       i.Total
FROM Customer c
JOIN Invoice i ON i.CustomerId = c.CustomerId
WHERE i.InvoiceDate = (
    SELECT MAX(i2.InvoiceDate)
    FROM Invoice i2
    WHERE i2.CustomerId = c.CustomerId
)
ORDER BY i.InvoiceDate DESC, Customer;
-- Result: 59 rows. First row: Manoj Pareek | 2013-12-22 00:00:00 | 1.99
-- Note: This is a correlated subquery: the inner query runs once for each
--       customer.

-- Q49. Print the company org chart: every employee with their level below the
--      General Manager (level 0).
WITH RECURSIVE org AS (
    SELECT EmployeeId, FirstName, LastName, Title, 0 AS Level
    FROM Employee
    WHERE ReportsTo IS NULL
    UNION ALL
    SELECT e.EmployeeId, e.FirstName, e.LastName, e.Title, org.Level + 1
    FROM Employee e
    JOIN org ON e.ReportsTo = org.EmployeeId
)
SELECT Level,
       FirstName || ' ' || LastName AS Employee,
       Title
FROM org
ORDER BY Level, LastName;
-- Result: 8 rows. First row: 0 | Andrew Adams | General Manager

-- Q50. Build a contact list: customer name, company (or 'Individual' when there
--      is none), state (or '-' when there is none) and country.
SELECT FirstName || ' ' || LastName    AS Customer,
       COALESCE(Company, 'Individual') AS Company,
       COALESCE(State, '-')            AS State,
       Country
FROM Customer
ORDER BY Country, LastName;
-- Result: 59 rows. First row: Diego Gutiérrez | Individual | - | Argentina



-- ============================================================================
-- LEVEL 6 of 6  |  Window functions and interview classics           Q51 - Q60
-- You practice: ROW_NUMBER, RANK, DENSE_RANK, NTILE, LAG, running totals, top-N
--               per group
-- ============================================================================

-- Q51. Number the customers from biggest spender to smallest and show the top
--      10.
SELECT ROW_NUMBER() OVER (ORDER BY SUM(i.Total) DESC, c.CustomerId) AS Position,
       c.FirstName || ' ' || c.LastName                              AS Customer,
       ROUND(SUM(i.Total), 2)                                        AS TotalSpent
FROM Customer c
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Position
LIMIT 10;
-- Result: 10 rows. First row: 1 | Helena Holý | 49.62

-- Q52. Rank the countries by revenue. Countries with the same revenue must
--      share the same rank.
SELECT BillingCountry,
       ROUND(SUM(Total), 2)                                   AS Revenue,
       RANK()       OVER (ORDER BY ROUND(SUM(Total), 2) DESC) AS RevenueRank,
       DENSE_RANK() OVER (ORDER BY ROUND(SUM(Total), 2) DESC) AS RevenueDenseRank
FROM Invoice
GROUP BY BillingCountry
ORDER BY Revenue DESC, BillingCountry;
-- Result: 24 rows. First row: USA | 523.06 | 1 | 1
-- Note: Hungary and Ireland tie at rank 11. After the tie, RANK jumps to 13 and
--       DENSE_RANK carries on with 12.

-- Q53. For each genre, find its 3 longest tracks.
WITH ranked AS (
    SELECT g.Name                             AS Genre,
           t.Name                             AS Track,
           ROUND(t.Milliseconds / 60000.0, 1) AS Minutes,
           ROW_NUMBER() OVER (
               PARTITION BY g.GenreId
               ORDER BY t.Milliseconds DESC, t.TrackId
           )                                  AS rn
    FROM Track t
    JOIN Genre g ON g.GenreId = t.GenreId
)
SELECT Genre, Track, Minutes
FROM ranked
WHERE rn <= 3
ORDER BY Genre, rn;
-- Result: 73 rows. First row: Alternative | Reach Down | 11.2
-- Note: This "top N per group" pattern is one of the most common interview
--       questions.

-- Q54. Show the revenue of every month together with a running total.
WITH monthly AS (
    SELECT strftime('%Y-%m', InvoiceDate) AS Month,
           SUM(Total)                     AS Revenue
    FROM Invoice
    GROUP BY Month
)
SELECT Month,
       ROUND(Revenue, 2)                            AS Revenue,
       ROUND(SUM(Revenue) OVER (ORDER BY Month), 2) AS RunningTotal
FROM monthly
ORDER BY Month;
-- Result: 60 rows. First row: 2009-01 | 35.64 | 35.64

-- Q55. Show the revenue of each year and how much it changed compared with the
--      year before.
WITH yearly AS (
    SELECT strftime('%Y', InvoiceDate) AS Year,
           SUM(Total)                  AS Revenue
    FROM Invoice
    GROUP BY Year
)
SELECT Year,
       ROUND(Revenue, 2)                                     AS Revenue,
       ROUND(Revenue - LAG(Revenue) OVER (ORDER BY Year), 2) AS ChangeVsLastYear
FROM yearly
ORDER BY Year;
-- Result: 5 rows. First row: 2009 | 449.46 | NULL
-- Note: The first year shows NULL because there is no earlier year to compare
--       with.

-- Q56. What share of the total revenue does each genre bring in?
WITH genre_revenue AS (
    SELECT g.Name                          AS Genre,
           SUM(il.UnitPrice * il.Quantity) AS Revenue
    FROM InvoiceLine il
    JOIN Track t ON t.TrackId = il.TrackId
    JOIN Genre g ON g.GenreId = t.GenreId
    GROUP BY g.GenreId, g.Name
)
SELECT Genre,
       ROUND(Revenue, 2)                                AS Revenue,
       ROUND(100.0 * Revenue / SUM(Revenue) OVER (), 1) AS PercentOfTotal
FROM genre_revenue
ORDER BY Revenue DESC, Genre;
-- Result: 24 rows. First row: Rock | 826.65 | 35.5

-- Q57. Split the customers into 4 equal groups by spending (group 1 = the
--      biggest spenders).
WITH spending AS (
    SELECT c.CustomerId,
           c.FirstName || ' ' || c.LastName AS Customer,
           SUM(i.Total)                     AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON i.CustomerId = c.CustomerId
    GROUP BY c.CustomerId, c.FirstName, c.LastName
)
SELECT Customer,
       ROUND(TotalSpent, 2)                                 AS TotalSpent,
       NTILE(4) OVER (ORDER BY TotalSpent DESC, CustomerId) AS SpendingGroup
FROM spending
ORDER BY SpendingGroup, TotalSpent DESC, CustomerId;
-- Result: 59 rows. First row: Helena Holý | 49.62 | 1

-- Q58. Interview classic: which customer has the SECOND highest total spending?
WITH spending AS (
    SELECT c.FirstName || ' ' || c.LastName AS Customer,
           ROUND(SUM(i.Total), 2)           AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON i.CustomerId = c.CustomerId
    GROUP BY c.CustomerId, c.FirstName, c.LastName
),
ranked AS (
    SELECT Customer,
           TotalSpent,
           DENSE_RANK() OVER (ORDER BY TotalSpent DESC) AS rnk
    FROM spending
)
SELECT Customer, TotalSpent
FROM ranked
WHERE rnk = 2;
-- Result: 1 row: Richard Cunningham | 47.62
-- Note: DENSE_RANK still gives the right answer when two customers tie for
--       first place. LIMIT 1 OFFSET 1 would not.

-- Q59. Show each month's revenue next to the average of that month and the two
--      months before it (a 3-month moving average).
WITH monthly AS (
    SELECT strftime('%Y-%m', InvoiceDate) AS Month,
           SUM(Total)                     AS Revenue
    FROM Invoice
    GROUP BY Month
)
SELECT Month,
       ROUND(Revenue, 2) AS Revenue,
       ROUND(AVG(Revenue) OVER (
                 ORDER BY Month
                 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
             ), 2)       AS MovingAvg3Months
FROM monthly
ORDER BY Month;
-- Result: 60 rows. First row: 2009-01 | 35.64 | 35.64

-- Q60. Boss level: what is the most popular genre in each country (by number of
--      tracks bought)? If two genres tie, show both.
WITH country_genre AS (
    SELECT i.BillingCountry AS Country,
           g.Name           AS Genre,
           COUNT(*)         AS TracksBought
    FROM Invoice i
    JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
    JOIN Track t        ON t.TrackId    = il.TrackId
    JOIN Genre g        ON g.GenreId    = t.GenreId
    GROUP BY i.BillingCountry, g.GenreId, g.Name
),
ranked AS (
    SELECT Country,
           Genre,
           TracksBought,
           RANK() OVER (PARTITION BY Country ORDER BY TracksBought DESC) AS rnk
    FROM country_genre
)
SELECT Country, Genre, TracksBought
FROM ranked
WHERE rnk = 1
ORDER BY Country, Genre;
-- Result: 25 rows. First row: Argentina | Alternative & Punk | 9
