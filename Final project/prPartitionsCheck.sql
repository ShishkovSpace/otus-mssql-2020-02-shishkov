USE LoadTestResults20;

GO
/*
DROP PARTITION SCHEME ps_ArchiveLT;
DROP PARTITION SCHEME ps_ScoresLT;
DROP PARTITION FUNCTION pf_ArchiveLT;
DROP PARTITION FUNCTION pf_ScoresLT;
*/
DROP PROCEDURE IF EXISTS DWH.prPartitionsCheck;
GO
CREATE PROCEDURE DWH.prPartitionsCheck @projectId int
AS
BEGIN

	DECLARE @checkValue int, @projectCheck int;
	/* First execution check */
	SET @checkValue = (SELECT COUNT(*) FROM DWH.ScenarioInfo);

	IF @checkValue = 0
		/* Partitions initiation */
		BEGIN
			CREATE PARTITION FUNCTION pf_ArchiveLT (int) AS RANGE RIGHT
			FOR VALUES (@projectId);

			CREATE PARTITION FUNCTION pf_ScoresLT (int) AS RANGE RIGHT
			FOR VALUES (@projectId);

			CREATE PARTITION SCHEME ps_ArchiveLT AS PARTITION pf_ArchiveLT ALL TO ([Partitions_ArchiveLT]);

			CREATE PARTITION SCHEME ps_ScoresLT AS PARTITION pf_ScoresLT ALL TO ([Partitions_ScoresLT]);

			IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'PK_ArchiveLT' AND type_desc = N'CLUSTERED')
				CREATE CLUSTERED INDEX PK_ArchiveLT ON DWH.ArchiveLT (id ASC, projectId ASC) ON ps_ArchiveLT (projectId);

			IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'PK_ScoresLT' AND type_desc = N'CLUSTERED')
				CREATE CLUSTERED INDEX PK_ScoresLT ON DWH.ScoresLT (id ASC, projectId ASC) ON ps_ScoresLT (projectId);

			PRINT 'Partitions initiated';
		END

	ELSE 
		
		BEGIN
			SET @projectCheck = (SELECT COUNT(*) FROM DWH.ScenarioInfo WHERE projectId=@projectId);
			/* Split partitions for new value */
			IF @projectCheck = 0
				
				BEGIN
					ALTER PARTITION FUNCTION pf_ArchiveLT () SPLIT RANGE (@projectId); 

					ALTER PARTITION FUNCTION pf_ScoresLT () SPLIT RANGE (@projectId);

					PRINT N'Partition splited for value ' + CAST(@projectId AS nvarchar(100));
				END;

			ELSE
				PRINT N'Partition already exists';
		END;

END;

GO
SELECT
	sc.name+N'.'+so.name AS [Schema.Table],
	si.index_id AS [Index ID],
	si.type_desc AS [Structure],
	si.name AS [Index],
	stat.row_count AS [Rows],
	stat.in_row_reserved_page_count * 8./1024/1024. AS [In-Row, GB],
	stat.lob_reserved_page_count * 8./1024/1024. AS [LOB, GB],
	p.partition_number AS [Partition #],
	pf.name AS [Partition function],
	CASE pf.boundary_value_on_right 
		WHEN 1 THEN 'Right / Lower'
		ELSE 'Left / Upper'
	END AS [Boundary type],
	prv.value AS [Boundary point],
	fg.name AS [Filegroup]
FROM sys.partition_functions AS pf
JOIN sys.partition_schemes AS ps ON ps.function_id=pf.function_id
JOIN sys.indexes AS si ON si.data_space_id=ps.data_space_id
JOIN sys.objects AS so ON si.object_id=so.object_id
JOIN sys.schemas AS sc ON sc.schema_id=so.schema_id
JOIN sys.partitions AS p ON si.object_id=p.object_id 
	AND si.index_id=p.index_id
LEFT JOIN sys.partition_range_values AS prv ON prv.function_id=pf.function_id 
	AND p.partition_number=
		CASE pf.boundary_value_on_right WHEN 1
			THEN prv.boundary_id+1
		ELSE prv.boundary_id
		END
JOIN sys.dm_db_partition_stats AS stat ON stat.object_id=p.object_id
	AND stat.index_id=p.index_id
	AND stat.partition_id=p.partition_id
	AND stat.partition_number=p.partition_number
JOIN sys.allocation_units AS au ON au.container_id=p.hobt_id
	AND au.type_desc='IN_ROW_DATA'
JOIN sys.filegroups AS fg ON fg.data_space_id=au.data_space_id
ORDER BY [Schema.Table], [Index ID], [Partition function], [Partition #];