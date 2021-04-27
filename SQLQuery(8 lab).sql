use KE_UNIVER

--1-- ������������� ������� TEACHER
go
CREATE VIEW [�������������] 
as select TEACHER [���], TEACHER_NAME [��� �������������], GENDER [���], PULPIT [��� �������] 
from  TEACHER;
go
select * from �������������
drop view [�������������];

--2-- ���������� ������ �� ������ ����������
go
CREATE VIEW [���������� ���� ������]
as select FACULTY.FACULTY_NAME [���������], count(*) [����������]
from FACULTY join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;
go
select * from [���������� ���� ������]
drop view [���������� ���� ������];

--3-- ��� ���������� ���������
go
CREATE VIEW [���������� ���������] (������������_���������, ���_���������)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%��%';        
go
select * from [���������� ���������] 
INSERT [���������� ���������]  values ('332-4', '��');
--DELETE from [���������� ���������] where ������������_��������� = '332-4';
select * from [���������� ���������] 
drop view [���������� ���������] 

--4-- �.3 with check option
go
CREATE VIEW [���������� ���������] (������������_���������, ���_���������)
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_TYPE  
from AUDITORIUM
where  AUDITORIUM.AUDITORIUM_TYPE like '%��%'        
WITH CHECK OPTION;
go
select * from [���������� ���������]

INSERT [���������� ���������] values ('432', '��');
--DELETE from [���������� ���������] where ������������_��������� = '432';
select * from [���������� ���������]
drop view [���������� ���������]

--5-- ���������� � ���������� �������
go
create view [����������] (���, ������������_����������, ���_�������)
as select top 15 SUBJECT.SUBJECT, SUBJECT.SUBJECT_NAME, SUBJECT.PULPIT
from SUBJECT 
order by SUBJECT.SUBJECT_NAME
go
select * from ����������

drop view [����������]

--6-- schemabinding
go
CREATE VIEW [���������� ������_1] WITH SCHEMABINDING
as select FACULTY.FACULTY_NAME [���������], count(*) [����������]
from dbo.FACULTY join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;
go
-- ��������� �������, �� ������� ��������� ������������� � ��������� ����� ��������� ����� ���� ������
select * from [���������� ������_1]

alter table FACULTY -- �� ����� ��������
alter column FACULTY char(50) not null;

drop view [���������� ������_1];


use K_MyBase

--������������� ������� ������
go
CREATE VIEW [���������� ������] 
as select [������������ ������] [�����],
���������� [����������],
[���� ������] [���� ������] from ������;
go
select * from [���������� ������]
drop view [���������� ������];

--������ �� ����������� ����
go
create view [��� ������] (������������, ����, ����������)
as select top 5 ������.[������������ ������], ������.����, ������.[���������� �� ������]
from ������
order by ������.����
go
select * from [��� ������]
drop view [��� ������]

--������, ������� �������� � 2 ����������� 
go
CREATE VIEW [���������� ������] (������������_������, ����������, ��������, �����_������)
as select ������.[������������ ������], ������.[���������� ����������� ������], ������.����������, 
������.[����� ������]
from ������
where  ������.[���������� ����������� ������] = 2;        
go
select * from [���������� ������] 
drop view [���������� ������] 

--���������� � �������� ����������
go
CREATE VIEW [��� ����������] (����������, �������, �����)
as select ����������.����������, ����������.�������, ����������.�����
from ����������     
go
select * from [��� ����������] 
INSERT [��� ����������]  values ('���������', '6854325', '�����������, 19,  804');
--DELETE from [��� ����������] where ���������� = '���������';
select * from [��� ����������] 
drop view [��� ����������] 