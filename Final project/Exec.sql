USE LoadTestResults20;

GO
EXEC [DWH].[prLoadTestScores] @ProjectId=1002, @EnvId=2, @Duration=3600, @RampUp=900, @NumberOfThreads=1000;

GO
SELECT *
FROM DWH.TestResultInfo