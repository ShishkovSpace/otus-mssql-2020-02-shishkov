USE WideWorldImporters;

/*
* 1. Query to get data about salespersons without any sales
*/
select p.PersonID, p.FullName
from Application.People as p
where p.IsSalesperson=1 and not exists (
										select i.SalespersonPersonID
										from Sales.Invoices as i
										inner join Sales.CustomerTransactions ct on ct.InvoiceID=i.InvoiceID
										where ct.IsFinalized=1
										group by i.SalespersonPersonID
										);
/* Using CTE */
with SaleslessPerson as 
(
	select i.SalespersonPersonID as ID
	from Sales.Invoices as i
	inner join Sales.CustomerTransactions ct on ct.InvoiceID=i.InvoiceID
	where ct.IsFinalized=1
	group by i.SalespersonPersonID
)
select distinct p.PersonID, p.FullName
from Application.People as p
where p.IsSalesperson=1 and not exists (select sp.ID from SaleslessPerson as sp);

/*
* 2. Query to get data about items with min price
*/
select si.StockItemID, si.StockItemName
from Warehouse.StockItems as si
where si.UnitPrice = all (select min(UnitPrice) from Warehouse.StockItems);

select MinItem.StockItemID, MinItem.StockItemName
from (
		select top 1 StockItemID, StockItemName
		from Warehouse.StockItems
		order by UnitPrice
	 ) as MinItem;

/* Using CTE */
with MinPriceItem as
(
	select min(UnitPrice) as MinPrice
	from Warehouse.StockItems
)
select si.StockItemID, si.StockItemName
from Warehouse.StockItems as si
where si.UnitPrice = all (select MinPrice from MinPriceItem);

/*
* 3. Query to get data about cutomers that done 5 max transactions
*/

select c.CustomerID, c.CustomerName
from Sales.Customers as c
inner join (
			select top 5 ct.CustomerID as ID, max(ct.TransactionAmount) as Amount
			from Sales.CustomerTransactions ct
			group by ct.CustomerID
			order by Amount desc) t1 on c.CustomerID=t1.ID;

select	c.CustomerID as Customer_ID, 
		c.CustomerName as Customer_Name
from Sales.Customers as c
where c.CustomerID = any (
							select ct.CustomerID
							from Sales.CustomerTransactions ct	
							group by ct.CustomerID
							order by max(ct.TransactionAmount) desc
							offset 0 rows fetch next 5 rows only
						 );

/*
* Using CTE
*/
-- hard query but it works
with FiveMaxTransactions as
(
	select ct.CustomerID
	from Sales.CustomerTransactions ct	
	group by ct.CustomerID
	order by max(ct.TransactionAmount) desc
	offset 0 rows fetch next 5 rows only
)
select * 
from (
		select	(select c.CustomerID 
				 from FiveMaxTransactions as fmt
				 where fmt.CustomerID=c.CustomerID) as Customer_ID, 
				 c.CustomerName as Customer_Name
		from Sales.Customers as c
	 ) tt
where tt.Customer_ID is not NULL;
-- easy alternative
with FiveMaxTransactions as
(
	select ct.CustomerID
	from Sales.CustomerTransactions ct	
	group by ct.CustomerID
	order by max(ct.TransactionAmount) desc
	offset 0 rows fetch next 5 rows only
)
select	c.CustomerID as Customer_ID, 
		c.CustomerName as Customer_Name
from Sales.Customers as c
inner join FiveMaxTransactions fmt on fmt.CustomerID=c.CustomerID;

/*
* Query to get data about cities in which were delivered top 3 most expensive items
*/

