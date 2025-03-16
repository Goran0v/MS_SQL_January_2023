USE Bank

CREATE TABLE Logs (
  LogId INT PRIMARY KEY IDENTITY,
  AccountId INT,
  OldSum MONEY,
  NewSum MONEY
)
GO

CREATE TRIGGER InsertNewEntryIntoLogs
  ON Accounts
  AFTER UPDATE
AS
  INSERT INTO Logs
  VALUES (
    (SELECT Id
     FROM inserted),
    (SELECT Balance
     FROM deleted),
    (SELECT Balance
     FROM inserted)
  )
GO


CREATE TABLE NotificationEmails
(
  Id INT PRIMARY KEY IDENTITY,
  Recipient INT FOREIGN KEY REFERENCES Accounts(Id),
  [Subject] VARCHAR(100) NOT NULL,
  Body VARCHAR(100) NOT NULL
)
GO

CREATE TRIGGER tr_EmailsNotificationsAfterInsert
ON Logs AFTER INSERT 
AS
BEGIN
INSERT INTO NotificationEmails(Recipient,Subject,Body)
SELECT i.AccountID, 
CONCAT('Balance change for account: ',i.AccountId),
CONCAT('On ',GETDATE(),' your balance was changed from ',i.NewSum,' to ',i.OldSum)
  FROM inserted AS i
END
GO


CREATE PROC usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
BEGIN TRANSACTION
	IF(@MoneyAmount > 0)
	UPDATE Accounts SET Balance += @MoneyAmount
	WHERE Id = @AccountId
COMMIT
GO


CREATE PROC usp_WithdrawMoney(@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
BEGIN TRANSACTION
	IF(@MoneyAmount > 0)
	UPDATE Accounts SET Balance -= @MoneyAmount
	WHERE Id = @AccountId
COMMIT
GO


CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18,4))
AS
BEGIN TRANSACTION
	IF(@Amount > 0)
		UPDATE Accounts 
		SET Balance += @Amount
		WHERE Id = @ReceiverId

		UPDATE Accounts 
		SET Balance -= @Amount
		WHERE Id = @SenderId
	IF(@Amount <= 0)
		BEGIN
			ROLLBACK
		END
COMMIT
GO


USE Diablo
GO


CREATE TRIGGER tr_UserGameItems_LevelRestriction ON UserGameItems
INSTEAD OF UPDATE
AS
     BEGIN
         IF(
           (
               SELECT Level
               FROM UsersGames
               WHERE Id =
               (
                   SELECT UserGameId
                   FROM inserted
               )
           ) <
           (
               SELECT MinLevel
               FROM Items
               WHERE Id =
               (
                   SELECT ItemId
                   FROM inserted
               )
           ))
             BEGIN
                 RAISERROR('Your current level is not enough', 16, 1);
         END;

/* Assign the new item when the exception isn't thrown */
         INSERT INTO UserGameItems
         VALUES
         (
         (
             SELECT ItemId
             FROM inserted
         ),
         (
             SELECT UserGameId
             FROM inserted
         )
         );
     END;
	 
/* Add bonus cash */
UPDATE ug
  SET
      ug.Cash+=50000
FROM UsersGames AS ug
     JOIN Users AS u ON u.Id = ug.UserId
     JOIN Games AS g ON g.Id = ug.GameId
WHERE u.Username IN('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos')
AND g.Name = 'Bali';

SELECT u.Username, g.Name, ug.Cash, i.Name AS [Item Name] 
FROM UsersGames AS ug
     JOIN Users AS u ON u.Id = ug.UserId
     JOIN Games AS g ON g.Id = ug.GameId
	 JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.GameId
	 JOIN Items AS i ON i.Id = ugi.ItemId
	 WHERE g.Name = 'Bali'
	 AND (u.Username = 'baleremuda' OR u.Username = 'loosenoise' OR u.Username = 'inguinalself' OR u.Username = 'buildingdeltoid' OR u.Username = 'monoxidecos')
	 ORDER BY [Item Name]
GO



USE SoftUni
GO

CREATE PROCEDURE usp_AssignProject (@employeeID int, @projectID int)
AS
BEGIN
  DECLARE @maxEmployeeProjectsCount int = 3;
  DECLARE @employeeProjectsCount int;

  BEGIN TRAN
  INSERT INTO EmployeesProjects (EmployeeID, ProjectID) 
  VALUES (@employeeID, @projectID)

  SET @employeeProjectsCount = (
    SELECT COUNT(*)
    FROM EmployeesProjects
    WHERE EmployeeID = @employeeID
  )
  IF(@employeeProjectsCount > @maxEmployeeProjectsCount)
    BEGIN
      RAISERROR('The employee has too many projects!', 16, 1);
      ROLLBACK;
    END
  ELSE COMMIT
END
GO