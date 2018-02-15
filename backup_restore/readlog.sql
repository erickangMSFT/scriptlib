<<<<<<< HEAD:backup_restore/readlog.sql
USE master
GO
-- Uncomment the ALTER DATABASE statement below to set the database to SINGLE_USER mode if the drop database command fails because the database is in use.
ALTER DATABASE SuperHeroDB_Read_Log SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- Drop the database if it exists
IF EXISTS (
SELECT name
FROM sys.databases
WHERE name = N'SuperHeroDB_Read_Log'
)
DROP DATABASE SuperHeroDB_Read_Log
GO
CREATE DATABASE [SuperHeroDB_Read_Log];
GO
USE [SuperHeroDB_Read_Log];
GO
-- Create Hero table
CREATE TABLE [dbo].[Heroes]
(
        [HeroId] [int] NOT NULL,
        [FirstName] [nvarchar](50) NOT NULL,
        [LastName] [nvarchar](50) NOT NULL,
        [Email] [nvarchar](50) NOT NULL,
        [City] [nvarchar](50) NULL,
        [MobileNumber] [nvarchar](50) NOT NULL PRIMARY KEY CLUSTERED ([HeroId] ASC) ON [PRIMARY]
);
GO
-- Fullbackup
BACKUP DATABASE [SuperHeroDB_Read_Log] TO DISK = N'/var/opt/mssql/backup/SuperHeroDB_Read_Log.bak' WITH INIT;
GO
-- Insert sample data into 'Heroes' table
INSERT INTO [dbo].[Heroes]
        ([HeroId],[FirstName],[LastName],[Email],[City],[MobileNumber])
VALUES
        (1, 'Thor', 'Odinson', 'thor@gmail.com', 'Asgard', '0102234455'),
        (2, 'Tony', 'Stark', 'ironman@outlook.com', 'Los Angeles', '2131206339'),
        (3, 'Natalia', 'Romanova', 'blackwidow@live.com', 'Stalingrad', '8846050681'),
        (4, 'Bruce', 'Banner', 'hulk@gmail.com', 'Dayton', '9373846910'),
        (5, 'Clint', 'Barton', 'hawkeye@naver.com', 'Secret', '0104452321')
GO
-- Dump and check Hero records
SELECT [FirstName], [LastName], [Email], [MobileNumber]
FROM Heroes;
GO


BACKUP LOG [SuperHeroDB_Read_Log] TO DISK = N'/var/opt/mssql/backup/SuperHeroDB_Read_Log_Log0.bak' WITH INIT;
GO

DELETE FROM Heroes;
GO
SELECT [FirstName], [LastName], [Email], [MobileNumber]
FROM Heroes;
GO
-- Taks a transaction log backup
BACKUP LOG [SuperHeroDB_Read_Log] TO DISK = N'/var/opt/mssql/backup/SuperHeroDB_Read_Log_Log1.bak' WITH INIT;
GO
-- Insert some more information 
INSERT INTO [dbo].[Heroes]
        ([HeroId],[FirstName],[LastName],[Email],[City],[MobileNumber])
VALUES
        (6, 'Gil-dong', 'Hong', 'honggildong@outlook.com', 'Seoul', '010332022')
GO
SELECT [FirstName], [LastName], [Email], [MobileNumber]
FROM Heroes;
GO
-- Taks a transaction log backup
--BACKUP LOG [SuperHeroDB_Read_Log] TO DISK = N'/var/opt/mssql/backup/SuperHeroDB_Read_Log_Log2.bak' WITH INIT;
--GO
-- Reading from online log
SELECT log.[Operation], log.[Current LSN], log.[Begin Time], log.[Transaction ID], log.[Transaction Name], log.[AllocUnitId], log.[AllocUnitName], log.[Description]
FROM fn_dblog(null, null) log
WHERE [Transaction Name] IS NOT NULL
ORDER BY log.[AllocUnitId]
GO
-- Reading from log backup
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Read_Log_Log1.bak';
--RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Read_Log_Log2.bak';
-- undocumented fucntion: fn_dump_dblog
        SELECT [Operation], [Begin Time], [Current LSN], [Transaction ID], [Transaction Name], [PartitionID], [TRANSACTION SID]
        FROM fn_dump_dblog (NULL, NULL, N'DISK', 1, N'/var/opt/mssql/backup/SuperHeroDB_Read_Log_Log1.bak',
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT)
        WHERE [Transaction Name] IS NOT NULL
-- UNION
--         SELECT [Operation], [Begin Time], [Current LSN], [Transaction ID], [Transaction Name], [PartitionID], [TRANSACTION SID]
--         FROM fn_dump_dblog (NULL, NULL, N'DISK', 1, N'/var/opt/mssql/backup/SuperHeroDB_Read_Log_Log2.bak',
-- DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
-- DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
-- DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
-- DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
-- DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT)
--         WHERE [Transaction Name] IS NOT NULL;
=======
USE master
GO
-- Uncomment the ALTER DATABASE statement below to set the database to SINGLE_USER mode if the drop database command fails because the database is in use.

ALTER DATABASE SuperHeroDB_Read_Log SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- Drop the database if it exists
IF EXISTS (
  SELECT name
FROM sys.databases
WHERE name = N'SuperHeroDB_Read_Log'
)
DROP DATABASE SuperHeroDB_Read_Log
GO
CREATE DATABASE [SuperHeroDB_Read_Log];
GO

USE [SuperHeroDB_Read_Log];
GO
-- Create Hero table
CREATE TABLE [dbo].[Heroes]
(

        [HeroId] [int] NOT NULL,
        [FirstName] [nvarchar](50) NOT NULL,
        [LastName] [nvarchar](50) NOT NULL,
        [Email] [nvarchar](50) NOT NULL,
        [City] [nvarchar](50) NULL,
        [MobileNumber] [nvarchar](50) NOT NULL PRIMARY KEY CLUSTERED ([HeroId] ASC) ON [PRIMARY]
);
GO
-- Insert sample data into 'Heroes' table
INSERT INTO [dbo].[Heroes]
        ([HeroId],[FirstName],[LastName],[Email],[City],[MobileNumber])
VALUES
        (1, 'Thor', 'Odinson', 'thor@gmail.com', 'Asgard', '0102234455'),
        (2, 'Tony', 'Stark', 'ironman@outlook.com', 'Los Angeles', '2131206339'),
        (3, 'Natalia', 'Romanova', 'blackwidow@live.com', 'Stalingrad', '8846050681'),
        (4, 'Bruce', 'Banner', 'hulk@gmail.com', 'Dayton', '9373846910'),
        (5, 'Clint', 'Barton', 'hawkeye@naver.com', 'Secret', '0104452321')
GO
-- Dump and check Hero records
SELECT [FirstName], [LastName], [Email], [MobileNumber]
FROM Heroes;
GO
DELETE FROM Heroes;
GO
SELECT [FirstName], [LastName], [Email], [MobileNumber]
FROM Heroes;
GO
-- Insert some more information 
INSERT INTO [dbo].[Heroes]
        ([HeroId],[FirstName],[LastName],[Email],[City],[MobileNumber])
VALUES
        (6, 'Gil-dong', 'Hong', 'honggildong@outlook.com', 'Seoul', '010332022')
GO
SELECT [FirstName], [LastName], [Email], [MobileNumber]
FROM Heroes;
GO
-- Reading from online log
SELECT log.[Operation], log.[Current LSN], log.[Begin Time], log.[Transaction ID], log.[Transaction Name], log.[AllocUnitId], log.[AllocUnitName], log.[Description]
FROM fn_dblog(null, null) log
WHERE [Transaction Name] IS NOT NULL
ORDER BY log.[AllocUnitId]
GO
-- Reading from log backup
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log.bak';
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/SuperHeroDB_Log_Tail.bak';
-- undocumented fucntion: fn_dump_dblog
SELECT [Operation], [Begin Time], [Current LSN], [Transaction ID], [Transaction Name], [PartitionID], [TRANSACTION SID]

FROM fn_dump_dblog (NULL, NULL, N'DISK', 1, N'/var/opt/mssql/backup/SuperHeroDB_Log.bak',
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT)
WHERE [Transaction Name] IS NOT NULL;
>>>>>>> master:backup/firedrill/readlog.sql
