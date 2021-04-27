USE KE_UNIVER
-------------------------1
create table #table1
(string1 int,
string2 nvarchar(50),
string3 nvarchar(50)
);
set nocount on;
declare @a int=0;
while @a<1000
begin 
insert #table1(string1,string2,string3)
values(floor(20000*rand()),replicate('Засчитайте лабу',1),replicate('Засчитайте!',1));
if(@a%10=0)
print @a 
set @a=@a+1;
end;
select string2,string3 from #table1 where string1 between 150 and 850 order by string1; --предполагаемый план выполнения
checkpoint; --фиксация бд
dbcc dropcleanbuffers;--очистка буферного кэша
create clustered index #ефид on #table1(string1 asc) --кластеризированный индекс
drop table #table1
-------------------------2
create table #table2
(
keys int,
surname nvarchar(50),
name nvarchar(50),
lastname nvarchar(50),
cc int identity(1,1)
);
set nocount on;
declare @i int =0;
while @i<30000
begin
insert #table2(keys,surname,name,lastname)
values(floor(40000*rand()),replicate('Kerez',1),replicate('Ekaterina',1),replicate('Viktorovna',1));
set @i=@i+1;
end;
select count(*)[number of string] from #table2
select * from #table2
create index #task2 on #table2(keys,cc) --некластеризованный индекс
select * from #table2 where keys>1500 and cc<2000;
select * from #table2 order by keys,surname,name,lastname,cc;
select * from #table2 where keys=212 and cc>3;
drop table #table2
------------------------------3
create table #table3(
id int,
value varchar(20),
cc int identity(1,1),
);

go
set nocount on
declare @c int = 0;
while @c < 10000
begin
insert #table3 (id, value)
values(floor(4000*rand()), 'Pupa');
set @c = @c +1;
end;
go


select * from #table3 where id between 1000 and 20000

checkpoint ;
DBCC DROPCLEANBUFFERS;

create index #task3 on #table3(id) include (cc); --некластеризованный индекс покрытия запроса

select * from #table3 where id between 50 and 5000 

drop table #table3
-----------------------------------------4


create table #table4(
id int,
value varchar(80),
cc int identity(1,1),
);

go
set nocount on
declare @d int = 0;
while @d < 1000
begin
insert #table4 (id, value)
values(floor(400*rand()), 'Хотите, я разбужу для вас кота?');
set @d = @d +1;
end;
go


select id from #table4 where id between 50 and 199
select id from #table4 where id > 150 and id <199
select id from #table4 where id = 170

checkpoint ;
DBCC DROPCLEANBUFFERS;

CREATE  index #task4 on #table4(id) where(id>=50 and id <=199); --фильтруемый некластеризованный индекс
drop table #table4
------------------------------------------5

create table #table5_1(
	id int,
	value varchar(80),
	cc int identity(1,1),
);
go
create table #table5_2(
	id int,
	value varchar(80),
	cc int identity(1,1),
);

set nocount on
declare @f int = 0;
while @f < 1000
begin
insert #table5_1 (id, value)
values(floor(200*rand()), 'Bulochka');
set @f = @f +1;
end;
go
set nocount on
declare @f int = 0;
while @f < 1000
begin
insert #table5_2 (id, value)
values(floor(200*rand()), 'Bulochka');
set @f = @f +1;
end;

CREATE  index #task5_in on #table5_1(id);
CREATE  index #task5_in on #table5_2(id);

select name[Индекс], avg_fragmentation_in_percent [Фрагментация %]
from sys.dm_db_index_physical_stats(DB_ID(N'KE_UNIVER'), 
        OBJECT_ID(N'#task5_in'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii 
		on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
        WHERE name is not null;
set nocount on;
declare @j int =0;
while @j < 100
begin 
insert #table5_1(id, value)
values(floor(200*rand()), 'vupsen');
set @j = @j + 1;
end;

go
set nocount on;
declare @j int =0;
while @j < 100
begin 
insert #table5_2(id, value)
values(floor(200*rand()), 'pupsen');
set @j = @j + 1;
end;



alter index #task5_in on #table5_1 reorganize --реорганизация
alter index #task5_in on #table5_2 rebuild; --перестройка

drop table #table5_1
drop table #table5_2

---------------------------------------6
create table #table6(
	id int,
	value varchar(80),
	cc int identity(1,1),
);
go

set nocount on
declare @c int = 0;
while @c < 10000
begin
insert #table6 (id, value)
values(floor(4000*rand()), 'print');
set @c = @c +1;
end;
go


select * from #table6 where id between 1000 and 2000

checkpoint ;
DBCC DROPCLEANBUFFERS;

create index #task6 on #table6(id) with (fillfactor = 20); --некластеризованный индекс с fillfactor

drop table #table6
