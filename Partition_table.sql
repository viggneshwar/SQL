--How do you partition a table in SQL Server?
CREATE PARTITION FUNCTION EmpPartition (INT)
AS RANGE LEFT FOR VALUES (1000, 2000, 3000);

CREATE PARTITION SCHEME EmpScheme
AS PARTITION EmpPartition TO ([PRIMARY], [FG1], [FG2], [FG3]);

CREATE TABLE EmployeePartitioned (
    EmpId INT,
    Name NVARCHAR(100)
) ON EmpScheme(EmpId);

--- Explanation: Partitioning improves performance for large tables by splitting data across filegroups.
