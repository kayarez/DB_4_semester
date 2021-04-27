use KE_UNIVER;

---------------------------------------------------1/1

go
create function COUNT_STUDENTS (@faculty varchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (select count(IDSTUDENT) from FACULTY inner join "GROUPS" 
													on FACULTY.FACULTY = "GROUPS".FACULTY 
												inner join STUDENT 
													on "GROUPS".IDGROUP = STUDENT.IDGROUP 
													where FACULTY.FACULTY LIKE @faculty);
return @rc;
end;
--drop function COUNT_STUDENTS
go
declare @n int = dbo.COUNT_STUDENTS('ÈÒ');
print 'Êîëè÷åñòâî ñòóäåíòîâ: ' + cast(@n as varchar(4));
-----------------------------------------------------------------1/2
go
alter function COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = '1-89 02 02') returns int
as begin
declare @rc int = 0;
set @rc = (select count(IDSTUDENT) from FACULTY inner join "GROUPS" 
													on FACULTY.FACULTY = "GROUPS".FACULTY 
												inner join STUDENT 
													on "GROUPS".IDGROUP = STUDENT.IDGROUP 
														where FACULTY.FACULTY = @faculty and "GROUPS".PROFESSION = @prof);
return @rc;
end;

go
declare @n int = dbo.COUNT_STUDENTS('ÈÝÔ', '1-25 01 07');
print 'Êîëè÷åñòâî ñòóäåíòîâ: ' + cast(@n as varchar(4));
--2.
go
create function FSUBJECTS (@p varchar(20)) returns varchar(300)
as begin
declare @sb varchar(10), @s varchar(300) = 'Äèñöèïëèíû: ';
declare sbjct cursor local static for select "SUBJECT" from "SUBJECT" where PULPIT LIKE @p;
open sbjct;
fetch sbjct into @sb;
while @@fetch_status = 0
begin
set @s = @s + ', ' + rtrim(@sb);
fetch sbjct into @sb;
end;
return @s;
end;
--DROP FUNCTION FSUBJECTS
go 
select PULPIT, dbo.FSUBJECTS(PULPIT) from SUBJECT;
--3. 
go 
create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY left outer join PULPIT
  on FACULTY.FACULTY = PULPIT.FACULTY
   where FACULTY.FACULTY = isnull(@f, FACULTY.FACULTY) and 
   PULPIT.PULPIT = isnull(@p, PULPIT.PULPIT);
 --DROP FUNCTION FFACPUL
go
select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL('ÒÎÂ', null);
select * from dbo.FFACPUL(null, 'ÕÏÄ');
select * from dbo.FFACPUL('ÒÎÂ', 'ÕÏÄ');

--4. 
go 
create function FCTEACHER(@p varchar(20)) returns int
as begin
declare @rc int = (select count(TEACHER) from TEACHER where PULPIT = isnull(@p, PULPIT));
return @rc;
end;
-- DROP FUNCTION FCTEACHER
go 
select PULPIT, dbo.FCTEACHER(PULPIT)[Êîëè÷åñòâî ïðåïîäàâàòåëåé] from TEACHER;
select dbo.FCTEACHER(null)[Îáùåå êîëè÷åñòâî ïðåïîäàâàòåëåé];
--5.
CREATE FUNCTION FACULTY_REPORT(@C INT) 
  RETURNS @FR TABLE
	(   
		[ÔÀÊÓËÜÒÅÒ] VARCHAR(50), 
		[ÊÎËÈ×ÅÑÒÂÎ ÊÀÔÅÄÐ] INT, 
		[ÊÎËÈ×ÅÑÒÂÎ ÃÐÓÏÏ]  INT, 
		[ÊÎËÈ×ÅÑÒÂÎ ÑÒÓÄÅÍÒÎÂ] INT, 
		[ÊÎËÈ×ÅÑÒÂÎ ÑÏÅÖÈÀËÜÍÎÑÒÅÉ] INT    
	)
	AS 
	BEGIN 
		DECLARE CC CURSOR STATIC FOR SELECT FACULTY FROM FACULTY WHERE DBO.COUNT_STUDENTS(FACULTY, DEFAULT)> @C; 
	    DECLARE @F VARCHAR(30);
	    OPEN CC;  
		FETCH CC INTO @F;
	    WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT @FR VALUES( @F,  (SELECT COUNT(PULPIT) FROM PULPIT WHERE FACULTY = @F),
				(SELECT COUNT(IDGROUP) FROM GROUPS WHERE FACULTY = @F),   DBO.COUNT_STUDENTS(@F, DEFAULT),
				(SELECT COUNT(PROFESSION) FROM PROFESSION WHERE FACULTY = @F)   ); 
				FETCH CC INTO @F;  
			END;   
		 RETURN; 
	 END;
GO

SELECT *  FROM DBO.FACULTY_REPORT(1)
GO

CREATE FUNCTION COUNT_PULPITS(@F VARCHAR(20)) RETURNS INT
 AS 
	BEGIN  
	DECLARE @RC INT = 0;
    SET @RC = (SELECT COUNT(PULPIT) 
		FROM PULPIT INNER JOIN FACULTY 
		ON PULPIT.FACULTY=FACULTY.FACULTY 
		WHERE FACULTY.FACULTY = @F) ;  
	 RETURN @RC;          
	END;  
GO


CREATE FUNCTION COUNT_GROUPS(@F VARCHAR(20)) RETURNS INT
 AS 
	BEGIN  
	DECLARE @RC INT = 0;
    SET @RC = (SELECT COUNT(IDGROUP) 
		FROM GROUPS INNER JOIN FACULTY 
		ON GROUPS.FACULTY=FACULTY.FACULTY 
		WHERE FACULTY.FACULTY = @F) ;  
	 RETURN @RC;          
	END;  
GO

--drop FUNCTION COUNT_SPECS

CREATE FUNCTION COUNT_SPECS(@F VARCHAR(20)) RETURNS INT
 AS 
	BEGIN  
	DECLARE @RC INT = 0;
    SET @RC = (SELECT COUNT(PROFESSION) 
		FROM PROFESSION INNER JOIN FACULTY 
		ON PROFESSION.FACULTY=FACULTY.FACULTY 
		WHERE FACULTY.FACULTY = @F) ;  
	 RETURN @RC;          
	END;  
GO

ALTER FUNCTION FACULTY_REPORT(@C INT) 
  RETURNS @FR TABLE
	(   
		[ÔÀÊÓËÜÒÅÒ] VARCHAR(50), 
		[ÊÎËÈ×ÅÑÒÂÎ ÊÀÔÅÄÐ] INT, 
		[ÊÎËÈ×ÅÑÒÂÎ ÃÐÓÏÏ]  INT, 
		[ÊÎËÈ×ÅÑÒÂÎ ÑÒÓÄÅÍÒÎÂ] INT, 
		[ÊÎËÈ×ÅÑÒÂÎ ÑÏÅÖÈÀËÜÍÎÑÒÅÉ] INT      
	)
	AS 
	BEGIN 
		DECLARE CC CURSOR STATIC FOR SELECT FACULTY FROM FACULTY WHERE DBO.COUNT_STUDENTS(FACULTY, DEFAULT)> @C; 
	    DECLARE @F VARCHAR(30);
	    OPEN CC;  
		FETCH CC INTO @F;
	    WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT @FR VALUES
				(	@F,  
					DBO.COUNT_PULPITS (@F),
					DBO.COUNT_GROUPS (@F),   
					DBO.COUNT_STUDENTS(@F, DEFAULT),
					dbo.COUNT_SPECS(@F)  
				); 
				FETCH CC INTO @F;  
			END;   
		 RETURN; 
	 END;
GO

SELECT *  FROM DBO.FACULTY_REPORT(1) 
GO

