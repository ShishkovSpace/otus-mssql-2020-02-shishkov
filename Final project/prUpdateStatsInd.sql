USE [LoadTestResults];

GO
CREATE PROCEDURE dbo.UpdateStatsAndInd
AS
BEGIN
BEGIN TRY
	DECLARE @SQL NVARCHAR(MAX)

	/*
	* Info about indexes that will be updated
	*/
	DROP TABLE IF EXISTS #Result;

	SELECT	i.name AS IndexName, 
			'['+SCHEMA_NAME(o.schema_id)+'].['+o.name+']' AS TableName, 
			CASE 
				WHEN s.avg_fragmentation_in_percent > 30 THEN 'REBUILD' 
				ELSE 'REORGANIZE' 
			END AS Command
	INTO #Result
	FROM (
		SELECT s.[object_id] , s.index_id , avg_fragmentation_in_percent = MAX(s.avg_fragmentation_in_percent) 
			FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) s 
			WHERE s.page_count > 128 -- > 1 MB 
				AND s.index_id > 0 -- <> HEAP 
				AND s.avg_fragmentation_in_percent > 5 
			GROUP BY s.[object_id], s.index_id ) s
	JOIN sys.indexes i WITH(NOLOCK) ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id 
	JOIN sys.objects o WITH(NOLOCK) ON o.[object_id] = s.[object_id]

	/*
	* Building statements to execute in format 'ALTER INDEX <index_name> ON <schema_name.table_name> REBUILD WITH (SORT_IN_TEMPDB=ON)/REORGANIZE'
	*/
	DECLARE cur CURSOR LOCAL READ_ONLY FORWARD_ONLY FOR 
		SELECT 'ALTER INDEX [' + i.name + N'] ON [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] ' + 
					CASE WHEN s.avg_fragmentation_in_percent > 30 THEN 'REBUILD WITH (SORT_IN_TEMPDB = ON)' 
					ELSE 'REORGANIZE' END + ';' 
		FROM ( 
			SELECT s.[object_id] , s.index_id , avg_fragmentation_in_percent = MAX(s.avg_fragmentation_in_percent) 
			FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) s 
			WHERE s.page_count > 128 -- > 1 MB 
				AND s.index_id > 0 -- <> HEAP 
				AND s.avg_fragmentation_in_percent > 5 
			GROUP BY s.[object_id], s.index_id ) s 
		JOIN sys.indexes i WITH(NOLOCK) ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id 
		JOIN sys.objects o WITH(NOLOCK) ON o.[object_id] = s.[object_id] 

	OPEN cur 
	FETCH NEXT FROM cur INTO @SQL 

	/*
	* Execute prepared statements
	*/
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		EXEC sys.sp_executesql @SQL 
		--PRINT @SQL;
	
		FETCH NEXT FROM cur INTO @SQL 
	END 
	CLOSE cur 
	DEALLOCATE cur

	/*
	* Update statistic for all objects in DB
	*/
	EXEC sp_updatestats;

	/*
	* Clear cached queries
	*/
	DBCC FREEPROCCACHE;

	SELECT * FROM #Result;
RETURN
END TRY
BEGIN CATCH 
	DECLARE @errorCode int, @errorMessage nvarchar(1000);

	SET @errorCode = ERROR_NUMBER();
	SET @errorMessage = 
		'Server: ' + @@SERVERNAME + 
		', ErrorNumber: ' + CAST(@errorCode AS varchar(10)) + 
		', ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(),'') + 
		', ErrorLine: ' + CAST(ERROR_LINE() AS varchar(10));

	RAISERROR (@errorMessage, 16, 1);
END CATCH
END;