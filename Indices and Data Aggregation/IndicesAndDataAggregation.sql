USE Gringotts

SELECT COUNT(*) 
 From WizzardDeposits

SELECT MAX(wd.MagicWandSize) AS LongestMagicWand
 FROM WizzardDeposits AS wd

SELECT wd.DepositGroup, MAX(wd.MagicWandSize) AS LongestMagicWand
 FROM WizzardDeposits AS wd
GROUP BY wd.DepositGroup

SELECT TOP(2) wd.DepositGroup
 FROM WizzardDeposits AS wd
GROUP BY wd.DepositGroup
 ORDER BY AVG(wd.MagicWandSize)

SELECT wd.DepositGroup, SUM(wd.DepositAmount) AS TotalSum
 FROM WizzardDeposits AS wd
GROUP BY wd.DepositGroup

SELECT wd.DepositGroup, SUM(wd.DepositAmount) AS TotalSum
 FROM WizzardDeposits AS wd
WHERE wd.MagicWandCreator = 'Ollivander family'
 GROUP BY wd.DepositGroup

SELECT wd.DepositGroup, SUM(wd.DepositAmount) AS TotalSum
 FROM WizzardDeposits AS wd
WHERE wd.MagicWandCreator = 'Ollivander family'
 GROUP BY wd.DepositGroup
HAVING SUM(wd.DepositAmount) < 150000
 ORDER BY TotalSum DESC

SELECT wd.DepositGroup, wd.MagicWandCreator, MIN(wd.DepositCharge) AS MinDepositCharge
 FROM WizzardDeposits AS wd
 GROUP BY wd.DepositGroup, wd.MagicWandCreator
ORDER BY wd.MagicWandCreator, wd.DepositGroup

SELECT AgeGroup, COUNT(*) AS WizardCount
FROM
(SELECT 
 CASE
  WHEN wd.Age BETWEEN 0 AND 10 THEN '[0-10]'
  WHEN wd.Age BETWEEN 11 AND 20 THEN '[11-20]'
  WHEN wd.Age BETWEEN 21 AND 30 THEN '[21-30]'
  WHEN wd.Age BETWEEN 31 AND 40 THEN '[31-40]'
  WHEN wd.Age BETWEEN 41 AND 50 THEN '[41-50]'
  WHEN wd.Age BETWEEN 51 AND 60 THEN '[51-60]'
  ELSE '[61+]'
 END AS AgeGroup
FROM WizzardDeposits AS wd) AS Subquery
GROUP BY Subquery.AgeGroup

SELECT SUBSTRING(wd.FirstName, 1, 1) AS FirstLetter
 FROM WizzardDeposits AS wd
 WHERE wd.DepositGroup = 'Troll Chest'
 GROUP BY SUBSTRING(wd.FirstName, 1, 1)
 ORDER BY SUBSTRING(wd.FirstName, 1, 1)

SELECT wd.DepositGroup, wd.IsDepositExpired, AVG(DepositInterest) AS AverageInterest
 FROM WizzardDeposits AS wd
 WHERE wd.DepositStartDate > '01/01/1985'
 GROUP BY wd.DepositGroup, wd.IsDepositExpired
 ORDER BY wd.DepositGroup DESC, IsDepositExpired

SELECT SUM(sq.Difference) 
FROM
(SELECT wd1.FirstName AS [Host Wizard], wd1.DepositAmount AS [Host Wizard Deposit], wd2.FirstName AS [Guest Wizard], wd2.DepositAmount AS [Guest Wizard Deposit], wd1.DepositAmount - wd2.DepositAmount AS [Difference]
 FROM WizzardDeposits AS wd1
JOIN WizzardDeposits AS wd2
 ON wd1.Id + 1 = wd2.Id) AS sq


USE SoftUni

SELECT e.DepartmentID, SUM(e.Salary) 
FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY e.DepartmentID

SELECT e.DepartmentID, MIN(e.Salary) AS MinimumSalary
FROM Employees AS e
WHERE e.DepartmentID IN (2, 5, 7)
AND e.HireDate > '01/01/2000'
GROUP BY e.DepartmentID

--
SELECT * INTO [NewEmployees] FROM Employees
WHERE Salary > 30000

DELETE FROM NewEmployees
WHERE ManagerID = 42

UPDATE NewEmployees
SET Salary += 5000
WHERE DepartmentID = 1

SELECT e.DepartmentID, AVG(e.Salary) AS AverageSalary
FROM NewEmployees AS e
GROUP BY e.DepartmentID
--

SELECT e.DepartmentID, MAX(e.Salary) AS MaxSalary
FROM Employees AS e
GROUP BY e.DepartmentID
HAVING MAX(e.Salary) NOT BETWEEN 30000 AND 70000

SELECT COUNT(*)
FROM Employees AS e
WHERE e.ManagerID IS NULL

SELECT DISTINCT DepartmentID, Salary AS ThirdHighestSalary 
FROM
(SELECT e.DepartmentID, e.Salary, DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees AS e) AS SalaryRankingSubquery
WHERE SalaryRank = 3

SELECT TOP(10) e.FirstName, e.LastName, e.DepartmentID
FROM Employees AS e
WHERE e.Salary > (SELECT AVG(es.Salary)
FROM Employees AS es
WHERE e.DepartmentID = es.DepartmentID
GROUP BY es.DepartmentID)
ORDER BY e.DepartmentID