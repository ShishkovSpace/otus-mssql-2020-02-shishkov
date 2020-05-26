USE [LoadTestResults];
GO

/*
* Create objects for metrics
*/
--CREATE DATABASE [LoadTestResults];

GO
--CREATE SCHEMA LT;

GO
DROP TABLE IF EXISTS [LT].[Scores_AGR];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_10];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_9];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_8];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_7_6];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_7_5];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_7_4];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_7_3];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_7_2];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_7_1];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_6];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_4];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_3];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_2];
DROP TABLE IF EXISTS [LT].[ScoresLT_2_1_2];
DROP TABLE IF EXISTS [LT].[ArchiveLT];
DROP TABLE IF EXISTS [LT].[TargetInfo];
DROP TABLE IF EXISTS [LT].[ScenarioInfo];
DROP TABLE IF EXISTS [LT].[EnvInfo];
DROP TABLE IF EXISTS [LT].[ProjectInfo];
GO

/************************************** [LT].[ProjectInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ProjectInfo')
CREATE TABLE [LT].[ProjectInfo]
(
 [projectId]       int NOT NULL ,
 [projectName]     nvarchar(100) NOT NULL ,
 [AppMajorVersion] int NOT NULL ,
 [AppMinorVersion] int NOT NULL ,
 [BuildValidFrom]  datetime2(7) NOT NULL CONSTRAINT [DF_ProjectInfo_BuildValidFrom] DEFAULT GETDATE() ,
 [BuildValidTo]    datetime2(7) NULL ,

 CONSTRAINT [PK_ProjectInfo] PRIMARY KEY CLUSTERED ([projectId] ASC)
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Project link', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ProjectInfo';

GO

/*************************************** [LT].[EnvInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='EnvInfo')
CREATE TABLE [LT].[EnvInfo]
(
 [EnvId]             int IDENTITY(1, 1) NOT NULL ,
 [projectId]         int NOT NULL ,
 [NumberOfInstances] int NOT NULL ,
 [IsInternal]        bit NOT NULL CONSTRAINT [DF_EnvInfo_IsInternal] DEFAULT 0 ,
 [IsAWS]             bit NOT NULL CONSTRAINT [DF_EnvInfo_IsAWS] DEFAULT 0 ,
 [EnvDescription]	 nvarchar(300) NULL ,

 CONSTRAINT [PK_EnvInfo] PRIMARY KEY CLUSTERED ([EnvId] ASC),
 CONSTRAINT [FK_projectId_Env] FOREIGN KEY ([projectId])  REFERENCES [LT].[ProjectInfo]([projectId])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info about conditions and environment for scenarios', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'EnvInfo';

GO

/*************************************** [LT].[ScenarioInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScenarioInfo')
CREATE TABLE [LT].[ScenarioInfo]
(
 [testNumberId]    int IDENTITY(1,1) NOT NULL ,
 [projectId]       int NOT NULL ,
 [EnvId]           int NOT NULL ,
 [Duration]        int NOT NULL ,
 [RampUp]          int NOT NULL ,
 [NumberOfThreads] int NOT NULL ,
 [Date]            datetime2(7) NOT NULL CONSTRAINT [DF_ScenarioInfo_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScenarioInfo] PRIMARY KEY CLUSTERED ([testNumberId] ASC),
 CONSTRAINT [FK_EnvId] FOREIGN KEY ([EnvId])  REFERENCES [LT].[EnvInfo]([EnvId]),
 CONSTRAINT [FK_projectId] FOREIGN KEY ([projectId])  REFERENCES [LT].[ProjectInfo]([projectId])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for related scenarios', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScenarioInfo';

GO

/*************************************** [LT].[TargetInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='TargetInfo')
CREATE TABLE [LT].[TargetInfo]
(
 [TargetId]    int IDENTITY(1, 1) NOT NULL ,
 [projectId]   int NOT NULL ,
 [TargetName]  nvarchar(100) NOT NULL ,
 [TargetValue] int NOT NULL ,

 CONSTRAINT [PK_TargetInfo] PRIMARY KEY CLUSTERED ([TargetId] ASC),
 CONSTRAINT [FK_projectId_Target] FOREIGN KEY ([projectId])  REFERENCES [LT].[ProjectInfo]([projectId])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Target values for criterions', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'TargetInfo';

GO

/*************************************** [LT].[ArchiveLT]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ArchiveLT')
CREATE TABLE [LT].[ArchiveLT]
(
 [id]           int IDENTITY (1, 1) NOT NULL ,
 [testNumberId] int NOT NULL ,
 [elapsedTime]  int NULL ,
 [NumberOfExecution] int NULL,
 [Label]        nvarchar(200) NULL ,
 [responseCode] int NULL ,
 [threadName]   nvarchar(100) NULL ,
 [success]      nvarchar(10) NULL ,
 [grpThreads]   int NULL ,
 [allThreads]   int NULL ,
 [URL]          nvarchar(1000) NULL ,
 [SampleCount]  int NULL ,
 [ErrorCount]   int NULL ,
 [Date]         datetime2(7) NOT NULL CONSTRAINT [DF_ArchiveLT_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ArchiveLT] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_Archive] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId]) ON DELETE CASCADE
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_Archive] ON [LT].[ArchiveLT] 
 (
  [testNumberId] ASC
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_Archive_Label] ON [LT].[ArchiveLT]
 (
  [Label],
  [responseCode]
 )

GO

CREATE NONCLUSTERED INDEX [csIdx_Archive_elapsedTime] ON [LT].[ArchiveLT]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED INDEX [csIdx_Archive_ThreadIdentity] ON [LT].[ArchiveLT]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Archive info for all requests', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ArchiveLT';

GO

/*************************************** [LT].[ScoresLT_2_1_2]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_1_2')
CREATE TABLE [LT].[ScoresLT_2_1_2]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_1_2_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_1_2] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_1_2] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_1_2] ON [LT].[ScoresLT_2_1_2] 
 (
  [testNumberId] ASC
 )

GO

CREATE NONCLUSTERED INDEX [csIdx_2_1_2_elapsedTime] ON [LT].[ScoresLT_2_1_2]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_1_2_ThreadIdentity] ON [LT].[ScoresLT_2_1_2]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.1.2', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_1_2';

GO

/*************************************** [LT].[ScoresLT_2_2]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_2')
CREATE TABLE [LT].[ScoresLT_2_2]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_2_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_2] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_2] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_2] ON [LT].[ScoresLT_2_2] 
 (
  [testNumberId] ASC
 )
 
GO

 CREATE NONCLUSTERED INDEX [csIdx_2_2_elapsedTime] ON [LT].[ScoresLT_2_2]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_2_ThreadIdentity] ON [LT].[ScoresLT_2_2]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.2', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_2';

GO

/*************************************** [LT].[ScoresLT_2_3]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_3')
CREATE TABLE [LT].[ScoresLT_2_3]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_3_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_3] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_3] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_3] ON [LT].[ScoresLT_2_3] 
 (
  [testNumberId] ASC
 )
  
GO

CREATE NONCLUSTERED INDEX [csIdx_2_3_elapsedTime] ON [LT].[ScoresLT_2_3]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_3_ThreadIdentity] ON [LT].[ScoresLT_2_3]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.3', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_3';

GO

/*************************************** [LT].[ScoresLT_2_4]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_4')
CREATE TABLE [LT].[ScoresLT_2_4]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_4_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_4] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_4] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_4] ON [LT].[ScoresLT_2_4] 
 (
  [testNumberId] ASC
 )
  
GO

CREATE NONCLUSTERED INDEX [csIdx_2_4_elapsedTime] ON [LT].[ScoresLT_2_4]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_4_ThreadIdentity] ON [LT].[ScoresLT_2_4]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.4', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_4';

GO

/*************************************** [LT].[ScoresLT_2_6]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_6')
CREATE TABLE [LT].[ScoresLT_2_6]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_6_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_6] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_6] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_6] ON [LT].[ScoresLT_2_6] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_6_elapsedTime] ON [LT].[ScoresLT_2_6]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_6_ThreadIdentity] ON [LT].[ScoresLT_2_6]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.6', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_6';

GO

/*************************************** [LT].[ScoresLT_2_7_1]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_7_1')
CREATE TABLE [LT].[ScoresLT_2_7_1]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_7_1_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_7_1] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_7_1] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_7_1] ON [LT].[ScoresLT_2_7_1] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_7_1_elapsedTime] ON [LT].[ScoresLT_2_7_1]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_7_1_ThreadIdentity] ON [LT].[ScoresLT_2_7_1]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.7.1', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_7_1';

GO

/*************************************** [LT].[ScoresLT_2_7_2]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_7_2')
CREATE TABLE [LT].[ScoresLT_2_7_2]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_7_2_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_7_2] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_7_2] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_7_2] ON [LT].[ScoresLT_2_7_2] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_7_2_elapsedTime] ON [LT].[ScoresLT_2_7_2]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_7_2_ThreadIdentity] ON [LT].[ScoresLT_2_7_2]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.7.2', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_7_2';

GO

/*************************************** [LT].[ScoresLT_2_7_3]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_7_3')
CREATE TABLE [LT].[ScoresLT_2_7_3]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_7_3_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_7_3] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_7_3] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_7_3] ON [LT].[ScoresLT_2_7_3] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_7_3_elapsedTime] ON [LT].[ScoresLT_2_7_3]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_7_3_ThreadIdentity] ON [LT].[ScoresLT_2_7_3]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.7.3', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_7_3';

GO

/*************************************** [LT].[ScoresLT_2_7_4]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_7_4')
CREATE TABLE [LT].[ScoresLT_2_7_4]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_7_4_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_7_4] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_7_4] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_7_4] ON [LT].[ScoresLT_2_7_4] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_7_4_elapsedTime] ON [LT].[ScoresLT_2_7_4]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_7_4_ThreadIdentity] ON [LT].[ScoresLT_2_7_4]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.7.4', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_7_4';

GO

/*************************************** [LT].[ScoresLT_2_7_5]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_7_5')
CREATE TABLE [LT].[ScoresLT_2_7_5]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_7_5_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_7_5] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_7_5] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_7_5] ON [LT].[ScoresLT_2_7_5] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_7_5_elapsedTime] ON [LT].[ScoresLT_2_7_5]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_7_5_ThreadIdentity] ON [LT].[ScoresLT_2_7_5]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.7.5', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_7_5';

GO

/*************************************** [LT].[ScoresLT_2_7_6]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_7_6')
CREATE TABLE [LT].[ScoresLT_2_7_6]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_7_6_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_7_6] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_7_6] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_7_6] ON [LT].[ScoresLT_2_7_6] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_7_6_elapsedTime] ON [LT].[ScoresLT_2_7_6]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_7_6_ThreadIdentity] ON [LT].[ScoresLT_2_7_6]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.7.6', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_7_6';

GO

/*************************************** [LT].[ScoresLT_2_8]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_8')
CREATE TABLE [LT].[ScoresLT_2_8]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_8_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_8] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_8] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_8] ON [LT].[ScoresLT_2_8] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_8_elapsedTime] ON [LT].[ScoresLT_2_8]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_8_ThreadIdentity] ON [LT].[ScoresLT_2_8]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.8', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_8';

GO

/*************************************** [LT].[ScoresLT_2_9]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_9')
CREATE TABLE [LT].[ScoresLT_2_9]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_9_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_9] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_9] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_9] ON [LT].[ScoresLT_2_9] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_9_elapsedTime] ON [LT].[ScoresLT_2_9]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_9_ThreadIdentity] ON [LT].[ScoresLT_2_9]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.9', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_9';

GO

/*************************************** [LT].[ScoresLT_2_10]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='ScoresLT_2_10')
CREATE TABLE [LT].[ScoresLT_2_10]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [testNumberId]  int NOT NULL ,
 [NumberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [Label]         nvarchar(200) NULL ,
 [ThreadsCount]  int NULL ,
 [ThreadName]   nvarchar(100) NULL ,
 [NumOfRequests] int NULL ,
 [NumOfErrors]   int NULL ,
 [Date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_10_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScoresLT_2_10] PRIMARY KEY CLUSTERED ([id] ASC),
 CONSTRAINT [FK_testNumberId_2_10] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

CREATE NONCLUSTERED INDEX [fkIdx_2_10] ON [LT].[ScoresLT_2_10] 
 (
  [testNumberId] ASC
 )
 
GO

CREATE NONCLUSTERED INDEX [csIdx_2_10_elapsedTime] ON [LT].[ScoresLT_2_10]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [csIdx_2_10_ThreadIdentity] ON [LT].[ScoresLT_2_10]
 (
  [ThreadName],
  [NumberOfExecution]
 )

GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for criterion 2.10', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'ScoresLT_2_10';

GO

/*************************************** [LT].[Scores_AGR]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='LT' and t.name='Scores_AGR')
CREATE TABLE [LT].[Scores_AGR]
(
 [testNumberId]           int NOT NULL ,
 [NameOfTest]             nvarchar(100) NULL ,
 [NumberOfThreads]        int NULL ,
 [AverageElapsedTime, ms] int NULL ,
 [MinElapsedTime, ms]     int NULL ,
 [MaxElapsedTime, ms]     int NULL ,
 [CountOfExecutions]      int NULL ,
 [CountOfFails]           int NULL ,
 [Date]                   datetime2(7) NOT NULL CONSTRAINT [DF_Scores_AGR_Date] DEFAULT GETDATE()

 CONSTRAINT [FK_testNumberId_AGR] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Summary results for related tests', @level0type = N'SCHEMA', @level0name = N'LT', @level1type = N'TABLE', @level1name = N'Scores_AGR';
GO