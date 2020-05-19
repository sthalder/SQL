--Homework #2 Query from A Single Table

/*--------------------------------------------------------------------------------------
Instructions:

You will need to import the data for Chicago Salary in order to complete this assignment. 

The Chicago Salary tabe should be called dbo.ChicagoSalary and have 4 fields 
Name varchar(255) 
PositionTitle varchar(255) 
Department varchar(255) 
Salary decimal(19,2)

You should have a total of 32,432 rows.

Don't forget to name your columns, an output of (No column name) will reduce your overall grade.

Answer each question as best as possible.  
Show your work if you need to take multiple step to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/

CREATE DATABASE UC;   --- Creating the database UC
USE UC;


/* 
Q1. (0.5 point)
Write the query to COUNT the number of Records in the Salary table. 

*/

/* Q1. Query*/


SELECT 
	COUNT(Salary) as [Number_Of_Records]
FROM dbo.ChicagoSalary


/* 
Q2. (0.5 point)
Write a query to display the number of unique names.

*/

/* Q2. Query */


SELECT 
	COUNT(DISTINCT Name) AS [Unique_Names]
FROM dbo.ChicagoSalary


/* 
Q3. (0.5 point)
Write a query to display the only the name and position title of those with a full name 
that contains the text 'Spangler' in it.

*/

/* Q3. Query*/

SELECT 
	Name,
	PositionTitle as [Position_Title]
FROM dbo.ChicagoSalary
WHERE Name like '%Spangler%'



/* 
Q4. (0.5 point)
Write a query to display the name and position of the person who has the lowest Salary in the the AVIATION department.

*/

/* Q4. Query */


SELECT 
	Name,
	PositionTitle as [Position_Title]
FROM dbo.ChicagoSalary
WHERE	Department in ('AVIATION')
		AND Salary = (SELECT MIN(Salary) FROM dbo.ChicagoSalary
						WHERE Department in ('AVIATION'))


/* 
Q5. (0.5 point)
Write a query to display all the names and salaries of everyone in the WATER MGMNT department
that makes more than 150K in salary, order the output by Salary descending.

*/

/* Q5. Query */ 

SELECT 
	Name,
	Salary
FROM dbo.ChicagoSalary
WHERE	Department in ('WATER MGMNT')
		AND Salary > 150000
ORDER BY Salary DESC



/* 
Q6. (0.5 point)
Display the total salary of the entire Chicago salary table.

*/

/* Q6. Query */

SELECT 
	SUM(Salary) as [Total_Salary]
FROM dbo.ChicagoSalary



/* 
Q7. (0.5 point)
Display the department name and average salary where average salary for the department is more than 90000.

*/

/* Q7. Query */


SELECT 
	Department,
	AVG(Salary) as [Average_Salary]
FROM dbo.ChicagoSalary
GROUP BY Department
HAVING AVG(Salary) > 90000



/* Q8. (0.5 point)
Which Employee has the highest salary? 
How Much higher is that person's salary compared to the AVG salary of the department they belong to? 
You can use multiple queries to answer this question.

*/

/*Q8. Query */

-- 260004.00 - 76223.614 = 183780.386

SELECT 
	(SELECT Name from dbo.ChicagoSalary
		Where Salary = (SELECT MAX(Salary) FROM dbo.ChicagoSalary)) as Name,	
	Department, 
	MAX(Salary) Max_Salary, 
	AVG(Salary) Avg_Salary, 
	MAX(Salary) - AVG(Salary) as [Salary_Difference]
FROM dbo.ChicagoSalary
Where	Department in 
		(SELECT Department FROM dbo.ChicagoSalary 
			WHERE Salary = (SELECT MAX(SALARY) as MaxSalary FROM dbo.ChicagoSalary))
GROUP BY Department


/* Q9. (0.5 point)
Display the Name, Department, Salary (to the nearest whole number) of any employee who has a salary of 60000 or more 
and their name begins with 'Aaron'.

*/ 

/* Q9. Query */

SELECT 
	Name,
	Department, 
	CAST((ROUND(Salary, 0)) as INT) as Salary
FROM dbo.ChicagoSalary
WHERE	(Salary > 60000)
		AND (Name LIKE 'Aaron%') 




/* Q10. (0.5 point)
Display LastName and FirstName (with Middle Initial) as seperate columns/fields derived from the Name field. Write down your query in the answersheet.

*/

/* Q10. Query*/

SELECT 
	Name,
	SUBSTRING(Name, 1, CHARINDEX(',', Name, 1) - 1) as [Last_Name], 
	SUBSTRING(Name, CHARINDEX(',', Name, 1) + 2, LEN(Name) - CHARINDEX(',', Name) + 1) as [First_Name]
FROM dbo.ChicagoSalary



/*Bonus Q11. (0.1 point) 
You may share any challenge(s) you face while finishing the assignment and how you overcome the challenge.

*/

-- Question 6: I had a confusion whether to sum all salaries or sum only salries with distinct names. I confirmed
-- with Prof. that it should be all salaries. However, I observed there are some exact duplicate rows 
-- while some people had their departments changed. Below are the queries I used:

-- Query to find duplicate Names
SELECT * 
FROM
	(SELECT Name, SUM(Records) as [Sum_Of_Records]
	 FROM
		(SELECT Name, COUNT(*) as Records 
		 FROM dbo.ChicagoSalary
		 GROUP BY Name) rec
	 GROUP BY Name) total
WHERE [Sum_Of_Records] > 1

-- Randomly selected some names to check reason for duplicates
SELECT * 
FROM dbo.ChicagoSalary
WHERE Name in ('AGUILAR,  ROBERT', 'ADE,  JAMES P', 'BAUTISTA,  DAVID', 'BROWN,  DAVID L')

-- Question 9: The salary columns were already integers, however there were 2 decimal places with 0 due to data
-- type. I therefore casted them as integers after rounding off. Also, I selected last name begins with Aaron here

