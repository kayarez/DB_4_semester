use KE_UNIVER

--1-- данные об аудиториях
SELECT MAX(AUDITORIUM_CAPACITY) [MAX], 
		MIN(AUDITORIUM_CAPACITY) [MIN], 
		AVG(AUDITORIUM_CAPACITY) [AVG], 
		SUM(AUDITORIUM_CAPACITY) [SUM],
		count(*) [COUNT]
from AUDITORIUM;

--2-- данные об аудиториях каждого типа
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [Тип аудитории], 
		  max(AUDITORIUM_CAPACITY)  [Макс. вместимость],
		  min(AUDITORIUM_CAPACITY)  [Мин. вместимость],
		  avg(AUDITORIUM_CAPACITY)  [Ср. вместимость],
		  sum(AUDITORIUM_CAPACITY)  [Сум. вместимость],  
          count(*)  [Кол-во аудиторий]
From  AUDITORIUM inner join AUDITORIUM_TYPE
	on  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE  
		group by  AUDITORIUM_TYPENAME

--3-- количество оценок для диапазонов 4-5, 6-7, 8-9//независ
SELECT  *
 FROM (select Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end  [Оценки], COUNT (*) [Количество]    
FROM PROGRESS Group by Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end ) as T
ORDER BY Case [Оценки]
   when '4-5' then 4
   when '6-7' then 3
   when '8-9' then 2
   else 1
   end  

--4-- средняя оценка для каждой специальности каждого курса
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then 'выпуск'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else 'выпуск'
   end  [курс],  
 round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]--round
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT                  
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [средняя оценка] desc


--5-- п.4 только для ОАиП и БД
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then 'выпуск'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else 'выпуск'
   end  [курс],  
 round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT  
where p.[SUBJECT]='БД' or p.[SUBJECT] = 'ОАиП'                
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [средняя оценка] desc


--6-- средние оценки по всем предметам всех групп ТОВ'а
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ТОВ'                  
GROUP BY  f.FACULTY, g.PROFESSION, p.SUBJECT

--rollup возвращает комбинацию групп и итоговых строк
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ТОВ'                  
GROUP BY ROLLUP(f.FACULTY, g.PROFESSION, p.SUBJECT)


--7-- п.6 с CUBE 
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ТОВ'                  
GROUP BY CUBE(f.FACULTY, g.PROFESSION, p.SUBJECT)--возвращает любую возможную комбинацию групп и итоговых строк


--8-- union ИДиП и ХТиТ UNION 
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ТОВ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
UNION
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ХТиТ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--9-- intersect (нет общих строк)
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ТОВ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
INTERSECT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ХТиТ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--10--EXCEPT (разность) 
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ТОВ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
EXCEPT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средняя оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ХТиТ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--11-- having - количество 8 и 9 для каждой дисциплины
--HAVING вычисляется для каждой строки результирующего набора
select p1.SUBJECT, p1.NOTE,
(select count(*) from PROGRESS p2
where p1.SUBJECT=p2.SUBJECT and p1.NOTE=p2.NOTE) [количество]
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE 
having p1.NOTE=8 or p1.NOTE=9

use K_MyBase
SELECT MAX(Цена) [MAX], 
		MIN(Цена) [MIN], 
		AVG(Цена) [AVG], 
		SUM(Цена) [SUM],
		count(*) [COUNT]
from ТОВАРЫ;

--Определить наименования и максимальные цены товаров при продаже, 
--количество заказанных товаров для тех товаров, количество которых на складе больше 5
SELECT [Номер заказа],  
          max(Цена)  [Максимальная цена],  
          count(*)  [Количество заказанных товаров]
    From  ЗАКАЗЫ  Inner Join  ТОВАРЫ 
              On  ЗАКАЗЫ.[Наименование товара] = ТОВАРЫ.[Наименование товара]
               And  ТОВАРЫ.[Количество на складе] >5   Group by [Номер заказа]

--Получить информацию о заказанных товарах двух фирм и их количестве можно с помощью запроса
SELECT [Наименование товара], sum([Количество заказанного товара]) Количество
From ЗАКАЗЫ Where Покупатель = 'Лысенков'
Group By [Наименование товара]
UNION
SELECT [Наименование товара], sum([Количество заказанного товара]) Количество
From ЗАКАЗЫ Where Покупатель = 'Керезь'
Group By [Наименование товара]

--Наименования заказанных товаров, количество заказанных товаров которых меньше 4, и количество заказов
SELECT p1.[Наименование товара], p1.[Количество заказанного товара],
(select COUNT(*) from ЗАКАЗЫ p2
where p2.[Наименование товара] = p1.[Наименование товара]
and p2.[Количество заказанного товара] = p1.[Количество заказанного товара]) [Количество заказов]
from ЗАКАЗЫ p1
Group By p1.[Наименование товара], p1.[Количество заказанного товара]
Having [Количество заказанного товара]<4