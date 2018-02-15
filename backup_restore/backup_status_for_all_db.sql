


-- Get backup status for all databases
USE master;
GO
SELECT
    SERVERPROPERTY('MachineName') AS [MACHINE NAME],
    SERVERPROPERTY('InstanceName') AS INSTANCE,
    DB.name AS [DATABASE],
    CASE
        WHEN BK.[type] = 'D' THEN 'FULL'
        WHEN BK.[type] = 'I' THEN 'DIFF'
        WHEN BK.[type] = 'L' THEN 'LOG'
        WHEN BK.[type] = 'F' THEN 'FILEGROUP'
        WHEN BK.[type] = 'G' THEN 'DIFFERENTIAL - FILE'
        WHEN BK.[type] = 'P' THEN 'PARTIAL'
        WHEN BK.[type] = 'Q' THEN 'DIFFERENTIAL PARTIAL'
    END AS [BACKUP TYPE],
    MAX(BK.backup_start_date) AS [LAST BACKUP]
FROM master..sysdatabases AS DB
LEFT JOIN msdb..backupset AS BK ON DB.name = BK.database_name
LEFT JOIN msdb..backupmediafamily AS MD ON BK.media_set_id = MD.media_set_id
WHERE BK.[type] IS NOT NULL --AND BK.[type] = 'D'
AND DB.[dbid] > 4 and DB.name NOT LIKE 'ReportServer%'
GROUP BY DB.name, BK.[type]
ORDER BY [MACHINE NAME], MAX(BK.backup_start_date) DESC, DB.name
GO

--Description: Sample restore statement to migrate AdventureWorks from Windows to Linux.
--Author: Eric Kang

RESTORE DATABASE [AdventureWorks]
FROM DISK = N'/var/opt/mssql/backup/AdventureWorks.bak'
WITH FILE = 2,
MOVE N'AdventureWorks2014_Data' TO N'/var/opt/mssql/data/AdventureWorks.mdf',
MOVE N'AdventureWorks2014_Log' TO N'/var/opt/mssql/data/AdventureWorks.ldf'

