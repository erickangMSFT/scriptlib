-- Description: Sample backup statements
-- Author: Eric Kang

BACKUP DATABASE [AdventureWorks] TO  
DISK = N'G:\sqlbackups\Device1\AdventureworkdDevice1.bak',  
DISK = N'G:\sqlbackups\Device3\AdventureWorksDevice3.bak',  
DISK = N'G:\sqlbackups\Device2\AdventureWorksDevice2.bak' 
WITH NOFORMAT, NOINIT,  
NAME = N'AdventureWorks-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


-- on Linux
BACKUP DATABASE [Clinic]  TO 
DISK = N'/var/opt/mssql/backup/clinic.bak'
With Name = N'Clinic initial backup'