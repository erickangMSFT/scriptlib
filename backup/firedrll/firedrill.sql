-- Drop the database 'FiredrillDB'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Uncomment the ALTER DATABASE statement below to set the database to SINGLE_USER mode if the drop database command fails because the database is in use.
-- ALTER DATABASE FiredrillDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- Drop the database if it exists
IF EXISTS (
  SELECT name
   FROM sys.databases
   WHERE name = N'FiredrillDB'
)
DROP DATABASE FiredrillDB
GO


CREATE DATABASE [FiredrillDB];
GO
USE [FiredrillDB];
GO
 
CREATE TABLE [TestTable] ([C1] INT IDENTITY, [C2] CHAR (100));
GO
 
-- Take a full backup
BACKUP DATABASE [FiredrillDB] TO DISK = N'/var/opt/mssql/backup/FiredrillDB.bak' WITH INIT;
GO
 
-- Insert some rows
INSERT INTO [TestTable] VALUES ('Transaction 1');
INSERT INTO [TestTable] VALUES ('Transaction 2');
GO
 
-- Take a log backup
BACKUP LOG [FiredrillDB] TO DISK = N'/var/opt/mssql/backup/FiredrillDB_Log.bak' WITH INIT;
GO
 
-- Insert some more rows
INSERT INTO [TestTable] VALUES ('Transaction 3');
INSERT INTO [TestTable] VALUES ('Transaction 4');
GO

-- Check the current data
USE FiredrillDB;
GO

SELECT * FROM TestTable
GO

USE master;
GO

-- Change to single user mode and close all active connections.
ALTER DATABASE [FiredrillDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Change database to offline.
ALTER DATABASE [FiredrillDB] SET OFFLINE;
GO

-- Check the database state
USE master;
GO

SELECT db.name, state_desc
FROM sys.databases db
--WHERE db.name = N'FiredrillDB'
GO

-- Delete data file using command
-- e.g. docker exec -i -t <containerid> /bin/bash
-- docker_prompt> rm -rf /var/opt/mssql/data/FiredrillDB.mdf

-- Try to make database online. This will fail.
ALTER DATABASE [FiredrillDB] SET ONLINE;
GO

-- Recovery action
-- Create a tal-log backup

BACKUP LOG [FiredrillDB] TO DISK = N'/var/opt/mssql/backup/FiredrillDB_Log_Tail.bak' WITH INIT, NO_TRUNCATE;
GO

--Check backups

RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/FiredrillDB.bak';
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/FiredrillDB_Log.bak';
RESTORE HEADERONLY FROM DISK = N'/var/opt/mssql/backup/FiredrillDB_Log_Tail.bak';
GO

-- Restore in the following sequence
-- 1. Restore fullbackup WITH NORECOVERY
-- 2. Restore logbackup WITH NORECOVERY
-- 3. Restore tailo-log backup WITH RECOVERY and /or STOPAT for PITR

-- 1. Restore full backup
RESTORE DATABASE [FiredrillDB_recovered] 
FROM DISK = N'/var/opt/mssql/backup/FiredrillDB.bak'
WITH MOVE N'FiredrillDB' TO N'/var/opt/mssql/data/FiredrillDB_recovered.mdf',
    MOVE N'FiredrillDB_log' TO N'/var/opt/mssql/data/FiredrillDB_recovered.ldf',
    NORECOVERY, REPLACE;

-- 2. Restore transaction-log backup
RESTORE LOG [FiredrillDB_recovered] FROM DISK = N'/var/opt/mssql/backup/FiredrillDB_Log.bak' 
WITH NORECOVERY;

-- 3. Restore tail-log backup
RESTORE LOG [FiredrillDB_recovered] FROM DISK = N'/var/opt/mssql/backup/FiredrillDB_Log_Tail.bak'
WITH RECOVERY; 
--STOPAT = N'2017-05-11T17:06:54'
GO

USE [FiredrillDB_recovered] 
GO

SELECT * FROM 
dbo.TestTable
GO

--Cleanup
-- Drop the database 'FiredrillDB_restored'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Uncomment the ALTER DATABASE statement below to set the database to SINGLE_USER mode if the drop database command fails because the database is in use.
ALTER DATABASE FiredrillDB_recovered SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- Drop the database if it exists
IF EXISTS (
  SELECT name
   FROM sys.databases
   WHERE name = N'FiredrillDB_recovered'
)
DROP DATABASE FiredrillDB_recovered
GO