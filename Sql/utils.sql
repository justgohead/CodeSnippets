--��ѯԼ��
SELECT  *  from  INFORMATION_SCHEMA.
  TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME LIKE 'AK%'
  --ɾ��
  alter table ActivityOrder drop constraint  AK_ACTIVITYORDERCODE_ACTIVITY

--�ڴ洢�����в�ѯָ���ı�
--��text�滻����Ҫ���ҵ�����   
select name   
from sysobjects o, syscomments s   
where o.id = s.id   
and text like '%text%'   
and o.xtype = 'P'   
  
--��text�滻����Ҫ���ҵ�����   
SELECT ROUTINE_NAME, ROUTINE_DEFINITION   
FROM INFORMATION_SCHEMA.ROUTINES   
WHERE ROUTINE_DEFINITION LIKE '%text%'   
AND ROUTINE_TYPE='PROCEDURE' 

--��ѯ������
select name from sysobjects where xtype='TR' 

--�������
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
DBCC FREESYSTEMCACHE ('ALL');

--�޸��ֶ�
ALTER TABLE CustomerInfo ALTER COLUMN column �ֶ��� varchar(50) not null;

--�����������

EXECUTE sp_msforeachtable 'delete from ?'
����
EXECUTE sp_msforeachtable 'truncate table ?'

--ɾ�����б�
declare @sql varchar(8000)
while (select count(*) from sysobjects where type='U')>0
begin
SELECT @sql='drop table ' + name
FROM sysobjects
WHERE (type = 'U')
ORDER BY 'drop table ' + name
exec(@sql) 
end

--���ü���ģʽ(���EF���½ṹ�������� Ĭ��Ϊ120)
 ALTER DATABASE DATABASEName
 SET COMPATIBILITY_LEVEL = 110
