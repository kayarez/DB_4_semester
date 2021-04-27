USE KE_UNIVER
------------------------------------------------------------------1


DECLARE		 @a char ='c',
             @b varchar(4) = '����',
             @c datetime , 
			 @d time,
			 @i  int,
			 @e  smallint, 
			 @f numeric(12, 5);  
			 SET @c = getdate();
			 SET @d = getdate();
			 SELECT @i = (select count(*) from GROUPS);
			 SELECT @e = (select AVG(NOTE) from PROGRESS);
			 SELECT @a 'a = ', @b 'b = ', @c 'c = ', @d 'd = ';
			 print 'i = ' +cast(@i as varchar(5));
			 print 'e = ' +cast(@e as varchar(5));
			 print 'f = ' +cast(@f as varchar(5)); 



------------------------------------------------------------------2
--������������ ����� ����������� ���������

DECLARE @y1 int = (select cast(sum(AUDITORIUM_CAPACITY) as int) from AUDITORIUM), 
        @y2 int, 
		@y3 numeric(3,1), 
		@y4 int, 
		@y5 int;
If @y1>200 
begin
SELECT @y2 = (select cast( count(*) as numeric(8,3)) from AUDITORIUM),
       @y3 = (select cast(AVG(AUDITORIUM_CAPACITY ) as numeric(8,3)) from AUDITORIUM)
SET @y4= (select cast(COUNT(*) as numeric(8,3)) from AUDITORIUM where AUDITORIUM_CAPACITY < @y3)
SET @y5 = (@y4*100)/@y2
SELECT @y1   '����� �����������',  @y2   '����������',  @y3   '������� �����������',
 @y4   '���������� ��������� � ������������ ���� �������', @y5 '������� ��������� � ������������ ���� �������'
End
else   print '����� ����������� = ' + cast(@y1 as varchar(5));




--------------------------------------------------------------------3  

--����� ���������� ����������
print '����� ������������ �����: '+ cast( @@ROWCOUNT as varchar(12)); 
print '������ SQL Server: '+ cast( @@VERSION  as varchar(100)); 
print '���������� ��������� ������������� ��������, ����������� �������� �������� �����������: '+ cast( @@SPID  as varchar(12)); 
print '��� ��������� ������: '+ cast( @@ERROR  as varchar(12)); 
print '���������� ������� ����������� ����������: '+ cast( @@TRANCOUNT  as varchar(12)); 
print '�������� ���������� ���������� ����� ��������������� ������: '+ cast( @@FETCH_STATUS  as varchar(12)); 
print '��� �������: '+ cast( @@SERVERNAME as varchar(12)); 
print '������� ����������� ������� ���������: '+ cast( @@NESTLEVEL  as varchar(12)); 




-------------------------------------------------4


DECLARE @t int = 5, 
        @x int = 8, 
		@z float;
if @t>@x  SET @z = power(sin(@t), 2);
if @t<@x  SET @z = 4*(@t+@x);
else      SET @z = 1-exp(@x-2); 
print 'z = ' + cast(@z as varchar(12));



--______________________

--�������������� ������� ��� �������� � ����������� 
SELECT SUBSTRING(NAME, 1, CHARINDEX(' ', NAME))
      +SUBSTRING(NAME, CHARINDEX(' ', NAME)+1, 1)+'.'
      +SUBSTRING(NAME, CHARINDEX(' ', NAME, CHARINDEX(' ', NAME)+1)+1, 1)+'.' FROM STUDENT;


--______________________
--����� ���������, � ������� ���� �������� � ��������� ������, � ����������� �� ��������;

SELECT NAME, BDAY, DATEDIFF(YEAR, BDAY, GETDATE()) [AGE] FROM STUDENT
                   WHERE MONTH(BDAY) = MONTH(DATEADD(MONTH, 1, GETDATE()));



-------------------------------------------------------------------5


--������������ ����������� if else
   DECLARE @q int = (select count(*) FROM FACULTY);
     IF (select count(*) FROM FACULTY)>5
     begin
     PRINT '���������� ����������� ������ 5';
     PRINT '���������� = ' +cast(@q as varchar(10));  
     end;
	 else
     begin
     PRINT '���������� ����������� ������ 5';
     PRINT '���������� = ' +cast(@q as varchar(10));  
     end;




-------------------------------------------------------------------6
        SELECT  CASE 
                when NOTE between 9 and 10 then '9-10' 
                when NOTE between 7 and 8 then '7-8'
                when NOTE between 5 and 6 then '5-6'
				when NOTE = 4 then '������'
				else   '���������'
                end  ������ , count(*) [����������] 
           FROM PROGRESS   
           GROUP BY CASE 
                when NOTE between 9 and 10 then '9-10' 
                when NOTE between 7 and 8 then '7-8'
                when NOTE between 5 and 6 then '5-6'
				when NOTE = 4 then '������'
				else   '���������'
                end




-------------------------------------------------------------------7

--��������� ��������� �������
CREATE table  #TBL
 (   ����� int,  
  [���������� � �������] float, 
  ������ varchar(100) );
SET nocount on;      --�� �������� ��������� � ����� �����
DECLARE @ik int=0; 
WHILE @ik<10
  begin 
  INSERT #TBL values(@ik, POWER(@ik, 2), replicate('������', 3));
  SET @ik=@ik+1;
  end;
  select * from #TBL

  drop table  #TBL





-------------------------------------------------------------------9
--return
DECLARE @xk int = 5
     print exp(@xk)
     print sqrt(@xk+2) 
     RETURN
     print @xk+1





-------------------------------------------------------------------10


begin TRY
update dbo.PROGRESS set NOTE = '����' where NOTE= 6
end try
begin CATCH
print ERROR_NUMBER() --��� ��������� ������
print ERROR_MESSAGE() --��������� �� ������
print ERROR_LINE()  --��� ��������� ������
print ERROR_PROCEDURE() --���  ��������� ��� NULL
print ERROR_SEVERITY()  --������� ����������� ������
print ERROR_STATE() --����� ������
end catch



