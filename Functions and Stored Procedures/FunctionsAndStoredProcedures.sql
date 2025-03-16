USE SoftUni
GO

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
 SELECT FirstName, LastName
 FROM Employees
 WHERE Salary > 35000
END

EXEC dbo.usp_GetEmployeesSalaryAbove35000
GO

CREATE PROC usp_GetEmployeesSalaryAboveNumber (@Number DECIMAL(18,4))
AS
BEGIN
 SELECT FirstName, LastName
 FROM Employees
 WHERE Salary >= @Number
END

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100
GO


CREATE PROC usp_GetTownsStartingWith (@StartingLetter VARCHAR(50))
AS
BEGIN
 DECLARE @StartingLength INT = LEN(@StartingLetter)
 SELECT [Name] AS Town
 FROM Towns
 WHERE LEFT([Name], @StartingLength) = @StartingLetter
END

EXEC dbo.usp_GetTownsStartingWith 'b'
GO


CREATE PROC usp_GetEmployeesFromTown (@TownName VARCHAR(50))
AS
BEGIN
 SELECT e.FirstName, e.LastName
 FROM Employees AS e
 JOIN Addresses AS a
 ON e.AddressID = a.AddressID
 JOIN Towns AS t
 ON a.TownID = t.TownID
 WHERE t.[Name] = @TownName
END

EXEC dbo.usp_GetEmployeesFromTown 'Sofia'
GO


CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10)
AS
BEGIN
 DECLARE @Level VARCHAR(10) = 'Average'
 IF(@salary < 30000)
 BEGIN
  SET @Level = 'Low'
 END
 ELSE IF(@salary > 50000)
 BEGIN
  SET @Level = 'High'
 END
 RETURN @Level
END
GO

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level] 
FROM Employees
GO


CREATE PROC usp_EmployeesBySalaryLevel(@Level VARCHAR(10))
AS
BEGIN
 SELECT FirstName, LastName
 FROM Employees
 WHERE dbo.ufn_GetSalaryLevel(Salary) = @Level
END

EXEC dbo.usp_EmployeesBySalaryLevel 'High'
GO


CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
	DECLARE @wordIndex INT = 1
	WHILE(@wordIndex <= LEN(@word))
	BEGIN
		DECLARE @currentChar CHAR = SUBSTRING(@word, @wordIndex, 1)
		IF(CHARINDEX(@currentChar, @setOfLetters) = 0)
		BEGIN
			RETURN 0
		END
		
		SET @wordIndex += 1
	END

	RETURN 1
END
GO

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
GO


CREATE PROC usp_DeleteEmployeesFromDepartment(@departmentId INT)
AS
BEGIN
	DECLARE @EmployeesToDelete TABLE (Id INT)
	INSERT INTO @EmployeesToDelete
		SELECT EmployeeID 
		FROM Employees
		WHERE DepartmentID = @departmentId
	
	DELETE
	FROM EmployeesProjects
	WHERE EmployeeID IN (SELECT * FROM @EmployeesToDelete)

	ALTER TABLE Departments
	ALTER COLUMN ManagerId INT

	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT * FROM @EmployeesToDelete)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT * FROM @EmployeesToDelete)

	DELETE
	FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE
	FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees
	WHERE DepartmentID = @departmentId
END
GO


USE Bank
GO

CREATE PROC usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
	FROM AccountHolders
END

EXEC dbo.usp_GetHoldersFullName
GO


CREATE PROC usp_GetHoldersWithBalanceHigherThan(@Num MONEY)
AS
BEGIN
	SELECT ah.FirstName AS [First Name], ah.LastName AS [Last Name]
	FROM AccountHolders AS ah
	JOIN Accounts AS a
	ON ah.Id = a.Id
	WHERE SUM(a.Balance) > 4554
	ORDER BY ah.FirstName, ah.LastName
END

EXEC dbo.usp_GetHoldersWithBalanceHigherThan 5000
GO


CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numOfYears INT)
RETURNS DECIMAL(18, 4)
AS
BEGIN
	RETURN @sum * (POWER(1 + @yearlyInterestRate, @numOfYears))
END
GO

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)
GO


CREATE PROC usp_CalculateFutureValueForAccount(@AccountId INT, @InterestRate FLOAT)
AS
BEGIN
	SELECT a.Id AS [Account Id], ah.FirstName, ah.LastName, a.Balance AS [Current Balance], dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, 5) AS [Balance in 5 years]
	FROM AccountHolders AS ah
	JOIN Accounts AS a
	ON ah.Id = a.Id
	WHERE a.Id = @AccountId
END

EXEC dbo.usp_CalculateFutureValueForAccount 1, 0.1
GO


USE Diablo
GO

CREATE FUNCTION ufn_CashInUsersGames(@GameName VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
	SELECT SUM(Cash) AS SumCash
	FROM
	(SELECT g.Name, ug.Cash, ROW_NUMBER() OVER(ORDER BY ug.Cash DESC) AS RowNumber
	FROM UsersGames AS ug
	JOIN Games AS g
	ON ug.GameId = g.Id
	WHERE g.Name = @GameName) AS RankingSubquery
	WHERE RowNumber % 2 <> 0
)