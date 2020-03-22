USE Engine;
GO
DROP TABLE IF EXISTS dbo.DataDocumentXML;

CREATE TABLE dbo.DataDocumentXML(
	DataDocumentXMLID int NOT NULL,
	ProcessEngineID int NOT NULL,
	DataDocumentXMLIDName nvarchar(100) NOT NULL,
	DataDocumentXML nvarchar(4000) NOT NULL,
	UpdateTime datetime NULL,
 CONSTRAINT PK_DataDocumentXml PRIMARY KEY NONCLUSTERED 
(
	DataDocumentXMLID ASC
) WITH (PAD_INDEX = OFF, 
		STATISTICS_NORECOMPUTE = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS = ON, 
		ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE dbo.DataDocumentXML  WITH CHECK ADD  CONSTRAINT PE_DataDocumentXml FOREIGN KEY(ProcessEngineID)
REFERENCES dbo.ProcessEngine (ProcessEngineID)
ON DELETE CASCADE;
GO

ALTER TABLE dbo.DataDocumentXML CHECK CONSTRAINT PE_DataDocumentXml;
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'ID of the DataDocument', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DataDocumentXML', @level2type=N'COLUMN', @level2name=N'DataDocumentXMLID';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Linked ProcessEngineID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DataDocumentXML', @level2type=N'COLUMN', @level2name=N'ProcessEngineID';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Name of DataDocument', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DataDocumentXML', @level2type=N'COLUMN', @level2name=N'DataDocumentXMLIDName';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'XML file of DataDocument', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DataDocumentXML', @level2type=N'COLUMN', @level2name=N'DataDocumentXML';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Update time of DataDocument', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DataDocumentXML', @level2type=N'COLUMN', @level2name=N'UpdateTime';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Info and XML files of attached data documents for defined buisness processes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DataDocumentXML';
