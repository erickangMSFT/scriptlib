
declare @systime datetime = sysdatetime();
declare @backupfile varchar(126);
set @backupfile = N'C:\Temp\Backups\AdventureWorksFull-' 
					+ convert(varchar(25), @systime, 112)
					+ N'-' + convert(varchar(2),Datepart(hour, @systime))
					+ N'-' + convert(varchar(2),DATEPART(minute, @systime))
					+ N'-' + convert(varchar(2),datepart(second, @systime))
					+ N'.bak'

BACKUP DATABASE [AdventureWorks] 
TO  DISK = @backupfile
WITH FORMAT, INIT,  
NAME = N'AdventureWorks-Full Database Backup', 
STATS = 10, CHECKSUM
GO

select * from msdb..backupset