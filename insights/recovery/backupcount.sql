use master;
go
declare @condition tinyint = 24;
with
	backupInsight_cte (database_id, last_backup, health_check)
	as
	(
		select d.database_id, max(b.backup_start_date) AS last_backup, case when (datediff( hh , max(b.backup_start_date) , getdate()) < @condition) then 1 else 0 end as health_check
		from sys.databases as d left join msdb..backupset as b on d.name = b.database_name
		group by d.database_id
	)
select sum(health_check) [Within 24hrs], sum(case when health_check = 0 AND last_backup IS NOT NULL then 1 else 0 end) [Older than 24hrs], sum(case when health_check = 0 then 1 else 0 end) [No backup found]
from backupInsight_cte

--details
declare @condition2 tinyint = 24;
select d.database_id as [Database ID], d.name as [Database], d.recovery_model_desc as [Recovery model], d.state_desc as [Database state], case 
	when b.type = N'F' then N'Full'
	when b.type = N'D' then N'Differential' 
	when b.type = N'L' then N'Transaction-Log' else NULL
	end
as [Backup type], b.backup_start_date as [Backup start date], b.backup_finish_date as [Backup finish date], case 
	when m.last_backup_time is null then N'No backup found'
	when m.last_backup_time > @condition2 then N'Older than 24hrs' else N'Within 24hrs'
	end as [Backup Health]
from sys.databases as d left join msdb..backupset as b on d.name = b.database_name left join (select bs.database_name, max(bs.backup_start_date) as last_backup_time
	from msdb..backupset as bs
	group by bs.database_name ) as m on d.name = m.database_name and b.backup_start_date = m.last_backup_time
where b.backup_start_date is null or b.backup_start_date = m.last_backup_time
order by d.database_id asc