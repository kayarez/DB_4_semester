USE KE_UNIVER
------------------------------------------------------------------1


DECLARE		 @a char ='c',
             @b varchar(4) = 'БГТУ',
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
--определяется общая вместимость аудиторий

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
SELECT @y1   'Общая вместимость',  @y2   'Количество',  @y3   'Средняя вместимость',
 @y4   'Количество аудиторий с вместимостью ниже средней', @y5 'Процент аудиторий с вместимостью ниже средней'
End
else   print 'Общая вместимость = ' + cast(@y1 as varchar(5));




--------------------------------------------------------------------3  

--вывод глобальных переменных
print 'Число обработанных строк: '+ cast( @@ROWCOUNT as varchar(12)); 
print 'Версия SQL Server: '+ cast( @@VERSION  as varchar(100)); 
print 'Возвращает системный идентификатор процесса, назначенный сервером текущему подключению: '+ cast( @@SPID  as varchar(12)); 
print 'Код последней ошибки: '+ cast( @@ERROR  as varchar(12)); 
print 'Возвращает уровень вложенности транзакции: '+ cast( @@TRANCOUNT  as varchar(12)); 
print 'Проверка результата считывания строк результирующего набора: '+ cast( @@FETCH_STATUS  as varchar(12)); 
print 'Имя сервера: '+ cast( @@SERVERNAME as varchar(12)); 
print 'Уровень вложенности текущей процедуры: '+ cast( @@NESTLEVEL  as varchar(12)); 




-------------------------------------------------4


DECLARE @t int = 5, 
        @x int = 8, 
		@z float;
if @t>@x  SET @z = power(sin(@t), 2);
if @t<@x  SET @z = 4*(@t+@x);
else      SET @z = 1-exp(@x-2); 
print 'z = ' + cast(@z as varchar(12));



--______________________

--преобразование полного ФИО студента в сокращенное 
SELECT SUBSTRING(NAME, 1, CHARINDEX(' ', NAME))
      +SUBSTRING(NAME, CHARINDEX(' ', NAME)+1, 1)+'.'
      +SUBSTRING(NAME, CHARINDEX(' ', NAME, CHARINDEX(' ', NAME)+1)+1, 1)+'.' FROM STUDENT;


--______________________
--поиск студентов, у которых день рождения в следующем месяце, и определение их возраста;

SELECT NAME, BDAY, DATEDIFF(YEAR, BDAY, GETDATE()) [AGE] FROM STUDENT
                   WHERE MONTH(BDAY) = MONTH(DATEADD(MONTH, 1, GETDATE()));



-------------------------------------------------------------------5


--демонстрация конструкции if else
   DECLARE @q int = (select count(*) FROM FACULTY);
     IF (select count(*) FROM FACULTY)>5
     begin
     PRINT 'Количество факультетов больше 5';
     PRINT 'Количество = ' +cast(@q as varchar(10));  
     end;
	 else
     begin
     PRINT 'Количество факультетов меньше 5';
     PRINT 'Количество = ' +cast(@q as varchar(10));  
     end;




-------------------------------------------------------------------6
        SELECT  CASE 
                when NOTE between 9 and 10 then '9-10' 
                when NOTE between 7 and 8 then '7-8'
                when NOTE between 5 and 6 then '5-6'
				when NOTE = 4 then 'четыре'
				else   'пересдача'
                end  Оценка , count(*) [Количество] 
           FROM PROGRESS   
           GROUP BY CASE 
                when NOTE between 9 and 10 then '9-10' 
                when NOTE between 7 and 8 then '7-8'
                when NOTE between 5 and 6 then '5-6'
				when NOTE = 4 then 'четыре'
				else   'пересдача'
                end




-------------------------------------------------------------------7

--временная локальная таблица
CREATE table  #TBL
 (   Число int,  
  [Возведение в степень] float, 
  Строка varchar(100) );
SET nocount on;      --не выводить сообщения о вводе строк
DECLARE @ik int=0; 
WHILE @ik<10
  begin 
  INSERT #TBL values(@ik, POWER(@ik, 2), replicate('строка', 3));
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
update dbo.PROGRESS set NOTE = 'пять' where NOTE= 6
end try
begin CATCH
print ERROR_NUMBER() --код последней ошибки
print ERROR_MESSAGE() --сообщение об ошибке
print ERROR_LINE()  --код последней ошибки
print ERROR_PROCEDURE() --имя  процедуры или NULL
print ERROR_SEVERITY()  --уровень серьезности ошибки
print ERROR_STATE() --метка ошибки
end catch



