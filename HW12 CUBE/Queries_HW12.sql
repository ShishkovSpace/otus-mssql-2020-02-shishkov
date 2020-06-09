USE [LoadTestResults]
GO

/****** Object:  Table [LT].[TestResultsCube]    Script Date: 01.06.2020 16:39:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS [LT].[TestResultsFact];
GO
CREATE TABLE [LT].[TestResultsFact](
	[resultId] [bigint] NOT NULL,
	[projectId] [int] NOT NULL,
	[EnvId] [int] NOT NULL,
	[testNumberId] [int] NOT NULL,
	[Duration] [int] NOT NULL,
	[RampUp] [int] NOT NULL,
	[NumberOfThreads] [int] NOT NULL,
	[NameOfTest] [nvarchar](100) NULL,
	[RecievedNumberOfThreads] [int] NULL,
	[AverageElapsedTime, ms] [int] NULL,
	[MinElapsedTime, ms] [int] NULL,
	[MaxElapsedTime, ms] [int] NULL,
	[CountOfExecutions] [int] NULL,
	[CountOfFails] [int] NULL,
	[Summary] [varchar](10) NOT NULL,
 CONSTRAINT [PK_resultId_Fact] PRIMARY KEY CLUSTERED 
(
	[resultId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO LT.TestResultsCube (resultId, projectId, EnvId, testNumberId, Duration, RampUp, NumberOfThreads, NameOfTest, RecievedNumberOfThreads, [AverageElapsedTime, ms], [MinElapsedTime, ms], [MaxElapsedTime, ms], CountOfExecutions, CountOfFails, Summary)
SELECT	ROW_NUMBER() OVER (ORDER BY si.projectId) AS resultId,
		si.projectId, si.EnvId, si.testNumberId, si.Duration, si.RampUp, si.NumberOfThreads,
		agr.NameOfTest,
		agr.NumberOfThreads as RecievedNumberOfThreads,
		agr.[AverageElapsedTime, ms],
		agr.[MinElapsedTime, ms],
		agr.[MaxElapsedTime, ms],
		agr.CountOfExecutions,
		agr.CountOfFails,
		CASE 
			WHEN agr.NameOfTest LIKE N'2.1.%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.2%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.3%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.4%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.6%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.7.%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.8%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.9%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.10%' AND agr.[AverageElapsedTime, ms] <= (SELECT TOP 1 ti.TargetValue FROM LT.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			ELSE 'Not Passed'
		END AS Summary
FROM LT.ScenarioInfo si
JOIN LT.Scores_AGR agr ON si.testNumberId=agr.testNumberId;

GO
ALTER TABLE [LT].[TestResultsFact]  WITH CHECK ADD  CONSTRAINT [FK_envId_Fact] FOREIGN KEY([EnvId])
REFERENCES [LT].[DimEnvInfo] ([EnvId])
GO

ALTER TABLE [LT].[TestResultsFact] CHECK CONSTRAINT [FK_envId_Fact]
GO

ALTER TABLE [LT].[TestResultsFact]  WITH CHECK ADD  CONSTRAINT [FK_projectId_Fact] FOREIGN KEY([projectId])
REFERENCES [LT].[DimProjectInfo] ([projectId])
GO

ALTER TABLE [LT].[TestResultsFact] CHECK CONSTRAINT [FK_projectId_Fact]
GO

ALTER TABLE [LT].[TestResultsFact]  WITH CHECK ADD  CONSTRAINT [FK_testNumberd_Fact] FOREIGN KEY([testNumberId])
REFERENCES [LT].[DimScenarioInfo] ([testNumberId])
GO

ALTER TABLE [LT].[TestResultsFact] CHECK CONSTRAINT [FK_testNumberd_Fact]
GO

/****** Object:  Table [LT].[ProjectInfo]    Script Date: 09.06.2020 18:13:32 ******/
CREATE TABLE [LT].[DimProjectInfo](
	[projectId] [int] NOT NULL,
	[AppMajorVersion] [int] NOT NULL,
	[AppMinorVersion] [int] NOT NULL,
 CONSTRAINT [PK_DimProjectInfo] PRIMARY KEY CLUSTERED 
(
	[projectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Project link' , @level0type=N'SCHEMA',@level0name=N'LT', @level1type=N'TABLE',@level1name=N'DimProjectInfo'
GO

/****** Object:  Table [LT].[EnvInfo]    Script Date: 09.06.2020 18:16:17 ******/
CREATE TABLE [LT].[DimEnvInfo](
	[EnvId] [int] IDENTITY(1,1) NOT NULL,
	[NumberOfInstances] [int] NOT NULL,
 CONSTRAINT [PK_DimEnvInfo] PRIMARY KEY CLUSTERED 
(
	[EnvId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Info about conditions and environment for scenarios' , @level0type=N'SCHEMA',@level0name=N'LT', @level1type=N'TABLE',@level1name=N'DimEnvInfo'
GO

/****** Object:  Table [LT].[ScenarioInfo]    Script Date: 09.06.2020 18:18:02 ******/
CREATE TABLE [LT].[DimScenarioInfo](
	[testNumberId] [int] IDENTITY(1,1) NOT NULL,
	[Duration] [int] NOT NULL,
	[RampUp] [int] NOT NULL,
	[NumberOfThreads] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_DimScenarioInfo] PRIMARY KEY CLUSTERED 
(
	[testNumberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [LT].[DimScenarioInfo] ADD  CONSTRAINT [DF_DimScenarioInfo_Date]  DEFAULT (getdate()) FOR [Date]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Info for related scenarios' , @level0type=N'SCHEMA',@level0name=N'LT', @level1type=N'TABLE',@level1name=N'DimScenarioInfo'
GO
