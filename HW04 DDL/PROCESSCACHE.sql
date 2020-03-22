USE Engine;
GO
DROP TABLE IF EXISTS dbo.ProcessCache;

CREATE TABLE dbo.ProcessCache(
	ProcessCacheID int NOT NULL,
	ProcessCacheIDName nvarchar(100) NOT NULL,
	ProcessCacheIDDescription nvarchar(100) NOT NULL,
	VersionMajor int NOT NULL,
	VersionMinor int NOT NULL,
 CONSTRAINT PK_ProcessCache PRIMARY KEY NONCLUSTERED 
(
	ProcessCacheID ASC
) WITH (PAD_INDEX = OFF, 
		STATISTICS_NORECOMPUTE = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS = ON, 
		ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'ID of the buisness process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessCache', @level2type=N'COLUMN', @level2name=N'ProcessCacheID';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the buisness process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessCache', @level2type=N'COLUMN', @level2name=N'ProcessCacheIDName';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Description of the buisness process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessCache', @level2type=N'COLUMN', @level2name=N'ProcessCacheIDDescription';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Information about current buisness processes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessCache';
