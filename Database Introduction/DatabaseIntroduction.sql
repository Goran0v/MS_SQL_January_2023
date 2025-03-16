CREATE DATABASE [Minions]

USE [Minions]

CREATE TABLE Minions
(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(100),
	Age INT
)

CREATE TABLE Towns
(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(100)
)

ALTER TABLE Minions
	ADD [TownId] INT FOREIGN KEY REFERENCES Towns(Id)

INSERT INTO Towns
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions
VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)

--USE [Master]
--DROP DATABASE Minions

TRUNCATE TABLE [Minions]

DROP TABLE Minions
DROP TABLE Towns

CREATE TABLE People
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(2048),
	Height FLOAT,
	[Weight] FLOAT,
	Gender CHAR(1),
	Birthdate DATETIME2 NOT NULL,
	Biography VARCHAR(MAX)
)

INSERT INTO People
VALUES
('Petar1', null, 1.48, 66.50, 'm', '10-12-2022', 'sadasd'),
('Petar2', null, 1.49, 67.50, 'f','11-12-2022', 'sadasd'),
('Petar3', null, 1.47, 68.50, 'm', '12-12-2022', 'sadasd'),
('Petar4', null, 1.45, 69.50, 'f', '10-12-2022', 'sadasd'),
('Petar5', null, 1.46, 65.50, 'm', '11-12-2022', 'sadasd')

CREATE TABLE Users
(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),
	LastLoginTime DATETIME2,
	IsDeleted BIT
)

INSERT INTO Users
VALUES
('Petar1', '1234567', null, '10-12-2022', 0),
('Petar2', '1234567', null, '11-12-2022', 1),
('Petar3', '1234567', null, '12-12-2022', 0),
('Petar4', '1234567', null, '10-12-2022', 1),
('Petar5', '1234567', null, '11-12-2022', 0)

ALTER TABLE [Users] DROP CONSTRAINT PK__Users__3214EC07A8D7B07A
ALTER TABLE [Users] ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Username)

ALTER TABLE [Users] ADD CONSTRAINT CHK_PasswordMinLength CHECK(LEN([Password]) >= 5)

ALTER TABLE [Users] ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR [LastLoginTime]

ALTER TABLE [Users] DROP CONSTRAINT PK_IdUsername

ALTER TABLE [Users] ADD CONSTRAINT PK_Id PRIMARY KEY (Id)

ALTER TABLE [Users] ADD CONSTRAINT UC_Username UNIQUE (Username)

ALTER TABLE [Users] ADD CONSTRAINT CHK_UsernameMinLength CHECK(LEN(Username) >= 3)


CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees
(
	Id INT PRIMARY KEY, 
	FirstName NVARCHAR(100) NOT NULL, 
	LastName NVARCHAR(100) NOT NULL, 
	Title NVARCHAR(50), 
	Notes NVARCHAR(MAX)
)

INSERT INTO Employees
VALUES
(1, 'a', 'b', null, null),
(2, 'a', 'b', null, null),
(3, 'a', 'b', null, null)

CREATE TABLE Customers
(
	AccountNumber INT PRIMARY KEY, 
	FirstName NVARCHAR(100) NOT NULL, 
	LastName NVARCHAR(100) NOT NULL, 
	PhoneNumber CHAR(10) NOT NULL, 
	EmergencyName NVARCHAR(100) NOT NULL, 
	EmergencyNumber CHAR(10) NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Customers
VALUES
(1, 'a', 'b', '9', 'e', '2', null),
(2, 'a', 'b', '9', 'e', '2', null),
(3, 'a', 'b', '9', 'e', '2', null)

CREATE TABLE RoomStatus
(
	RoomStatus NVARCHAR(10) NOT NULL, 
	Notes NVARCHAR(MAX)
)

INSERT INTO RoomStatus
VALUES
('a', null),
('n', null),
('p', null)

CREATE TABLE RoomTypes
(
	RoomType NVARCHAR(10) NOT NULL, 
	Notes NVARCHAR(MAX)
)

INSERT INTO RoomTypes
VALUES
('a', null),
('n', null),
('p', null)

CREATE TABLE BedTypes
(
	BedType NVARCHAR(10) NOT NULL, 
	Notes NVARCHAR(MAX)
)

INSERT INTO BedTypes
VALUES
('a', null),
('n', null),
('p', null)

CREATE TABLE Rooms
(
	RoomNumber INT PRIMARY KEY, 
	RoomType NVARCHAR(10) NOT NULL, 
	BedType NVARCHAR(10) NOT NULL, 
	Rate TINYINT, 
	RoomStatus NVARCHAR(10) NOT NULL, 
	Notes NVARCHAR(MAX)
)

INSERT INTO Rooms
VALUES
(1, 'a', 'a', 2, 'n', null),
(2, 'a', 'a', 2, 'n', null),
(3, 'a', 'a', 2, 'n', null)

CREATE TABLE Payments
(
	Id INT PRIMARY KEY, 
	EmployeeId INT NOT NULL,
	PaymentDate DATETIME2,
	AccountNumber INT NOT NULL,
	FirstDateOccupied DATETIME2,
	LastDateOccupied DATETIME2, 
	TotalDays TINYINT, 
	AmountCharged DECIMAL(15,2), 
	TaxRate INT,
	TaxAmount DECIMAL(15,2),
	PaymentTotal DECIMAL(15,2), 
	Notes NVARCHAR(MAX)
)

INSERT INTO Payments
VALUES
(1, 4, null, 5, null, null, 2, 20.6, 3, 10, 30.6, null),
(2, 4, null, 5, null, null, 2, 20.6, 3, 10, 30.6, null),
(3, 4, null, 5, null, null, 2, 20.6, 3, 10, 30.6, null)

UPDATE Payments
SET TaxRate = TaxRate * 0.97

SELECT [TaxRate] FROM Payments

CREATE TABLE Occupancies 
(
	Id INT PRIMARY KEY,  
	EmployeeId INT NOT NULL,
	DateOccupied DATETIME2,
	AccountNumber INT NOT NULL,
	RoomNumber INT NOT NULL, 
	RateApplied INT,
	PhoneCharge DECIMAL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Occupancies
VALUES
(1, 4, null, 5, 2, 3, 20.6, null),
(2, 4, null, 5, 2, 3, 20.6, null),
(3, 4, null, 5, 2, 3, 20.6, null)

DELETE FROM Occupancies

CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors
(
	Id INT PRIMARY KEY,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Directors
VALUES
(1, 'Gosho', null),
(2, 'Gosho', null),
(3, 'Gosho', null),
(4, 'Gosho', null),
(5, 'Gosho', null)

CREATE TABLE Genres
(
	Id INT PRIMARY KEY,
	GenreName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Genres
VALUES
(1, 'Horror', null),
(2, 'Horror', null),
(3, 'Horror', null),
(4, 'Horror', null),
(5, 'Horror', null)

CREATE TABLE Categories 
(
	Id INT PRIMARY KEY,
	CategoryName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(MAX)
)

INSERT INTO Categories
VALUES
(1, 'Horror', null),
(2, 'Horror', null),
(3, 'Horror', null),
(4, 'Horror', null),
(5, 'Horror', null)

CREATE TABLE Movies 
(
	Id INT PRIMARY KEY, 
	Title NVARCHAR(100) NOT NULL, 
	DirectorId INT NOT NULL,
	CopyrightYear DATETIME2,
	[Length] INT NOT NULL,
	GenreId INT NOT NULL,
	CategoryId INT NOT NULL, 
	Rating INT, 
	Notes NVARCHAR(MAX)
)

INSERT INTO Movies
VALUES
(1, 'd', 4, null, 5, 6, 7, null, null),
(2, 'Horror', 4, null, 5, 6, 7, null, null),
(3, 'Horror', 4, null, 5, 6, 7, null, null),
(4, 'Horror', 4, null, 5, 6, 7, null, null),
(5, 'Horror', 4, null, 5, 6, 7, null, null)


CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories
(
	Id INT PRIMARY KEY,
	CategoryName NVARCHAR(100) NOT NULL,
	DailyRate TINYINT NOT NULL,
	WeeklyRate TINYINT NOT NULL,
	MonthlyRate TINYINT NOT NULL,
	WeekendRate TINYINT NOT NULL
)

INSERT INTO Categories
VALUES
(1, 'Name', 2, 3, 4, 5),
(2, 'Name', 2, 3, 4, 5),
(3, 'Name', 2, 3, 4, 5)

CREATE TABLE Cars
(
	Id INT PRIMARY KEY,
	PlateNumber INT NOT NULL,
	Manufacturer NVARCHAR(100) NOT NULL,
	Model NVARCHAR(100) NOT NULL,
	CarYear DATETIME2,
	CategoryId INT NOT NULL,
	Doors TINYINT NOT NULL,
	Picture VARBINARY(MAX),
	Condition NVARCHAR(100) NOT NULL,
	Available NVARCHAR(100) NOT NULL
)

INSERT INTO Cars
VALUES
(1, 56, 'Name', 'Name', null, 2, 4, null, 'good', 'a'),
(2, 56, 'Name', 'Name', null, 2, 4, null, 'good', 'a'),
(3, 56, 'Name', 'Name', null, 2, 4, null, 'good', 'a')

CREATE TABLE Employees
(
	Id INT PRIMARY KEY,
	FirstName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
	Title NVARCHAR(100), 
	Notes NVARCHAR(MAX)
)

INSERT INTO Employees
VALUES
(1, 'Name', 'Name', null, null),
(2, 'Name', 'Name', null, null),
(3, 'Name', 'Name', null, null)

CREATE TABLE Customers
(
	Id INT PRIMARY KEY, 
	DriverLicenceNumber INT NOT NULL, 
	FullName NVARCHAR(100) NOT NULL, 
	[Address] NVARCHAR(100) NOT NULL, 
	City NVARCHAR(100) NOT NULL,
	ZIPCode TINYINT NOT NULL, 
	Notes NVARCHAR(MAX)
)

INSERT INTO Customers
VALUES
(1, 44, 'Name', 'Name', 'Name', 55, null),
(2, 44, 'Name', 'Name', 'Name', 55, null),
(3, 44, 'Name', 'Name', 'Name', 55, null)

CREATE TABLE RentalOrders 
(
	Id INT PRIMARY KEY,
	EmployeeId INT NOT NULL,
	CustomerId INT NOT NULL, 
	CarId INT NOT NULL, 
	TankLevel INT NOT NULL,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage INT NOT NULL,
	StartDate DATETIME2,
	EndDate DATETIME2,
	TotalDays TINYINT NOT NULL,
	RateApplied TINYINT NOT NULL,
	TaxRate TINYINT NOT NULL,
	OrderStatus CHAR(10),
	Notes NVARCHAR(MAX)
)

INSERT INTO RentalOrders
VALUES
(1, 56, 43, 22, 5, 1234, 1324, 3333, null, null, 6, 7, 4, null, null),
(2, 56, 43, 22, 6, 1232, 2234, 3333, null, null, 6, 7, 4, null, null),
(3, 56, 43, 22, 7, 2332, 2444, 3333, null, null, 6, 7, 4, null, null)


CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	AddressText NVARCHAR(100) NOT NULL,
	TownId INT NOT NULL
)

CREATE TABLE Departments
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(100) NOT NULL,
	MiddleName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL, 
	JobTitle NVARCHAR(100) NOT NULL,
	DepartmentId NVARCHAR(100) NOT NULL,
	HireDate DATETIME2 NOT NULL, 
	Salary DECIMAL NOT NULL
)

INSERT INTO Towns
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO Employees
VALUES
('Petar', 'Petrov', 'Petrov', '.NET Developer', 'Software Development', '01/02/2013', 3500.00),
('Ivan', 'Ivanov', 'Ivanov', 'Senior Engineer', 'Engineering', '02/03/2004', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 'Quality Assurance', '08/28/2016', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 'Sales', '09/12/2007', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 'Marketing', '08/28/2016', 599.88)

SELECT * FROM Towns ORDER BY [Name]

SELECT * FROM Departments ORDER BY [Name]

SELECT * FROM Employees ORDER BY Salary DESC

SELECT [Name] FROM Towns ORDER BY [Name]

SELECT [Name] FROM Departments ORDER BY [Name]

SELECT [FirstName],[LastName],[JobTitle],[Salary] FROM Employees ORDER BY Salary DESC

