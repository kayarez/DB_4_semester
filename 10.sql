use KE_UNIVER
--Задание 1--
exec sp_helpindex "AUDITORIUM"
exec sp_helpindex "AUDITORIUM_TYPE"
exec sp_helpindex "FACULTY"
exec sp_helpindex "GROUPS"
exec sp_helpindex "PROFESSION"
exec sp_helpindex "PROGRESS"
exec sp_helpindex "PULPIT"
exec sp_helpindex "STUDENT"
exec sp_helpindex "SUBJECT"
exec sp_helpindex "TEACHER"

CREATE table  #EXPLRE
(    TIND int,  
      TFIELD varchar(100) 
);
set nocount on;
declare @i int =0;
while @i <1000
		begin
		insert #EXPLRE( TIND,TFIELD)
		values(floor(20000*rand()),REPLICATE('Катя',10));
		set @i = @i +1;
	end;

	CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc)
SELECT * FROM #EXPLRE where TIND between 1500 and 2500 order by TIND 

checkpoint;  --фиксация БД
 DBCC DROPCLEANBUFFERS;  --очистить буферный кэш


 drop table #EXPLRE;
--Задание 2--

CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100));

  set nocount on;           
  declare @a int = 0;
  while   @a < 20000       -- добавление в таблицу 20000 строк
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
        set @a = @a + 1; 
  end;
  
    CREATE index #EX_NONCLU on #EX(TKEY, CC)
  SELECT count(*)[количество строк] from #EX;
  SELECT * from #EX

  SELECT * from  #EX where  TKEY > 1500 and  CC < 4500;  
    SELECT * from  #EX order by  TKEY, CC
	SELECT * from  #EX where  TKEY = 556 and  CC > 3
--Задание 3--
 
 CREATE  index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)

 SELECT CC from #EX where TKEY>15000 
 drop table #EX
 --Задание 4--


SELECT TKEY from  #EX where TKEY between 5000 and 19999; 
SELECT TKEY from  #EX where TKEY>15000 and  TKEY < 20000  
SELECT TKEY from  #EX where TKEY=17000

CREATE  index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and 
 TKEY < 20000);  
 --Задание 5--



 CREATE   index #EX_TKEY ON #EX(TKEY); 
 use tempdb;
		SELECT a.object_id, object_name(a.object_id) AS TableName,
    a.index_id, name AS IndexName, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats
    (DB_ID (N'tempdb')
        , OBJECT_ID(N'#EX')
        , NULL
        , NULL
        , NULL) AS a
INNER JOIN sys.indexes AS b
    ON a.object_id = b.object_id
    AND a.index_id = b.index_id where name is not null;
GO

INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

ALTER index #EX_TKEY on #EX reorganize;

ALTER index #EX_TKEY on #EX rebuild with (online = off);
--Задание 6--


DROP index #EX_TKEY on #EX;
    CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 65);

	INSERT top(50)percent INTO #EX(TKEY, TF) 
           		SELECT a.object_id, object_name(a.object_id) AS TableName,
    a.index_id, name AS IndexName, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats
    (DB_ID (N'tempdb')
        , OBJECT_ID(N'#EX')
        , NULL
        , NULL
        , NULL) AS a
INNER JOIN sys.indexes AS b
    ON a.object_id = b.object_id
    AND a.index_id = b.index_id where name is not null;
GO                              


