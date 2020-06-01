USE [LoadTestResults]
GO

/****** Object:  Table [LT].[TestResultsCube]    Script Date: 01.06.2020 16:39:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [LT].[TestResultsCube](
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
	[Summary] [varchar](10) NOT NULL
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
ALTER TABLE LT.TestResultsCube
ADD CONSTRAINT [PK_resultId_Cube] PRIMARY KEY CLUSTERED ([resultId] ASC);
GO
ALTER TABLE LT.TestResultsCube
ADD CONSTRAINT [FK_projectId_Cube] FOREIGN KEY ([projectId])  REFERENCES [LT].[ProjectInfo]([projectId]);
GO
ALTER TABLE LT.TestResultsCube
ADD CONSTRAINT [FK_envId_Cube] FOREIGN KEY ([EnvId])  REFERENCES [LT].[EnvInfo]([EnvId]);
GO
ALTER TABLE LT.TestResultsCube
ADD CONSTRAINT [FK_testNumberd_Cube] FOREIGN KEY ([testNumberId])  REFERENCES [LT].[ScenarioInfo]([testNumberId]);

