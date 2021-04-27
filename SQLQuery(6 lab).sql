use KE_UNIVER
--������ ������������ ������, �� ������������� ������� ���������� ����� ��������
select PULPIT.PULPIT_NAME,FACULTY.FACULTY,PROFESSION_NAME
from faculty,pulpit,PROFESSION
where pulpit.FACULTY=FACULTY.FACULTY and PROFESSION.FACULTY=FACULTY.FACULTY
and PROFESSION.PROFESSION_NAME in(select PROFESSION.PROFESSION_NAME from PROFESSION where (PROFESSION.PROFESSION_NAME like '%��������%'));
--��� �� ������, �� � ����������� inner join ������ from �������� �������
select PULPIT.PULPIT_NAME,FACULTY.FACULTY,PROFESSION.PROFESSION_NAME
from PROFESSION inner join FACULTY
on faculty.FACULTY=PROFESSION.FACULTY
join pulpit on pulpit.FACULTY=FACULTY.FACULTY
where PROFESSION.PROFESSION_NAME in(select PROFESSION.PROFESSION_NAME from PROFESSION where (PROFESSION.PROFESSION_NAME like '%��������%'));
--��� �� ������ ��� ����������
select PULPIT.PULPIT_NAME,FACULTY.FACULTY,PROFESSION.PROFESSION_NAME
from PROFESSION inner join FACULTY
on faculty.FACULTY=PROFESSION.FACULTY
join pulpit on pulpit.FACULTY=FACULTY.FACULTY
where PROFESSION.PROFESSION_NAME like '%��������%';
--������ ��������� ����� ������� ������������
select AUDITORIUM_CAPACITY , AUDITORIUM_TYPE, AUDITORIUM_NAME
from AUDITORIUM a
where AUDITORIUM_CAPACITY=(select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
 where a.AUDITORIUM_TYPE=aa.AUDITORIUM_TYPE
 order by AUDITORIUM_CAPACITY desc  );
 --������ ������������ �����������, �� ������� ��� �� ����� �������
select FACULTY_NAME
from FACULTY
where not exists (select * from PULPIT where PULPIT.FACULTY=FACULTY.FACULTY)

--������������ ������, ���������� ������� �������� ������ �� 3 �����������
select top(1) (select avg(Note) from PROGRESS where PROGRESS.SUBJECT='����') [����],
(select avg(Note) from PROGRESS where PROGRESS.SUBJECT='��') [��],
(select avg(Note) from PROGRESS where PROGRESS.SUBJECT='����') [����]
from PROGRESS;
--������ � ����������� ��������� all
select progress.subject,progress.note, STUDENT.NAME from PROGRESS
join STUDENT
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
where note >=all(select note from PROGRESS where SUBJECT like '����');
--������ � ����������� ��������� any
select progress.subject,progress.note, STUDENT.NAME from PROGRESS
join STUDENT
on PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
where note >any(select note from PROGRESS where SUBJECT like '����');

use K_MyBase
select ������.����������,������.[����� ������], ������.�������� from ������
join ������
on ������.[������������ ������]=������.[������������ ������]
where [����� ������] >all(select [����� ������] from ������ where [������������ ������] like '������');

select ������.����������,������.[����� ������], ������.�������� from ������
join ������
on ������.[������������ ������]=������.[������������ ������]
where [����� ������] >any(select [����� ������] from ������ where [������������ ������] like '����');


