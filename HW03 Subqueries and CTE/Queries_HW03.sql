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
-- #1
select si.StockItemID, si.StockItemName
from Warehouse.StockItems as si
where si.UnitPrice = all (select min(UnitPrice) from Warehouse.StockItems);

-- #2
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
-- #1
select c.CustomerID, c.CustomerName
from Sales.Customers as c
inner join (
			select top 5 ct.CustomerID as ID, max(ct.TransactionAmount) as Amount
			from Sales.CustomerTransactions ct
			group by ct.CustomerID
			order by Amount desc) t1 on c.CustomerID=t1.ID;

-- #2
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
* 4. Query to get data about cities in which were delivered top 3 most expensive items
*/
with Items as 
(
	select ol.OrderID as ID, ol.StockItemID as ItemId
	from Sales.OrderLines ol
	inner join (select StockItemID
				from Warehouse.StockItems
				order by UnitPrice desc
				offset 0 rows fetch next 3 rows only) si on ol.StockItemID=si.StockItemID
)
select distinct ci.CityID, ci.CityName, o.PickedByPersonID, p.FullName
from Application.Cities ci
inner join Sales.Customers c on ci.CityID=c.DeliveryCityID
inner join Sales.Orders o on c.CustomerID=o.CustomerID
inner join Application.People p on o.PickedByPersonID=p.PersonID
inner join Items it on o.OrderID=it.ID
where p.IsEmployee=1

/*
* 5. Explanation of actual execution plan
*
* ������ � ����������� �� ����������� ��������� �������:
*
* 1. ��������� ����� ��������� �������
* "FROM Sales.Invoices 
* JOIN
* (SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
* FROM Sales.InvoiceLines
* GROUP BY InvoiceId
* HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
* ON Invoices.InvoiceID = SalesTotals.InvoiceID"
* ���������� ������ �� ������������������� columnstore ������� NCCX_Sales_InvoiceLines. � ������ ������ ����� ����������� �� �� ���������, � ������������ ��� ������, ������� �������� ������ ������ (Index Scan). 
* 2. ����� ����������� ���������� ������������ InvoceLines.Quantity*InvoiceLines.UnitPrice
* 3. Hash Match + Compute Scalar ��������� ���������� ����� ������������ �� �.2. Hash �������������� ������������, �.�. �������������� ���������� ������� �����
* 4. ����� �������������� ���������� ���������� � �.3 ����� ��� �������� >27000
* 5. �������������� ����� ������ �� ����������������� ������� PK_Sales_Invoices, ������� ���������� ��� �������� �������. Filter ��������� ����� ����� � ������ ������ ��� ���������� ���������� ������ Hash Match (Inner Join)
* 6. Hash Match (Inner Join) - ������� � �������������� hash �������������� ����� �������, ����������� ��
* "SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
* FROM Sales.InvoiceLines
* GROUP BY InvoiceId
* HAVING SUM(Quantity*UnitPrice) > 27000"
* � �������� Invoices (�� ��������� FROM ��������� �������)
* 7. ����� �������������� ����� ������ ��� ��������� �����������
* "SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
* FROM Sales.OrderLines
* WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
* 							FROM Sales.Orders
* 							WHERE Orders.PickingCompletedWhen IS NOT NULL AND Orders.OrderId = Invoices.OrderId)".
* ������� �������������� ����� �� ������������������� columnstore ������� NCCX_Sales_OrderLines, � ������� �������������� ����� �� ����� ������ ������ ��� ����������� ������������ PickedQuantity*UnitPrice.
* 8. ����� ����������� ������������ PickedQuantity*UnitPrice
* 9. Hash Match + Compute Scalar ��������� ���������� ����� ������������ �� �.8. Hash �������������� ������������, �.�. �������������� ���������� ������� �����
* 10. ����� �������������� ����� �� NULL �������� ���� PickingCompletedWhen � �������������� ����������������� ������� PK_Sales_Orders. ���������� Filter ����� �� ��� ������ ������������ ��� ����������� ������� � Hash ���������������
* 11. Hash Match (Inner Join) - ������� �� ������� Orders.OrderId = Invoices.OrderId �� ����������
* 12. ������, ���������� �� ����������� ���������� �.6  � �������������� Hash Match (Right Outer Join) ��������� � �������, ����������� �� ���������� ������ �� ������� ����� � ������� IX_Application_People_FullName
* 13. ����� ������, ���������� �� �.12 � ������� Hash Match (Left Outer Join) ������������ � ������� ����������� �� �.11
* 14. � Sort �������������� ���������� �� �������� ��������� � �������� ������� 
* "ORDER BY TotalSumm DESC"
* 15. �������� Parallelism ����������� ������ � ��������� ������������ ������� (� ���� ������ 4 ���� CPU - 4 ������) 
 */

-- �������������� �������, ������� ������� ��������, �� �� ������������������ ����������� �� ����������
WITH SalesTotals as
(
SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000
),
TotalSumForPickItems as
(
SELECT OrderLines.OrderID, SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) as TotalSum
FROM Sales.OrderLines
GROUP BY OrderLines.OrderID
)
SELECT 
Invoices.InvoiceID, 
Invoices.InvoiceDate,
People.FullName AS SalesPersonName,
st.TotalSumm AS TotalSummByInvoice, 
ts.TotalSum AS TotalSummForPickedItems
FROM Sales.Invoices 
JOIN SalesTotals AS st ON Invoices.InvoiceID = st.InvoiceID
JOIN Application.People as People on People.PersonID=Invoices.SalespersonPersonID
JOIN Sales.Orders as Orders on Orders.OrderID=Invoices.OrderID and Orders.SalespersonPersonID=People.PersonID
JOIN TotalSumForPickItems as ts on Orders.OrderID=ts.OrderID
WHERE Orders.PickingCompletedWhen is not NULL
ORDER BY st.TotalSumm DESC
/* �� ������������������ ��� ��������� ��������� ������ �������� 4 Index Scan'a, �� ������� ������ ����������� �������, ��� �� ��� ����������,*/
/* �� ���� ������������, ��� ��� ������, ����� ������ ������ ����� ����� ����� ��������������, � �� ������������, ��� ����� �� ����� ������������ � ������ � ������� Orders */
/* �����������/����������� �� ����� �����, �� � �� ��������� ��� ���������� ��������� ������������������ ������� ��������� ������ ��� Orders.OrderID � Orders.PickingCompletedWhen*/