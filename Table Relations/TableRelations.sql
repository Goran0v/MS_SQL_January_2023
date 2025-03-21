CREATE DATABASE NewDatabase

USE NewDatabase

CREATE TABLE Passports
(
	PassportId INT PRIMARY KEY IDENTITY(101, 1),
	PassportNumber VARCHAR(50) NOT NULL
)

CREATE TABLE Persons
(
	PersonId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,
	Salary DECIMAL(8, 2) NOT NULL,
	PassportId INT FOREIGN KEY REFERENCES Passports(PassportId) UNIQUE NOT NULL
)

INSERT INTO Passports
VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons
VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101)


CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	EstablishedOn DATETIME2 NOT NULL
)

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(50) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) NOT NULL
)

INSERT INTO Manufacturers
VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')

INSERT INTO Models
VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)


CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID),
	PRIMARY KEY(StudentID, ExamID)
)


CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(50) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)


CREATE TABLE Cities
(
	CityID INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE ItemTypes
(
	ItemTypeID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Birthdate DATETIME2 NOT NULL,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Items
(
	ItemID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID) NOT NULL
)

CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID) NOT NULL
)

CREATE TABLE OrderItems
(
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID) NOT NULL,
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
	PRIMARY KEY(ItemID, OrderID)
)


CREATE DATABASE TestDatabase

USE TestDatabase

CREATE TABLE Majors
(
	MajorID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Subjects
(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName VARCHAR(50) NOT NULL
)

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber VARCHAR(20) NOT NULL,
	StudentName VARCHAR(50) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID) NOT NULL
)

CREATE TABLE Agenda
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
	PRIMARY KEY(StudentID, SubjectID)
)

CREATE TABLE Payments
(
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATETIME2 NOT NULL,
	PaymentAmount DECIMAL(8, 2) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
)


USE [Geography]

SELECT m.MountainRange, p.PeakName, p.Elevation 
 FROM Peaks 
   AS p 
    LEFT JOIN Mountains 
   AS m 
  ON p.MountainId = m.Id 
 WHERE m.MountainRange = 'Rila' 
 ORDER BY p.Elevation DESC