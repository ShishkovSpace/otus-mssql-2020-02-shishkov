USE Engine;
GO
DROP TABLE IF EXISTS dbo.DATADOCUMENTXML;

CREATE TABLE dbo.DATADOCUMENTXML(
	DATADOCUMENTXMLID int NOT NULL,
	PROCESSENGINEID int NOT NULL,
	DATADOCUMENTIDNAME nvarchar(100) NOT NULL,
	DATADOCUMENTXML nvarchar(max) NOT NULL,
	UPDATETIME datetime NULL,
 CONSTRAINT PK_DataDocumentXml PRIMARY KEY NONCLUSTERED 
(
	DATADOCUMENTXMLID ASC
) WITH (PAD_INDEX = OFF, 
		STATISTICS_NORECOMPUTE = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS = ON, 
		ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO

ALTER TABLE dbo.DATADOCUMENTXML  WITH CHECK ADD  CONSTRAINT PE_DataDocumentXml FOREIGN KEY(PROCESSENGINEID)
REFERENCES dbo.PROCESSENGINE (PROCESSENGINEID)
ON DELETE CASCADE;
GO

ALTER TABLE dbo.DATADOCUMENTXML CHECK CONSTRAINT PE_DataDocumentXml;
GO


