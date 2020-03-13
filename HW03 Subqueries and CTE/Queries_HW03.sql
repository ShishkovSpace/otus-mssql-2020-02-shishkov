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
* Анализ и предложения по оптимизации исходного запроса:
*
* 1. Обработка части исходного запроса
* "FROM Sales.Invoices 
* JOIN
* (SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
* FROM Sales.InvoiceLines
* GROUP BY InvoiceId
* HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
* ON Invoices.InvoiceID = SalesTotals.InvoiceID"
* Отбираются данные по некластеризованному columnstore индексу NCCX_Sales_InvoiceLines. В данном случае поиск выполняется не по указателю, а перебираются все данные, которые содержит данный индекс (Index Scan). 
* 2. Затем выполняется вычисление произведения InvoceLines.Quantity*InvoiceLines.UnitPrice
* 3. Hash Match + Compute Scalar выполняют вычисление суммы произведения из п.2. Hash преобразование используется, т.к. обрабатывается достаточно большой объем
* 4. Далее осуществляется фильтрация полученной в п.3 суммы для значений >27000
* 5. Осуществляется поиск данных по кластеризованному индексу PK_Sales_Invoices, которые необходимы для итоговой выборки. Filter вероятней всего нужен в данном случае для дальнейшей корректной работы Hash Match (Inner Join)
* 6. Hash Match (Inner Join) - слияние с использованием hash преобразования между данными, полученными из
* "SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
* FROM Sales.InvoiceLines
* GROUP BY InvoiceId
* HAVING SUM(Quantity*UnitPrice) > 27000"
* и таблицей Invoices (из оператора FROM исходного запроса)
* 7. Далее осуществляется поиск данных для вложенных подзапросов
* "SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
* FROM Sales.OrderLines
* WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
* 							FROM Sales.Orders
* 							WHERE Orders.PickingCompletedWhen IS NOT NULL AND Orders.OrderId = Invoices.OrderId)".
* Сначала осуществляется поиск по некластеризованному columnstore индексу NCCX_Sales_OrderLines, в котором осуществляется поиск по всему индесу данных для дальнейшего произведения PickedQuantity*UnitPrice.
* 8. Далее вычисляется произведение PickedQuantity*UnitPrice
* 9. Hash Match + Compute Scalar выполняют вычисление суммы произведения из п.8. Hash преобразование используется, т.к. обрабатывается достаточно большой объем
* 10. Затем осуществляется поиск не NULL значений поля PickingCompletedWhen с использованием кластеризованного индекса PK_Sales_Orders. Дальнейший Filter также на мой взгляд используется для дальнейшего слияния с Hash преобразованием
* 11. Hash Match (Inner Join) - слияние по условию Orders.OrderId = Invoices.OrderId из подзапроса
* 12. Данные, полученные по результатам выполнения п.6  с использованием Hash Match (Right Outer Join) сливаются с данными, полученными по резульатам поиска по полного имени в индексе IX_Application_People_FullName
* 13. Затем данные, полученные из п.12 с помощью Hash Match (Left Outer Join) объединяются с данными подзапросов из п.11
* 14. В Sort осуществляется сортировка по убыванию указанная в исходном запросе 
* "ORDER BY TotalSumm DESC"
* 15. Оператор Parallelism выполняется запрос в несколько параллельных потоков (в моем случае 4 ядра CPU - 4 потока) 
 */

-- Альтернативный вариант, который удобней читается, но по производительности существенно не отличается
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
/* По производительности для различных вариантов всегда остаются 4 Index Scan'a, на текущий момент затрудняюсь сказать, как от них избавиться,*/
/* но могу предположить, что для случая, когда данный запрос будет очень часто использоваться, и мы предполагаем, что места на диске неограничено и данные в таблицу Orders */
/* вставляются/обновляются не очень часто, то я бы предложил для небольшого улучшения производительности создать составной индекс для Orders.OrderID и Orders.PickingCompletedWhen*/