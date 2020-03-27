USE WideWorldImporters;
GO
/*
* 1. WHILE loop to insert 5 records into Purchasing.Suppliers table
*/
DECLARE @SupplierCategoryID int,
		@ContactPersonID int,
		@DeliveryMethodID int,
		@DeliveryCityID int,
		@PostalCityID int,
		@cnt int;

SET @cnt=1;

WHILE @cnt<=5

BEGIN

	SET @SupplierCategoryID=(SELECT TOP 1 SupplierCategoryID FROM Purchasing.SupplierCategories);
	SET @ContactPersonID=(SELECT TOP 1 PersonID FROM Application.People);
	SET @DeliveryMethodID=(SELECT TOP 1 DeliveryMethodID FROM Application.DeliveryMethods);
	SET @DeliveryCityID=(SELECT TOP 1 CityID FROM Application.Cities);
	SET @PostalCityID=(SELECT TOP 1 CityID FROm Application.Cities);

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
	VALUES (CONCAT('Name_1', @cnt), 
			@SupplierCategoryID, 
			@ContactPersonID, 
			@ContactPersonID, 
			@DeliveryCityID, 
			@PostalCityID, 
			@cnt+1, 
			CONCAT('916123123',@cnt), 
			CONCAT('916123123',@cnt), 
			'http://www.test.com', 
			CONCAT('AddressLine',@cnt), 
			CONCAT('PostCode',@cnt), 
			'AddressLine', 
			'PostalCode', 
			@ContactPersonID);

	SET @cnt=@cnt+1;

END;
GO
/*
* 2. DELETE one of the inserted records from previous WHILE loop
*/
DELETE FROM Purchasing.Suppliers
OUTPUT deleted.*
WHERE SupplierID=(SELECT TOP 1 SupplierID FROM Purchasing.Suppliers ORDER BY SupplierID DESC);
GO
/*
* 3. UPDATE one of the inserted records from previous WHILE loop
*/
UPDATE Purchasing.Suppliers
SET SupplierName='UpdatedName'
OUTPUT inserted.*, deleted.*
WHERE SupplierID=(SELECT TOP 1 SupplierID FROM Purchasing.Suppliers ORDER BY SupplierID DESC);

/*
* 4. Merge
*/
MERGE Sales.Customers as target
USING (
		select	CustomerID,
				'Test'+CustomerName as CustomerName,
				BillToCustomerID,
				CustomerCategoryID,
				PrimaryContactPersonID,
				case year(AccountOpenedDate)
					when 2013 then 3
					when 2014 then 1
					when 2015 then 2
					when 2016 then 4
				end as DeliveryMethodID,
				DeliveryCityID,
				PostalCityID,
				AccountOpenedDate,
				StandardDiscountPercentage,
				IsStatementSent,
				IsOnCreditHold,
				PaymentDays,
				PhoneNumber,
				FaxNumber,
				WebsiteURL,
				DeliveryAddressLine1,
				DeliveryPostalCode,
				PostalAddressLine1,
				PostalPostalCode,
				LastEditedBy
		from Sales.Customers
		where CustomerCategoryID=6
) AS source (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1, DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy)
ON target.DeliveryMethodID=source.DeliveryMethodID AND target.CustomerID=source.CustomerID
WHEN MATCHED 
	THEN UPDATE SET DeliveryMethodID=8,
					StandardDiscountPercentage=10
WHEN NOT MATCHED 
	THEN INSERT (CustomerName, BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, WebsiteURL, DeliveryAddressLine1, DeliveryPostalCode, PostalAddressLine1, PostalPostalCode, LastEditedBy)
		VALUES	(source.CustomerName, source.BillToCustomerID, source.CustomerCategoryID, source.PrimaryContactPersonID, source.DeliveryMethodID, source.DeliveryCityID, source.PostalCityID, source.AccountOpenedDate, source.StandardDiscountPercentage, source.IsStatementSent, source.IsOnCreditHold, source.PaymentDays, source.PhoneNumber, source.FaxNumber, source.WebsiteURL, source.DeliveryAddressLine1, source.DeliveryPostalCode, source.PostalAddressLine1, source.PostalPostalCode, source.LastEditedBy)
OUTPUT $action, deleted.*, inserted.*;

/*
* 5. bcp in/out, bulk insert
*/
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
RECONFIGURE;  
GO  

SELECT @@SERVERNAME

exec master..xp_cmdshell 'bcp "WideWorldImporters.Sales.Invoices" out  "C:\Invoices_tmp.txt" -T -w -t"@#$%" -S DESKTOP-VPJ2RTJ\SQLSERVER2017'

TRUNCATE TABLE Sales.Invoices_Bulk;

DECLARE 
	@path VARCHAR(256),
	@FileName VARCHAR(256),
	@onlyScript BIT, 
	@query	nVARCHAR(MAX),
	@dbname VARCHAR(255),
	@batchsize INT
	
	SELECT @dbname = DB_NAME();
	SET @batchsize = 1000;

	/*******************************************************************/
	/*******************************************************************/
	/******Change for path and file name*******************************/
	SET @path = 'C:\';
	SET @FileName = 'Invoices_tmp.txt';
	/*******************************************************************/
	/*******************************************************************/
	/*******************************************************************/

	SET @onlyScript = 1;

	BEGIN TRY

		IF @FileName IS NOT NULL
		BEGIN
			SET @query = 'BULK INSERT ['+@dbname+'].[Sales].[Invoices_Bulk]
				   FROM "'+@path+@FileName+'"
				   WITH 
					 (
						BATCHSIZE = '+CAST(@batchsize AS VARCHAR(255))+', 
						DATAFILETYPE = ''widechar'',
						FIELDTERMINATOR = ''@#$%'',
						ROWTERMINATOR =''\n'',
						KEEPNULLS,
						TABLOCK        
					  );'

			PRINT @query

			IF @onlyScript = 0
				EXEC sp_executesql @query 
			PRINT 'Bulk insert '+@FileName+' is done, current time '+CONVERT(VARCHAR, GETUTCDATE(),120);
		END;
	END TRY

	BEGIN CATCH
		SELECT   
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_MESSAGE() AS ErrorMessage; 

		PRINT 'ERROR in Bulk insert '+@FileName+' , current time '+CONVERT(VARCHAR, GETUTCDATE(),120);

	END CATCH

BULK INSERT WideWorldImporters.Sales.Invoices_Bulk
   FROM "C:\Invoices_tmp.txt"
   WITH 
	 (
		BATCHSIZE = 1000, 
		DATAFILETYPE = 'widechar',
		FIELDTERMINATOR = '@#$%',
		ROWTERMINATOR ='\n',
		KEEPNULLS,
		TABLOCK        
	  );

SELECT COUNT(*) FROM Sales.Invoices_Bulk;