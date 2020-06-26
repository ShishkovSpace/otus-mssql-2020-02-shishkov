/*======================================================================*/
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

/*======================================================================*/

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

/*======================================================================*/

-- create queue
CREATE QUEUE TargetQueueWWI;

-- create service for queue
CREATE SERVICE [//WWI/SB/TargetService]
       ON QUEUE TargetQueueWWI
       ([//WWI/SB/Contract]);
GO


CREATE QUEUE InitiatorQueueWWI;

CREATE SERVICE [//WWI/SB/InitiatorService]
       ON QUEUE InitiatorQueueWWI
       ([//WWI/SB/Contract]);
GO

/*======================================================================*/