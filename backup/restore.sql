--Description: Sample restore statement to migrate AdventureWorks from Windows to Linux.
--Author: Eric Kang

RESTORE DATABASE [AdventureWorks]
FROM DISK = N'/var/opt/mssql/backup/AdventureWorks.bak'
WITH FILE = 2,
MOVE N'AdventureWorks2014_Data' TO N'/var/opt/mssql/data/AdventureWorks.mdf',
MOVE N'AdventureWorks2014_Log' TO N'/var/opt/mssql/data/AdventureWorks.ldf'