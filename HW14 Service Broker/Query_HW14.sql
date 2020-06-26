/* Enable and configure ServiceBroker */
USE master;
GO
ALTER DATABASE WideWorldImporters SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

USE master;
-- enabling service broker
ALTER DATABASE WideWorldImporters
SET ENABLE_BROKER; 

-- allow trusted connections
ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON; 
-- DB properties
SELECT is_broker_enabled FROM sys.databases WHERE name = 'WideWorldImporters';
-- add authorizations properties to sa
ALTER AUTHORIZATION    
   ON DATABASE::WideWorldImporters TO [sa];

 -- back to multi_user mode
ALTER DATABASE WideWorldImporters SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO

/* Create message types and Cotract */

--Create Message Types for Request and Reply messages
USE WideWorldImporters
-- For Request
CREATE MESSAGE TYPE
[//WWI/SB/RequestMessage]
VALIDATION=WELL_FORMED_XML;
-- For Reply
CREATE MESSAGE TYPE
[//WWI/SB/ReplyMessage]
VALIDATION=WELL_FORMED_XML; 

GO
-- create contract
CREATE CONTRACT [//WWI/SB/Contract]
      ([//WWI/SB/RequestMessage]
         SENT BY INITIATOR,
       [//WWI/SB/ReplyMessage]
         SENT BY TARGET
      );
GO

/* Create queues for Initiator and Target services */

CREATE QUEUE TargetQueueWWI;

CREATE SERVICE [//WWI/SB/TargetService]
       ON QUEUE TargetQueueWWI
       ([//WWI/SB/Contract]);
GO


CREATE QUEUE InitiatorQueueWWI;

CREATE SERVICE [//WWI/SB/InitiatorService]
       ON QUEUE InitiatorQueueWWI
       ([//WWI/SB/Contract]);
GO

/* Procedure to send data for report */
CREATE PROCEDURE Sales.SendCustomer
	@customerId INT,
	@startDt date,
	@endDt date
AS
BEGIN
	SET NOCOUNT ON;

    --Sending a Request Message to the Target	
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER; 
	DECLARE @RequestMessage NVARCHAR(4000); 
	
	BEGIN TRAN 

	SELECT @RequestMessage = (SELECT DISTINCT CustomerID, @startDt AS startDate, @endDt AS endDate
							  FROM Sales.Invoices AS Inv
							  WHERE CustomerID = @customerId
							  FOR XML AUTO, root('RequestMessage')); 
	
	--Determine the Initiator Service, Target Service and the Contract 
	BEGIN DIALOG @InitDlgHandle
	FROM SERVICE
	[//WWI/SB/InitiatorService]
	TO SERVICE
	'//WWI/SB/TargetService'
	ON CONTRACT
	[//WWI/SB/Contract]
	WITH ENCRYPTION=OFF; 

	--Send the Message
	SEND ON CONVERSATION @InitDlgHandle 
	MESSAGE TYPE
	[//WWI/SB/RequestMessage]
	(@RequestMessage);
	
	COMMIT TRAN 
END;
GO

/* Procedure to get data from queue and create report */
-- Target table for collecting data
DROP TABLE IF EXISTS Sales.CustomerReport;

CREATE TABLE Sales.CustomerReport (
	CustomerId bigint NOT NULL,
	OrderCount bigint NOT NULL,
	StartDt DATE NOT NULL,
	EndDt DATE NOT NULL
);

GO
CREATE PROCEDURE Sales.GetCustomer
AS
BEGIN

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER, 
			@Message NVARCHAR(4000),
			@MessageType Sysname,
			@ReplyMessage NVARCHAR(4000),
			@CustomerID INT,
			@startDt DATE,
			@endDt DATE,
			@xml XML; 
	
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueWWI; 

	SET @xml = CAST(@Message AS XML);

	-- Get Data for report from xml
	SELECT	@CustomerID = R.Inv.value('@CustomerID','INT'),
			@startDt = R.Inv.value('@startDate','DATE'),
			@endDt = R.Inv.value('@endDate', 'DATE')
	FROM @xml.nodes('/RequestMessage/Inv') as R(Inv);

	INSERT INTO Sales.CustomerReport (CustomerId, OrderCount, StartDt, EndDt)
	VALUES (@CustomerID, (SELECT COUNT(*) FROM Sales.Orders WHERE CustomerId=@CustomerID AND OrderDate BETWEEN @startDt AND @endDt), @startDt, @endDt);
	
	-- Confirm and Send a reply
	IF @MessageType=N'//WWI/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received</ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//WWI/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;
	END 

	COMMIT TRAN;
END;
GO

/* Procedure to get confirmation and close dialog from Initiator side */
CREATE PROCEDURE Sales.ConfirmReport
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER, 
			@ReplyReceivedMessage NVARCHAR(1000) 
	
	BEGIN TRAN; 

		RECEIVE TOP(1)
			@InitiatorReplyDlgHandle=Conversation_Handle
			,@ReplyReceivedMessage=Message_Body
		FROM dbo.InitiatorQueueWWI; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; 

	COMMIT TRAN; 
END;
GO

/* Configure queues for continious work */
ALTER QUEUE [dbo].[InitiatorQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF) 
	, ACTIVATION (   STATUS = ON ,
        PROCEDURE_NAME = Sales.ConfirmReport, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
ALTER QUEUE [dbo].[TargetQueueWWI] WITH STATUS = ON , RETENTION = OFF , POISON_MESSAGE_HANDLING (STATUS = OFF)
	, ACTIVATION (  STATUS = ON ,
        PROCEDURE_NAME = Sales.GetCustomer, MAX_QUEUE_READERS = 1, EXECUTE AS OWNER) ; 

GO
EXEC Sales.SendCustomer @customerId=1, @startDt='2013-03-04', @endDt='2013-04-01';
-- And... It works!)