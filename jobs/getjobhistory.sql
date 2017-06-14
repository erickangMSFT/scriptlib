use msdb
GO

select  
    h.run_date,
    h.run_time,
    j.name,
    h.step_id,
    h.message,
    h.sql_severity,
    h.sql_message_id,
    h.retries_attempted,
    h.job_id,
    h.run_duration
from dbo.sysjobhistory h
left join dbo.sysjobs j on h.job_id = j.job_id 
-- where h.sql_severity >= 11 
-- where h.job_id = '26aef7ef-f2bf-45bb-b012-402984adf226'
order by h.run_date DESC
