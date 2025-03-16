CREATE DATABASE Airport

USE Airport

CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	FullName VARCHAR(100) NOT NULL UNIQUE,
	Email VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Pilots
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL UNIQUE,
	LastName VARCHAR(30) NOT NULL UNIQUE,
	Age TINYINT NOT NULL CHECK(Age >= 21 AND Age <= 62),
	Rating FLOAT CHECK(Rating >= 0.0 AND Rating <= 10.0)
)

CREATE TABLE AircraftTypes
(
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30) NOT NULL UNIQUE
)

CREATE TABLE Airports
(
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) NOT NULL UNIQUE,
	Country VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE Aircraft
(
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,
	Condition CHAR(1) NOT NULL,
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft
(
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PilotId INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL
	PRIMARY KEY(AircraftId, PilotId)
)

CREATE TABLE FlightDestinations
(
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	TicketPrice DECIMAL(18, 2) NOT NULL DEFAULT 15
)


INSERT INTO Passengers
SELECT (FirstName + ' ' + LastName) AS FullName, (FirstName + LastName + '@gmail.com') AS Email
FROM Pilots
WHERE Id >= 5 AND Id <= 15


UPDATE Aircraft
 SET Condition = 'A'
 WHERE (Condition = 'C' OR Condition = 'B')
 AND (FlightHours IS NULL OR FlightHours <= 100)
 AND [Year] > 2013


DELETE FROM Passengers
 WHERE LEN(FullName) <= 10


SELECT Manufacturer, Model, FlightHours, Condition
 FROM Aircraft
 ORDER BY FlightHours DESC


SELECT p.FirstName, p.LastName, a.Manufacturer, a.Model, a.FlightHours
 FROM Pilots AS p
 JOIN PilotsAircraft AS pa
 ON p.Id = pa.PilotId
 JOIN Aircraft AS a
 ON a.Id = pa.AircraftId
 WHERE a.FlightHours IS NOT NULL AND
 a.FlightHours < 304
 ORDER BY a.FlightHours DESC, p.FirstName


SELECT TOP(20) fd.Id, fd.[Start], p.FullName, a.AirportName, fd.TicketPrice
 FROM FlightDestinations AS fd
 JOIN Passengers AS p
 ON fd.PassengerId = p.Id
 JOIN Airports AS a
 ON fd.AirportId = a.Id
 WHERE DAY(fd.[Start]) % 2 = 0
 ORDER BY fd.TicketPrice DESC, a.AirportName


SELECT a.Id AS AircraftId, a.Manufacturer, a.FlightHours, COUNT(*) AS FlightDestinationsCount, ROUND(AVG(fd.TicketPrice), 2) AS AvgPrice
 FROM Aircraft AS a
 JOIN FlightDestinations AS fd
 ON a.Id = fd.AircraftId
 GROUP BY a.Id, a.Manufacturer, a.FlightHours
 HAVING COUNT(*) >= 2
 ORDER BY COUNT(*) DESC, a.Id


SELECT p.FullName, COUNT(*) AS CountOfAircraft, SUM(fd.TicketPrice) AS TotalPayed
 FROM Passengers AS p
 JOIN FlightDestinations AS fd
 ON p.Id = fd.PassengerId
 JOIN Aircraft AS a
 ON a.Id = fd.AircraftId
 WHERE SUBSTRING(p.FullName, 2, 1) = 'a'
 GROUP BY p.FullName
 HAVING COUNT(*) > 1


SELECT a.AirportName, fd.[Start] AS DayTime, fd.TicketPrice, p.FullName, aa.Manufacturer, aa.Model
 FROM FlightDestinations AS fd
 JOIN Airports AS a
 ON fd.AirportId = a.Id
 JOIN Passengers AS p
 ON fd.PassengerId = p.Id
 JOIN Aircraft AS aa
 ON fd.AircraftId = aa.Id
 WHERE (DATEPART(HOUR, fd.[Start]) >= 6
 AND DATEPART(HOUR, fd.[Start]) <= 20)
 AND fd.TicketPrice > 2500
 ORDER BY aa.Model
GO


CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS
	BEGIN
		DECLARE @value INT = (SELECT COUNT(*)
		FROM Passengers AS p
		JOIN FlightDestinations AS fd
		ON fd.PassengerId = p.Id
		WHERE p.Email = @email
		GROUP BY p.Id)

		IF(@value IS NULL)
		SELECT @value = 0

		RETURN @value
	END
GO


SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')
GO


CREATE PROC usp_SearchByAirportName(@airportName VARCHAR(70))
AS
	BEGIN
		SELECT a.AirportName, p.FullName, 
		 CASE
		  WHEN fd.TicketPrice <= 400 THEN 'Low'
		  WHEN fd.TicketPrice >= 401 AND fd.TicketPrice <= 1500 THEN 'Medium'
		  ELSE 'High'
		 END AS LevelOfTickerPrice, aa.Manufacturer, aa.Condition, at.TypeName
		 FROM Airports AS a
		 JOIN FlightDestinations AS fd
		 ON a.Id = fd.AirportId
		 JOIN Aircraft AS aa
		 ON aa.Id = fd.AircraftId
		 JOIN AircraftTypes AS [at]
		 ON [at].Id = aa.TypeId
		 JOIN Passengers AS p
		 ON p.Id = fd.PassengerId
		 WHERE a.AirportName = @airportName
		 ORDER BY aa.Manufacturer, p.FullName
	END

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'