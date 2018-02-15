-- Description: View audit log
-- Author: Eric Kang

USE master;
GO

-- Get audit detail
SELECT 
    audit_id,
    name,
    create_date,
    modify_date,
    on_failure_desc
FROM sys.server_audits

-- Get audit file detail
SELECT 
    audit_id,
    name,
    create_date,
    modify_date,
    log_file_path + log_file_name auditlog_file_name
FROM sys.server_file_audits

-- Read audit file
SELECT 
    event_time, 
    action_id, 
    succeeded, 
    database_name + '.' + schema_name + '.' + object_name as 'object name',
    client_ip,
    application_name,
    server_principal_name, database_principal_name,
    [statement]
FROM sys.fn_get_audit_file ('/var/opt/mssql/auditlog/CarbonAudit_FC062890-A102-46B3-83CC-CD148AB70EB2_0_131394759189390000.sqlaudit',default,default)    
-- filter for failed login
-- WHERE succeeded = 0 
GO  

