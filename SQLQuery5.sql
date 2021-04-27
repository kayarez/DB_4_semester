USE K_MyBase;
SELECT * From ПОКУПАТЕЛИ;
SELECT ПОКУПАТЕЛЬ from ПОКУПАТЕЛИ;
SELECT count(*) From ПОКУПАТЕЛИ;
SELECT [Наименование товара] From ТОВАРЫ Order By Цена Desc;
SELECT ПОКУПАТЕЛЬ from ЗАКАЗЫ where [Дата поставки] between '2019-01-01' and '2020-01-01';