-- Get backup status for all databases
USE master;
GO
DECLARE @HOURS tinyint
SET @HOURS = 24

SELECT
	DB.name AS [DATABASE],
	DB.recovery_model_desc as [Recovery Model],
	CASE
		WHEN BK.[type] = 'D' THEN 'FULL'
		WHEN BK.[type] = 'I' THEN 'DIFFERENTIAL'
		WHEN BK.[type] = 'L' THEN 'TRANSACTION-LOG'
		WHEN BK.[type] = 'F' THEN 'FILEGROUP'
		WHEN BK.[type] = 'G' THEN 'DIFFERENTIAL FILE'
		WHEN BK.[type] = 'P' THEN 'PARTIAL'
		WHEN BK.[type] = 'Q' THEN 'DIFFERENTIAL PARTIAL'
	END AS [BACKUP TYPE],

	MAX(BK.backup_start_date) AS [LAST BACKUP],
	CASE
		WHEN (DATEDIFF( HH , MAX(BK.backup_start_date) , GETDATE()) < @HOURS) THEN 'Success' ELSE 'Failed'
	END AS [HealthCheck]
FROM sys.databases AS DB
LEFT JOIN msdb..backupset AS BK ON DB.name = BK.database_name
--WHERE DB.database_id > 4 
GROUP BY DB.name, BK.[type], db.recovery_model_desc
ORDER BY DB.name, MAX(BK.backup_start_date) DESC
GO

