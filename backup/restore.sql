

-- Get backup status for all databases
USE master;
GO
DECLARE @HOURS tinyint
SET @HOURS = 22
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
    MAX(BK.backup_start_date) AS [LAST BACKUP],
    CASE
        WHEN (DATEDIFF( HH , MAX(BK.backup_start_date) , GETDATE()) < @HOURS) THEN 'Compliant' ELSE 'Incompliant'
    END AS Compliance
FROM master..sysdatabases AS DB
LEFT JOIN msdb..backupset AS BK ON DB.name = BK.database_name
LEFT JOIN msdb..backupmediafamily AS MD ON BK.media_set_id = MD.media_set_id
WHERE BK.[type] IS NOT NULL --AND BK.[type] = 'D'
AND DB.[dbid] > 4 and DB.name NOT LIKE 'ReportServer%'
GROUP BY DB.name, BK.[type]
ORDER BY [MACHINE NAME], MAX(BK.backup_start_date) DESC, DB.name
GO