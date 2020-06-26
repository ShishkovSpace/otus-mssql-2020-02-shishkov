DBCC FREEPROCCACHE 
GO 
DBCC DROPCLEANBUFFERS 
Go 
DBCC FREESYSTEMCACHE ('ALL') 
GO 
DBCC FREESESSIONCACHE 
GO

SET STATISTICS IO ON;

GO

Select	ord.CustomerID, 
		det.StockItemID, 
		SUM(det.UnitPrice), 
		SUM(det.Quantity), 
		COUNT(ord.OrderID)
FROM Sales.Orders AS ord 
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID 
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID AND Inv.BillToCustomerID != ord.CustomerID AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
JOIN Warehouse.StockItems It ON It.StockItemID=det.StockItemID AND It.SupplierId = 12
WHERE (SELECT SUM(Total.UnitPrice*Total.Quantity)
		FROM Sales.OrderLines AS Total 
		Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000 
	--AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID