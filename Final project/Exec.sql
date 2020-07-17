USE LoadTestResults20;

GO
EXEC [DWH].[prLoadTestScores] @projectId=1001, @envId=1, @duration=3600, @rampUp=900, @numberOfThreads=1000;

GO
SELECT *
FROM DWH.TestResultInfo

GO
EXEC dbo.UpdateStatsAndInd;