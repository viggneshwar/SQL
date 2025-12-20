--How do you update salaries by 10% for employees in a specific department?
UPDATE EmployeeSalary
SET Salary = Salary * 1.10
WHERE Department = 'IT';

--How do you find employees without managers?
SELECT *
FROM Employee
WHERE ManagerId IS NULL;


-- Explanation: Checks for NULL values in ManagerId.

-- How do you retrieve the top 5 highest paid employees?
SELECT TOP 5 *
FROM EmployeeSalary
ORDER BY Salary DESC;


-- Explanation: TOP keyword with ORDER BY is commonly asked in interviews.

-- How do you join two tables to get employee details with their salary?
SELECT e.FullName, e.City, s.Salary
FROM Employee e
INNER JOIN EmployeeSalary s ON e.EmpId = s.EmpId;


- Explanation: Demonstrates INNER JOIN usage.


-- How do you get the nth highest salary (say 3rd)?
SELECT Salary
FROM (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM EmployeeSalary
) AS t
WHERE rnk = 3;


-- Explanation: DENSE_RANK() is better than ROW_NUMBER() when duplicates exist.

-- How do you find employees who don’t have a salary record?
SELECT e.FullName
FROM Employee e
LEFT JOIN EmployeeSalary s ON e.EmpId = s.EmpId
WHERE s.EmpId IS NULL;

