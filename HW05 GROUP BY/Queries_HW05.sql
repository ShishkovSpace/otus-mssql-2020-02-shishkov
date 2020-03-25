use WideWorldImporters;
/*
* 1. Query to get data about average item price and total sales sum per month
*/
-- for months over all years
select	month(i.InvoiceDate) as Month, 
		AVG(il.UnitPrice) as AverageUnitPrice,
		SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by month(i.InvoiceDate)
order by Month;

-- for months over each year
select	year(i.InvoiceDate) as Year,
		month(i.InvoiceDate) as Month, 
		AVG(il.UnitPrice) as AverageUnitPrice,
		SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by year(i.InvoiceDate), month(i.InvoiceDate)
order by Year, Month;

/*
* 2. Query to get info about all months where total sales amount more then 10000
*/
-- for months over all years
select	month(i.InvoiceDate) as Month,
		SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by month(i.InvoiceDate)
having SUM(il.Quantity*il.UnitPrice)>10000
order by Month;

-- for months over each year
select	year(i.InvoiceDate) as Year,
		month(i.InvoiceDate) as Month,
		SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by year(i.InvoiceDate), month(i.InvoiceDate)
having SUM(il.Quantity*il.UnitPrice)>10000
order by Year, Month;

/*
* 3. Query to get info about sales amount, date of first sale and amount of sold items per month
* for items which have count less then 50 per month
*/
select	il.StockItemID as ItemID, year(i.InvoiceDate) as Year, month(i.InvoiceDate) as Month,
		SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount,
		MIN(i.InvoiceDate) as FirstSaleDate,
		SUM(il.Quantity) as AmountOfSoldItems 
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by il.StockItemID, year(i.InvoiceDate), month(i.InvoiceDate)
having SUM(il.Quantity)<=50
order by ItemID, Year, Month

/*
* 4. Recursive CTE query to pull data into temporary table or table variable
*/
-- Creating table
DROP TABLE IF EXISTS dbo.MyEmployees;

CREATE TABLE dbo.MyEmployees 
( 
EmployeeID smallint NOT NULL, 
FirstName nvarchar(30) NOT NULL, 
LastName nvarchar(40) NOT NULL, 
Title nvarchar(50) NOT NULL, 
DeptID smallint NOT NULL, 
ManagerID int NULL, 
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
); 
GO
INSERT INTO dbo.MyEmployees VALUES 
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL) 
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1) 
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273) 
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274) 
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274) 
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273) 
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285) 
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273) 
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 

-- table variable
declare @var_table table
		(EmployeeID smallint NOT NULL, 
		 FullName nvarchar(70) NOT NULL, 
		 Title nvarchar(50) NOT NULL, 
		 EmployeeLevel int NOT NULL);
		 
with CTEParent as (
select	EmployeeID,
		CONCAT(FirstName, ' ', LastName)as FullName,
		Title, 
		1 as Level
from dbo.MyEmployees
where ManagerID is NULL
union all
select	me.EmployeeID,
		CONCAT(FirstName, ' ', LastName)as FullName,
		me.Title, 
		cte.Level+1 as Level
from dbo.MyEmployees me
inner join CTEParent cte on cte.EmployeeID=me.ManagerID
)
insert into @var_table
select	EmployeeID,
		case Level
			when 1 then FullName
			when 2 then CONCAT('| ', FullName)
			when 3 then CONCAT('|| ', FullName)
			when 4 then CONCAT('||| ', FullName)
		end as FullName,
		Title,
		Level
from CTEParent;

select *
from @var_table;

--  temporary table
drop table if exists tempdb.#temp_table;

create table #temp_table
		(EmployeeID smallint NOT NULL, 
		 FullName nvarchar(70) NOT NULL, 
		 Title nvarchar(50) NOT NULL, 
		 EmployeeLevel int NOT NULL);
		 
with CTEParent as (
select	EmployeeID,
		CONCAT(FirstName, ' ', LastName)as FullName,
		Title, 
		1 as Level
from dbo.MyEmployees
where ManagerID is NULL
union all
select	me.EmployeeID,
		CONCAT(me.FirstName, ' ', me.LastName) as FullName,
		me.Title, 
		cte.Level+1 as Level
from dbo.MyEmployees me
inner join CTEParent cte on cte.EmployeeID=me.ManagerID
)
insert into #temp_table
	(EmployeeID,
	 FullName,
	 Title,
	 EmployeeLevel)
select	EmployeeID,
		case Level
			when 1 then FullName
			when 2 then CONCAT('| ', FullName)
			when 3 then CONCAT('|| ', FullName)
			when 4 then CONCAT('||| ', FullName)
		end as FullName,
		Title,
		Level
from CTEParent;

select *
from #temp_table;