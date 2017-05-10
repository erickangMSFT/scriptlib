--Description: Sample restore statement to get backup info from backup media.
--Author: Eric Kang

Restore Labelonly from disk = 'G:\sqlbackups\Device1\AdventureworkdDevice1.bak'
Restore Headeronly from disk = 'G:\sqlbackups\Device1\AdventureworkdDevice1.bak'
Restore Filelistonly from disk = 'G:\sqlbackups\Device1\AdventureworkdDevice1.bak'
Restore Verifyonly from DISK = N'G:\sqlbackups\Device1\AdventureworkdDevice1.bak',  
                        DISK = N'G:\sqlbackups\Device3\AdventureWorksDevice3.bak',  
                        DISK = N'G:\sqlbackups\Device2\AdventureWorksDevice2.bak'


-- Get all backupset information from msdb

SELECT name, *
FROM msdb..backupset

SELECT name, *
FROM msdb..backupmediaset

SELECT *
FROM msdb..backupmediafamily
--WHERE media_set_id = 6