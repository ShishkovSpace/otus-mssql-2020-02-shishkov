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