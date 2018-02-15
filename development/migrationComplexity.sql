-- Description: demo to show the complexity of migration based database development and change management.
-- Author: Eric Kang
-- Run this demo on AdventureWorks sample database

-- Connect to AdventureWorks
-- View the data in EmailAddress table: email is not masked.

SELECT *
FROM [AdventureWorks].[Person].[EmailAddress]

-- Change EmailAddress column with MASKED WITH clause
ALTER TABLE [PERSON].[EmailAddress] ALTER COLUMN [EmailAddress]
ADD MASKED WITH (FUNCTION='email()');
GO

-- Add SuspiciousUser and run-as the user to view the masked values.
CREATE USER SuspiciousUser Without Login
GRANT SELECT ON [Person].[EmailAddress] to SuspiciousUser;
GO

-- Check if emailAddress column is masked.
SELECT * FROM sys.masked_columns;
GO

EXECUTE AS USER = 'SuspiciousUser';
SELECT * FROM Person.EmailAddress e
REVERT;


-- Later new change request comes in. The current size of EmailAddress is too small. 
-- Change it as nvarchar(60)

ALTER TABLE [PERSON].[EmailAddress] ALTER COLUMN [EmailAddress]
nvarchar(60);

SELECT * FROM sys.masked_columns;
GO

EXECUTE AS USER = 'SuspiciousUser';
SELECT * FROM Person.EmailAddress e
REVERT;
 

-- ALTER COLUMN removed masking property from the column 
-- and caused a security issue in the database and application.
-- In migration based database development and change management, developer needs to have
-- a deeper knowledge of RDBMS.
-- Use the same scenario with SSDT's database project in Visual Studio.
-- SSDT (state-based database development) automatically handles this type of complexity more effectively.

-- Reset
-- ALTER TABLE [PERSON].[EmailAddress] ALTER COLUMN [EmailAddress] nvarchar(50);
-- GO
-- DROP USER [SuspiciousUser]
-- GO