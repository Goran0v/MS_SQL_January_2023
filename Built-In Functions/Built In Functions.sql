SELECT FirstName, LastName 
 FROM Employees 
WHERE FirstName 
 LIKE 'Sa%'

SELECT FirstName, LastName 
 FROM Employees 
WHERE LastName 
 LIKE '%ei%'

SELECT FirstName 
 FROM Employees 
WHERE (DepartmentID = 3 OR DepartmentID = 10) 
 AND 
 (YEAR(HireDate) >= 1995 AND YEAR(HireDate) <= 2005)

SELECT FirstName, LastName 
 FROM Employees 
WHERE JobTitle NOT LIKE '%engineer%'

SELECT [Name]
 FROM Towns
WHERE LEN([Name]) = 5 
 OR LEN([Name]) = 6
ORDER BY [Name]

SELECT TownID, [Name]
 FROM Towns
WHERE [Name] LIKE 'M%' 
 OR [Name] LIKE 'K%' 
 OR [Name] LIKE 'B%' 
 OR [Name] LIKE 'E%'
ORDER BY [Name]

SELECT TownID, [Name]
 FROM Towns
WHERE ([Name] NOT LIKE 'R%')
 AND ([Name] NOT LIKE 'B%')
 AND ([Name] NOT LIKE 'D%')
ORDER BY [Name]
GO

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName 
FROM Employees 
WHERE YEAR(HireDate) > 2000
GO

SELECT FirstName, LastName 
 FROM Employees 
WHERE LEN(LastName) = 5

SELECT * FROM
(SELECT EmployeeID, FirstName, LastName, Salary
,DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID) 
AS Rank
FROM Employees 
WHERE Salary BETWEEN 10000 AND 50000) 
AS RankingSubquery 
WHERE Rank = 2
ORDER BY Salary DESC


USE [Geography]

SELECT CountryName AS [Country Name]
 ,IsoCode AS [ISO Code] 
 FROM Countries 
WHERE (LOWER(CountryName) LIKE '%a%a%a%') 
 ORDER BY [ISO Code]

SELECT p.PeakName, r.RiverName,
 LOWER(CONCAT(SUBSTRING(p.PeakName, 1, LEN(p.PeakName) - 1), r.RiverName)) AS Mix
 FROM Peaks AS p, Rivers AS r
WHERE RIGHT(LOWER(p.PeakName), 1) = LEFT(LOWER(r.RiverName), 1)
ORDER BY Mix


USE Diablo

SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
 FROM Games
WHERE YEAR([Start]) = 2011 OR
 YEAR([Start]) = 2012
ORDER BY [Start], [Name]

SELECT Username
 ,SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email) - CHARINDEX('@', Email)) 
 AS [Email Provider] 
 FROM Users
ORDER BY [Email Provider], Username

SELECT Username, IpAddress 
 FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

SELECT [Name] AS Game, 
  CASE 
	WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
	WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
	ElSE 'Evening'
  END
 AS [Part of the day],
  CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration >= 4 AND Duration <= 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	ELSE 'Extra Long'
  END
 AS Duration
 FROM Games 
ORDER BY Game, Duration, [Part of the day]

SELECT ProductName, OrderDate, (DATEADD(DAY, 3, OrderDate)) AS [Pay Due], (DATEADD(MONTH, 1, OrderDate)) AS [Deliver Due]
FROM Orders