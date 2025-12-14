--🗂 Typical Table Structure
--You usually have a table like:
Employees (
    EmpID INT,
    EmpName VARCHAR(100),
    ManagerID INT
)

--✅ Basic Employee–Manager Query
--To list employees along with their manager’s name:
SELECT 
    e.EmpID,
    e.EmpName AS Employee,
    m.EmpName AS Manager
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmpID;

--🔄 Recursive Hierarchy (All Levels)
--If you want the full chain of command (employee → manager → director → VP, etc.), you use a recursive CTE:
WITH RECURSIVE EmpHierarchy AS (
    -- Anchor: start with employees and their direct manager
    SELECT 
        e.EmpID,
        e.EmpName,
        e.ManagerID,
        1 AS Level
    FROM Employees e

    UNION ALL

    -- Recursive part: join employee’s manager to find higher levels
    SELECT 
        eh.EmpID,
        eh.EmpName,
        m.ManagerID,
        eh.Level + 1
    FROM EmpHierarchy eh
    JOIN Employees m
        ON eh.ManagerID = m..EmpID
)
SELECT * 
FROM EmpHierarchy
ORDER BY EmpID, Level;

-- Level shows how far up the hierarchy you are.
-- You can stop recursion at the top (CEO with ManagerID IS NULL).



  

