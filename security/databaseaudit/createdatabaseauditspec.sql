USE [AdventureWorks]
GO

CREATE DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification-20170517-124055]
FOR SERVER AUDIT [CarbonAudit]
ADD (SELECT ON OBJECT::[Person].[EmailAddress] BY [db_owner])
WITH ( STATE = ON );
GO

--
SELECT * FROM [Person].[EmailAddress];
GO