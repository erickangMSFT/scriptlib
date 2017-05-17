-- Description: View audit log
-- Author: Eric Kang

USE master;
GO

-- Get audit detail
SELECT * FROM sys.server_audits

-- Get audit file detail
SELECT * FROM sys.server_file_audits

-- Read audit file
SELECT 
    event_time, 
    action_id, 
    succeeded, 
    database_name,
    schema_name,
    object_name,
    client_ip,
    application_name,
    server_principal_name, database_principal_name,
    [statement]
FROM sys.fn_get_audit_file ('/var/opt/mssql/auditlog/CarbonAudit_FC062890-A102-46B3-83CC-CD148AB70EB2_0_131394759189390000.sqlaudit',default,default);    
GO  

