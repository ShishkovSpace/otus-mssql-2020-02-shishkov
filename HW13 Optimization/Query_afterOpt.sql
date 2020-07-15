GO
CREATE NONCLUSTERED INDEX idx_ScoresLT_projectId_testNumberId ON DWH.ScoresLT 
(
	projectId,
	testNumberId
)
INCLUDE (label, elapsedTime, numberOfExecution, NumOfErrors, ThreadsCount);

GO
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

/* Query after optimization */
SELECT	testNumberId, 
		label, 
		MAX(ThreadsCount) as numberOfThreads, 
		AVG(elapsedTime) as averageElapsedTime, 
		MIN(elapsedTime) as minElapsedTime, 
		MAX(elapsedTime) as maxElapsedTime, 
		MAX(numberOfExecution) AS countOfExecutions,
		COUNT(testNumberId) as countOfRequests, 
		SUM(NumOfErrors) as countOfFails
FROM DWH.ScoresLT
WHERE testNumberId=2 AND projectId=1002 -- additional filter because table partitioned by using values from column projectId
GROUP BY testNumberId, Label;