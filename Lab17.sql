use KE_UNIVER;

--1
go 
create trigger DDL_TMPSH_BSTU on database for DDL_DATABASE_LEVEL_EVENTS  
as 
declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');
print '��� �������: ' + @t;
print '��� �������: ' + @t1;
print '��� �������: ' + @t2;
raiserror(N' �������� ��������, ��������, ��������� ������ ���������', 16, 1);  
rollback;    
return;

drop table TEACHER;

drop trigger DDL_S_BSTU
--2
--2 RAW

select TEACHER.TEACHER_NAME '������������' 
      from  TEACHER  
	  where TEACHER.GENDER = '�' for xml RAW('������������'),
      root('������_�������������'), elements;



-- AUTO
select [�������].IDSTUDENT [�����],
       [�������].NAME [���], 
       [������].IDGROUP [�����_������] 
       from  STUDENT [�������] join GROUPS [������] 
                                 on [�������].IDGROUP=[������].IDGROUP
   where [������].YEAR_FIRST in (2010, 2012) 
   order by [�����_������]  for xml AUTO, 
   root('������_���������'), elements;



--  PATH
select [�������������].TEACHER_NAME  [���],
       [�������].PULPIT_NAME [�������], 
       [���������].FACULTY_NAME [���������] 
       from  TEACHER [�������������] join PULPIT [�������] 
       on [�������������].PULPIT = [�������].PULPIT join FACULTY [���������]
       on [���������].FACULTY =  [�������].FACULTY
 where [���������].FACULTY in('����','���') 
 order by [���������]  for xml PATH('�������������'),    
 root('������_��������������'), elements;


--3
go
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <����������> 
                         <���������� ���="����" ��������="������������ ��������� � �������" �������="���" /> 
                         <���������� ���="���" ��������="������ ������ ����������" �������="���" />  
                      </����������>';
exec sp_xml_preparedocument @h output, @sbj;
insert "SUBJECT" select [���], [��������], [�������] from openxml(@h, '/����������/����������', 0) with([���] char(10), [��������] varchar(100), [�������] char(20));      

select * from SUBJECT
--4
insert into STUDENT(IDGROUP, NAME, BDAY, INFO) values(19, '������ ��������� ����������', '05.06.2000', 
                                                         '<���������>
														    <������� �����="AB" �����="4546655" ����="22.05.2012"/>
															<�������>+375336717658</�������>
															<�����>
															   <������>��������</������>
															   <�����>�����</�����>
															   <�����>���������</�����>
															   <���>11</���>
															   <��������>35</��������>
															</�����>
														  </���������>');
select * from STUDENT where NAME = '������ ��������� ����������';
update STUDENT set INFO = '<���������>
						      <������� �����="AB" �����="4546655" ����="22.05.2012"/>
								<�������>+375336717658</�������>
								<�����>
									<������>��������</������>
									<�����>�����</�����>
									<�����>���������</�����>
									<���>11</���>
									<��������>35</��������>
								</�����>
							</�������>'
where NAME = '������ ��������� ����������';
select NAME[���], INFO.value('(�������/�������/@�����)[1]', 'char(2)')[����� ��������], INFO.value('(���������/�������/@�����)[1]', 'varchar(20)')[����� ��������], INFO.query('/���������/�����')[�����] from  STUDENT where NAME = '������ ��������� ����������';       

--5
go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������">
<xs:complexType><xs:sequence>
<xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
<xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);
