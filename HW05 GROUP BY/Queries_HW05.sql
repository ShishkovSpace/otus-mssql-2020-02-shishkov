/*
* 1. Query to get data about average item price and total sales sum per month
*/
select	AVG(il.UnitPrice) as AverageUnitPrice,
		SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by month(i.InvoiceDate);

/*
* 2. Query to get info about all months where total sales amount more then 10000
*/
select	month(i.InvoiceDate) as Month,
		SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by month(i.InvoiceDate)
having SUM(il.Quantity*il.UnitPrice)>10000
order by Month;

/*
* 3. Query to get info about sales amount, date of first sale and amount of sold items per month
* for items which have count less then 50 per month
*/
select	SUM(il.UnitPrice*il.Quantity) as TotalSalesAmount,
		MIN(i.InvoiceDate) as FirstSaleDate,
		SUM(il.Quantity) as AmountOfSoldItems
from Sales.InvoiceLines il
inner join Sales.Invoices i on i.InvoiceID=il.InvoiceID
group by year(i.InvoiceDate), month(i.InvoiceDate)
having count(il.StockItemID)<=50

/*
* 
*/