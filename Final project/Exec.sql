USE LoadTestResults20;

GO
EXEC [DWH].[prLoadTestScores] @ProjectId=1001, @EnvId=1, @Duration=3600, @RampUp=900, @NumberOfThreads=1000;

GO
SELECT *
FROM DWH.TestResultInfo

GO
EXEC dbo.UpdateStatsAndInd;