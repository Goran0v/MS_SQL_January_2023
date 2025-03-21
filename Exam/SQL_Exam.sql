CREATE DATABASE Boardgames

USE Boardgames

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(100) NOT NULL,
	StreetNumber INT NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)

CREATE TABLE Creators
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL
)

CREATE TABLE PlayersRanges
(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT NULL
)

CREATE TABLE Publishers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL,
	Website NVARCHAR(40),
	Phone NVARCHAR(20)
)

CREATE TABLE Boardgames
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(18, 2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	PublisherId INT FOREIGN KEY REFERENCES Publishers(Id) NOT NULL,
	PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(Id) NOT NULL
)

CREATE TABLE CreatorsBoardgames
(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id) NOT NULL,
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id) NOT NULL,
	PRIMARY KEY(CreatorId, BoardgameId)
)


INSERT INTO Boardgames
VALUES
('Deep Blue', 2019, 5.67, 1, 15, 7),
('Paris', 2016, 9.78, 7, 1, 5),
('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers
VALUES
('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')


UPDATE PlayersRanges
SET PlayersMax += 1
WHERE PlayersMin >= 2 AND PlayersMax <= 2

UPDATE Boardgames
SET [Name] += 'V2'
WHERE YearPublished >= 2020


DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (SELECT b.Id FROM 
(SELECT p.Id FROM Addresses AS a JOIN Publishers AS p ON p.AddressId = a.Id 
WHERE Country = 'USA') AS sq JOIN Boardgames AS b ON b.PublisherId = sq.Id)

DELETE FROM Boardgames
WHERE PublisherId IN (SELECT p.Id FROM Addresses AS a JOIN Publishers AS p ON p.AddressId = a.Id WHERE Country = 'USA')

DELETE FROM Publishers
WHERE AddressId IN (SELECT a.Id FROM Addresses AS a JOIN Publishers AS p ON p.AddressId = a.Id WHERE Country = 'USA')

DELETE FROM Addresses
WHERE Country = 'USA'


SELECT [Name], Rating
FROM Boardgames
ORDER BY YearPublished, [Name] DESC


SELECT b.Id, b.[Name], b.YearPublished, c.[Name] AS CategoryName
FROM Boardgames AS b
JOIN Categories AS c
ON b.CategoryId = c.Id
WHERE c.[Name] = 'Strategy Games'
OR c.[Name] = 'Wargames'
ORDER BY YearPublished DESC


SELECT Id, (FirstName + ' ' + LastName) AS CreatorName, Email
FROM Creators
WHERE Id IN (5, 7)
ORDER BY CreatorName


SELECT TOP(5) b.[Name], Rating, c.[Name] AS CategoryName
FROM Boardgames AS b
JOIN Categories AS c
ON b.CategoryId = c.Id
JOIN PlayersRanges AS pr
ON b.PlayersRangeId = pr.Id
WHERE (b.Rating > 7.00 AND
(b.[Name] LIKE 'a%' OR b.[Name] LIKE '%a%' OR b.[Name] LIKE '%a')) OR
(b.Rating > 7.50 AND pr.PlayersMin >= 2 AND pr.PlayersMax <= 5)
ORDER BY b.[Name], Rating DESC


SELECT (FirstName + ' ' + LastName) AS FullName, Email, MAX(b.Rating)
FROM Creators AS c
JOIN CreatorsBoardgames AS cb
ON c.Id = cb.CreatorId
JOIN Boardgames AS b
ON cb.BoardgameId = b.Id
WHERE SUBSTRING(Email, LEN(Email) - 3, 4) = '.com'
GROUP BY (FirstName + ' ' + LastName), Email
ORDER BY FullName


SELECT c.LastName, CEILING(AVG(b.Rating)) AS AverageRating, p.[Name] AS PublisherName
FROM Creators AS c
JOIN CreatorsBoardgames AS cb
ON c.Id = cb.CreatorId
JOIN Boardgames AS b
ON cb.BoardgameId = b.Id
JOIN Publishers AS p
ON b.PublisherId = p.Id
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC
GO


CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT
AS
	BEGIN
		RETURN (SELECT COUNT(*) FROM Creators AS c JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId WHERE c.FirstName = @name)
	END
GO

SELECT dbo.udf_CreatorWithBoardgames('Bruno')
GO


CREATE PROC usp_SearchByCategory(@category VARCHAR(50))
AS
	BEGIN
		SELECT b.[Name], b.YearPublished, b.Rating, c.[Name] AS CategoryName, p.[Name] AS PublisherName, CONCAT(pr.PlayersMin, ' people') AS MinPlayers, CONCAT(pr.PlayersMax, ' people') AS MaxPlayers
		FROM Categories AS c
		JOIN Boardgames AS b
		ON b.CategoryId = c.Id
		JOIN Publishers AS p
		ON b.PublisherId = p.Id
		JOIN PlayersRanges AS pr
		ON b.PlayersRangeId = pr.Id
		WHERE c.[Name] = @category
		ORDER BY PublisherName, b.YearPublished DESC
	END
GO

EXEC usp_SearchByCategory 'Wargames'