--🗂 Typical Table Structure
--You’ll usually have a login/logout audit table like:
EmployeeLogins (
    EmpID INT,
    LoginTime DATETIME,
    LogoutTime DATETIME
)
-- LoginTime → when the employee logged in
-- LogoutTime → when the employee logged out

--✅ Query to Calculate Hours Logged In per Day
--We can use DATEDIFF (SQL Server, MySQL) or TIMESTAMPDIFF depending on the RDBMS.
SELECT 
    EmpID,
    CAST(LoginTime AS DATE) AS LoginDate,
    SUM(DATEDIFF(HOUR, LoginTime, LogoutTime)) AS TotalHours
FROM EmployeeLogins
GROUP BY EmpID, CAST(LoginTime AS DATE)
ORDER BY EmpID, LoginDate;

--employees may log in and out multiple times in a single day (breaks, meetings, etc.). You need to sum up all sessions for that day.
SELECT 
    EmpID,
    CAST(LoginTime AS DATE) AS LoginDate,
    SUM(DATEDIFF(MINUTE, LoginTime, LogoutTime)) / 60.0 AS TotalHours
FROM EmployeeLogins
GROUP BY EmpID, CAST(LoginTime AS DATE)
ORDER BY EmpID, LoginDate;

--Ignore Incomplete Pairs
--If either LoginTime or LogoutTime is missing, skip that record:
SELECT 
    EmpID,
    CAST(LoginTime AS DATE) AS LoginDate,
    SUM(DATEDIFF(MINUTE, LoginTime, LogoutTime)) / 60.0 AS TotalHours
FROM EmployeeLogins
WHERE LoginTime IS NOT NULL AND LogoutTime IS NOT NULL
GROUP BY EmpID, CAST(LoginTime AS DATE);

--For table structure like below
EmployeeLogins (
    EmpID INT,
    LoginType VARCHAR(10),  -- 'In' or 'Out'
    LogTime DATETIME
)
--This means each row is either a login event (In) or a logout event (Out). To calculate how many hours an employee worked in a day, you need to pair each In with the next Out and then sum the durations.
--Pair In/Out events
--You can use a window function (LEAD) to find the next Out time after an In.
--SQL Server / Oracle / PostgreSQL
WITH SessionPairs AS (
    SELECT 
        EmpID,
        CAST(LogTime AS DATE) AS LoginDate,
        LogTime AS InTime,
        LEAD(LogTime) OVER (PARTITION BY EmpID, CAST(LogTime AS DATE) ORDER BY LogTime) AS OutTime
    FROM EmployeeLogins
    WHERE LoginType = 'In'
)
SELECT 
    EmpID,
    LoginDate,
    SUM(DATEDIFF(MINUTE, InTime, OutTime)) / 60.0 AS TotalHours
FROM SessionPairs
WHERE OutTime IS NOT NULL
GROUP BY EmpID, LoginDate
ORDER BY EmpID, LoginDate;


--Pair In with next Out
--Use a window function (LEAD) to find the next event after an In:
WITH SessionPairs AS (
    SELECT 
        EmpID,
        CAST(LogTime AS DATE) AS LoginDate,
        LogTime AS InTime,
        LEAD(LogTime) OVER (
            PARTITION BY EmpID, CAST(LogTime AS DATE) 
            ORDER BY LogTime
        ) AS OutTime,
        LEAD(LoginType) OVER (
            PARTITION BY EmpID, CAST(LogTime AS DATE) 
            ORDER BY LogTime
        ) AS NextType
    FROM EmployeeLogins
    WHERE LoginType = 'In'
)
SELECT 
    EmpID,
    LoginDate,
    SUM(DATEDIFF(MINUTE, InTime, 
                 CASE WHEN NextType = 'Out' THEN OutTime END)) / 60.0 AS TotalHours
FROM SessionPairs
WHERE NextType = 'Out'   -- only valid In→Out pairs
GROUP BY EmpID, LoginDate
ORDER BY EmpID, LoginDate;


