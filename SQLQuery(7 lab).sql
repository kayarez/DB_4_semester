use KE_UNIVER

--1-- ������ �� ����������
SELECT MAX(AUDITORIUM_CAPACITY) [MAX], 
		MIN(AUDITORIUM_CAPACITY) [MIN], 
		AVG(AUDITORIUM_CAPACITY) [AVG], 
		SUM(AUDITORIUM_CAPACITY) [SUM],
		count(*) [COUNT]
from AUDITORIUM;

--2-- ������ �� ���������� ������� ����
SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [��� ���������], 
		  max(AUDITORIUM_CAPACITY)  [����. �����������],
		  min(AUDITORIUM_CAPACITY)  [���. �����������],
		  avg(AUDITORIUM_CAPACITY)  [��. �����������],
		  sum(AUDITORIUM_CAPACITY)  [���. �����������],  
          count(*)  [���-�� ���������]
From  AUDITORIUM inner join AUDITORIUM_TYPE
	on  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE  
		group by  AUDITORIUM_TYPENAME

--3-- ���������� ������ ��� ���������� 4-5, 6-7, 8-9//�������
SELECT  *
 FROM (select Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end  [������], COUNT (*) [����������]    
FROM PROGRESS Group by Case 
   when NOTE  between 4 and  5  then '4-5'
   when NOTE  between 6 and  7  then '6-7'
   when NOTE  between 8 and  9  then '8-9'
   else '10'
   end ) as T
ORDER BY Case [������]
   when '4-5' then 4
   when '6-7' then 3
   when '8-9' then 2
   else 1
   end  

--4-- ������� ������ ��� ������ ������������� ������� �����
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then '������'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else '������'
   end  [����],  
 round(avg(cast(p.NOTE as float(4))),2) [������� ������]--round
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT                  
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [������� ������] desc


--5-- �.4 ������ ��� ���� � ��
SELECT  f.FACULTY, g.PROFESSION,
case  when g.YEAR_FIRST = 2010 then '������'
	  when g.YEAR_FIRST = 2011 then '5'
	  when g.YEAR_FIRST = 2012 then '4'
	  when g.YEAR_FIRST = 2013 then '3'
	  when g.YEAR_FIRST = 2014 then '2'
	  when g.YEAR_FIRST = 2015 then '1'
   else '������'
   end  [����],  
 round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT  
where p.[SUBJECT]='��' or p.[SUBJECT] = '����'                
GROUP BY g.PROFESSION, f.FACULTY, g.YEAR_FIRST
ORDER BY [������� ������] desc


--6-- ������� ������ �� ���� ��������� ���� ����� ���'�
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='���'                  
GROUP BY  f.FACULTY, g.PROFESSION, p.SUBJECT

--rollup ���������� ���������� ����� � �������� �����
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='���'                  
GROUP BY ROLLUP(f.FACULTY, g.PROFESSION, p.SUBJECT)


--7-- �.6 � CUBE 
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='���'                  
GROUP BY CUBE(f.FACULTY, g.PROFESSION, p.SUBJECT)--���������� ����� ��������� ���������� ����� � �������� �����


--8-- union ���� � ���� UNION 
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='���'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
UNION
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--9-- intersect (��� ����� �����)
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='���'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
INTERSECT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--10--EXCEPT (��������) 
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='���'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
EXCEPT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT


--11-- having - ���������� 8 � 9 ��� ������ ����������
--HAVING ����������� ��� ������ ������ ��������������� ������
select p1.SUBJECT, p1.NOTE,
(select count(*) from PROGRESS p2
where p1.SUBJECT=p2.SUBJECT and p1.NOTE=p2.NOTE) [����������]
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE 
having p1.NOTE=8 or p1.NOTE=9

use K_MyBase
SELECT MAX(����) [MAX], 
		MIN(����) [MIN], 
		AVG(����) [AVG], 
		SUM(����) [SUM],
		count(*) [COUNT]
from ������;

--���������� ������������ � ������������ ���� ������� ��� �������, 
--���������� ���������� ������� ��� ��� �������, ���������� ������� �� ������ ������ 5
SELECT [����� ������],  
          max(����)  [������������ ����],  
          count(*)  [���������� ���������� �������]
    From  ������  Inner Join  ������ 
              On  ������.[������������ ������] = ������.[������������ ������]
               And  ������.[���������� �� ������] >5   Group by [����� ������]

--�������� ���������� � ���������� ������� ���� ���� � �� ���������� ����� � ������� �������
SELECT [������������ ������], sum([���������� ����������� ������]) ����������
From ������ Where ���������� = '��������'
Group By [������������ ������]
UNION
SELECT [������������ ������], sum([���������� ����������� ������]) ����������
From ������ Where ���������� = '������'
Group By [������������ ������]

--������������ ���������� �������, ���������� ���������� ������� ������� ������ 4, � ���������� �������
SELECT p1.[������������ ������], p1.[���������� ����������� ������],
(select COUNT(*) from ������ p2
where p2.[������������ ������] = p1.[������������ ������]
and p2.[���������� ����������� ������] = p1.[���������� ����������� ������]) [���������� �������]
from ������ p1
Group By p1.[������������ ������], p1.[���������� ����������� ������]
Having [���������� ����������� ������]<4