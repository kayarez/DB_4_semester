
use KE_UNIVER;

--1-- РЕЖИМ НЕЯВНОЙ ТРАНЗАКЦИИ
--CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- неявная транзакция продолжается до тех пор, пока не будет выполнен COMMIT или ROLLBACK
set nocount on
if  exists (select * from  SYS.OBJECTS where OBJECT_ID=object_id(N'DBO.TAB')) drop table TAB;           
declare @c int, @flag char = 'c'; -- если поменять с на r, то таблица не сохранится

SET IMPLICIT_TRANSACTIONS ON -- включение режим неявной транзакции
	create table TAB(K int );                         
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print 'количество строк в таблице TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit; else rollback;                              
SET IMPLICIT_TRANSACTIONS OFF   -- выключение режим неявной транзакции
if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.TAB')) print 'таблица TAB есть';  
	else print 'таблицы TAB нет'



--2
-- BEGIN TRANSACTION -> COMMIT TRAN или ROLLBACK TRAN
begin try
	begin tran                 -- начало  явной транзакции
		insert FACULTY values ('ДФ', 'Факультет других наук');
	    --insert FACULTY values ('ПиМ', 'Факультет print-технологий и медиакоммуникаций');
	commit tran;               -- фиксация транзакции
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then 'дублирование товара'
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5))+ error_message()  
	end; 
	if @@trancount > 0 rollback tran; -- если значение больше нуля, то транзакция не завершена, откат  
end catch;

select * from FACULTY;



--3-- ОПЕРАТОР SAVETRAN
-- если несколько независимых блоков операторов T-SQL
declare @point varchar(32);
 
begin try
	begin tran                              

		set @point = 'p1'; 
		save tran @point;  -- контрольная точка p1

		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values (20,'Алина', '1998-01-22', NULL, NULL),
							  (20,'Александра', '1998-08-06', NULL, NULL),
							  (20,'Татьяна', '1998-08-01', NULL, NULL),
							  (20,'Екатерина', '1998-08-03', NULL, NULL);    

		set @point = 'p2'; 
		save tran @point; -- контрольная точка p2 (перезаписали, назвали по-другому)

		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values (20, 'Особенный Студент', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then 'дублирование студента' 
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- если транзакция не завершена
	begin
	   print 'контрольная точка: '+ @point;
	   rollback tran @point; -- откат к последней контрольной точке
	   commit tran; -- фиксация изменений, выполненных до контрольной точки 
	end;     
end catch;

select * from STUDENT where IDGROUP=20; 
delete STUDENT where IDGROUP=20; 


--4. 
--Сценарий A явная транзакция с уровнем изолированности READ UNCOMMITED, 
--сценарий B – явная транзакция с уровнем изолированности READ COMMITED (по умолчанию). 
--Сценарий A должен демонстрировать, что уровень READ UNCOMMITED допускает неподтвержденное, 
--неповторяющееся и фантомное чтение. 


------A----------

set transaction isolation level READ UNCOMMITTED
begin transaction


-----t1----------

select @@SPID, 'insert FACULTY' 'результат', *
from FACULTY WHERE FACULTY = 'ИТ2';
select @@SPID, 'update PULPIT' 'результат', *
from PULPIT WHERE FACULTY = 'ИТ2';
commit;

-----t2----------

-----B-----------

begin transaction
select @@SPID
insert FACULTY VALUES ('ИТ2','Информационных технологий');
update PULPIT set FACULTY = 'ИТ' WHERE PULPIT = 'ИСиТ'

-----t1----------
-----t2----------

ROLLBACK;




--5.
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, 
--но при этом возможно  неповторяющееся и фантомное чтение. 

-----A--------

set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT
where FACULTY = 'ИТ2';

-----t1-------
-----t2-------

select 'update PULPIT' 'результат', count(*)
from PULPIT;
commit;

------B----

begin transaction

------t1-----

update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ИСиТ';
commit;

------t2------

--6.
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. 
--Сце-нарий B – явную транзакцию с уровнем изолированности READ COMMITED. 

--------A---------

set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = 'ПОиСОИ';

--------t1---------
--------t2---------

select case
    when TEACHER = 'ПТР' THEN 'insert TEACHER'
	else ' '
	end 'результат', TEACHER
FROM TEACHER WHERE PULPIT = 'ПОиСОИ';
commit;

--- B ---	
begin transaction 	  
--- t1 --------------------
insert TEACHER values ('ИИИ', 'Иванов Иван Иванович', 'м', 'ИСиТ                ');
commit; 
--- t2 --------------------

select * from TEACHER




--7. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий представляет собой явную транзакцию с уровнем изолированности SE-RIALIZABLE. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COM-MITED. 
--Сценарий A должен демонстрировать отсутствие фантомного, неподтвержденного и не-повторяющегося чтения.

      -- A ---
          set transaction isolation level SERIALIZABLE 
	begin transaction 
		  delete TEACHER where TEACHER = 'АРС';  
          insert TEACHER values ('ИВН', 'Иванов Сергей Борисович', 'м', 'ПОиСОИ              ');
          update TEACHER set TEACHER = 'ШМКВ' where TEACHER = 'ШМК';
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';
	-------------------------- t1 -----------------
	 select TEACHER from TEACHER  where PULPIT = 'ЛУ';
	-------------------------- t2 ------------------ 
	commit; 	
	--- B ---	
	begin transaction 	  
	delete TEACHER where TEACHER = 'АРС';  
          insert TEACHER values ('ИВН', 'Иванов Сергей Борисович', 'м', 'ПОиСОИ              ');
          update TEACHER set TEACHER = 'ШМКВ' where TEACHER = 'ШМК';
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';
          -------------------------- t1 --------------------
          commit; 
           select TEACHER from TEACHER  where PULPIT = 'ЛУ';
      -------------------------- t2 --------------------


--8-- ВЛОЖЕННЫЕ ТРАНЗАКЦИИ
-- Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
-- оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции; 
-- оператор ROLLBACK вложенной транзакции действует на опе-рации внешней и внутренней транзакции, 
-- а также завершает обе транзакции; 
-- уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT. 

select (select count(*) from dbo.PULPIT where FACULTY = 'ИДиП') 'Кафедры ИДИПа', 
(select count(*) from FACULTY where FACULTY.FACULTY = 'ИДиП') 'ИДИП'; 

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='Кафедра ИДиПа' where PULPIT.FACULTY = 'ИДиП';
	commit;
if @@TRANCOUNT > 0 rollback;

-- Здесь внутренняя транзакция завершается фиксацией своих операций; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции. 
set transaction isolation level READ UNCOMMITTED;

set transaction isolation level READ COMMITTED;

set transaction isolation level REPEATABLE READ;

