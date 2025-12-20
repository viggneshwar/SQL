#You can get the 3rd highest salary in SQL using several approaches: subqueries, ranking functions (ROW_NUMBER, RANK, DENSE_RANK), TOP/LIMIT with OFFSET, or correlated queries
#1. Using TOP with ORDER BY (SQL Server)
SELECT TOP 1 salary
FROM (
    SELECT TOP 3 salary
    FROM employees
    ORDER BY salary DESC
) AS temp
ORDER BY salary ASC;

#2. Using LIMIT with OFFSET (MySQL, PostgreSQL)

SELECT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

#3. Using ROW_NUMBER() (SQL Server, Oracle, PostgreSQL)
SELECT salary
FROM (
    SELECT salary, ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
    FROM employees
) AS ranked
WHERE row_num = 3;

#4. Using RANK() or DENSE_RANK()
SELECT salary
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) AS ranked
WHERE rnk = 3;


#5. Using Nested Subqueries
SELECT MAX(salary)
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (
        SELECT MAX(salary)
        FROM employees
    )
);

#6. Using CTE
WITH SalaryRank AS (
    SELECT salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
    FROM employees
)
SELECT salary
FROM SalaryRank
WHERE row_num = 3;

--How do you get the nth highest salary (say 3rd)?
SELECT Salary
FROM (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM EmployeeSalary
) AS t
WHERE rnk = 3;
