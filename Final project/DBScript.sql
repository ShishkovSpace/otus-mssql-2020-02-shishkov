USE [master]
GO
/****** Object:  Database [LoadTestResults20]    Script Date: 17.07.2020 23:38:24 ******/
CREATE DATABASE [LoadTestResults20]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LoadTestResults20', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLSERVERLOCAL\MSSQL\DATA\LoadTestResults20.mdf' , SIZE = 335872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [Partitions_ArchiveLT] 
( NAME = N'Partitions_ArchiveLT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLSERVERLOCAL\MSSQL\DATA\Partitions_ArchiveLT.ndf' , SIZE = 307200KB , MAXSIZE = 1048576KB , FILEGROWTH = 51200KB ), 
 FILEGROUP [Partitions_ScoresLT] 
( NAME = N'Partitions_ScoresLT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLSERVERLOCAL\MSSQL\DATA\Partitions_ScoresLT.ndf' , SIZE = 102400KB , MAXSIZE = 1048576KB , FILEGROWTH = 51200KB )
 LOG ON 
( NAME = N'LoadTestResults20_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLSERVERLOCAL\MSSQL\DATA\LoadTestResults20_log.ldf' , SIZE = 794624KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [LoadTestResults20] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LoadTestResults20].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LoadTestResults20] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LoadTestResults20] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LoadTestResults20] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LoadTestResults20] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LoadTestResults20] SET ARITHABORT OFF 
GO
ALTER DATABASE [LoadTestResults20] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LoadTestResults20] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LoadTestResults20] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LoadTestResults20] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LoadTestResults20] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LoadTestResults20] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LoadTestResults20] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LoadTestResults20] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LoadTestResults20] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LoadTestResults20] SET  ENABLE_BROKER 
GO
ALTER DATABASE [LoadTestResults20] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LoadTestResults20] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LoadTestResults20] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LoadTestResults20] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LoadTestResults20] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LoadTestResults20] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LoadTestResults20] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LoadTestResults20] SET RECOVERY FULL 
GO
ALTER DATABASE [LoadTestResults20] SET  MULTI_USER 
GO
ALTER DATABASE [LoadTestResults20] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LoadTestResults20] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LoadTestResults20] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LoadTestResults20] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LoadTestResults20] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'LoadTestResults20', N'ON'
GO
ALTER DATABASE [LoadTestResults20] SET QUERY_STORE = OFF
GO
USE [LoadTestResults20]
GO
/****** Object:  Schema [DWH]    Script Date: 17.07.2020 23:38:24 ******/
CREATE SCHEMA [DWH]
GO
/****** Object:  PartitionFunction [pf_ArchiveLT]    Script Date: 17.07.2020 23:38:24 ******/
CREATE PARTITION FUNCTION [pf_ArchiveLT](int) AS RANGE RIGHT FOR VALUES (1001)
GO
/****** Object:  PartitionFunction [pf_ScoresLT]    Script Date: 17.07.2020 23:38:24 ******/
CREATE PARTITION FUNCTION [pf_ScoresLT](int) AS RANGE RIGHT FOR VALUES (1001)
GO
/****** Object:  PartitionScheme [ps_ArchiveLT]    Script Date: 17.07.2020 23:38:24 ******/
CREATE PARTITION SCHEME [ps_ArchiveLT] AS PARTITION [pf_ArchiveLT] TO ([Partitions_ArchiveLT], [Partitions_ArchiveLT], [Partitions_ArchiveLT])
GO
/****** Object:  PartitionScheme [ps_ScoresLT]    Script Date: 17.07.2020 23:38:24 ******/
CREATE PARTITION SCHEME [ps_ScoresLT] AS PARTITION [pf_ScoresLT] TO ([Partitions_ScoresLT], [Partitions_ScoresLT], [Partitions_ScoresLT])
GO
/****** Object:  Table [DWH].[ProjectInfo_History]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[ProjectInfo_History](
	[projectId] [int] NOT NULL,
	[projectName] [nvarchar](100) NOT NULL,
	[appMajorVersion] [int] NOT NULL,
	[appMinorVersion] [int] NOT NULL,
	[ValidFrom] [datetime2](2) NOT NULL,
	[ValidTo] [datetime2](2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_ProjectInfo_History]    Script Date: 17.07.2020 23:38:24 ******/
CREATE CLUSTERED INDEX [ix_ProjectInfo_History] ON [DWH].[ProjectInfo_History]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Table [DWH].[ProjectInfo]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[ProjectInfo](
	[projectId] [int] NOT NULL,
	[projectName] [nvarchar](100) NOT NULL,
	[appMajorVersion] [int] NOT NULL,
	[appMinorVersion] [int] NOT NULL,
	[ValidFrom] [datetime2](2) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](2) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_ProjectInfo] PRIMARY KEY CLUSTERED 
(
	[projectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [DWH].[ProjectInfo_History] )
)
GO
/****** Object:  Table [DWH].[TargetInfo_History]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[TargetInfo_History](
	[targetId] [int] NOT NULL,
	[projectId] [int] NOT NULL,
	[targetName] [nvarchar](100) NOT NULL,
	[targetValue] [int] NOT NULL,
	[ValidFrom] [datetime2](2) NOT NULL,
	[ValidTo] [datetime2](2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ix_TargetInfo_History]    Script Date: 17.07.2020 23:38:24 ******/
CREATE CLUSTERED INDEX [ix_TargetInfo_History] ON [DWH].[TargetInfo_History]
(
	[ValidTo] ASC,
	[ValidFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Table [DWH].[TargetInfo]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[TargetInfo](
	[targetId] [int] IDENTITY(1,1) NOT NULL,
	[projectId] [int] NOT NULL,
	[targetName] [nvarchar](100) NOT NULL,
	[targetValue] [int] NOT NULL,
	[ValidFrom] [datetime2](2) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](2) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_TargetInfo] PRIMARY KEY CLUSTERED 
(
	[targetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [DWH].[TargetInfo_History] )
)
GO
/****** Object:  Table [DWH].[ScenarioInfo]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[ScenarioInfo](
	[testNumberId] [int] IDENTITY(1,1) NOT NULL,
	[projectId] [int] NOT NULL,
	[envId] [int] NOT NULL,
	[duration] [int] NOT NULL,
	[rampUp] [int] NOT NULL,
	[numberOfThreads] [int] NOT NULL,
	[date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ScenarioInfo] PRIMARY KEY CLUSTERED 
(
	[testNumberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [DWH].[TestSummary]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[TestSummary](
	[testNumberId] [int] NOT NULL,
	[nameOfTest] [nvarchar](100) NOT NULL,
	[numberOfThreads] [int] NULL,
	[averageElapsedTimeMs] [int] NULL,
	[minElapsedTimeMs] [int] NULL,
	[maxElapsedTimeMs] [int] NULL,
	[countOfExecutions] [int] NULL,
	[countOfRequests] [int] NULL,
	[countOfFails] [int] NULL,
	[date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_TestSummary] PRIMARY KEY CLUSTERED 
(
	[testNumberId] ASC,
	[nameOfTest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [DWH].[TestResultInfo]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [DWH].[TestResultInfo]
AS
SELECT	si.projectId, si.EnvId, si.testNumberId, si.Duration, si.RampUp, si.NumberOfThreads,
		agr.NameOfTest,
		agr.NumberOfThreads as RecievedNumberOfThreads,
		agr.[AverageElapsedTimeMs],
		agr.[MinElapsedTimeMs],
		agr.[MaxElapsedTimeMs],
		agr.CountOfExecutions,
		agr.CountOfFails,
		CASE 
			WHEN agr.NameOfTest LIKE N'2.1.%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.2%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.3%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.4%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.6%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.7.%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.8%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.9%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			WHEN agr.NameOfTest LIKE N'2.10%' AND agr.[AverageElapsedTimeMs] <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
			ELSE 'Not Passed'
		END AS Summary
FROM DWH.ScenarioInfo si
JOIN DWH.TestSummary agr ON si.testNumberId=agr.testNumberId;
GO
/****** Object:  UserDefinedFunction [DWH].[fnTestSummary]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DWH].[fnTestSummary] (@testNumber int, @projectId int)
RETURNS TABLE
AS
RETURN
(
	SELECT	si.projectId, si.EnvId, si.testNumberId, si.Duration, si.RampUp, si.NumberOfThreads,
			agr.NameOfTest,
			agr.NumberOfThreads as RecievedNumberOfThreads,
			agr.AverageElapsedTimeMs,
			agr.MinElapsedTimeMs,
			agr.MaxElapsedTimeMs,
			agr.CountOfExecutions,
			agr.CountOfFails,
			CASE 
				WHEN agr.NameOfTest LIKE N'2.1.%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.2%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.3%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.4%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.6%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.7.%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.8%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.9%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				WHEN agr.NameOfTest LIKE N'2.10%' AND agr.AverageElapsedTimeMs <= (SELECT TOP 1 ti.TargetValue FROM DWH.TargetInfo ti WHERE SUBSTRING(ti.TargetName,1,3)=SUBSTRING(agr.NameOfTest, 1, 3) AND ti.projectId=si.projectId) THEN 'Passed'
				ELSE 'Not Passed'
			END AS Summary
	FROM DWH.ScenarioInfo si
	JOIN DWH.TestSummary agr ON si.testNumberId=agr.testNumberId
	WHERE si.testNumberId=@testNumber AND si.projectId=@projectId
);
GO
/****** Object:  Table [DWH].[ArchiveLT]    Script Date: 17.07.2020 23:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[ArchiveLT](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[projectId] [int] NOT NULL,
	[testNumberId] [int] NOT NULL,
	[elapsedTime] [int] NULL,
	[numberOfExecution] [int] NULL,
	[label] [nvarchar](200) NULL,
	[responseCode] [int] NULL,
	[threadName] [nvarchar](100) NULL,
	[success] [nvarchar](10) NULL,
	[grpThreads] [int] NULL,
	[allThreads] [int] NULL,
	[URL] [nvarchar](1000) NULL,
	[sampleCount] [int] NULL,
	[errorCount] [int] NULL,
	[date] [datetime2](7) NOT NULL
) ON [ps_ArchiveLT]([projectId])
GO
/****** Object:  Index [PK_ArchiveLT]    Script Date: 17.07.2020 23:38:25 ******/
CREATE CLUSTERED INDEX [PK_ArchiveLT] ON [DWH].[ArchiveLT]
(
	[id] ASC,
	[projectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [ps_ArchiveLT]([projectId])
GO
/****** Object:  Table [DWH].[EnvInfo]    Script Date: 17.07.2020 23:38:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[EnvInfo](
	[envId] [int] IDENTITY(1,1) NOT NULL,
	[projectId] [int] NOT NULL,
	[numberOfInstances] [int] NOT NULL,
	[isInternal] [bit] NOT NULL,
	[isAWS] [bit] NOT NULL,
	[envDescription] [nvarchar](300) NULL,
 CONSTRAINT [PK_EnvInfo] PRIMARY KEY CLUSTERED 
(
	[envId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [DWH].[ScoresLT]    Script Date: 17.07.2020 23:38:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DWH].[ScoresLT](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[projectId] [int] NOT NULL,
	[testNumberId] [int] NOT NULL,
	[numberOfExecution] [int] NULL,
	[elapsedTime] [int] NULL,
	[label] [nvarchar](200) NULL,
	[threadsCount] [int] NULL,
	[threadName] [nvarchar](100) NULL,
	[numOfRequests] [int] NULL,
	[numOfErrors] [int] NULL,
	[date] [datetime2](7) NOT NULL
) ON [ps_ScoresLT]([projectId])
GO
/****** Object:  Index [PK_ScoresLT]    Script Date: 17.07.2020 23:38:25 ******/
CREATE CLUSTERED INDEX [PK_ScoresLT] ON [DWH].[ScoresLT]
(
	[id] ASC,
	[projectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [ps_ScoresLT]([projectId])
GO
/****** Object:  Index [idx_ScoresLT_projectId_testNumberId]    Script Date: 17.07.2020 23:38:25 ******/
CREATE NONCLUSTERED INDEX [idx_ScoresLT_projectId_testNumberId] ON [DWH].[ScoresLT]
(
	[projectId] ASC,
	[testNumberId] ASC
)
INCLUDE([label],[elapsedTime],[numberOfExecution],[numOfErrors],[threadsCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [DWH].[ArchiveLT] ADD  CONSTRAINT [DF_ArchiveLT_Date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [DWH].[EnvInfo] ADD  CONSTRAINT [DF_EnvInfo_IsInternal]  DEFAULT ((0)) FOR [isInternal]
GO
ALTER TABLE [DWH].[EnvInfo] ADD  CONSTRAINT [DF_EnvInfo_IsAWS]  DEFAULT ((0)) FOR [isAWS]
GO
ALTER TABLE [DWH].[ScenarioInfo] ADD  CONSTRAINT [DF_ScenarioInfo_Date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [DWH].[ScoresLT] ADD  CONSTRAINT [DF_ScoresLT_2_1_2_Date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [DWH].[TestSummary] ADD  CONSTRAINT [DF_Scores_AGR_Date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [DWH].[ArchiveLT]  WITH CHECK ADD  CONSTRAINT [FK_projectId_Archive] FOREIGN KEY([projectId])
REFERENCES [DWH].[ProjectInfo] ([projectId])
GO
ALTER TABLE [DWH].[ArchiveLT] CHECK CONSTRAINT [FK_projectId_Archive]
GO
ALTER TABLE [DWH].[ArchiveLT]  WITH CHECK ADD  CONSTRAINT [FK_testNumberId_Archive] FOREIGN KEY([testNumberId])
REFERENCES [DWH].[ScenarioInfo] ([testNumberId])
GO
ALTER TABLE [DWH].[ArchiveLT] CHECK CONSTRAINT [FK_testNumberId_Archive]
GO
ALTER TABLE [DWH].[EnvInfo]  WITH CHECK ADD  CONSTRAINT [FK_projectId_Env] FOREIGN KEY([projectId])
REFERENCES [DWH].[ProjectInfo] ([projectId])
GO
ALTER TABLE [DWH].[EnvInfo] CHECK CONSTRAINT [FK_projectId_Env]
GO
ALTER TABLE [DWH].[ScenarioInfo]  WITH CHECK ADD  CONSTRAINT [FK_EnvId] FOREIGN KEY([envId])
REFERENCES [DWH].[EnvInfo] ([envId])
GO
ALTER TABLE [DWH].[ScenarioInfo] CHECK CONSTRAINT [FK_EnvId]
GO
ALTER TABLE [DWH].[ScenarioInfo]  WITH CHECK ADD  CONSTRAINT [FK_projectId] FOREIGN KEY([projectId])
REFERENCES [DWH].[ProjectInfo] ([projectId])
GO
ALTER TABLE [DWH].[ScenarioInfo] CHECK CONSTRAINT [FK_projectId]
GO
ALTER TABLE [DWH].[ScoresLT]  WITH CHECK ADD  CONSTRAINT [FK_projectId_ScoresLT] FOREIGN KEY([projectId])
REFERENCES [DWH].[ProjectInfo] ([projectId])
GO
ALTER TABLE [DWH].[ScoresLT] CHECK CONSTRAINT [FK_projectId_ScoresLT]
GO
ALTER TABLE [DWH].[ScoresLT]  WITH CHECK ADD  CONSTRAINT [FK_testNumberId_ScoresLT] FOREIGN KEY([testNumberId])
REFERENCES [DWH].[ScenarioInfo] ([testNumberId])
GO
ALTER TABLE [DWH].[ScoresLT] CHECK CONSTRAINT [FK_testNumberId_ScoresLT]
GO
ALTER TABLE [DWH].[TargetInfo]  WITH CHECK ADD  CONSTRAINT [FK_projectId_Target] FOREIGN KEY([projectId])
REFERENCES [DWH].[ProjectInfo] ([projectId])
GO
ALTER TABLE [DWH].[TargetInfo] CHECK CONSTRAINT [FK_projectId_Target]
GO
ALTER TABLE [DWH].[TestSummary]  WITH CHECK ADD  CONSTRAINT [FK_testNumberId_Summary] FOREIGN KEY([testNumberId])
REFERENCES [DWH].[ScenarioInfo] ([testNumberId])
GO
ALTER TABLE [DWH].[TestSummary] CHECK CONSTRAINT [FK_testNumberId_Summary]
GO
/****** Object:  StoredProcedure [dbo].[UpdateStatsAndInd]    Script Date: 17.07.2020 23:38:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateStatsAndInd]
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
GO
/****** Object:  StoredProcedure [DWH].[prLoadTestScores]    Script Date: 17.07.2020 23:38:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DWH].[prLoadTestScores] @ProjectId int, @EnvId int, @Duration int, @RampUp int, @NumberOfThreads int
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
    WHERE testNumberId=@testNumber
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
GO
/****** Object:  StoredProcedure [DWH].[prPartitionsCheck]    Script Date: 17.07.2020 23:38:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DWH].[prPartitionsCheck] @projectId int
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Archive info for all requests' , @level0type=N'SCHEMA',@level0name=N'DWH', @level1type=N'TABLE',@level1name=N'ArchiveLT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Info about conditions and environment for scenarios' , @level0type=N'SCHEMA',@level0name=N'DWH', @level1type=N'TABLE',@level1name=N'EnvInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Project link' , @level0type=N'SCHEMA',@level0name=N'DWH', @level1type=N'TABLE',@level1name=N'ProjectInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Info for related scenarios' , @level0type=N'SCHEMA',@level0name=N'DWH', @level1type=N'TABLE',@level1name=N'ScenarioInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Info for all criterions' , @level0type=N'SCHEMA',@level0name=N'DWH', @level1type=N'TABLE',@level1name=N'ScoresLT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Target values for criterions' , @level0type=N'SCHEMA',@level0name=N'DWH', @level1type=N'TABLE',@level1name=N'TargetInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Summary results for related tests' , @level0type=N'SCHEMA',@level0name=N'DWH', @level1type=N'TABLE',@level1name=N'TestSummary'
GO
USE [master]
GO
ALTER DATABASE [LoadTestResults20] SET  READ_WRITE 
GO
