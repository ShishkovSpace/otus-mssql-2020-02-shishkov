/*
* 1. Upload data from StockItems.xml to Warehouse.StockItems
*/
-- Open .xml file
DECLARE @x xml, @docHandle int;
SET @x = ( 
 SELECT * FROM OPENROWSET
  (BULK 'C:\Users\Asus\Desktop\OTUS\Other\StockItems.xml',
   SINGLE_BLOB)
   as d);

EXEC sp_xml_preparedocument @docHandle OUTPUT, @x;

MERGE Warehouse.StockItems as target
USING (
	SELECT *
	FROM OPENXML (@docHandle, N'StockItems/Item', 3)
	WITH (
		StockItemName nvarchar(100) '@Name',
		SupplierId int './SupplierID',
		UnitPackageID int './Package/UnitPackageID',
		OuterPackageID int './Package/OuterPackageID',
		QuantityPerOuter int './Package/QuantityPerOuter',
		TypicalWeightPerUnit decimal(18,3) './Package/TypicalWeightPerUnit',
		LeadTimeDays int './LeadTimeDays',
		IsChillerStock bit './IsChillerStock',
		TaxRate decimal(18,3) './TaxRate',
		UnitPrice decimal(18,2) './UnitPrice'
	) 
) AS source (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice)
ON (target.StockItemName=source.StockItemName)
WHEN MATCHED 
	THEN UPDATE SET StockItemName=source.StockItemName,
					SupplierID=source.SupplierID,
					UnitPackageID=source.UnitPackageID,
					OuterPackageID=source.OuterPackageID,
					QuantityPerOuter=source.QuantityPerOuter,
					TypicalWeightPerUnit=source.TypicalWeightPerUnit,
					LeadTimeDays=source.LeadTimeDays,
					IsChillerStock=source.IsChillerStock,
					TaxRate=source.TaxRate,
					UnitPrice=source.UnitPrice
WHEN NOT MATCHED 
	THEN INSERT (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice, LastEditedBy)
	VALUES (source.StockItemName, source.SupplierID, source.UnitPackageID, source.OuterPackageID, source.QuantityPerOuter, source.TypicalWeightPerUnit, source.LeadTimeDays, source.IsChillerStock, source.TaxRate, source.UnitPrice, 1)
	OUTPUT $action, deleted.*, inserted.*;

/*
* 2. Export Warehouse.StockItems to xml format
*/
SELECT	StockItemName as [@Name], 
		SupplierID as [SupplierID], 
		UnitPackageID as [Package/UnitPackageID], 
		OuterPackageID as [Package/OuterPackageID], 
		QuantityPerOuter as [Package/QuantityPerOuter], 
		TypicalWeightPerUnit as [Package/TypicalWeightPerUnit], 
		LeadTimeDays as [LeadTimeDays], 
		IsChillerStock as [IsChillerStock], 
		TaxRate as [TaxRate], 
		UnitPrice as [UnitPrice]
FROM Warehouse.StockItems
FOR XML PATH ('Items'), ROOT ('StockItems');

/*
* 3. Query to get json data from Warehouse.StockItems.CustomField
*/
SELECT	StockItemID,
		StockItemName,
		CountryOfManufacture = JSON_VALUE(CustomFields, '$.CountryOfManufacture'),
		FirstTag = JSON_VALUE(CustomFields, '$.Tags[1]')
FROM Warehouse.StockItems;

/*
* 4. Query to get json data from Warehouse.StockItems.CustomField with 'Vintage' tag
*/
WITH VintageItems as 
(
	SELECT	F.StockItemID,
			S.value as Tag
	FROM Warehouse.StockItems AS F
	CROSS APPLY
	(SELECT value
	FROM OPENJSON((SELECT CustomFields FROM WareHouse.StockItems S WHERE F.StockItemID=S.StockItemID), '$.Tags')) AS S
)
SELECT	si.StockItemID,
		si.StockItemName,
		CountryOfManufacture = JSON_VALUE(si.CustomFields, '$.CountryOfManufacture'),
		Tags = JSON_QUERY(si.CustomFields, '$.Tags')
FROM Warehouse.StockItems si
INNER JOIN VintageItems vi on vi.StockItemID=si.StockItemID and vi.Tag = 'Vintage';

/*
* 5. Dynamic pivot
*/
declare @c_Name nvarchar(max), @query nvarchar(max);

select @c_Name=ISNULL(@c_Name + ',','') + QUOTENAME(CustomerName)
from Sales.Customers;

set @query = 
N'with sourceRes as
(
	select	c.CustomerName as ClientName,
			FORMAT(i.InvoiceDate,''01.MM.yyyy'') as FormattedDate,
			i.InvoiceID as ID
	from Sales.Customers c
	inner join Sales.Invoices i on c.CustomerID=i.CustomerID
)
select *
from sourceRes as Source
pivot (
COUNT(ID)
for ClientName in ('+ @c_Name +')
) as pvt
order by year(FormattedDate), month(FormattedDate);';

EXEC sp_executesql @query;