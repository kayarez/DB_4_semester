use KE_UNIVER
declare @tv char(20), @subj char(300)='';
declare CursorSubject Cursor 
for select s.SUBJECT from PULPIT as p inner join SUBJECT as s
on p.PULPIT=s.PULPIT
where p.PULPIT='ИСиТ'
open CursorSubject;
fetch CursorSubject into @tv;
print 'Subjects:'
while @@FETCH_STATUS=0 --проверка на успешность выполнения
begin
set @subj=RTRIM(@tv)+','+@subj;
fetch CursorSubject into @tv;
end;
print @subj;
close CursorSubject
--------------------------------------2
declare SecondTask cursor local
for select s.SUBJECT from PULPIT as p inner join SUBJECT as s
on p.PULPIT=s.PULPIT
where p.PULPIT='ИСиТ';
declare @a char(20), @d char(300)='';
open SecondTask
fetch SecondTask into @d
set @a=rtrim(@d)
set @a='Subjects '+@a;
print @a
go
declare @a char(20), @d char(300)='';
fetch SecondTask into @d
set @a=rtrim(@d)
set @a='Subjects '+@a;
print @a
close SecondTask
go

declare SecondTaskGlobal cursor global
for select s.SUBJECT from PULPIT as p inner join SUBJECT as s
on p.PULPIT=s.PULPIT
where p.PULPIT='ИСиТ';
declare @b char(20), @c char(300)='';
open SecondTaskGlobal
fetch SecondTaskGlobal into @c
set @b=rtrim(@c)
set @b='Subjects '+@b;
print @b
go
declare @b char(20), @c char(300)='';
fetch SecondTaskGlobal into @c
set @b=rtrim(@c)
set @b='Subjects '+@b;
print @b
close SecondTaskGlobal
deallocate SecondTaskGlobal
go

-------------------------------------3
declare ThirdTaskStatic cursor local static
for select SUBJECT,PULPIT from SUBJECT
declare @count varchar(30),@pulpit varchar(30);
open ThirdTaskStatic;
print 'number of lines: '+cast(@@cursor_rows as varchar(5));
update SUBJECT SET SUBJECT_NAME='PUPA' where SUBJECT like 'БД'
delete SUBJECT where SUBJECT like 'PUPA'
insert SUBJECT(SUBJECT,SUBJECT_NAME,PULPIT) values
('Помогите','мне','ИСиТ');
fetch ThirdTaskStatic into @count,@pulpit
while @@FETCH_STATUS = 0
		begin  
		print @count+' '+@pulpit;
		fetch ThirdTaskStatic into @count, @pulpit
		end;
 close  ThirdTaskStatic;
 go


declare ThirdTaskDynamic cursor dynamic
for select SUBJECT,PULPIT from SUBJECT
declare @count varchar(30),@pulpit varchar(30);
open ThirdTaskDynamic;
print 'number of lines: '+cast(@@cursor_rows as varchar(5));
update SUBJECT SET SUBJECT_NAME='PUPA' where SUBJECT like 'БД'
delete SUBJECT where SUBJECT like 'PUPA'
insert SUBJECT(SUBJECT,SUBJECT_NAME,PULPIT) values
('Помогите','мне','ИСиТ');
fetch ThirdTaskDynamic into @count,@pulpit
while @@FETCH_STATUS = 0
		begin  
		print @count+' '+@pulpit;
		fetch ThirdTaskDynamic into @count, @pulpit
		end;
 close  ThirdTaskDynamic;
 go
 ---------------------------------4
 declare @f varchar(20), @s varchar(50);
 declare FourthTask cursor local  dynamic scroll
 for select ROW_NUMBER() over ( order by SUBJECT ) as row_numbers, SUBJECT from SUBJECT
 open FourthTask;
 fetch FourthTask into @f,@s;
 fetch first from FourthTask into @f,@s
 print 'first line  : ' +cast (@f as varchar(3)) +'-'+rtrim (@s);
 	fetch next from FourthTask into @f,@s;
	print 'next line   : '+cast (@f as varchar(3))+'-'+rtrim(@s);
	fetch last from FourthTask into @f,@s;
	print 'last line   : '+cast(@f as varchar (3))+'-' +rtrim (@s);
	fetch prior from FourthTask into @f,@s;
	print 'prior line by current  : '+cast (@f as varchar(3))+'-'+rtrim(@s);
	fetch absolute 3 from FourthTask into @f,@s;
	print '3 line from start: ' + cast(@f as varchar(3))+'-'+rtrim(@s);
	fetch relative -2 from FourthTask into @f,@s;
	print '-2 line from current: '+cast(@f as varchar(3))+'-' +rtrim(@s);
	close FourthTask;

select * from STUDENT as S
inner join PROGRESS as P
on P.IDSTUDENT = S.IDSTUDENT
inner join GROUPS as G
on G.IDGROUP = S.IDGROUP
declare @note varchar(5), @name varchar(100);
declare FifthSixTask cursor local dynamic
for select NOTE,IDSTUDENT from PROGRESS for update;
open FifthSixTask;
fetch FifthSixTask into @note,@name;
while @@FETCH_STATUS = 0
	begin
	print @name + '-' + @note
	if cast(@note as int) < 4 
	delete PROGRESS where current of FifthSixTask
	else
	print @note
	fetch FifthSixTask into @note, @name;
	end;
fetch last from FifthSixTask into @note, @name;
update PROGRESS set NOTE = NOTE + 1 where current of FifthSixTask;
close FifthSixTask;