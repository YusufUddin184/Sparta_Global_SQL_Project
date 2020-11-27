use Northwind
--1.1

SELECT c.CompanyName AS "Company Name", c.CustomerID AS "Customer ID", c.Address AS "Address", c.City AS "City"
FROM Customers c
WHERE c.City = 'London' OR c.City = 'Paris'

--1.2

SELECT p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID=c.CategoryID
WHERE p.ProductName LIKE '%bottles%' -- need where clause and wildcard characters


--1.3

SELECT p.ProductName,s.CompanyName ,s.Country
FROM Products p 
INNER JOIN Suppliers s ON p.SupplierID= s.SupplierID

--1.4

SELECT c.CategoryName, COUNT(p.ProductID) as "Count"
FROM Products p
INNER JOIN Categories c ON p.CategoryID=c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY "count" DESC

-- 1.5 

SELECT CONCAT(e.TitleOfCourtesy +' ', e.FirstName +' ', e.LastName) AS "Employee", e.City AS "City"
FROM Employees e

--1.6

SELECT r.regionDescription
, ROUND(SUM(od.UnitPrice * od.Quantity * (1- od.Discount)), 2) AS "Sales Total"
FROM [Order Details] od 
INNER JOIN Orders o 
ON od.OrderID = o.OrderID
INNER JOIN Employees e 
ON e.EmployeeID = o.EmployeeID
INNER JOIN EmployeeTerritories et 
ON et.EmployeeID = e.EmployeeID
INNER JOIN Territories t 
ON et.TerritoryID = t.TerritoryID
INNER JOIN Region r 
ON r.RegionID = t.RegionID
GROUP BY r.RegionID, r.RegionDescription
HAVING SUM(od.UnitPrice * od.Quantity * (1- od.Discount)) > 1000000

-- 1.7

SELECT o.OrderID, o.ShipCountry, SUM(o.Freight) AS 'frieght' --count
FROM Orders o
WHERE o.ShipCountry = 'USA' or o.ShipCountry = 'UK'
GROUP BY o.OrderID, o.Freight, o.ShipCountry
HAVING SUM(o.Freight) > 100

-- 1.8

SELECT TOP 1 od.OrderID, MAX(od.UnitPrice*od.Quantity)-(1-od.Discount) as 'Highest value'
FROM [Order Details] od
GROUP BY od.OrderID, od.Discount
Order by 'Highest Value' DESC

-- 2.1 and 2.2.

CREATE TABLE spartans_table
(
    title VARCHAR (225),
    first_name VARCHAR (225),
    last_name VARCHAR (225),
    university VARCHAR (225),
    degree VARCHAR (225),
    grade_achieved VARCHAR (225),
    favourite_colour VARCHAR(225)
)
INSERT INTO spartans_table
(
    title, 
    first_name,
    last_name ,
    university ,
    degree ,
    grade_achieved,
    favourite_colour
)
VALUES
(
    'Mr','Yusuf','Uddin','Cambridge','Politics','30', 'red'
),
(
    'Mr', 'Timin', 'Rickaby', 'Kings College London', 'Computer Science','10', 'yellow'
),
(
    'Mr','Benjamin','Balls','University of Exeter','Engineering','20', 'Blue'
); 

SELECT * FROM spartans_table

--3.1

SELECT e.EmployeeID,e.FirstName,e.LastName,s.CompanyName
FROM Employees e
INNER JOIN orders o ON e.EmployeeID=o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
INNER JOIN Products p ON od.ProductID=p.ProductID
INNER JOIN Suppliers s ON p.SupplierID=s.SupplierID
ORDER BY s.CompanyName

--3.2

SELECT e.FirstName + ' ' + e.LastName AS "Employee Name", er.FirstName + ' ' + er.LastName AS "Reports To"
FROM Employees e
LEFT JOIN Employees er ON e.ReportsTo = er.EmployeeID

-- 3.3
    
SELECT TOP 10 c.CompanyName, ROUND(SUM((1-od.Discount)*od.Quantity * od.UnitPrice),2) AS"sales"
FROM [Order Details] od
INNER JOIN Orders o
ON o.OrderID = od.OrderID
INNER JOIN Customers c 
ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName, o.ShippedDate
HAVING o.ShippedDate >'1997-12-31'
ORDER BY sales DESC

-- 3.4

SELECT YEAR(o.OrderDate) AS "Year", MONTH(o.OrderDate) AS "Month", FORMAT(o.OrderDate, 'MMM-yy') AS "Year-Month", AVG(CAST(DATEDIFF(d, o.OrderDate, o.ShippedDate) AS Decimal(4,2))) AS "Average Number of Ship Days"
FROM Orders o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), FORMAT(o.OrderDate, 'MMM-yy')
ORDER BY 1, 2