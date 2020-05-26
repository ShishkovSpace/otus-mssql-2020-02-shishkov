USE LoadTestResults;

GO
DECLARE @projectId int=1001;

INSERT INTO LT.ProjectInfo (projectId, projectName, AppMajorVersion, AppMinorVersion)
VALUES (@projectId, 'ALFA', 1, 0);

INSERT INTO LT.EnvInfo (projectId, NumberOfInstances, EnvDescription)
VALUES (@projectId, 20, 'Environment for load test');

INSERT INTO LT.TargetInfo (projectId, TargetName, TargetValue)
VALUES	(@projectId, '2.1.2', 1500),
		(@projectId, '2.2', 1000),
		(@projectId, '2.3', 5000),
		(@projectId, '2.4', 3000),
		(@projectId, '2.6', 4000),
		(@projectId, '2.7.X', 1500),
		(@projectId, '2.8', 2000),
		(@projectId, '2.9', 4000),
		(@projectId, '2.10', 500);