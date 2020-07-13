USE LoadTestResults20;

GO
DECLARE @projectId int=1002;

INSERT INTO DWH.ProjectInfo (projectId, projectName, appMajorVersion, appMinorVersion)
VALUES (@projectId, 'BETA', 1, 1);

INSERT INTO DWH.EnvInfo (projectId, numberOfInstances, envDescription)
VALUES (@projectId, 10, 'Environment for load test');

INSERT INTO DWH.TargetInfo (projectId, targetName, targetValue)
VALUES	(@projectId, '2.1.2', 500),
		(@projectId, '2.2', 100),
		(@projectId, '2.3', 500),
		(@projectId, '2.4', 300),
		(@projectId, '2.6', 400),
		(@projectId, '2.7.X', 150),
		(@projectId, '2.8', 200),
		(@projectId, '2.9', 400),
		(@projectId, '2.10', 100);