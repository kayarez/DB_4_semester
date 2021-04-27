USE KEREZ_UNIVER;
CREATE table STUDENT
(nomer_zachetki int primary key,
second_name nvarchar(20) not null,
groups int);
ALTER Table STUDENT ADD Дата_поступления date; 
ALTER Table STUDENT ADD POL nchar(1) default 'м' check (POL in ('м', 'ж'));
ALTER Table STUDENT DROP Column Дата_поступления;
INSERT into STUDENT (nomer_zachetki, second_name, groups) values (123, 'kerez', 4);
INSERT into STUDENT (nomer_zachetki, second_name, groups) values (143, 'kostukov', 5);
INSERT into STUDENT (nomer_zachetki, second_name, groups) values (133, 'smelov', 6);
INSERT into STUDENT (nomer_zachetki, second_name, groups) values (183, 'ivanov', 7);
SELECT * From STUDENT;
SELECT nomer_zachetki, second_name from STUDENT;
SELECT count(*) From STUDENT;
SELECT second_name From STUDENT Order By nomer_zachetki Desc;
UPDATE STUDENT set groups = 5;
DELETE from STUDENT Where nomer_zachetki = 183;
SELECT * From STUDENT;
SELECT second_name from STUDENT where nomer_zachetki In (143, 144);
CREATE Table RESULTS
(ID int primary key identity(1,1),
STUDENT_NAME nvarchar(20),
RESULT1 real,
RESULT2 real,
AVER_VALUE as (RESULT1 + RESULT2)/2
);
INSERT into RESULTS(STUDENT_NAME, RESULT1, RESULT2) values ('sidorov', 5.6, 6.5);
INSERT into RESULTS(STUDENT_NAME, RESULT1, RESULT2) values ('petrov', 4.9, 7.3);


