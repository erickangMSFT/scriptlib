-- Description: View audit log
-- Author: Eric Kang

-- Get audit detail
SELECT * FROM sys.server_audits

-- Get audit file detail
SELECT * FROM sys.server_file_audits

-- Read audit file
SELECT * FROM sys.fn_get_audit_file ('G:\Temp\CarbonAudit_D6AD07D2-A312-40B4-B284-21205C8C5AF6_0_131395233211190000.sqlaudit',default,default);    
SELECT * FROM sys.fn_get_audit_file ('G:\Temp\CarbonAudit_D6AD07D2-A312-40B4-B284-21205C8C5AF6_0_131395232168200000.sqlaudit',default,default);  
GO  

