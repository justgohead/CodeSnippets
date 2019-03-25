--查询约束
SELECT  *  from  INFORMATION_SCHEMA.
  TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME LIKE 'AK%'
  --删除
  alter table ActivityOrder drop constraint  AK_ACTIVITYORDERCODE_ACTIVITY

--在存储过程中查询指定文本
--将text替换成你要查找的内容   
select name   
from sysobjects o, syscomments s   
where o.id = s.id   
and text like '%text%'   
and o.xtype = 'P'   
  
--将text替换成你要查找的内容   
SELECT ROUTINE_NAME, ROUTINE_DEFINITION   
FROM INFORMATION_SCHEMA.ROUTINES   
WHERE ROUTINE_DEFINITION LIKE '%text%'   
AND ROUTINE_TYPE='PROCEDURE' 

--查询触发器
select name from sysobjects where xtype='TR' 

--清除缓存
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
DBCC FREESYSTEMCACHE ('ALL');

--修改字段
ALTER TABLE CustomerInfo ALTER COLUMN column 字段名 varchar(50) not null;

--清空所有数据

EXECUTE sp_msforeachtable 'delete from ?'
或者
EXECUTE sp_msforeachtable 'truncate table ?'

--删除所有表
declare @sql varchar(8000)
while (select count(*) from sysobjects where type='U')>0
begin
SELECT @sql='drop table ' + name
FROM sysobjects
WHERE (type = 'U')
ORDER BY 'drop table ' + name
exec(@sql) 
end

--设置兼容模式(解决EF更新结构卡死问题 默认为120)
 ALTER DATABASE DATABASEName
 SET COMPATIBILITY_LEVEL = 110
 
 SELECT  der.[session_id],der.[blocking_session_id],  
 sp.lastwaittype,sp.hostname,sp.program_name,sp.loginame,  
 der.[start_time] AS '开始时间',  
 der.[status] AS '状态',  
 dest.[text] AS 'sql语句',  
 DB_NAME(der.[database_id]) AS '数据库名',  
 der.[wait_type] AS '等待资源类型',  
 der.[wait_time] AS '等待时间',  
 der.[wait_resource] AS '等待的资源',  
 der.[logical_reads] AS '逻辑读次数'  
 FROM sys.[dm_exec_requests] AS der  
 INNER JOIN master.dbo.sysprocesses AS sp ON der.session_id=sp.spid  
 CROSS APPLY  sys.[dm_exec_sql_text](der.[sql_handle]) AS dest  
 --WHERE [session_id]>50 AND session_id<>@@SPID  
 ORDER BY der.[session_id]

 kill session_id
