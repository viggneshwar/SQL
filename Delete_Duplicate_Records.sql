-- How do you delete duplicate rows but keep one copy?
WITH CTE AS (
    SELECT EmpId, ROW_NUMBER() OVER (PARTITION BY FullName ORDER BY EmpId) AS rn
    FROM Employee
)
DELETE FROM CTE WHERE rn > 1;
