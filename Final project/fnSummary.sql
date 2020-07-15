USE [LoadTestResults20];

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DWH].[fnTestSummary] (@testNumber int, @projectId int)
RETURNS TABLE
AS
RETURN
(
	SELECT	si.projectId, si.EnvId, si.testNumberId, si.Duration, si.RampUp, si.NumberOfThreads,
			agr.NameOfTest,
			agr.NumberOfThreads as RecievedNumberOfThreads,
			agr.AverageElapsedTimeMs,
			agr.MinElapsedTimeMs,
			agr.MaxElapsedTimeMs,
			agr.CountOfExecutions,
			agr.CountOfFails,
			CASE 
				WHEN agr.NameOfTest LIKE N'2.1.%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.2%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.3%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.4%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.6%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.7.%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.8%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.9%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.10%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				ELSE 'Not Passed'
			END AS Summary
	FROM DWH.ScenarioInfo si
	JOIN DWH.TestSummary agr ON si.testNumberId=agr.testNumberId
	WHERE si.testNumberId=@testNumber AND si.projectId=@projectId
);
GO