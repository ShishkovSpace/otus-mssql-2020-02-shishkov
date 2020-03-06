/*
* First query
*/
select si.StockItemID, si.StockItemName
from Warehouse.StockItems as si
where si.StockItemName like '%urgent%'
	or si.StockItemName like 'Animal%'

/*
* Second query
*/
select Sup.SupplierID, Sup.SupplierName
from Purchasing.Suppliers as Sup
left join Purchasing.PurchaseOrders po on po.SupplierID=Sup.SupplierID
group by Sup.SupplierID, Sup.SupplierName
having count(po.SupplierID) = 0

/*
* Third query
*/
select	i.InvoiceID as ID,
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
order by Quarter, OneThird, i.InvoiceDate
OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY

/*
* Forth query
*/
select	po.PurchaseOrderID as OrderID,
		s.SupplierName as Name,
		p.FullName
from Purchasing.PurchaseOrders po
inner join Purchasing.Suppliers s on po.SupplierID=s.SupplierID
inner join Application.People p on po.ContactPersonID=p.PersonID
where po.DeliveryMethodID in (1,7)
	and DATEPART(year, po.OrderDate)=2014
	and po.IsOrderFinalized = 1

/*
* Fifth query
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
* Sixth query
*/
select distinct o.CustomerID, c.CustomerName, c.PhoneNumber
from Sales.Orders o
inner join Sales.OrderLines ol on o.OrderID=ol.OrderID
inner join Sales.Customers c on o.CustomerID=c.CustomerID
inner join Warehouse.StockItems si on ol.StockItemID=si.StockItemID
where si.StockItemName='Chocolate frogs 250g'