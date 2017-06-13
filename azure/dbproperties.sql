--Essentials

select 
d.name,
o.service_objective,
o. edition,
d.create_date,
d.compatibility_level,
d.collation_name,
d.state_desc,
d.is_encrypted
from sys.databases d
join sys.database_service_objectives o on d.database_id = o.database_id 

--current database size
SELECT SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) AS DatabaseSizeInBytes,
       SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) / 1024 / 1024 AS DatabaseSizeInMB,
       SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) / 1024 / 1024 / 1024 AS DatabaseSizeInGB
FROM sys.database_files
WHERE type_desc = 'ROWS';

--get database properties
SELECT DATABASEPROPERTYEX('Database_Name', 'EDITION')
SELECT DATABASEPROPERTYEX('Database_Name', 'MaxSizeInBytes')
SELECT CONVERT(BIGINT,DATABASEPROPERTYEX ( 'Database_Name' , 'MAXSIZEINBYTES'))/1024/1024/1024 AS 'MAXSIZE IN GB'