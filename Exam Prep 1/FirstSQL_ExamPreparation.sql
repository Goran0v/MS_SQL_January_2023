CREATE DATABASE Zoo

USE Zoo

CREATE TABLE Owners
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50)
)

CREATE TABLE VolunteersDepartments
(
	Id INT PRIMARY KEY IDENTITY,
	DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE AnimalTypes
(
	Id INT PRIMARY KEY IDENTITY,
	AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages
(
	Id INT PRIMARY KEY IDENTITY,
	AnimalTypeId INT FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	OwnerId INT FOREIGN KEY REFERENCES Owners(Id),
	AnimalTypeId INT FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE AnimalsCages
(
	CageId INT FOREIGN KEY REFERENCES Cages(Id) NOT NULL,
	AnimalId INT FOREIGN KEY REFERENCES Animals(Id) NOT NULL
	PRIMARY KEY(CageId, AnimalId)
)

CREATE TABLE Volunteers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50),
	AnimalId INT FOREIGN KEY REFERENCES Animals(Id),
	DepartmentId INT FOREIGN KEY REFERENCES VolunteersDepartments(Id) NOT NULL
)


INSERT INTO Volunteers
VALUES
('Anita Kostova', '0896365412',	'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', null, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233', null, 31, 5)

INSERT INTO Animals
VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', null, 1),
('Tuatara', '2021-06-30', 2, 4)


UPDATE Animals
SET OwnerId = (SELECT Id FROM Owners
WHERE [Name] = 'Kaloqn Stoqnov')
WHERE OwnerId IS NULL


DELETE FROM Volunteers
WHERE DepartmentId = (SELECT Id FROM VolunteersDepartments
WHERE DepartmentName = 'Education program assistant')

DELETE FROM VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'


SELECT [Name], PhoneNumber, [Address], AnimalId, DepartmentId 
 FROM Volunteers
 ORDER BY [Name], AnimalId, DepartmentId


SELECT [Name], AnimalType, FORMAT(BirthDate, 'dd.MM.yyyy')
 FROM Animals AS a
 JOIN AnimalTypes AS [at]
 ON a.AnimalTypeId = [at].Id
 ORDER BY [Name]


SELECT TOP(5) o.[Name] AS [Owner], COUNT(*) AS CountOfAnimals
 FROM Owners AS o
 JOIN Animals AS a
 ON a.OwnerId = o.Id
 GROUP BY o.Name
 ORDER BY CountOfAnimals DESC


SELECT CONCAT(o.[Name], '-', a.[Name]) AS OwnersAnimals, o.PhoneNumber, ac.CageId
 FROM Owners AS o
 JOIN Animals AS a
 ON o.Id = a.OwnerId
 JOIN AnimalTypes AS [at]
 ON a.AnimalTypeId = [at].Id
 JOIN AnimalsCages AS ac
 ON a.Id = ac.AnimalId
 WHERE at.AnimalType = 'Mammals'
 ORDER BY o.[Name], a.[Name] DESC


SELECT v.[Name], v.PhoneNumber, SUBSTRING(TRIM(v.[Address]), 8, 30)
 FROM Volunteers AS v
 JOIN VolunteersDepartments AS vd
 ON v.DepartmentId = vd.Id
 WHERE vd.DepartmentName = 'Education program assistant'
 AND SUBSTRING(LTRIM(v.[Address]), 1, 5) = 'Sofia'
 ORDER BY v.[Name]


SELECT a.[Name], YEAR(a.BirthDate) AS BirthYear, at.AnimalType
 FROM Animals AS a
 JOIN AnimalTypes AS [at]
 ON a.AnimalTypeId = [at].Id
 WHERE OwnerId IS NULL
 AND YEAR(BirthDate) > 2017
 AND at.AnimalType <> 'Birds'
 ORDER BY a.[Name]

GO

CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS
	BEGIN
		RETURN (SELECT COUNT(*)
		FROM VolunteersDepartments AS vd
		JOIN Volunteers AS v
		ON v.DepartmentId = vd.Id
		WHERE DepartmentName = @VolunteersDepartment
		GROUP BY vd.DepartmentName)
	END
GO

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Zoo events')
GO


CREATE PROC usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(30))
AS
	BEGIN
		IF((SELECT a.OwnerId
		FROM Owners AS o
		JOIN Animals AS a
		ON o.Id = a.OwnerId
		WHERE a.[Name] = @AnimalName) IS NULL)
		(SELECT @AnimalName AS [Name], 'For adoption' AS OwnersName)
		ELSE
		(SELECT a.[Name], o.[Name] AS OwnersName
		FROM Owners AS o
		JOIN Animals AS a
		ON o.Id = a.OwnerId
		WHERE a.[Name] = @AnimalName)
	END
GO


EXEC dbo.usp_AnimalsWithOwnersOrNot 'Brown bear'