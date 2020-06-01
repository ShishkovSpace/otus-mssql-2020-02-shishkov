USE LoadTestResults;

GO
DECLARE @projectId int=1002;

INSERT INTO LT.ProjectInfo (projectId, projectName, AppMajorVersion, AppMinorVersion)
VALUES (@projectId, 'DELTA', 2, 1);

INSERT INTO LT.EnvInfo (projectId, NumberOfInstances, EnvDescription)
VALUES (@projectId, 10, 'Another Environment for load test');

INSERT INTO LT.TargetInfo (projectId, TargetName, TargetValue)
VALUES	(@projectId, '2.1.2', 500),
		(@projectId, '2.2', 100),
		(@projectId, '2.3', 500),
		(@projectId, '2.4', 300),
		(@projectId, '2.6', 400),
		(@projectId, '2.7.X', 150),
		(@projectId, '2.8', 200),
		(@projectId, '2.9', 400),
		(@projectId, '2.10', 100);