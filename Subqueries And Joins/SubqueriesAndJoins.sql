USE SoftUni

SELECT TOP(5) e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText 
 FROM Employees AS e JOIN Addresses AS a 
 ON e.AddressID = a.AddressID 
ORDER BY a.AddressID

SELECT TOP(50) e.FirstName, e.LastName, t.[Name], a.AddressText 
 FROM Addresses AS a JOIN Towns AS t 
 ON a.TownID = t.TownID
 JOIN Employees AS e
 ON e.AddressID = a.AddressID
ORDER BY e.FirstName, e.LastName

SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name AS [DepartmentName]
 FROM Employees AS e 
 JOIN Departments AS d 
 ON e.DepartmentID = d.DepartmentID
 WHERE e.DepartmentID = 3
ORDER BY e.EmployeeID

SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.Name AS [DepartmentName]
 FROM Employees AS e 
 JOIN Departments AS d 
 ON e.DepartmentID = d.DepartmentID
 WHERE e.Salary > 15000
ORDER BY d.DepartmentID

SELECT TOP(3) e.EmployeeID, e.FirstName
 FROM Employees AS e 
 FULL JOIN EmployeesProjects AS ep
 ON e.EmployeeID = ep.EmployeeID
 WHERE ep.EmployeeID IS NULL
ORDER BY e.EmployeeID

SELECT e.FirstName, e.LastName, e.HireDate, d.Name AS [DeptName]
 FROM Employees AS e 
 JOIN Departments AS d 
 ON e.DepartmentID = d.DepartmentID
 WHERE (e.HireDate > '1999-1-1')
 AND (e.DepartmentID = 3 OR e.DepartmentID = 10)
ORDER BY e.HireDate

SELECT TOP(5) e.EmployeeID, e.FirstName, p.Name AS ProjectName
 FROM Projects AS p
 JOIN EmployeesProjects AS ep
 ON p.ProjectID = ep.ProjectID
 JOIN Employees AS e 
 ON e.EmployeeID = ep.EmployeeID
 WHERE (p.StartDate > '2002-8-13')
 AND (p.EndDate IS NULL)
ORDER BY e.EmployeeID

SELECT e.EmployeeID, e.FirstName,
(CASE
 WHEN p.StartDate >= '2005-1-1' THEN NULL
 ELSE p.Name
END) AS ProjectName
 FROM Projects AS p
 JOIN EmployeesProjects AS ep
 ON p.ProjectID = ep.ProjectID
 JOIN Employees AS e 
 ON e.EmployeeID = ep.EmployeeID
 WHERE e.EmployeeID = 24

SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName AS ManagerName
 FROM Employees AS e
 JOIN Employees AS m
 ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
 ORDER BY e.EmployeeID

SELECT TOP(50) e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName), CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName, d.Name AS DepartmentName
 FROM Employees AS e
 JOIN Departments AS d
 ON e.DepartmentID = d.DepartmentID
 JOIN Employees AS m
 ON e.ManagerID = m.EmployeeID
 ORDER BY e.EmployeeID

SELECT MIN(a.AverageSalary) AS MinAverageSalary FROM
(SELECT e.DepartmentID, AVG(e.Salary) AS AverageSalary 
FROM Employees AS e
GROUP BY e.DepartmentID) AS a


USE [Geography]

SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM MountainsCountries AS mc
JOIN Countries AS c
ON mc.CountryCode = c.CountryCode
JOIN Mountains AS m
ON mc.MountainId = m.Id
JOIN Peaks AS p
ON p.MountainId = m.Id
WHERE c.CountryName = 'Bulgaria'
AND p.Elevation > 2835
ORDER BY p.Elevation DESC

SELECT CountryCode, COUNT(MountainId) AS MountainRanges
FROM MountainsCountries
WHERE CountryCode IN (SELECT CountryCode 
FROM Countries
WHERE CountryName IN ('United States', 'Russia', 'Bulgaria'))
GROUP BY CountryCode

SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

SELECT ContinentCode, CurrencyCode, CurrencyUsage FROM
(SELECT *, DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC) AS CurrencyRank FROM
(SELECT ContinentCode, CurrencyCode, COUNT(*) AS CurrencyUsage
FROM Countries
GROUP BY ContinentCode, CurrencyCode
HAVING COUNT(*) > 1) AS CurrencyUsageSubquery) AS CurrencyRankingSubquery
WHERE CurrencyRank = 1

SELECT COUNT(c.CountryCode)
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
ON mc.MountainId = m.Id
WHERE m.MountainRange IS NULL

SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS HighestPeakElevation, MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks AS p
ON mc.MountainId = p.MountainId
LEFT JOIN CountriesRivers AS cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName

SELECT TOP(5) CountryName AS Country,
CASE
 WHEN PeakName IS NULL THEN '(no highest peak)'
 ELSE PeakName
END 
AS [Highest Peak Name],
CASE
 WHEN Elevation IS NULL THEN 0
 ELSE Elevation
END
AS [Highest Peak Elevation],
CASE
 WHEN MountainRange IS NULL THEN '(no mountain)'
 ELSE MountainRange
END
AS Mountain
FROM
(SELECT c.CountryName, p.PeakName, p.Elevation, m.MountainRange, DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS PeakRank
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m
ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p
ON mc.MountainId = p.MountainId) AS PeakRankingSubquery
WHERE PeakRank = 1
ORDER BY Country, [Highest Peak Name]