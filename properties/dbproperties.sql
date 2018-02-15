--declare @db_name varchar(126) = N'TechSummitSeoulDB'
declare @db_name varchar(126) = N'AdventureWorks'

select 
    DATABASEPROPERTYEX(@db_name, 'Collation') as Collation
    , DATABASEPROPERTYEX(@db_name, 'Edition') as Edition
    , DATABASEPROPERTYEX(@db_name, 'IsAnsiNullDefault') as IsAnsiNullDefault
    , DATABASEPROPERTYEX(@db_name, 'IsAnsiNullsEnabled') as IsAnsiNullsEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsAnsiPaddingEnabled') as IsAnsiPaddingEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsAnsiWarningsEnabled') as IsAnsiWarningsEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsArithmeticAbortEnabled') as IsArithmeticAbortEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsAutoClose') as IsAutoClose
    , DATABASEPROPERTYEX(@db_name, 'IsAutoCreateStatistics') as IsAutoCreateStatistics
    , DATABASEPROPERTYEX(@db_name, 'IsAutoCreateStatisticsIncremental') as IsAutoCreateStatisticsIncremental
    , DATABASEPROPERTYEX(@db_name, 'IsAutoShrink') as IsAutoShrink
    , DATABASEPROPERTYEX(@db_name, 'IsAutoUpdateStatistics') as IsAutoUpdateStatistics
    , DATABASEPROPERTYEX(@db_name, 'IsClone') as IsClone
    , DATABASEPROPERTYEX(@db_name, 'IsCloseCursorsOnCommitEnabled') as IsCloseCursorsOnCommitEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsFulltextEnabled') as IsFulltextEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsInStandBy') as IsInStandBy
    , DATABASEPROPERTYEX(@db_name, 'IsLocalCursorsDefault') as IsLocalCursorsDefault
    , DATABASEPROPERTYEX(@db_name, 'IsMemoryOptimizedElevateToSnapshotEnabled') as IsMemoryOptimizedElevateToSnapshotEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsMergePublished') as IsMergePublished
    , DATABASEPROPERTYEX(@db_name, 'IsNullConcat') as IsNullConcat
    , DATABASEPROPERTYEX(@db_name, 'IsNumericRoundAbortEnabled') as IsNumericRoundAbortEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsParameterizationForced') as IsParameterizationForced
    , DATABASEPROPERTYEX(@db_name, 'IsQuotedIdentifiersEnabled') as IsQuotedIdentifiersEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsPublished') as IsPublished
    , DATABASEPROPERTYEX(@db_name, 'IsRecursiveTriggersEnabled') as IsRecursiveTriggersEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsSubscribed') as IsSubscribed
    , DATABASEPROPERTYEX(@db_name, 'IsSyncWithBackup') as IsSyncWithBackup
    , DATABASEPROPERTYEX(@db_name, 'IsTornPageDetectionEnabled') as IsTornPageDetectionEnabled
    , DATABASEPROPERTYEX(@db_name, 'IsXTPSupported') as IsXTPSupported
    , DATABASEPROPERTYEX(@db_name, 'LCID') as LCID
    , DATABASEPROPERTYEX(@db_name, 'MaxSizeInBytes') as MaxSizeInBytes
    , DATABASEPROPERTYEX(@db_name, 'Recovery') as Recovery
    , DATABASEPROPERTYEX(@db_name, 'ServiceObjective') as ServiceObjective
    , DATABASEPROPERTYEX(@db_name, 'ServiceObjectiveId') as ServiceObjectiveId
    , DATABASEPROPERTYEX(@db_name, 'SQLSortOrder') as SQLSortOrder
    , DATABASEPROPERTYEX(@db_name, 'Status') as Status
    , DATABASEPROPERTYEX(@db_name, 'Updateability') as Updateability
    , DATABASEPROPERTYEX(@db_name, 'UserAccess') as UserAccess
    , DATABASEPROPERTYEX(@db_name, 'Version') as Version



--current database size
SELECT SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) AS DatabaseSizeInBytes,
       SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) / 1024 / 1024 AS DatabaseSizeInMB,
       SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) / 1024 / 1024 / 1024 AS DatabaseSizeInGB
FROM sys.database_files
WHERE type_desc = 'ROWS';
