-- Backup Plan Builder for 30min RPO.
-- Database Name: ${DatabaseName}
-- Start Date:
-- End Date:
-- Active Start Time:
-- Active End Time:

USE [msdb]
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Backup Plans (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Backup Plans (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END

-- Daily Full Backup Job Plan --

DECLARE @jobId BINARY(16)

EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'AdventureWorks Full Backup', 
		@enabled=1, 
		@description=N'Full backup for AdventureWorks', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Full Backup T-SQL Script', 
		@step_id=1, 
		@subsystem=N'TSQL', 
		@command=N'--Full Backup
BACKUP DATABASE [AdventureWorks] 
TO  DISK = N''/var/opt/mssql/backup/AdventureWorks.bak'' 
WITH NOFORMAT, NOINIT,  NAME = N''AdventureWorks Daily Full Backup'', STATS = 10
GO'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily Backup Schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170410, 
		@active_end_date=99991231, 
		@active_start_time=020000, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


-- 12HR Differential Backup Job Plan --
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'AdventureWorks Differential Backup', 
		@enabled=1, 
		@description=N'Differential backup for AdventureWorks', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Differential Backup T-SQL Script', 
		@step_id=1, 
		@subsystem=N'TSQL', 
		@command=N'--Differential Backup
BACKUP DATABASE [AdventureWorks] 
TO  DISK = N''/var/opt/mssql/backup/AdventureWorks.bak'' 
WITH NOFORMAT, NOINIT,  NAME = N''AdventureWorks Differential Backup'', STATS = 10
GO'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'12HR Backup Schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170410, 
		@active_end_date=99991231, 
		@active_start_time=020000, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

-- 30MIN Transaction-Log Backup Job Plan --
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'AdventureWorks Transaction-Log Backup', 
		@enabled=1, 
		@description=N'Transaction-Log backup for AdventureWorks', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Transaction-Log Backup T-SQL Script', 
		@step_id=1, 
		@subsystem=N'TSQL', 
		@command=N'--Transaction-Log Backup
BACKUP LOG [AdventureWorks] 
TO  DISK = N''/var/opt/mssql/backup/AdventureWorks.bak'' 
WITH NOFORMAT, NOINIT,  NAME = N''AdventureWorks Transaction-Log Backup'', STATS = 10
GO'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'30MIN Backup Schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170410, 
		@active_end_date=99991231, 
		@active_start_time=020000, 
		@active_end_time=070000
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO