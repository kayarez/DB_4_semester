use KE_UNIVER
-----------------1
if OBJECT_ID('X','U') is not null 
drop table X

	declare @a int, @b varchar(10), @flag char = 'a';
	declare FirstTask cursor local 
	for select count(*), PULPIT from SUBJECT 
	group by PULPIT;
	create table X(count int,pulpit varchar(10));
	SET IMPLICIT_TRANSACTIONS  ON   
	open FirstTask
	fetch FirstTask into @a,@b;
	while @@FETCH_STATUS = 0
	begin
	insert X values(@a,@b)
	fetch FirstTask into @a,@b;
	end
	close FirstTask
	set @a = (select count(*) from X);
	print 'count of lines in table X: ' + cast(@a as varchar(2));
	if @flag = 'a' 
	commit ;
	else 
	rollback;
	select * from X
	SET IMPLICIT_TRANSACTIONS  off 

--------------------2
go

 begin try 
	begin tran
		delete PULPIT where PULPIT='ОВ';
		insert SUBJECT values('Помогите','Мне','ИСиТ');
		commit tran;
end try
	begin catch
		print 'error: ' + case 
			when error_number() = 2627 and patindex('%PK_PULPIT%', error_message()) > 0
          then N'дублирование pulpit' 
          else N'неизвестная ошибка: '+cast(@@Trancount as  varchar(5))+ '=='+ cast(error_number() as  varchar(5))+ error_message()  
	  end; 
if @@TRANCOUNT >0 
rollback;
end catch

--------------3
declare @point varchar(10)
begin try 
	begin tran
		delete SUBJECT where [SUBJECT] like 'What' and SUBJECT_NAME like'HelpMe'
		set @point = 'p1' save tran @point --контрольные точки
		insert SUBJECT values('What','HelpMe','POiPS');
		set @point = 'p2' save tran @point
		delete pulpit where pulpit like 'POiPS'
		set @point = 'p3' save tran @point
		commit tran;
end try
	begin catch
		print 'error: ' + case 
			when error_number() = 2627 and patindex('%PK_PULPIT%', error_message()) > 0
          then N'дублирование pulpit' 
          else N'неизвестная ошибка: '+cast(@@Trancount as  varchar(5))+ '=='+ cast(error_number() as  varchar(5))+ error_message()  
	  end; 
	  if @@TRANCOUNT > 0
	  begin print 'ControlPoint ' + @point
	  rollback tran @point;
	  commit tran;
	  end;
if @@TRANCOUNT >0 rollback;
end catch

 
--A--
set transaction isolation level read uncommitted 
begin transaction 
	select @@SPID, 'insert FACULTY', N'результат', *
	from FACULTY 
	select @@SPID , 'update PULPIT', N'результат', *
	from PULPIT where FACULTY = 'IT';
commit;
--B--
begin transaction 
	select @@SPID --системный идентификатор процесса
	insert FACULTY values ('MN','MoneyN');
	update PULPIT set FACULTY = N'IT' where PULPIT = N'POiPS'
--t1
--t2
rollback;
go

set transaction isolation level read committed 
begin transaction
	select count(*) from PULPIT
		where FACULTY = 'IT';
	select 'update PULPIT', N'результат', count(*)
	from PULPIT where FACULTY = 'IT';
commit;


begin transaction 
	update PULPIT set FACULTY = N'IT' where PULPIT = N'POiPS'
	commit;
--A
set transaction isolation level repeatable read
begin transaction
	select TEACHER_NAME from TEACHER
	where PULPIT = 'POiPS';
--t1
--t2
	select case 
	when TEACHER_NAME like '%Kolya%' then 'insert TEACHER'
	else ''
	end N'результат ', TEACHER_NAME
	from TEACHER where PULPIT = 'POiPS';
	commit;

--B
begin transaction
--t1
insert TEACHER values(12,'Bycnuk Nickolay','f','POiPS')
commit
--T2

--7
DELETE TEACHER WHERE TEACHER_NAME LIKE '%Kolya%'
--A
set transaction isolation level serializable
begin tran
DELETE TEACHER WHERE TEACHER_NAME LIKE 'Bycnuk%'
insert TEACHER values(18,'Yarmolik Nickolay','m','ISiT')
update TEACHER set TEACHER_NAME = 'Misha Poc' where TEACHER_NAME like '%Yarmolik%'
select TEACHER_NAME FROM TEACHER WHERE PULPIT LIKE 'ISiT'
--t1
select TEACHER_NAME FROM TEACHER WHERE PULPIT LIKE 'ISiT'
--t2
COMMIT

--B
BEGIN TRAN
DELETE TEACHER WHERE TEACHER_NAME LIKE 'Bycnuk%'
insert TEACHER values(18,'Yarmolik Nickolay','m','ISiT')
update TEACHER set TEACHER_NAME = 'Misha Poc' where TEACHER_NAME like '%Yarmolik%'
select TEACHER_NAME FROM TEACHER WHERE PULPIT LIKE 'ISiT'
--t1
COMMIT
select TEACHER_NAME FROM TEACHER WHERE PULPIT LIKE 'ISiT'
--t2

--8
begin tran 
	insert FACULTY values ('NB','NewBalance');
	begin tran
		update PULPIT set FACULTY = 'NB' where PULPIT = 'BP'
	commit;
	if @@TRANCOUNT >0 commit; --rollback отменит всё
	select (select count(*) from PULPIT where FACULTY = 'NB') 'PULPIT',
	(select count(8) from FACULTY where FACULTY = 'NB')  'FACULTY';

update PULPIT set FACULTY = 'IT' where PULPIT = 'BP'
delete faculty where FACULTY = 'NB'