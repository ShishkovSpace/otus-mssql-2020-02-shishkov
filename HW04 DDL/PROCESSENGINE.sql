USE Engine;
GO
DROP TABLE IF EXISTS dbo.ProcessEngine;

CREATE TABLE dbo.ProcessEngine(
	ProcessEngineID int NOT NULL,
	ProcessCacheID int NOT NULL,
	ApplicationID int IDENTITY(1,1) NOT NULL,
	CreationTime datetime NOT NULL,
	ProcessEngineStatus nvarchar(50) NOT NULL,
	PhaseCacheId int NOT NULL,
	IsRunning bit NOT NULL,
	StopTime datetime NOT NULL,
	LastUpdateTime datetime NOT NULL,
 CONSTRAINT PK_ProcessEngine PRIMARY KEY NONCLUSTERED 
(
	ProcessEngineID ASC
) WITH (PAD_INDEX = OFF, 
		STATISTICS_NORECOMPUTE = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS = ON, 
		ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE dbo.ProcessEngine ADD CONSTRAINT DF_ProcessEngine_CreationTime DEFAULT (getdate()) FOR CreationTime;
GO

ALTER TABLE dbo.ProcessEngine ADD CONSTRAINT DF_ProcessEngine_PhaseCache DEFAULT ((0)) FOR PhaseCacheId;
GO

ALTER TABLE dbo.ProcessEngine ADD CONSTRAINT DF_ProcessEngine_IsRunning  DEFAULT ((0)) FOR IsRunning;
GO

ALTER TABLE dbo.ProcessEngine ADD CONSTRAINT DF_ProcessEngine_StopTime  DEFAULT (getdate()) FOR StopTime;
GO

ALTER TABLE dbo.ProcessEngine ADD CONSTRAINT DF_ProcessEngine_LastUpdateTime  DEFAULT (getdate()) FOR LastUpdateTime;
GO

ALTER TABLE dbo.ProcessEngine WITH CHECK ADD CONSTRAINT PC_ProcessEngine FOREIGN KEY(ProcessCacheID)
REFERENCES dbo.PROCESSCACHE (ProcessCacheID)
ON DELETE CASCADE;
GO

ALTER TABLE dbo.ProcessEngine CHECK CONSTRAINT PC_ProcessEngine
GO

ALTER TABLE dbo.ProcessEngine WITH CHECK ADD CONSTRAINT PC_PhaseCache FOREIGN KEY(PhaseCacheId)
REFERENCES dbo.PHASECACHE (PhaseCacheId)
ON DELETE SET DEFAULT;
GO

ALTER TABLE dbo.ProcessEngine CHECK CONSTRAINT PC_ProcessEngine
GO

IF EXISTS (SELECT name from sys.indexes  
           WHERE name = N'IX_Engine_ApplicationID')   
   DROP INDEX IX_Engine_ApplicationID ON Production.UnitMeasure;   
GO  
  
CREATE UNIQUE INDEX IX_Engine_ApplicationID   
   ON dbo.ProcessEngine (ApplicationID);   
GO 
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'ID of the process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'ProcessEngineID';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Linked buisness process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'ProcessCacheID';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Unique ApplicationID of the process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'ApplicationID';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Creation time of process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'CreationTime';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Current status of the process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'ProcessEngineStatus';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Current Phase of the process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'PhaseCacheId';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Current status for services', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'IsRunning';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Stop time of the process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'StopTime';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'last update time of the process', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine', @level2type=N'COLUMN', @level2name=N'LastUpdateTime';

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Info about created applications for possible buisness processes', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ProcessEngine';
