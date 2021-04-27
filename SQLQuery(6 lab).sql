use KE_UNIVER
--список наименований кафедр, на специальности которых содержится слово технолог
select PULPIT.PULPIT_NAME,FACULTY.FACULTY,PROFESSION_NAME
from faculty,pulpit,PROFESSION
where pulpit.FACULTY=FACULTY.FACULTY and PROFESSION.FACULTY=FACULTY.FACULTY
and PROFESSION.PROFESSION_NAME in(select PROFESSION.PROFESSION_NAME from PROFESSION where (PROFESSION.PROFESSION_NAME like '%технолог%'));
--тот же запрос, но в конструкции inner join секции from внешнего запроса
select PULPIT.PULPIT_NAME,FACULTY.FACULTY,PROFESSION.PROFESSION_NAME
from PROFESSION inner join FACULTY
on faculty.FACULTY=PROFESSION.FACULTY
join pulpit on pulpit.FACULTY=FACULTY.FACULTY
where PROFESSION.PROFESSION_NAME in(select PROFESSION.PROFESSION_NAME from PROFESSION where (PROFESSION.PROFESSION_NAME like '%технолог%'));
--тот же запрос без подзапроса
select PULPIT.PULPIT_NAME,FACULTY.FACULTY,PROFESSION.PROFESSION_NAME
from PROFESSION inner join FACULTY
on faculty.FACULTY=PROFESSION.FACULTY
join pulpit on pulpit.FACULTY=FACULTY.FACULTY
where PROFESSION.PROFESSION_NAME like '%технолог%';
--список аудиторий самых больших вместимостей
select AUDITORIUM_CAPACITY , AUDITORIUM_TYPE, AUDITORIUM_NAME
from AUDITORIUM a
where AUDITORIUM_CAPACITY=(select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
 where a.AUDITORIUM_TYPE=aa.AUDITORIUM_TYPE
 order by AUDITORIUM_CAPACITY desc  );
 --список наименований факультетов, на которых нет ни одной кафедры
select FACULTY_NAME
from FACULTY
where not exists (select * from PULPIT where PULPIT.FACULTY=FACULTY.FACULTY)

--сформировать строку, содержащую средние значения оценок по 3 дисциплинам
select top(1) (select avg(Note) from PROGRESS where PROGRESS.SUBJECT='ОАиП') [ОАиП],
(select avg(Note) from PROGRESS where PROGRESS.SUBJECT='БД') [БД],
(select avg(Note) from PROGRESS where PROGRESS.SUBJECT='СУБД') [СУБД]
from PROGRESS;
--запрос с применением оператора all
select progress.subject,progress.note, STUDENT.NAME from PROGRESS
join STUDENT
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
where note >=all(select note from PROGRESS where SUBJECT like 'ОАиП');
--запрос с применением оператора any
select progress.subject,progress.note, STUDENT.NAME from PROGRESS
join STUDENT
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
where note >any(select note from PROGRESS where SUBJECT like 'ОАиП');

use K_MyBase
select ЗАКАЗЫ.Покупатель,ЗАКАЗЫ.[Номер заказа], ТОВАРЫ.Описание from ЗАКАЗЫ
join ТОВАРЫ
on ЗАКАЗЫ.[Наименование товара]=ТОВАРЫ.[Наименование товара]
where [Номер заказа] >all(select [Номер заказа] from ЗАКАЗЫ where [Наименование товара] like 'Стакан');

select ЗАКАЗЫ.Покупатель,ЗАКАЗЫ.[Номер заказа], ТОВАРЫ.Описание from ЗАКАЗЫ
join ТОВАРЫ
on ЗАКАЗЫ.[Наименование товара]=ТОВАРЫ.[Наименование товара]
where [Номер заказа] >any(select [Номер заказа] from ЗАКАЗЫ where [Наименование товара] like 'Стол');


