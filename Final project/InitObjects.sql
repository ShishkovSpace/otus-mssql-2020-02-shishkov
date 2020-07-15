USE master;
GO

/*
* Create objects for metrics
*/
--CREATE DATABASE [LoadTestResults20];

GO
/* Additional filegroups for partitions */
/*
ALTER DATABASE LoadTestResults20 
	ADD FILEGROUP Partitions_ScoresLT;

GO
ALTER DATABASE LoadTestResults20 
	ADD FILE
	(
		NAME = Partitions_ScoresLT,
		FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLSERVERLOCAL\MSSQL\DATA\Partitions_ScoresLT.ndf',
		SIZE = 50MB,
		MAXSIZE = 1024MB,
		FILEGROWTH = 50MB
	)
TO FILEGROUP Partitions_ScoresLT;

GO
ALTER DATABASE LoadTestResults20 
	ADD FILEGROUP Partitions_ArchiveLT;

GO
ALTER DATABASE LoadTestResults20 
	ADD FILE
	(
		NAME = Partitions_ArchiveLT,
		FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLSERVERLOCAL\MSSQL\DATA\Partitions_ArchiveLT.ndf',
		SIZE = 50MB,
		MAXSIZE = 1024MB,
		FILEGROWTH = 50MB
	)
TO FILEGROUP Partitions_ArchiveLT;
*/
GO
USE [LoadTestResults20];

GO
--CREATE SCHEMA DWH;

GO
DROP TABLE IF EXISTS [DWH].[TestSummary];
DROP TABLE IF EXISTS [DWH].[ScoresLT];
DROP TABLE IF EXISTS [DWH].[ArchiveLT];
GO

ALTER TABLE DWH.TargetInfo DROP CONSTRAINT FK_projectId_Target;
GO

ALTER TABLE DWH.TargetInfo SET ( SYSTEM_VERSIONING = OFF);
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DWH].[TargetInfo]') AND type in (N'U'))
DROP TABLE DWH.TargetInfo;
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DWH].[TargetInfo_History]') AND type in (N'U'))
DROP TABLE DWH.TargetInfo_History;
GO
DROP TABLE IF EXISTS DWH.ScenarioInfo;
DROP TABLE IF EXISTS DWH.EnvInfo;
GO

ALTER TABLE DWH.ProjectInfo SET ( SYSTEM_VERSIONING = OFF );
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DWH].[ProjectInfo]') AND type in (N'U'))
DROP TABLE DWH.ProjectInfo;
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DWH].[ProjectInfo_History]') AND type in (N'U'))
DROP TABLE DWH.ProjectInfo_History;
GO

/************************************** [DWH].[ProjectInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='DWH' and t.name='ProjectInfo')
CREATE TABLE [DWH].[ProjectInfo]
(
 [projectId]       int NOT NULL ,
 [projectName]     nvarchar(100) NOT NULL ,
 [appMajorVersion] int NOT NULL ,
 [appMinorVersion] int NOT NULL ,
 [ValidFrom]  datetime2(2) GENERATED ALWAYS AS ROW START NOT NULL ,
 [ValidTo]    datetime2(2) GENERATED ALWAYS AS ROW END NOT NULL ,
 PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo]) ,

 CONSTRAINT [PK_ProjectInfo] PRIMARY KEY CLUSTERED ([projectId] ASC)
) WITH ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [DWH].[ProjectInfo_History] ) );
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Project link', @level0type = N'SCHEMA', @level0name = N'DWH', @level1type = N'TABLE', @level1name = N'ProjectInfo';

GO

/*************************************** [DWH].[EnvInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='DWH' and t.name='EnvInfo')
CREATE TABLE [DWH].[EnvInfo]
(
 [envId]             int IDENTITY(1, 1) NOT NULL ,
 [projectId]         int NOT NULL ,
 [numberOfInstances] int NOT NULL ,
 [isInternal]        bit NOT NULL CONSTRAINT [DF_EnvInfo_IsInternal] DEFAULT 0 ,
 [isAWS]             bit NOT NULL CONSTRAINT [DF_EnvInfo_IsAWS] DEFAULT 0 ,
 [envDescription]	 nvarchar(300) NULL ,

 CONSTRAINT [PK_EnvInfo] PRIMARY KEY CLUSTERED ([EnvId] ASC),
 CONSTRAINT [FK_projectId_Env] FOREIGN KEY ([projectId])  REFERENCES [DWH].[ProjectInfo]([projectId])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info about conditions and environment for scenarios', @level0type = N'SCHEMA', @level0name = N'DWH', @level1type = N'TABLE', @level1name = N'EnvInfo';

GO

/*************************************** [DWH].[ScenarioInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='DWH' and t.name='ScenarioInfo')
CREATE TABLE [DWH].[ScenarioInfo]
(
 [testNumberId]    int IDENTITY(1,1) NOT NULL ,
 [projectId]       int NOT NULL ,
 [envId]           int NOT NULL ,
 [duration]        int NOT NULL ,
 [rampUp]          int NOT NULL ,
 [numberOfThreads] int NOT NULL ,
 [date]            datetime2(7) NOT NULL CONSTRAINT [DF_ScenarioInfo_Date] DEFAULT GETDATE() ,

 CONSTRAINT [PK_ScenarioInfo] PRIMARY KEY CLUSTERED ([testNumberId] ASC),
 CONSTRAINT [FK_EnvId] FOREIGN KEY ([EnvId])  REFERENCES [DWH].[EnvInfo]([EnvId]),
 CONSTRAINT [FK_projectId] FOREIGN KEY ([projectId])  REFERENCES [DWH].[ProjectInfo]([projectId])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for related scenarios', @level0type = N'SCHEMA', @level0name = N'DWH', @level1type = N'TABLE', @level1name = N'ScenarioInfo';

GO

/*************************************** [DWH].[TargetInfo]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='DWH' and t.name='TargetInfo')
CREATE TABLE [DWH].[TargetInfo]
(
 [targetId]    int IDENTITY(1, 1) NOT NULL ,
 [projectId]   int NOT NULL ,
 [targetName]  nvarchar(100) NOT NULL ,
 [targetValue] int NOT NULL ,
 [ValidFrom]  datetime2(2) GENERATED ALWAYS AS ROW START NOT NULL ,
 [ValidTo]    datetime2(2) GENERATED ALWAYS AS ROW END NOT NULL ,
 PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo]) ,

 CONSTRAINT [PK_TargetInfo] PRIMARY KEY CLUSTERED ([TargetId] ASC),
 CONSTRAINT [FK_projectId_Target] FOREIGN KEY ([projectId])  REFERENCES [DWH].[ProjectInfo]([projectId])
) WITH ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [DWH].[TargetInfo_History] ) );
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Target values for criterions', @level0type = N'SCHEMA', @level0name = N'DWH', @level1type = N'TABLE', @level1name = N'TargetInfo';

GO

/*************************************** [LT].[ArchiveLT]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='DWH' and t.name='ArchiveLT')
CREATE TABLE [DWH].[ArchiveLT]
(
 [id]           int IDENTITY (1, 1) NOT NULL ,
 [projectId]	int NOT NULL,
 [testNumberId] int NOT NULL ,
 [elapsedTime]  int NULL ,
 [numberOfExecution] int NULL,
 [label]        nvarchar(200) NULL ,
 [responseCode] int NULL ,
 [threadName]   nvarchar(100) NULL ,
 [success]      nvarchar(10) NULL ,
 [grpThreads]   int NULL ,
 [allThreads]   int NULL ,
 [URL]          nvarchar(1000) NULL ,
 [sampleCount]  int NULL ,
 [errorCount]   int NULL ,
 [date]         datetime2(7) NOT NULL CONSTRAINT [DF_ArchiveLT_Date] DEFAULT GETDATE() ,

 --CONSTRAINT [PK_ArchiveLT] PRIMARY KEY CLUSTERED ([id] ASC), -- Will be created from procedure
 CONSTRAINT [FK_testNumberId_Archive] FOREIGN KEY ([testNumberId])  REFERENCES [DWH].[ScenarioInfo]([testNumberId]),
 CONSTRAINT [FK_projectId_Archive] FOREIGN KEY ([projectId])  REFERENCES [DWH].[ProjectInfo]([projectId])
);
GO
/*
CREATE NONCLUSTERED INDEX [fkIdx_Archive_testNumberId] ON [DWH].[ArchiveLT] 
 (
  [testNumberId] ASC
 );

GO

CREATE NONCLUSTERED INDEX [csIdx_Archive_Label] ON [DWH].[ArchiveLT]
 (
  [label],
  [responseCode]
 );

GO

CREATE NONCLUSTERED INDEX [csIdx_Archive_elapsedTime] ON [DWH].[ArchiveLT]
 (
  [elapsedTime]
 )

GO

CREATE NONCLUSTERED INDEX [csIdx_Archive_ThreadIdentity] ON [DWH].[ArchiveLT]
 (
  [ThreadName],
  [NumberOfExecution]
 )
*/
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Archive info for all requests', @level0type = N'SCHEMA', @level0name = N'DWH', @level1type = N'TABLE', @level1name = N'ArchiveLT';

GO

/*************************************** [DWH].[ScoresLT]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='DWH' and t.name='ScoresLT')
CREATE TABLE [DWH].[ScoresLT]
(
 [id]            int IDENTITY (1, 1) NOT NULL ,
 [projectId]	 int NOT NULL,
 [testNumberId]  int NOT NULL ,
 [numberOfExecution] int NULL,
 [elapsedTime]   int NULL ,
 [label]         nvarchar(200) NULL ,
 [threadsCount]  int NULL ,
 [threadName]   nvarchar(100) NULL ,
 [numOfRequests] int NULL ,
 [numOfErrors]   int NULL ,
 [date]          datetime2(7) NOT NULL CONSTRAINT [DF_ScoresLT_2_1_2_Date] DEFAULT GETDATE() ,

 --CONSTRAINT [PK_ScoresLT] PRIMARY KEY CLUSTERED ([id] ASC), -- Will be created from procedure
 CONSTRAINT [FK_testNumberId_ScoresLT] FOREIGN KEY ([testNumberId])  REFERENCES [DWH].[ScenarioInfo]([testNumberId]),
 CONSTRAINT [FK_projectId_ScoresLT] FOREIGN KEY ([projectId])  REFERENCES [DWH].[ProjectInfo]([projectId])
);

GO
CREATE NONCLUSTERED INDEX idx_ScoresLT_projectId_testNumberId ON DWH.ScoresLT 
(
	projectId,
	testNumberId
)
INCLUDE (label, elapsedTime, numberOfExecution, NumOfErrors, ThreadsCount);

GO
/*
CREATE NONCLUSTERED INDEX [fkIdx_Scores_testNumberId] ON [DWH].[ScoresLT] 
 (
  [testNumberId] ASC
 );

GO

CREATE NONCLUSTERED INDEX [csIdx_2_1_2_elapsedTime] ON [DWH].[ScoresLT]
 (
  [elapsedTime]
 );

GO

CREATE NONCLUSTERED INDEX [csIdx_2_1_2_ThreadIdentity] ON [DWH].[ScoresLT]
 (
  [ThreadName],
  [NumberOfExecution]
 );
*/
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Info for all criterions', @level0type = N'SCHEMA', @level0name = N'DWH', @level1type = N'TABLE', @level1name = N'ScoresLT';

GO

/*************************************** [DWH].[TestSummary]*/

IF NOT EXISTS (SELECT * FROM sys.tables t join sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name='DWH' and t.name='TestSummary')
CREATE TABLE [DWH].[TestSummary]
(
 [testNumberId]           int NOT NULL ,
 [nameOfTest]             nvarchar(100) NULL ,
 [numberOfThreads]        int NULL ,
 [averageElapsedTimeMs]	  int NULL ,
 [minElapsedTimeMs]       int NULL ,
 [maxElapsedTimeMs]       int NULL ,
 [countOfExecutions]	  int NULL,	
 [countOfRequests]        int NULL ,
 [countOfFails]           int NULL ,
 [date]                   datetime2(7) NOT NULL CONSTRAINT [DF_Scores_AGR_Date] DEFAULT GETDATE()

 CONSTRAINT [FK_testNumberId_Summary] FOREIGN KEY ([testNumberId])  REFERENCES [DWH].[ScenarioInfo]([testNumberId])
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Summary results for related tests', @level0type = N'SCHEMA', @level0name = N'DWH', @level1type = N'TABLE', @level1name = N'TestSummary';
GO

DROP VIEW IF EXISTS DWH.TestResultInfo;

GO
CREATE VIEW DWH.TestResultInfo
AS
SELECT	si.projectId, si.EnvId, si.testNumberId, si.Duration, si.RampUp, si.NumberOfThreads,
		agr.NameOfTest,
		agr.NumberOfThreads as RecievedNumberOfThreads,
		agr.[AverageElapsedTimeMs],
		agr.[MinElapsedTimeMs],
		agr.[MaxElapsedTimeMs],
		agr.CountOfExecutions,
		agr.CountOfFails,
		CASE 
			WHEN agr.NameOfTest LIKE N'2.1.%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.2%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.3%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.4%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.6%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.7.%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.8%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.9%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.10%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			ELSE 'Not Passed'
		END AS Summary
FROM DWH.ScenarioInfo si
JOIN DWH.TestSummary agr ON si.testNumberId=agr.testNumberId;