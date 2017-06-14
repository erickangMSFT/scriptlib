use master;
go

declare @condition tinyint;
SET @condition = 24;

with backupInsight_cte (database_id, last_backup, health_check)
as
(
	select
		d.database_id,
        max(b.backup_start_date) AS last_backup,
		case
			when (datediff( hh , max(b.backup_start_date) , getdate()) < @condition) then 1 else 0
		end as health_check
	from sys.databases as d
	left join msdb..backupset as b on d.name = b.database_name
	group by d.database_id
)
select 
    sum(health_check) Green,
    sum(case when health_check = 0 AND last_backup IS NOT NULL then 1 else 0 end) Yellow,
    sum(case when health_check = 0 then 1 else 0 end) Red 
from backupInsight_cte
