USE Engine;
GO
DROP TABLE IF EXISTS dbo.PhaseCache;

CREATE TABLE dbo.PhaseCache(
	PhaseCacheID int NOT NULL,
	PhaseCacheIDName nvarchar(100) NOT NULL,
	PhaseCacheIDDescription nvarchar(100) NOT NULL,
 CONSTRAINT PK_PhaseCache PRIMARY KEY NONCLUSTERED 
(
	PhaseCacheID ASC
) WITH (PAD_INDEX = OFF, 
		STATISTICS_NORECOMPUTE = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS = ON, 
		ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'ID of the phase for buisness processes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PhaseCache', @level2type=N'COLUMN', @level2name=N'PhaseCacheID';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Name of the phase for buisness processes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PhaseCache', @level2type=N'COLUMN', @level2name=N'PhaseCacheIDName';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Description of the phase for buisness processes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PhaseCache', @level2type=N'COLUMN', @level2name=N'PhaseCacheIDDescription';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'List of possible phases for buisness processes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'PhaseCache';
