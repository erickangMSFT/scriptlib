select @@version

DECLARE @BackupDirectory VARCHAR(100) 
EXEC master..xp_regread @rootkey='HKEY_LOCAL_MACHINE', 
@key='SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL\MSSQLServer', 
@value_name='BackupDirectory', 
@BackupDirectory=@BackupDirectory OUTPUT 
SELECT @BackupDirectory 


EXEC master..xp_regwrite 
@rootkey='HKEY_LOCAL_MACHINE', 
@key='SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL\MSSQLServer', 
@value_name='BackupDirectory', 
@type='REG_SZ', 
@value='/var/opt/mssql/backup' 