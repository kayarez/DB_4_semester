use KE_UNIVER;
go

--1
create procedure PSUBJECT
as begin
declare @n int = (select count(*) from "SUBJECT");
select SUBJECT [���], SUBJECT_NAME [����������], PULPIT [�������] from "SUBJECT";
return @n;
--drop procedure PSUBJECT;
end;


declare @k int;
exec @k = PSUBJECT;--��������� � ���������
print '���������� ���������: ' + cast(@k as varchar(3));
go



--2
alter procedure PSUBJECT @p varchar(20), @c int output
as begin
select * from "SUBJECT" where "SUBJECT" = @p;
set @c = @@rowcount;
return @c;
end;


declare @k1 int;
exec @k1 = PSUBJECT @p = '����', @c = @k1 output;
print '���������� ���������: ' + cast(@k1 as varchar(3));
go

--3
alter procedure PSUBJECT @p varchar(20)
as begin
select * from "SUBJECT" where "SUBJECT" = @p;
end;


create table #SUBJECT(���_�������� varchar(20), ��������_�������� varchar(100), ������� varchar(20));
insert #SUBJECT exec PSUBJECT @p = '���';
insert #SUBJECT exec PSUBJECT @p = '����';
select * from #SUBJECT;
go




--4
create procedure PAUDITORIUM_INSERT12 @a char(20), @n varchar(50), @c int = 0, @t char(10)
as begin 
begin try
insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME) values(@a, @n, @c, @t);
return 1;
end try
begin catch
print '����� ������: ' + cast(error_number() as varchar(6));
print '���������: ' + error_message();
print '�������: ' + cast(error_severity() as varchar(6));
print '�����: ' + cast(error_state() as varchar(8));
print '����� ������: ' + cast(error_line() as varchar(8));
if error_procedure() is not null   
print '��� ���������: ' + error_procedure();
return -1;
end catch;
end;


declare @rc int;  
exec @rc = PAUDITORIUM_INSERT12 @a = '621-3', @n = '��', @c = 85, @t = '621-3'; 
print '��� ������: ' + cast(@rc as varchar(3));
go

--5
create procedure SUBJECT_REPORT12 @p char(10) 
as begin
declare @rc int;
begin try
declare @sb char(10), @r varchar(100) = '';
declare sbjct cursor for select "SUBJECT" from "SUBJECT" where PULPIT = @p;
if not exists(select "SUBJECT" from "SUBJECT" where PULPIT = @p)
raiserror('������', 11, 1);
else open sbjct;
fetch sbjct into @sb;
print '��������: ';
while @@fetch_status = 0
begin
set @r = rtrim(@sb) + ', ' + @r;  
set @rc = @rc + 1;
fetch sbjct into @sb;
end
print @r;
close sbjct;
return @rc;
end try
begin catch
print '������ � ����������' 
if error_procedure() is not null   
print '��� ���������: ' + error_procedure();
return @rc;
end catch;
end;


declare @k2 int;  
exec @k2 = SUBJECT_REPORT12 @p ='���';  
print '���������� ���������: ' + cast(@k2 as varchar(3));
go




--6 
create procedure PAUDITORIUM_INSERTX12 @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50)
as begin
declare @rc int = 1;
begin try
set transaction isolation level serializable;          
begin tran
insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values(@n, @tn);
exec @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
commit tran;
return @rc;
end try
begin catch
print '����� ������: ' + cast(error_number() as varchar(6));
print '���������: ' + error_message();
print '�������: ' + cast(error_severity() as varchar(6));
print '�����: ' + cast(error_state() as varchar(8));
print '����� ������: ' + cast(error_line() as varchar(8));
if error_procedure() is not  null   
print '��� ���������: ' + error_procedure(); 
if @@trancount > 0 rollback tran ; 
return -1;
end catch;
end;


declare @k3 int;  
exec @k3 = PAUDITORIUM_INSERTX12 '622-3', @n = '��', @c = 85, @t = '622-3', @tn = '����. �����'; 
print '��� ������: ' + cast(@k3 as varchar(3));  



--��������� ������� ������ �������� � ���-��� �� ������� ������ � ������. ���� ���� �������, �� + 1 ����, ���� - -1


--������� �� id �������, ����� ����� ������. ���� ��. 


--�������� ��������� ������� �� ��������� ������. 

