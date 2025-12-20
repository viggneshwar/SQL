--How do you find employees working on more than one project?
SELECT EmpId
FROM EmployeeSalary
GROUP BY EmpId
HAVING COUNT(Project) > 1;

