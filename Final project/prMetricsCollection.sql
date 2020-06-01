USE [LoadTestResults]
GO
/****** Object:  StoredProcedure [LT].[prLoadTestScores]    Script Date: 26.05.2020 16:29:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
* Procedure to fullfill metrics table
*/

CREATE PROCEDURE [LT].[prLoadTestScores] @ProjectId int, @EnvId int, @Duration int, @RampUp int, @NumberOfThreads int
AS
BEGIN 
BEGIN TRY
    BEGIN TRAN;
	/*
	DECLARE @seq_value int;
    SET @seq_value = NEXT VALUE FOR seq_TestNumber;
	*/
    -- Upload data for 2_1_2
    DROP TABLE IF EXISTS #Stage_2_1_2;

    CREATE TABLE #Stage_2_1_2 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_1_2
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_1_2.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_2
    DROP TABLE IF EXISTS #Stage_2_2;

    CREATE TABLE #Stage_2_2 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_2
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_2.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_3
    DROP TABLE IF EXISTS #Stage_2_3;

    CREATE TABLE #Stage_2_3 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_3
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_3.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

	-- Upload data for 2_3
    DROP TABLE IF EXISTS #Stage_2_4;

    CREATE TABLE #Stage_2_4 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_4
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_4.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_6
    DROP TABLE IF EXISTS #Stage_2_6;

    CREATE TABLE #Stage_2_6 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_6
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_6.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_7_1
    DROP TABLE IF EXISTS #Stage_2_7_1;

    CREATE TABLE #Stage_2_7_1 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_7_1
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_7_1.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_7_2
    DROP TABLE IF EXISTS #Stage_2_7_2;

    CREATE TABLE #Stage_2_7_2 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_7_2
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_7_2.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_7_3
    DROP TABLE IF EXISTS #Stage_2_7_3;

    CREATE TABLE #Stage_2_7_3 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_7_3
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_7_3.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_7_4
    DROP TABLE IF EXISTS #Stage_2_7_4;

    CREATE TABLE #Stage_2_7_4 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_7_4
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_7_4.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_7_5
    DROP TABLE IF EXISTS #Stage_2_7_5;

    CREATE TABLE #Stage_2_7_5 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_7_5
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_7_5.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_7_6
    DROP TABLE IF EXISTS #Stage_2_7_6;

    CREATE TABLE #Stage_2_7_6 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_7_6
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_7_6.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_8
    DROP TABLE IF EXISTS #Stage_2_8;

    CREATE TABLE #Stage_2_8 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_8
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_8.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_9
    DROP TABLE IF EXISTS #Stage_2_9;

    CREATE TABLE #Stage_2_9 (
        elapsedTime int,
        Label nvarchar(100),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_9
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_9.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

    -- Upload data for 2_10
    DROP TABLE IF EXISTS #Stage_2_10;

    CREATE TABLE #Stage_2_10 (
        elapsedTime int,
        Label nvarchar(200),
        responseCode int, 
        responseMessage nvarchar(200), 
        threadName nvarchar(50),
        success nvarchar(10),
        grpThreads int,
        allThreads int,
        URL nvarchar(1000), 
        SampleCount int, 
        ErrorCount int
    );

    BULK INSERT #Stage_2_10
    FROM 'C:\Users\Александр\Desktop\metrics\results_2_10.csv'
    WITH ( FORMAT='CSV',
        BATCHSIZE=1000,
        FIRSTROW=2
        );

	-- Insert Scenario info
	INSERT INTO LT.ScenarioInfo (projectId, EnvId,Duration, RampUp, NumberOfThreads)
	VALUES (@ProjectId, @EnvId, @Duration, @RampUp, @NumberOfThreads);

	DECLARE @testNumber int;
	SET @testNumber = (SELECT TOP 1 testNumberId FROM LT.ScenarioInfo ORDER BY testNumberId DESC);
	
	-- Insert archive values
	INSERT INTO LT.ArchiveLT (testNumberId, elapsedTime, NumberOfExecution, Label, responseCode, threadName, success, grpThreads, allThreads, URL, SampleCount, ErrorCount)
    SELECT @testNumber, t.*
    FROM (
        SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_1_2 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_1_2
		WHERE responseMessage IS NULL
        UNION ALL
        SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_2 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_2
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_3 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_3
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_4 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads,
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_4
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_6 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_6
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_7_1 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_7_1
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_7_2 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_7_2
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_7_3 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_7_3
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_7_4 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_7_4
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_7_5 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_7_5
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_7_6 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_7_6
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_8 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_8
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_9 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_9
		WHERE responseMessage IS NULL
        UNION ALL
		SELECT	elapsedTime, 
				CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT) as NumberOfExecution, 
				(SELECT TOP 1 SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label))  FROM #Stage_2_10 WHERE responseMessage IS NOT NULL) as Label, 
				responseCode, 
				threadName, 
				success, 
				grpThreads, 
				allThreads, 
				URL, 
				SampleCount, 
				ErrorCount
		FROM #Stage_2_10
		WHERE responseMessage IS NULL
    ) AS t;

    -- Insert values from temp tables to final tables with transformation
    INSERT INTO LT.ScoresLT_2_1_2 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_1_2
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_2 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_2
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_3 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_3
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

	INSERT INTO LT.ScoresLT_2_4 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_4
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_6 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_6
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_7_1 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_7_1
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_7_2 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_7_2
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_7_3 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_7_3
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_7_4 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_7_4
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_7_5 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_7_5
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_7_6 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_7_6
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_8 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_8
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';


    INSERT INTO LT.ScoresLT_2_9 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_9
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    INSERT INTO LT.ScoresLT_2_10 (testNumberId, NumberOfExecution, elapsedTime, Label, ThreadsCount, ThreadName, NumOfRequests, NumOfErrors)
    SELECT  @testNumber,
			CAST(SUBSTRING(Label, 0, CHARINDEX(':',Label,0)) as INT),
            elapsedTime,
            SUBSTRING(Label, CHARINDEX(':',Label,0)+2, LEN(Label)),
            grpThreads,
            ThreadName,
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage)+1, (CHARINDEX(',', responseMessage)-(CHARINDEX(':', responseMessage)+1))) AS INT),
            CAST(SUBSTRING(responseMessage, CHARINDEX(':', responseMessage, CHARINDEX(',', responseMessage))+1, LEN(responseMessage)) AS INT)
    FROM #Stage_2_10
	WHERE responseMessage IS NOT NULL and (responseCode = 200 or responseCode IS NULL) and responseMessage NOT LIKE N'Non HTTP%';

    -- Insert all agregate values for current test number
    INSERT INTO LT.Scores_AGR ([testNumberId], [NameOfTest], [NumberOfThreads], [AverageElapsedTime, ms], [MinElapsedTime, ms], [MaxElapsedTime, ms], [CountOfExecutions], [CountOfFails])
    SELECT t.*
    FROM (
        SELECT testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(testNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_1_2
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_2
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_3
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
		SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_4
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(testNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_6
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_7_1
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_7_2
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_7_3
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_7_4
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_7_5
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(testNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_7_6
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_8
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_9
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
        UNION ALL
        SELECT  testNumberId, Label, MAX(ThreadsCount) as [NumberOfThreads], AVG(elapsedTime) as AverageElapsedTime, MIN(elapsedTime) as MinElapsedTime, MAX(elapsedTime) as MaxElapsedTime, COUNT(TestNumberId) as CountOfRequests, SUM(NumOfErrors) as CountOfFails
        FROM LT.ScoresLT_2_10
        WHERE testNumberId=@testNumber
        GROUP BY testNumberId, Label
    ) AS t
    WHERE CountOfFails IS NOT NULL;

	COMMIT;

	DROP TABLE #Stage_2_1_2;
	DROP TABLE #Stage_2_2;
	DROP TABLE #Stage_2_3;
	DROP TABLE #Stage_2_4;
	DROP TABLE #Stage_2_6;
	DROP TABLE #Stage_2_7_1;
	DROP TABLE #Stage_2_7_2;
	DROP TABLE #Stage_2_7_3;
	DROP TABLE #Stage_2_7_4;
	DROP TABLE #Stage_2_7_5;
	DROP TABLE #Stage_2_7_6;
	DROP TABLE #Stage_2_8;
	DROP TABLE #Stage_2_9;
	DROP TABLE #Stage_2_10;

    SELECT * FROM LT.fnTestSummary(@testNumber, @ProjectId);

	RETURN;
END TRY
BEGIN CATCH
	DECLARE @errorCode int, @errorMessage nvarchar(1000);

	SELECT XACT_STATE() as [XACT_STATE];

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
