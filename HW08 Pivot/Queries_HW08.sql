/*
* 1. Count of sales per month for Customer ID from 2 to 6
*/
select *
from (
		select	REPLACE(REPLACE(SUBSTRING(c.CustomerName, CHARINDEX('(',c.CustomerName), LEN(c.CustomerName)), '(', ''), ')','') as ClientName,
				case
					when month(i.InvoiceDate)>9 then 
						CONVERT(date, CONCAT('01.', month(i.InvoiceDate), '.', year(i.InvoiceDate)), 104)
					else 
						CONVERT(date, CONCAT('01.0', month(i.InvoiceDate), '.', year(i.InvoiceDate)), 104)
				end as FormattedDate,
				i.InvoiceID as ID
		from Sales.Customers c
		inner join Sales.Invoices i on c.CustomerID=i.CustomerID
		where c.CustomerID between 2 and 6
) as Source
pivot (
COUNT(ID)
for ClientName in ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])
) as pvt
order by FormattedDate;

/*
* 2. Addresses for Tailspyn Toys
*/
select Name, AddressLine
from (
		select	c.CustomerName as Name,
				c.DeliveryAddressLine1 as Address_1,
				c.DeliveryAddressLine2 as Address_2,
				c.PostalAddressLine1 as Address_3,
				c.PostalAddressLine2 as Address_4
		from Sales.Customers c
		where c.CustomerName like '%Tailspin Toys%'
) as Source
unpivot (
AddressLine
for Address in (Address_1, Address_2, Address_3, Address_4)
) as pvt;

/*
* 3. Digits and chars for countries
*/