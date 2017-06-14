CREATE EVENT SESSION [errorevents] 
ON SERVER 
ADD EVENT sqlserver.error_reported
(
    ACTION
    (
        sqlserver.client_hostname,
        sqlserver.database_id,
        sqlserver.sql_text,
        sqlserver.username
    )
    WHERE 
    (
        [severity] >= (16)
    )
) 
ADD TARGET package0.asynchronous_file_target
(
    SET filename=N'e:\temp\error_xevent.xel'
)
WITH 
(
    MAX_MEMORY=4096 KB,
    EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
    MAX_DISPATCH_LATENCY=30 SECONDS,
    MAX_EVENT_SIZE=0 KB,
    MEMORY_PARTITION_MODE=NONE,
    TRACK_CAUSALITY=OFF,
    STARTUP_STATE=ON
);
GO

ALTER EVENT SESSION [errorevents]
ON SERVER
STATE = START;
GO