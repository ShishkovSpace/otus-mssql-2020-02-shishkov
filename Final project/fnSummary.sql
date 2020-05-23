USE [LoadTestResults];

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [LT].[fnTestSummary](@testNumber int)
RETURNS TABLE
AS
RETURN
(
	SELECT si.testNumberId, si.Duration, si.RampUp, si.NumberOfThreads,
		agr.NameOfTest,
		agr.NumberOfThreads as RecievedNumberOfThreads,
		agr.[AverageElapsedTime, ms],
		agr.[MinElapsedTime, ms],
		agr.[MaxElapsedTime, ms],
		agr.CountOfExecutions,
		agr.CountOfFails,
		CASE 
			WHEN NameOfTest LIKE N'2.1.2%' AND [AverageElapsedTime, ms] <= 1500 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.2%' AND [AverageElapsedTime, ms] <= 1000 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.3%' AND [AverageElapsedTime, ms] <= 5000 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.4%' AND [AverageElapsedTime, ms] <= 3000 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.6%' AND [AverageElapsedTime, ms] <= 4000 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.7.%' AND [AverageElapsedTime, ms] <= 1500 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.8%' AND [AverageElapsedTime, ms] <= 2000 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.9%' AND [AverageElapsedTime, ms] <= 4000 THEN 'Passed'
			WHEN NameOfTest LIKE N'2.10%' AND [AverageElapsedTime, ms] <= 500 THEN 'Passed'
			ELSE 'Not Passed'
		END AS Summary
	FROM LT.ScenarioInfo si
	JOIN LT.Scores_AGR agr ON si.testNumberId=agr.testNumberId
	WHERE si.testNumberId=@testNumber
);
GO