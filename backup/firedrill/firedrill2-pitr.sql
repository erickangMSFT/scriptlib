-- Description: Firedrill scenario 2: recover data from an accidental table data deletion
-- Author: Eric Kang

-- ***************************
-- Prep
--

-- clean up
USE [master]
GO
ALTER DATABASE [SuperHeroDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE IF EXISTS [SuperHeroDB];
GO

ALTER DATABASE [SuperHeroDB_Tail] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE IF EXISTS [SuperHeroDB_Tail];
GO

-- in Terminal, run following commands
-- docker exec -i -t b855c869a707 /bin/bash
-- rm -rf /var/opt/mssql/backup/SuperHeroDB*

-- init
CREATE DATABASE [SuperHeroDB];
GO

USE [SuperHeroDB];
GO
-- Create Hero table
CREATE TABLE [dbo].[Heroes]
(
 [HeroId] [int] NOT NULL,
 [FirstName] [nvarchar](50) NOT NULL,
 [LastName] [nvarchar](50) NOT NULL, 
 [Email] [nvarchar](50) NOT NULL,
 [City] [nvarchar](50) NULL,
 [MobileNumber] [nvarchar](50) NOT NULL
 PRIMARY KEY CLUSTERED ([HeroId] ASC) ON [PRIMARY]
);
GO

-- Take a full backup
BACKUP DATABASE [SuperHeroDB] TO DISK = N'/var/opt/mssql/backup/SuperHeroDB.bak' WITH INIT;
GO

-- Insert sample data into 'Heroes' table
INSERT INTO [dbo].[Heroes]([HeroId],[FirstName],[LastName],[Email],[City],[MobileNumber])
VALUES
(1, 'Thor', 'Odinson', 'thor@gmail.com', 'Asgard', '0102234455'),
(2, 'Tony', 'Stark', 'ironman@outlook.com', 'Los Angeles', '2131206339'),
(3, 'Natalia', 'Romanova', 'blackwidow@live.com', 'Stalingrad', '8846050681'),
(4, 'Bruce', 'Banner', 'hulk@gmail.com', 'Dayton', '9373846910'),
(5, 'Clint', 'Barton', 'hawkeye@naver.com', 'Secret', '0104452321')
GO

-- Dump and check Hero records
SELECT [FirstName], [LastName], [Email], [MobileNumber] FROM Heroes;
GO

-- ********
-- Wait a couple of minutes...
-- ACCIDENTAL DELETION OF OUR HEROES!!!! 
-- Write down the time of this incident before executing truncation

TRUNCATE TABLE dbo.Heroes;
GO
SELECT [FirstName], [LastName], [Email], [MobileNumber] FROM Heroes;
GO

-- Taks a transaction log backup: this is mostly performed by an agent job.
BACKUP LOG [SuperHeroDB] TO DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log.bak' WITH INIT;
GO

-- Insert some more information 
INSERT INTO [dbo].[Heroes]([HeroId],[FirstName],[LastName],[Email],[City],[MobileNumber])
VALUES
(6, 'Gil-dong', 'Hong', 'honggildong@outlook.com', 'Seoul', '010332022')
GO
SELECT [FirstName], [LastName], [Email], [MobileNumber] FROM Heroes;
GO

-- At this point, your app / customer noticed something has gone wrong and reported it.

-- ************
-- Recover the lost data with PITR
--

-- Take a tail-log backup to save Hong Gil-Dong later.
USE master
GO
ALTER DATABASE [SuperHeroDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
BACKUP LOG [SuperHeroDB] TO DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log_Tail.bak' WITH INIT, NO_TRUNCATE, NORECOVERY;
GO

RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB.bak';
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log.bak';
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log_Tail.bak';
GO

-- Restore full backup
RESTORE DATABASE [SuperHeroDB]
FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB.bak'
WITH NORECOVERY;

-- Restore log backup STOPAT 
RESTORE LOG [SuperHeroDB]
FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log.bak'
WITH NORECOVERY, STOPAT = N'2017-05-12T02:44:00'; -- This is UTC time

-- Finish Restore
RESTORE DATABASE [SuperHeroDB]
WITH RECOVERY
GO

ALTER DATABASE [SuperHeroDB] 
SET MULTI_USER;

-- ** Saving Hong Gil-Dong

-- Restore full backup
RESTORE DATABASE [SuperHeroDB_Tail]
FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB.bak'
WITH NORECOVERY,
MOVE N'SuperHeroDB' TO N'/var/opt/mssql/data/SuperHeroDB_Tail.mdf',
MOVE N'SuperHeroDB_log' TO N'/var/opt/mssql/data/SuperHeroDB_Tail.ldf';

-- Restore log backup STOPAT 
RESTORE LOG [SuperHeroDB_Tail]
FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log.bak'
WITH NORECOVERY;

-- Restore tail-log backup 
RESTORE LOG [SuperHeroDB_Tail]
FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log_Tail.bak'
WITH RECOVERY;

ALTER DATABASE [SuperHeroDB_Tail] 
SET MULTI_USER;

USE [SuperHeroDB_Tail];
GO
SELECT [HeroId], [FirstName], [LastName], [Email], [MobileNumber] FROM Heroes;
GO

USE [SuperHeroDB]
GO
SELECT [HeroId], [LastName], [Email], [MobileNumber] FROM Heroes;
GO

-- Merge upsert data from tail-log backup
MERGE dbo.Heroes AS T
USING (SELECT h.HeroId, h.FirstName, h.LastName, h.Email, h.MobileNumber FROM SuperHeroDB_Tail.dbo.HEROES as h) S
ON (T.HeroId = S.HeroId)
WHEN MATCHED THEN
    UPDATE SET  T.FirstName = S.FirstName,
                T.LastName = S.LastName,
                T.Email = S.Email,
                T.MobileNumber = S.MobileNumber
WHEN NOT MATCHED THEN
    INSERT (HeroId, FirstName, LastName, Email, MobileNumber)
    VALUES (S.HeroId, S.FirstName, S.LastName, S.Email, S.MobileNumber);
GO

-- Check the result
SELECT [HeroId], [FirstName], [LastName], [Email], [MobileNumber] FROM Heroes;
GO

