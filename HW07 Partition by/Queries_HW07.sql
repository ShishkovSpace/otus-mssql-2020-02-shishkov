/* 
* 1. Using temp table and table variable
*/
-- table variable
declare @tmp_table table (Year int, Month int, Total decimal(18,2));

insert into @tmp_table (Year, Month, Total)
select	year(ii.InvoiceDate) as Year, month(ii.InvoiceDate) as Month, 
		SUM(iil.Quantity*iil.UnitPrice)+(select coalesce(SUM(til.Quantity*til.UnitPrice),0)
										  from Sales.Invoices ti
										  inner join Sales.InvoiceLines til on ti.InvoiceID=til.InvoiceID
										  where year(ti.InvoiceDate)>=2015 and ti.InvoiceDate<=CONCAT(year(ii.InvoiceDate),'-',month(ii.InvoiceDate),'-01')
			) as Total
from Sales.Invoices ii
inner join Sales.InvoiceLines iil on ii.InvoiceID=iil.InvoiceID
where year(ii.InvoiceDate)>=2015
group by year(ii.InvoiceDate), month(ii.InvoiceDate);

select	i.InvoiceID as InvoiceID,
		i.CustomerID as CustomerID,
		i.InvoiceDate as Month,
		(il.Quantity*il.UnitPrice) as Sum,
		(select Total
		 from @tmp_table
		 where year=year(i.InvoiceDate) and Month=month(i.InvoiceDate)) as IncreasingTotal
from Sales.Invoices i
inner join Sales.InvoiceLines il on il.InvoiceID=i.InvoiceID
where year(i.InvoiceDate)>=2015
order by year(i.InvoiceDate), month(i.InvoiceDate);

-- temporary table
drop table if exists tempdb.#tmp_table;

create table #tmp_table(Year int, Month int, Total decimal(18,2));

insert into #tmp_table (Year, Month, Total)
select	year(ii.InvoiceDate) as Year, month(ii.InvoiceDate) as Month, 
		SUM(iil.Quantity*iil.UnitPrice)+(select coalesce(SUM(til.Quantity*til.UnitPrice),0)
										  from Sales.Invoices ti
										  inner join Sales.InvoiceLines til on ti.InvoiceID=til.InvoiceID
										  where year(ti.InvoiceDate)>=2015 and ti.InvoiceDate<=CONCAT(year(ii.InvoiceDate),'-',month(ii.InvoiceDate),'-01')
			) as Total
from Sales.Invoices ii
inner join Sales.InvoiceLines iil on ii.InvoiceID=iil.InvoiceID
where year(ii.InvoiceDate)>=2015
group by year(ii.InvoiceDate), month(ii.InvoiceDate);

select	i.InvoiceID as InvoiceID,
		i.CustomerID as CustomerID,
		i.InvoiceDate as Month,
		(il.Quantity*il.UnitPrice) as Sum,
		(select Total
		 from #tmp_table
		 where year=year(i.InvoiceDate) and Month=month(i.InvoiceDate)) as IncreasingTotal
from Sales.Invoices i
inner join Sales.InvoiceLines il on il.InvoiceID=i.InvoiceID
where year(i.InvoiceDate)>=2015
order by year(i.InvoiceDate), month(i.InvoiceDate);

/*
* 2. Query with window function
*/

select	i.InvoiceID as InvoiceID,
		i.CustomerID as CustomerID,
		i.InvoiceDate as Month,
		(il.Quantity*il.UnitPrice) as Sum,
		SUM(il.Quantity*il.UnitPrice) over (order by year(i.InvoiceDate), month(i.InvoiceDate)) as IncreasingTotal
from Sales.Invoices i
inner join Sales.InvoiceLines il on il.InvoiceID=i.InvoiceID
where year(i.InvoiceDate)>=2015
order by year(i.InvoiceDate), month(i.InvoiceDate);

/*
* 3. Top 2 most popular StockItemID per month for 2016
*/
select tt.ID, tt.Year, tt.Month, tt.IDAmount
from (
	select	t.*,
			ROW_NUMBER() over (partition by t.Year, t.Month order by t.IDAmount desc) as Rank
	from (
		select	distinct ol.StockItemID as ID,
				year(o.OrderDate) as Year,
				month(o.OrderDate) as Month,
				count(ol.StockItemID) over (partition by year(o.OrderDate), month(o.OrderDate), ol.StockItemID) as IDAmount
		from Sales.Orders o
		inner join Sales.OrderLines ol on o.OrderID=ol.OrderID
		where year(o.OrderDate)=2016
	) as t
) as tt
where tt.Rank <=2;

/*
* 4. One-query function
*/
select	StockItemID,
		StockItemName,
		Brand,
		UnitPrice,
		ROW_NUMBER() over (partition by SUBSTRING(StockItemName,1,1) order by StockItemID) as AlphabetSort,
		COUNT(StockItemID) over () as TotalCount,
		COUNT(StockItemID) over (partition by SUBSTRING(StockItemName,1,1)) as AlphabetCount,
		LEAD(StockItemID) over (partition by SUBSTRING(StockItemName,1,1) order by StockItemName) as NextID,
		LAG(StockItemID) over (partition by SUBSTRING(StockItemName,1,1) order by StockItemName) as PreviousID,
		LAG(StockItemName,2,'No items') over (order by StockItemName) as TwoRowsPreviousName,
		NTILE(30) over (partition by TypicalWeightPerUnit order by StockItemID) as Groups
from Warehouse.StockItems
order by Groups;

/*
* 5. Last client for each employee
*/
select	distinct tt.Employee,
		p.FullName,
		tt.Customer,
		c.CustomerName,
		tt.EmployeeDates,
		SUM(il.Quantity*il.UnitPrice) over (partition by tt.ID)
from (
	select	t.*,
			ROW_NUMBER() over (partition by t.Employee order by t.ID desc) as SortValues
	from (
		select	i.InvoiceID as ID, i.SalesPersonPersonID as Employee, i.CustomerID as Customer, 
				max(i.InvoiceDate) over (partition by i.SalesPersonPersonID order by i.InvoiceDate desc) as EmployeeDates
		from Sales.Invoices i
	) as t	
) as tt
inner join Sales.InvoiceLines il on tt.ID=il.InvoiceID
inner join Sales.Customers c on c.CustomerID=tt.Customer
inner join Application.People p on p.PersonID=tt.Employee
where tt.SortValues=1;

/*
* 6. Top 2 most expensive StockItemID
*/
select Result.CustomerID, Result.CustomerName, Result.StockItemID, Result.ItemPrice, Result.InvoiceDate
from (
	select	tt.*,
			ROW_NUMBER() over (partition by tt.CustomerID, tt.StockItemID order by tt.InvoiceDate) as SortItems,
			DENSE_RANK() over (partition by tt.CustomerID order by tt.StockItemID desc) as RankedItem
	from (
		select	t.*,
				DENSE_RANK() over (partition by t.CustomerID order by t.ItemPrice desc) as RankedPrice
		from (
			select	c.CustomerID, c.CustomerName, il.StockItemID, 
					MAX(il.UnitPrice) over (partition by i.CustomerID, il.StockItemID) as ItemPrice,
					i.InvoiceDate
			from Sales.Customers c
			inner join Sales.Invoices i on i.CustomerID=c.CustomerID
			inner join Sales.InvoiceLines il on il.InvoiceID=i.InvoiceID
		) as t
	) as tt
	where tt.RankedPrice<=2
) as Result
where Result.SortItems=1 and Result.RankedItem<=2;