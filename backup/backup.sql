-- Description: Sample backup statements
-- Author: Eric Kang

BACKUP DATABASE [AdventureWorks] TO  
DISK = N'G:\sqlbackups\Device1\AdventureworkdDevice1.bak',  
DISK = N'G:\sqlbackups\Device3\AdventureWorksDevice3.bak',  
DISK = N'G:\sqlbackups\Device2\AdventureWorksDevice2.bak' 
WITH NOFORMAT, NOINIT,  
NAME = N'AdventureWorks-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


-- On Linux
BACKUP DATABASE [Clinic]  TO 
DISK = N'/var/opt/mssql/backup/clinic.bak'
With Name = N'Clinic initial backup'

--Create a new backup set
BACKUP DATABASE [AdventureWorks] TO
DISK = N'/var/opt/mssql/backup/AdventureWorksLinux.bak' 
WITH EXPIREDATE  = N'12/31/2049 00:00:00',
        FORMAT,
        INIT,
        MEDIANAME = 'AdventureWorksDockerBackupMedia',
        NAME = N'AdventureWorks-Full-05-10-2017',
        SKIP, COMPRESSION

--Full backup
BACKUP DATABASE [AdventureWorks] TO
DISK = N'/var/opt/mssql/backup/AdventureWorksLinux.bak' 
WITH 
        NAME = N'AdventureWorks-Full-05-10-2017',
        NOFORMAT, NOINIT

--Differential backup
BACKUP DATABASE [AdventureWorks] TO
DISK = N'/var/opt/mssql/backup/AdventureWorksLinux.bak' 
WITH 
        DIFFERENTIAL, 
        NAME = N'AdventureWorks-Diff-05-10-2017',
        NOFORMAT, NOINIT

--Log backup
BACKUP LOG [AdventureWorks] TO
DISK = N'/var/opt/mssql/backup/AdventureWorksLinux.bak'
WITH
        NOFORMAT,
        NOINIT,
        NAME = N'AdventureWorks-Log-05-10-2017' 