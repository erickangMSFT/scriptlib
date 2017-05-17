-- Description: Create Audit on server
-- Author: Eric Kang
USE [master]
GO

-- Create Audit object
CREATE SERVER AUDIT [CarbonAudit]
TO FILE 
(	FILEPATH = N'G:\Temp'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
)
GO


-- Create server audit specification for Success and Failed logins
ALTER SERVER AUDIT [CarbonAudit] 
WITH (STATE = OFF);  
GO  

CREATE SERVER AUDIT SPECIFICATION [ServerAuditSpecification-20170517-123351]
FOR SERVER AUDIT [CarbonAudit]
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP)
WITH ( STATE = ON );
GO

ALTER SERVER AUDIT [CarbonAudit]
WITH (STATE = ON);  
