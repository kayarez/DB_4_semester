use KE_UNIVER

--1-- представление таблицы TEACHER
go
CREATE VIEW [Преподаватели] 
as select TEACHER [Код], TEACHER_NAME [Имя преподавателя], GENDER [Пол], PULPIT [Код кафедры] 
from  TEACHER;
go
select * from Преподаватели
drop view [Преподаватели];

--2-- количество кафедр на каждом факультете
go
CREATE VIEW [Количество всех кафедр]
as select FACULTY.FACULTY_NAME [Факультет], count(*) [Количество]
from FACULTY join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;
go
select * from [Количество всех кафедр]
drop view [Количество всех кафедр];

--3-- все лекционные аудитории
go
CREATE VIEW [Лекционные аудитории] (Наименование_аудитории, код_аудитории)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%ЛК%';        
go
select * from [Лекционные аудитории] 
INSERT [Лекционные аудитории]  values ('332-4', 'ЛК');
--DELETE from [Лекционные аудитории] where Наименование_аудитории = '332-4';
select * from [Лекционные аудитории] 
drop view [Лекционные аудитории] 

--4-- п.3 with check option
go
CREATE VIEW [Лекционные аудитории] (Наименование_аудитории, код_аудитории)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%ЛК%'        
WITH CHECK OPTION;
go
select * from [Лекционные аудитории]

INSERT [Лекционные аудитории] values ('432', 'ЛК');
--DELETE from [Лекционные аудитории] where Наименование_аудитории = '432';
select * from [Лекционные аудитории]
drop view [Лекционные аудитории]

--5-- дисциплины в алфавитном порядке
go
create view [Дисциплины] (Код, Наименование_дисциплины, Код_кафедры)
as select top 15 SUBJECT.SUBJECT, SUBJECT.SUBJECT_NAME, SUBJECT.PULPIT
from SUBJECT 
order by SUBJECT.SUBJECT_NAME
go
select * from Дисциплины

drop view [Дисциплины]

--6-- schemabinding
go
CREATE VIEW [Количество кафедр_1] WITH SCHEMABINDING
as select FACULTY.FACULTY_NAME [Факультет], count(*) [Количество]
from dbo.FACULTY join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;
go
-- блокирует таблицы, на которые ссылается представление и запрещает любые изменения схемы этих таблиц
select * from [Количество кафедр_1]

alter table FACULTY -- не можем изменять
alter column FACULTY char(50) not null;

drop view [Количество кафедр_1];


use K_MyBase

--Представление таблицы ЗАКАЗЫ
go
CREATE VIEW [Заказанные товары] 
as select [Наименование товара] [Товар],
Покупатель [Покупатель],
[Дата сделки] [Дата сделки] from ЗАКАЗЫ;
go
select * from [Заказанные товары]
drop view [Заказанные товары];

--Товары по возрастанию цены
go
create view [Все товары] (Наименование, Цена, Количество)
as select top 5 ТОВАРЫ.[Наименование товара], ТОВАРЫ.Цена, ТОВАРЫ.[Количество на складе]
from ТОВАРЫ
order by ТОВАРЫ.Цена
go
select * from [Все товары]
drop view [Все товары]

--Товары, которые заказаны в 2 экземплярах 
go
CREATE VIEW [Заказанные товары] (Наименование_товара, Количество, Заказчик, Номер_заказа)
as select ЗАКАЗЫ.[Наименование товара], ЗАКАЗЫ.[Количество заказанного товара], ЗАКАЗЫ.Покупатель, 
ЗАКАЗЫ.[Номер заказа]
from ЗАКАЗЫ
where  ЗАКАЗЫ.[Количество заказанного товара] = 2;        
go
select * from [Заказанные товары] 
drop view [Заказанные товары] 

--Добавление и удаление покупателя
go
CREATE VIEW [Все покупатели] (Покупатель, Телефон, Адрес)
as select ПОКУПАТЕЛИ.Покупатель, ПОКУПАТЕЛИ.Телефон, ПОКУПАТЕЛИ.Адрес
from ПОКУПАТЕЛИ     
go
select * from [Все покупатели] 
INSERT [Все покупатели]  values ('Лисункова', '6854325', 'Белорусская, 19,  804');
--DELETE from [Все покупатели] where Покупатель = 'Лисункова';
select * from [Все покупатели] 
drop view [Все покупатели] 