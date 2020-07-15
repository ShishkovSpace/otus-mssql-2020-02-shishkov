/* Query before optimization */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

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
WHERE testNumberId=2
GROUP BY testNumberId, Label;