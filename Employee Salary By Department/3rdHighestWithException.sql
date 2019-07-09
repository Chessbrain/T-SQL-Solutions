-- This returns the 3rd highest salary in each department, 
-- as well as the highest pay in a department if that department has less than 3 employees.

WITH Z AS (
SELECT	EmployeeName, 
		Department, 
		Salary, 
		DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS DenseRank
FROM EmployeesTable
)
SELECT Z.Department, Z.EmpoyeeName, Z.Salary
FROM Z
WHERE Z.DenseRank = 3

UNION ALL

SELECT	A.Department, 
		A.EmployeeName, 
		A.Salary
FROM EmployeesTable AS A
JOIN (
	SELECT MAX(Salary) As [HighestSalary], Department 
	FROM EmployeesTable 
	GROUP BY Department 
	HAVING COUNT(Department) < 3) AS B
ON A.Department = B.Department AND A.Salary = B.Salary
GROUP BY A.Department, A.EmployeeName, A.Salary

