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
* 3. One-query functions
*/