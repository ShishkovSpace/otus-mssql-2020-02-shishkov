USE [LoadTestResults20]
GO
/****** Object:  StoredProcedure [LT].[prLoadTestScores]    Script Date: 26.05.2020 16:29:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
* Procedure to fullfill metrics tables
*/
DROP PROCEDURE IF EXISTS [DWH].[prLoadTestScores];

GO
CREATE PROCEDURE [DWH].[prLoadTestScores] @projectId int, @envId int, @duration int, @rampUp int, @numberOfThreads int
AS
BEGIN 
BEGIN TRY
    /* Procedure to check current partitiones info */
	EXEC DWH.prPartitionsCheck @projectId=@projectId;
	
	BEGIN TRAN;

    -- Insert Scenario info
	INSERT INTO DWH.ScenarioInfo (projectId, envId,duration, rampUp, numberOfThreads)
	VALUES (@projectId, @envId, @duration, @rampUp, @numberOfThreads);

	DECLARE @testNumber int;
	SET @testNumber = (SELECT TOP 1 testNumberId FROM DWH.ScenarioInfo ORDER BY testNumberId DESC);
	
	/*Config table*/
	DROP TABLE IF EXISTS #csv;

	CREATE TABLE #csv (
		filename nvarchar(100)
	);

	DECLARE @path nvarchar(100)=N'C:\Users\Александр\Desktop\metrics\',
			@config nvarchar(300);

	SET @config=N'BULK INSERT #csv
    FROM '''+@path+'list.csv''
    WITH ( FORMAT=''CSV'',
        BATCHSIZE=1000,
        FIRSTROW=1
        )';

	EXEC sp_executesql @config;

	/*Staging endpoint temp table for results*/
	DROP TABLE IF EXISTS #StageLT;

    CREATE TABLE #StageLT (
        elapsedTime int,
		numberOfExecution int,
        label nvarchar(300),
        responseCode int, 
        responseMessage nvarchar(300), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        sampleCount int, 
        errorCount int
    );
	
	DECLARE @filename nvarchar(100);

	/*Processing of bulk insert from .csv files*/
	DECLARE list CURSOR FOR  
		SELECT filename FROM #csv;

	OPEN list;
	FETCH NEXT FROM list INTO @filename;

	WHILE @@FETCH_STATUS=0 
	BEGIN
		DECLARE @sql nvarchar(1000), @label nvarchar(300);

		/*Stage table for collecting data from separate .csv files*/
		DROP TABLE IF EXISTS #StageResults;

		CREATE TABLE #StageResults (
			elapsedTime int,
			label nvarchar(300),
			responseCode int, 
			responseMessage nvarchar(300), 
			threadName nvarchar(50),
			success nvarchar(10),
			grpThreads int,
			allThreads int,
			URL nvarchar(1000), 
			sampleCount int, 
			errorCount int
		);

		SET @sql = N'BULK INSERT #StageResults
		FROM '''+@path+@filename+'''
		WITH ( FORMAT=''CSV'',
			DATAFILETYPE=''char'',
			FIELDTERMINATOR='','',
			ROWTERMINATOR=''\n'',
			BATCHSIZE=1000,
			FIRSTROW=2
			);'

		EXEC sp_executesql @sql;
		
		/*The same label for all current uploaded data*/
		SET @label = (SELECT TOP 1 SUBSTRING(label, CHARINDEX(':',label,0)+2, LEN(label)) FROM #StageResults WHERE responseMessage IS NOT NULL);

		/*Insert collected data into staging endpoint temp table*/
		INSERT INTO #StageLT (elapsedTime, numberOfExecution, label, responseCode, responseMessage, threadName, success, grpThreads, allThreads, URL, sampleCount, errorCount)
		SELECT elapsedTime, CAST(SUBSTRING(label, 0, CHARINDEX(':',label,0)) as INT), @label, responseCode, responseMessage, threadName, success, grpThreads, allThreads, URL, sampleCount, errorCount 
		FROM #StageResults;

		FETCH NEXT FROM list INTO @filename;
	END;

	CLOSE list;
	DEALLOCATE list;
	
	-- Insert archive values
	WITH Stage AS
	(
		SELECT	st.elapsedTime, 
				st.numberOfExecution, 
				st.label, 
				st.responseCode, 
				st.threadName, 
				st.success, 
				st.grpThreads, 
				st.allThreads, 
				st.URL, 
				st.sampleCount, 
				st.errorCount
		FROM #StageLT st
		WHERE responseMessage IS NULL
	)
	INSERT INTO DWH.ArchiveLT (projectId, testNumberId, elapsedTime, numberOfExecution, label, responseCode, threadName, success, grpThreads, allThreads, URL, sampleCount, errorCount)
    SELECT	@projectId,
			@testNumber, 
			s.*
    FROM Stage s;

    -- Insert values from temp tables to final tables with transformation
    INSERT INTO DWH.ScoresLT (projectId, testNumberId, numberOfExecution, elapsedTime, label, threadsCount, threadName, numOfRequests, numOfErrors)
    SELECT  @projectId,
			@testNumber,
			numberOfExecution,
            elapsedTime,
            label,
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #StageLT
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    -- Insert all agregate values for current test number
    INSERT INTO DWH.TestSummary (testNumberId, nameOfTest, numberOfThreads, AverageElapsedTimeMs, minElapsedTimeMs, maxElapsedTimeMs, countOfExecutions, countOfRequests, countOfFails)
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
    WHERE testNumberId=@testNumber AND projectId=@projectId
    GROUP BY testNumberId, Label;

	COMMIT;

	/* Result set for RETURN */
    SELECT *
	FROM DWH.fnTestSummary (@testNumber, @projectId);

	RETURN;
END TRY
BEGIN CATCH
	DECLARE @errorCode int, @errorMessage nvarchar(1000);

	IF @@TRANCOUNT>0
		ROLLBACK;

	SET @errorCode = ERROR_NUMBER();
	SET @errorMessage = 'Server: ' + @@SERVERNAME
						+ ', Error: ' + ERROR_MESSAGE()
						+ ', Error number: ' + CAST(@errorCode as varchar(100))
						+ ', Error line: ' + CAST(ERROR_LINE() as varchar(100));

	RAISERROR(@errorMessage, 16, 1);
END CATCH
END;
