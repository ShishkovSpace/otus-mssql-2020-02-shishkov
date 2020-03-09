USE WideWorldImporters
/*
* 1. Query to get data about items that have 'urgent' in their name or start with 'Animal'
*/
select si.StockItemID, si.StockItemName
from Warehouse.StockItems as si
where si.StockItemName like '%urgent%'
	or si.StockItemName like 'Animal%'

/*
* 2. Query to get data about suppliers that have no orders
*/
select Sup.SupplierID, Sup.SupplierName
from Purchasing.Suppliers as Sup
left join Purchasing.PurchaseOrders po on po.SupplierID=Sup.SupplierID
group by Sup.SupplierID, Sup.SupplierName
having count(po.SupplierID) = 0
/*alternative query*/
select Sup.SupplierID, Sup.SupplierName
from Purchasing.PurchaseOrders as po
right join Purchasing.Suppliers Sup on po.SupplierID=Sup.SupplierID
where po.PurchaseOrderID is NULL

/*
* 3. Query to get data about sales and delivery date with info in which month, quarter and one third it have done
*/
select distinct i.InvoiceID as ID,
		DATENAME(month, ct.FinalizationDate) as Month,
		DATEPART(QUARTER, ct.FinalizationDate) as Quarter,
		case 
			when DATEPART(month, ct.FinalizationDate) between 1 and 4 then 'I'
			when DATEPART(month, ct.FinalizationDate) between 5 and 8 then 'II'
			when DATEPART(month, ct.FinalizationDate) between 9 and 12 then 'III'
		end as OneThird,
		IIF ((il.Quantity > 20 or il.UnitPrice >= 100), CONVERT(date, i.ConfirmedDeliveryTime), null) as DeliveryDate
from Sales.Invoices i
inner join Sales.InvoiceLines il on i.InvoiceID=il.InvoiceID
inner join Sales.CustomerTransactions ct on i.InvoiceID=ct.InvoiceID
where ct.IsFinalized=1
-- Additional part of query
order by Quarter, OneThird, DeliveryDate
OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY

/*
* 4. Query to get data about supplier's orders which done in 2014 with delivery type 'Road Freight' or 'Post'
*/
select	po.PurchaseOrderID as OrderID,
		s.SupplierName as Name,
		p.FullName
from Purchasing.PurchaseOrders po
inner join Purchasing.Suppliers s on po.SupplierID=s.SupplierID
inner join Application.People p on po.ContactPersonID=p.PersonID
inner join Application.DeliveryMethods dm on po.DeliveryMethodID=dm.DeliveryMethodID
where dm.DeliveryMethodName in ('Road Freight', 'Post')
	and DATEPART(year, po.ExpectedDeliveryDate)=2014
	and po.IsOrderFinalized = 1

/*
* 5. Query to get data about last 10 sales with client name and sales person full name
*/
select top 10	i.InvoiceID, 
				c.CustomerName, 
				p.FullName
from Sales.Invoices i
inner join Sales.CustomerTransactions ct on i.InvoiceID=ct.InvoiceID
inner join Sales.Customers c on i.CustomerID=c.CustomerID
inner join Application.People p on i.SalespersonPersonID=p.PersonID
where ct.IsFinalized=1
order by i.InvoiceDate desc

/*
* 6. Query to get id, client names and their phone numebrs that have bought item 'Chocolate frogs 250g'
*/
select distinct o.CustomerID, c.CustomerName, c.PhoneNumber
from Sales.Orders o
inner join Sales.OrderLines ol on o.OrderID=ol.OrderID
inner join Sales.Customers c on o.CustomerID=c.CustomerID
inner join Warehouse.StockItems si on ol.StockItemID=si.StockItemID
where si.StockItemName='Chocolate frogs 250g'