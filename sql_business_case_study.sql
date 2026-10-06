-- ============================================================
-- SQL Business Case Study: Chinook Database
-- Tool: MySQL Workbench
-- Author: Sayali Raktate
-- ============================================================

USE Chinook;

-- ------------------------------------------------------------
-- Q1: List all customers from Brazil
-- ------------------------------------------------------------
SELECT *
FROM Customer
WHERE Country = 'Brazil';

-- ------------------------------------------------------------
-- Q2: Find all tracks longer than 5 minutes
-- ------------------------------------------------------------
SELECT Name, Milliseconds
FROM Track
WHERE Milliseconds > 300000;

-- ------------------------------------------------------------
-- Q3: Count total number of invoices
-- ------------------------------------------------------------
SELECT COUNT(*) AS TotalInvoices
FROM Invoice;

-- ------------------------------------------------------------
-- Q4: Find the total revenue from all invoices
-- ------------------------------------------------------------
SELECT SUM(Total) AS TotalRevenue
FROM Invoice;

-- ------------------------------------------------------------
-- Q5: Which genre has generated the most total revenue?
-- ------------------------------------------------------------
SELECT g.Name AS Genre,
       SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY g.Name
ORDER BY Revenue DESC;

-- ------------------------------------------------------------
-- Q6: Who are the top 5 customers by total spend?
-- ------------------------------------------------------------
SELECT c.FirstName,
       c.LastName,
       SUM(i.Total) AS TotalSpent
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY TotalSpent DESC
LIMIT 5;

-- ------------------------------------------------------------
-- Q7: Which employee has the highest total sales handled?
-- ------------------------------------------------------------
SELECT e.FirstName,
       e.LastName,
       SUM(i.Total) AS TotalSales
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY TotalSales DESC;

-- ------------------------------------------------------------
-- Q8: What is the average invoice total per country?
-- ------------------------------------------------------------
SELECT BillingCountry,
       AVG(Total) AS AvgInvoiceTotal
FROM Invoice
GROUP BY BillingCountry
ORDER BY AvgInvoiceTotal DESC;

-- ------------------------------------------------------------
-- Q9: What is the monthly revenue trend over time?
-- ------------------------------------------------------------
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
       SUM(Total) AS MonthlyRevenue
FROM Invoice
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY Month;

-- ------------------------------------------------------------
-- Q10: Which artist has the most albums in the store?
-- ------------------------------------------------------------
SELECT ar.Name AS Artist,
       COUNT(al.AlbumId) AS AlbumCount
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
GROUP BY ar.ArtistId, ar.Name
ORDER BY AlbumCount DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q11: What percentage of total revenue does each genre contribute?
-- ------------------------------------------------------------
SELECT g.Name AS Genre,
       SUM(il.UnitPrice * il.Quantity) AS Revenue,
       ROUND(
           SUM(il.UnitPrice * il.Quantity) * 100.0
           / (SELECT SUM(UnitPrice * Quantity) FROM InvoiceLine),
           2
       ) AS PercentOfTotal
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY g.Name
ORDER BY PercentOfTotal DESC;

-- ------------------------------------------------------------
-- Q12: Find customers who spent above the average customer spend
-- ------------------------------------------------------------
SELECT c.FirstName,
       c.LastName,
       SUM(i.Total) AS TotalSpent
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
HAVING SUM(i.Total) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(Total) AS CustomerTotal
        FROM Invoice
        GROUP BY CustomerId
    ) AS sub
)
ORDER BY TotalSpent DESC;

-- ------------------------------------------------------------
-- Q13: What is the total revenue by billing country?
-- ------------------------------------------------------------
SELECT BillingCountry,
       SUM(Total) AS TotalRevenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC;


-- ============================================================
-- Practice queries (filtering and sorting basics)
-- ============================================================

-- All customers
SELECT * FROM Customer;

-- Customers from the USA
SELECT *
FROM Customer
WHERE Country = 'USA';

-- Customers from New York, USA
SELECT *
FROM Customer
WHERE Country = 'USA' AND City = 'New York';

-- Customers sorted by country (A to Z)
SELECT *
FROM Customer
ORDER BY Country;

-- Customers sorted by country (Z to A)
SELECT *
FROM Customer
ORDER BY Country DESC;

-- Customers sorted by country, then city
SELECT *
FROM Customer
ORDER BY Country, City;

-- USA customers sorted by city
SELECT *
FROM Customer
WHERE Country = 'USA'
ORDER BY City;
