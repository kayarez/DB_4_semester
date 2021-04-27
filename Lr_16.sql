
use KE_UNIVER
go 
create table TR_AUDIT
(
ID int identity,
STMT varchar(20)
check (STMT in ('INS', 'DEL', 'UPD')),
TRNAME varchar(50),
CC varchar(300)
)
go
--drop table TR_AUDIT
-- drop trigger TR_TEACHER_INS 
    CREATE  trigger TR_TEACHER_INS 
      on TEACHER after INSERT  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
      print 'Операция вставки';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('INS', 'TR_TEACHER_INS', @in);	         
      return;  
      go
	  insert into  TEACHER values('nwунн', 'newу', 'м', 'ИСиТ');
	  select * from TR_AUDIT
	 

------------------------------------------------------------------2
drop  trigger TR_TEACHER_DEL  
go
    create  trigger TR_TEACHER_DEL 
      on TEACHER after DELETE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
      print 'Операция удаления';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER_DEL', @in);	         
      return;  
      go

	  delete TEACHER where TEACHER='nwунн'
	  select * from TR_AUDIT
------------------------------------------------------------------
--3
drop trigger TR_TEACHER_DEL
go
    alter  trigger TR_TEACHER_DEL
      on TEACHER after UPDATE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
	  declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 

      print 'Операция обновления';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      set @a1 = (select TEACHER from deleted);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('UPD', 'TR_TEACHER_UPD', @in);	         
      return;  
      go

	  update TEACHER set GENDER = 'ж' where TEACHER='nw'
	  select * from TR_AUDIT

	  delete from TR_AUDIT where STMT = 'UPD'
------------------------------------------------------------------4 
go
create trigger TR_TEACHER   on TEACHER after INSERT, DELETE, UPDATE  
 as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
	  declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 
   if  @ins > 0 and  @del = 0  begin print 'Событие: INSERT';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('INS', 'TR_TEACHER_INS', @in);	
	 end; 
  else		  	 
    if @ins = 0 and  @del > 0  begin print 'Событие: DELETE';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER_DEL', @in);
	  end; 
  else	  
    if @ins > 0 and  @del > 0  begin print 'Событие: UPDATE'; 
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      set @a1 = (select TEACHER from deleted);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('UPD', 'TR_TEACHER_UPD', @in); 
	  end; 
	  return;  

	  delete TEACHER where TEACHER='nw'
	  insert into  TEACHER values('nw', 'new', 'м', 'ИСиТ');
	  	  update TEACHER set GENDER = 'ж' where TEACHER='nw'
	  select * from TR_AUDIT
------------------------------------------------------------------5

update TEACHER set GENDER = 'э' where TEACHER='nw'
 select * from TR_AUDIT
------------------------------------------------------------------6

--Создать три AFTER-триггера



Insert into FACULTY(FACULTY) values ('new')
go   
create trigger TR_TEACHER_DEL1 on FACULTY after DELETE  
as print 'TR_TEACHER_DEL1';
 return;  
go 
create trigger TR_TEACHER_DEL2 on FACULTY after DELETE  
as print 'TR_TEACHER_DEL2';
 return;  
go  
create trigger TR_TEACHER_DEL3 on FACULTY after DELETE  
as print 'TR_TEACHER_DEL3';
 return;  
go    


select t.name, e.type_desc 
  from sys.triggers  t join  sys.trigger_events e  on t.object_id = e.object_id  
  where OBJECT_NAME(t.parent_id)='FACULTY' and e.type_desc = 'DELETE' ;  
  -- системные процедуры
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order='First', @stmttype = 'DELETE';
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order='Last', @stmttype = 'DELETE';


select t.name, e.type_desc 
  from sys.triggers  t join  sys.trigger_events e  on t.object_id = e.object_id  
  where OBJECT_NAME(t.parent_id)='FACULTY' and e.type_desc = 'DELETE' ; 
------------------------------------------------------------------7

--Разработать сценарий, демонстрирующий на примере базы данных X_BSTU утверждение: 
--AFTER-триггер является частью транзакции, в рамках которого выполняется оператор, акти-визировавший триггер.
go 
	create trigger PTran 
	on PULPIT after INSERT, DELETE, UPDATE  
	as   declare @c int = (select count (*) from PULPIT); 	 
	 if (@c >26) 
	 begin
       raiserror('Общая количество кафедр не может быть >26', 10, 1);
	 rollback; 
	 end; 
	 return;          

	insert into PULPIT(PULPIT) values ('new')
------------------------------------------------------------------8
go 
	create trigger F_INSTEAD_OF 
	on FACULTY instead of DELETE 
	as 
raiserror (N'Удаление запрещено', 10, 1);
	return;
	 delete FACULTY where FACULTY = 'ИДиП'

	 drop trigger F_INSTEAD_OF
	 drop trigger PTran
	 drop trigger TR_TEACHER
	 drop trigger TR_TEACHER_DEL
	
	 
--ласт
go 
create trigger DDL_TMPSH_BSTU on database for DDL_DATABASE_LEVEL_EVENTS  
as 
declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');
print 'Тип события: ' + @t;
print 'Имя объекта: ' + @t1;
print 'Тип объекта: ' + @t2;
raiserror(N' Операции удаления, создания, изменения таблиц запрещены', 16, 1);  
rollback;    
return;

drop table TEACHER;

drop trigger DDL_S_BSTU
