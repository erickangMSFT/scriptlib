declare @log table
(   LogDate datetime2,
    ProcessInfo SYSNAME,
    Text varchar(max)
)

insert into @log
exec sp_readerrorlog

select * from @log 
order by logdate desc