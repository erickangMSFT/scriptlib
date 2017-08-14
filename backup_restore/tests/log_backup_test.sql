

declare @systime datetime = sysdatetime();
declare @logfile varchar(126);
set @logfile = N'C:\Temp\Backups\AdventureWorks_Log-' 
					+ convert(varchar(25), @systime, 112)
					+ N'-' + convert(varchar(2),Datepart(hour, @systime))
					+ N'-' + convert(varchar(2),DATEPART(minute, @systime))
					+ N'-' + convert(varchar(2),datepart(second, @systime))
					+ N'.bak'

BACKUP LOG [AdventureWorks] 
TO  DISK = @logfile
WITH FORMAT, INIT,  NAME = N'AdventureWorks-log Database Backup', 
STATS = 10
GO