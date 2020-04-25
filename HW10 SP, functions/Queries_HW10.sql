/*
* 1. Function to get Customer with biggest amount of Sales
*/
CREATE FUNCTION fnTopOneCustomer()
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 1 i.CustomerID, c.CustomerName, MAX(il.Quantity*il.UnitPrice) as MaxSum
	FROM Sales.Invoices i
	JOIN Sales.InvoiceLines il on il.InvoiceID=i.InvoiceID
	JOIN Sales.Customers c on i.CustomerID=c.CustomerID
	GROUP BY i.CustomerID, c.CustomerName
	ORDER BY MaxSum DESC
);

GO
-- Default isolation level because needed only committed data

SELECT * FROM fnTopOneCustomer();
-------------------------------------
/*
* 2. Procedure to get sum of purchases for defined CustomerID
*/
CREATE PROCEDURE prSumOfPurchases @ID int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT i.CustomerID, c.CustomerName, SUM(il.Quantity*il.UnitPrice) as MaxSum
	FROM Sales.Invoices i
	JOIN Sales.InvoiceLines il on il.InvoiceID=i.InvoiceID
	JOIN Sales.Customers c on i.CustomerID=c.CustomerID
	WHERE i.CustomerID=@ID
	GROUP BY i.CustomerID, c.CustomerName;

	RETURN;
END;

GO
-- Default isolation level because needed only committed data
EXEC prSumOfPurchases @ID=1;
-------------------------------------
/*
* 3. Custom function and procedure
*/ 
-- Procedure to return defined amount of records from Sales.Orders table ordered by date DESC
CREATE PROCEDURE prLastDefinedOrders @top int = 100
AS
BEGIN
	DECLARE @ExecString nvarchar(1100);

	SET @ExecString = 
	'SELECT TOP '+CAST(@top as nvarchar(1000))+' * FROM Sales.Orders ORDER BY OrderDate DESC;'

	EXEC sp_executesql @ExecString;
	RETURN;
END;

GO
-- Function with the same funtionality as procedure above
CREATE FUNCTION fnLastDefinedOrders(@top int = 100)
RETURNS TABLE
AS
RETURN
(
	SELECT *
	FROM Sales.Orders
	ORDER BY OrderDate DESC
	OFFSET 0 ROWS FETCH NEXT @top ROWS ONLY
);	

GO
SET STATISTICS io ON;
-- Default transaction isolation level

SELECT * FROM fnLastDefinedOrders(10);

EXEC prLastDefinedOrders @top=10;

/*
* For examples above there are no differences between execution plans, but there are differences in time spended for execution and size of cached plan
*/
-------------------------------------
/*
* 4. Table function for each row in record set
*/
CREATE FUNCTION fnCurrentCustomer(@id int)
RETURNS TABLE
AS
RETURN
(
	SELECT COUNT(OrderID) as CountOfOrders, MAX(OrderDate) as LastOrderDate
	FROM Sales.Orders
	WHERE CustomerID=@id
);

GO
-- Default transaction level isolation

SELECT	distinct o.CustomerID, 
		t.*
FROM Sales.Orders o
CROSS APPLY dbo.fnCurrentCustomer(o.CustomerID) as t

/*
* 7. Transactions
*/
-- READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRAN
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
	/* Parallel -->*/
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
COMMIT;
-- READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
	/* Parallel -->*/
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
COMMIT;
-- REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
	/* Parallel -->*/
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
COMMIT;
-- SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
	/* Parallel -->*/
	SELECT StockItemID, UnitPrice 
	FROM Warehouse.StockItems 
	WHERE StockItemID=226;
COMMIT;
/*
* 8. Insert and Update in transaction
*/
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN
-- insert
INSERT INTO Purchasing.Suppliers (SupplierName,
									  SupplierCategoryID,
									  PrimaryContactPersonID,
									  AlternateContactPersonID,
									  DeliveryCityID,
									  PostalCityID,
									  PaymentDays,
									  PhoneNumber,
									  FaxNumber,
									  WebsiteURL,
									  DeliveryAddressLine1,
									  DeliveryPostalCode,
									  PostalAddressLine1,
									  PostalPostalCode,
									  LastEditedBy)
SELECT TOP 1 CONCAT(SupplierName, 'Test'), 
			 SupplierCategoryID, 
			 PrimaryContactPersonID, 
			 AlternateContactPersonID, 
			 DeliveryCityID, 
			 PostalCityID, 
			 PaymentDays, 
			 PhoneNumber, 
			 FaxNumber, 
			 WebsiteURL, 
			 DeliveryAddressLine1, 
			 DeliveryPostalCode, 
			 PostalAddressLine1, 
			 PostalPostalCode, 
			 LastEditedBy
FROM Purchasing.Suppliers
ORDER BY SupplierID DESC;

SELECT TOP 1 *
FROM Purchasing.Suppliers
ORDER BY SupplierID DESC;
COMMIT;

BEGIN TRAN
-- first update
UPDATE Purchasing.Suppliers
SET SupplierName='UpdatedName_One'
OUTPUT inserted.*, deleted.*
WHERE SupplierID=(SELECT TOP 1 SupplierID FROM Purchasing.Suppliers ORDER BY SupplierID DESC);

SELECT TOP 1 *
FROM Purchasing.Suppliers
ORDER BY SupplierID DESC;
ROLLBACK;

BEGIN TRAN
-- second update
UPDATE Purchasing.Suppliers
SET SupplierName='UpdatedName_Two'
OUTPUT inserted.*, deleted.*
WHERE SupplierID=(SELECT TOP 1 SupplierID FROM Purchasing.Suppliers ORDER BY SupplierID DESC);

SELECT TOP 1 *
FROM Purchasing.Suppliers
ORDER BY SupplierID DESC;
COMMIT;