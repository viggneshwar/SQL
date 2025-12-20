--Explain the difference between RANK(), DENSE_RANK(), and ROW_NUMBER().

SELECT EmpId, Salary,
       RANK() OVER (ORDER BY Salary DESC) AS Rank,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank,
       ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum
FROM EmployeeSalary;

-- RANK(): Skips numbers if duplicates exist.
-- DENSE_RANK(): No gaps in ranking.
-- ROW_NUMBER(): Always unique sequence.
