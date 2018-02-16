use msdb
go

DECLARE @jobId BINARY(16)

EXEC msdb.dbo.sp_add_job @job_name=N'WideWorldImporters Full Backup', 
		@enabled=1, 
		@description=N'Full backup for WideWorldImporters', 
		@job_id = @jobId OUTPUT

Select @jobId


EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run Full Backup T-SQL Script', 
		@step_id=1, 
		@subsystem=N'TSQL', 
		@command=N'--Full Backup
BACKUP DATABASE [WideWorldImporters] 
-- TO  DISK = N''/var/opt/mssql/backup/WideWorldImporters.bak'' 
WITH NOFORMAT, NOINIT,  NAME = N''WideWorldImporters Daily Full Backup'', STATS = 10
GO'

exec msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1

-- Daily schedule starting on 2017-04-10 with no enddate and starting time is at 02:00:00
EXEC msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily Backup Schedule', 
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


EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'

exec msdb.dbo.sp_start_job @job_id = @jobId