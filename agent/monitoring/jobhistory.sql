--EXEC msdb.dbo.sp_help_jobhistory
select job_id, run_date, run_time, run_status, [message] from [msdb].[dbo].[sysjobhistory]
where step_id = 0

select job_id, run_date, run_time, run_duration from msdb.dbo.sysjobhistory

select * from msdb.dbo.sysalerts