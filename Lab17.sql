use KE_UNIVER;

--1
go 
create trigger DDL_TMPSH_BSTU on database for DDL_DATABASE_LEVEL_EVENTS  
as 
declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');
print 'Тип события: ' + @t;
print 'Имя объекта: ' + @t1;
print 'Тип объекта: ' + @t2;
raiserror(N' Операции удаления, создания, изменения таблиц запрещены', 16, 1);  
rollback;    
return;

drop table TEACHER;

drop trigger DDL_S_BSTU
--2
--2 RAW

select TEACHER.TEACHER_NAME 'преподоватль' 
      from  TEACHER  
	  where TEACHER.GENDER = 'ж' for xml RAW('наименование'),
      root('Список_преподоватлей'), elements;



-- AUTO
select [студент].IDSTUDENT [номер],
       [студент].NAME [имя], 
       [группа].IDGROUP [номер_группы] 
       from  STUDENT [студент] join GROUPS [группа] 
                                 on [студент].IDGROUP=[группа].IDGROUP
   where [группа].YEAR_FIRST in (2010, 2012) 
   order by [номер_группы]  for xml AUTO, 
   root('Список_студентов'), elements;



--  PATH
select [преподователь].TEACHER_NAME  [имя],
       [кафедра].PULPIT_NAME [кафедра], 
       [факультет].FACULTY_NAME [факультет] 
       from  TEACHER [преподователь] join PULPIT [кафедра] 
       on [преподователь].PULPIT = [кафедра].PULPIT join FACULTY [факультет]
       on [факультет].FACULTY =  [кафедра].FACULTY
 where [факультет].FACULTY in('ТТЛП','ЛХФ') 
 order by [факультет]  for xml PATH('преподаватель'),    
 root('Список_преподавателей'), elements;


--3
go
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины> 
                         <дисциплина код="КГиГ" название="Компьютерная геометрия и графика" кафедра="РИТ" /> 
                         <дисциплина код="ОЗИ" название="Основы защиты информации" кафедра="РИТ" />  
                      </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj;
insert "SUBJECT" select [код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина', 0) with([код] char(10), [название] varchar(100), [кафедра] char(20));      

select * from SUBJECT
--4
insert into STUDENT(IDGROUP, NAME, BDAY, INFO) values(19, 'Керезь Екатерина Викторовна', '05.06.2000', 
                                                         '<студентка>
														    <паспорт серия="AB" номер="4546655" дата="22.05.2012"/>
															<телефон>+375336717658</телефон>
															<адрес>
															   <страна>Беларусь</страна>
															   <город>Брест</город>
															   <улица>Екельчика</улица>
															   <дом>11</дом>
															   <квартира>35</квартира>
															</адрес>
														  </студентка>');
select * from STUDENT where NAME = 'Керезь Екатерина Викторовна';
update STUDENT set INFO = '<студентка>
						      <паспорт серия="AB" номер="4546655" дата="22.05.2012"/>
								<телефон>+375336717658</телефон>
								<адрес>
									<страна>Беларусь</страна>
									<город>Брест</город>
									<улица>Екельчика</улица>
									<дом>11</дом>
									<квартира>35</квартира>
								</адрес>
							</студент>'
where NAME = 'Керезь Екатерина Викторовна';
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта], INFO.value('(студентка/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта], INFO.query('/студентка/адрес')[Адрес] from  STUDENT where NAME = 'Керезь Екатерина Викторовна';       

--5
go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);
