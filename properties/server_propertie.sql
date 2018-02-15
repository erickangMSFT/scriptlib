
select 
    serverproperty('Collation') as Collation
, serverproperty('BuildClrVersion') as BuildClrVersion
, serverproperty('Edition') as Edition
-- 1 = Personal or Desktop Engine (Not available in SQL Server 2005 and later versions.)
-- 2 = Standard (This is returned for Standard, Web, and Business Intelligence.)
-- 3 = Enterprise (This is returned for Evaluation, Developer, and both Enterprise editions.)
-- 4 = Express (This is returned for Express, Express with Tools and Express with Advanced Services)
-- 5 = SQL Database
-- 6 - SQL Data Warehouse
, serverproperty('EngineEdition') as EngineEdition
, serverproperty('InstanceDefaultDataPath') as DefaultDataPath
, serverproperty('InstanceDefaultLogPath') as DefaultLogPath
, serverproperty('IsAdvancedAnalyticsInstalled') as AdvancedAnalyticsInstalled
, serverproperty('IsClustered') as IsClustered
, serverproperty('IsFullTextInstalled') as IsFullTextInstalled
, serverproperty('IsHadrEnabled') as IsHadrEnabled
, serverproperty('IsIntegratedSecurityOnly') as IsIntegratedSecurityOnly
, SERVERPROPERTY('IsLocalDB') as IsLocalDB
, SERVERPROPERTY('IsPolybaseInstalled') as IsPolybaseInstalled
, SERVERPROPERTY('IsSingleUser') as IsSingleUser
, SERVERPROPERTY('IsXTPSupported') as IsXTPSupported
, SERVERPROPERTY('LCID') as LCID
, SERVERPROPERTY('LicenseType') as LicenseType
, SERVERPROPERTY('MachineName') as MachineName
, SERVERPROPERTY('NumLicenses') as NumLicenses
, SERVERPROPERTY('ProcessID') as ProcessID
, SERVERPROPERTY('ProductBuild') as ProductBuild
, SERVERPROPERTY('ProductBuildType') as ProductBuildType
, SERVERPROPERTY('ProductLevel') as ProductLevel
, SERVERPROPERTY('ProductMajorVersion') as ProductMajorVersion
, SERVERPROPERTY('ProductMinorVersion') as ProductMinorVersion
, SERVERPROPERTY('ProductUpdateLevel') as ProductUpdateLevel
, SERVERPROPERTY('ProductUpdateReference') as ProductUpdateReference
, SERVERPROPERTY('ProductVersion') as ProductVersion
, SERVERPROPERTY('ResourceLastUpdateDateTime') as ResourceLastUpdateDateTime
, SERVERPROPERTY('ResourceVersion') as ResourceVersion
, SERVERPROPERTY('ServerName') as ServerName
, SERVERPROPERTY('SqlCharSet') as SqlCharSet
, SERVERPROPERTY('SqlCharSetName') as SqlCharSetName
, SERVERPROPERTY('SqlSortOrder') as SqlSortOrder
, SERVERPROPERTY('SqlSortOrderName') as SqlSortOrderName
, SERVERPROPERTY('FilestreamShareName') as FilestreamShareName
, SERVERPROPERTY('FilestreamConfiguredLevel') as FilestreamConfiguredLevel
, SERVERPROPERTY('FilestreamEffectiveLevel') as FilestreamEffectiveLevel


-- memory allocation

If (SERVERPROPERTY('EngineEdition') < 5)
BEGIN
    SELECT  
    (physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,  
    (locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
    (total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,  
    process_physical_memory_low,  
    process_virtual_memory_low  
    FROM sys.dm_os_process_memory;  
End

select c.name, c.value, c.minimum, c.maximum, c.value_in_use, c.[description], c.is_advanced, c.is_dynamic
from sys.configurations c