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
