RETURN;
--Homework #4b Querying Multiple Tables
--Your Name:

/*--------------------------------------------------------------------------------------
Instructions:

You will be using the Chicago Salary table but you will following the questions 
to normalize the data in order to provide a table structure to test your JOIN abilities. 

You can use the original summary table to double check any answers.

Answer each question as best as possible.  
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/
create database HW4;
use HW4;

/* 
Q1. (1 point)
	Write the syntax to drop and build a table called dbo.Employee. 
	Create an EmployeeID field (IDENTITY PK), a Name field and a Salary field for the Employee table.
	Populate the Employee table with unique Name and Salary information from the dbo.ChicagoSalary table.
*/


/* Q1. Syntax*/

IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee;

create table dbo.Employee (EmployeeID int identity primary key
						,EmployeeName nvarchar (255)	
						,Salary money
);

insert into dbo.Employee(EmployeeName, Salary)
select distinct Name, Salary
from dbo.ChicagoSalary

select * from dbo.Employee

/* Q2. (1 point)
	Write the syntax to drop and build a table called dbo.Department.
	Create an DepartmentID field (IDENTITY PK), and a Name field for the Department Table.
	Populate the Department table with unique Department Names.
*/

/* Q2. Syntax */

IF OBJECT_ID('dbo.Department', 'U') IS NOT NULL DROP TABLE dbo.Department;

create table dbo.Department (DepartmentID int identity primary key
						,DepartmentName nvarchar (255)	
);

insert into dbo.Department(DepartmentName)
select distinct Department
from dbo.ChicagoSalary

select * from dbo.Department



/* Q3. (1 point)
	Write the syntax to drop and build a table called dbo.Position.
	Create an PositionID field (IDENTITY PK), and a Name field for the Position table.
	Populate the Position table with unique PositionTitles (call the field Title).
*/

/* Q3. Syntax */


IF OBJECT_ID('dbo.Position', 'U') IS NOT NULL DROP TABLE dbo.Position;

create table dbo.Position (PositionID int identity primary key
						,PositionTitle nvarchar (255)	
);

insert into dbo.Position(PositionTitle)
select distinct PositionTitle
from dbo.ChicagoSalary

select * from dbo.Position


/* Run the following query to populate a Employment table to help build the relationship between the above three tables. */


IF OBJECT_ID('dbo.Employment','U') IS NOT NULL DROP TABLE dbo.Employment;

SELECT DISTINCT IDENTITY(INT,1,1)  EmploymentID
		, EmployeeID
		, PositionID
		, DepartmentID
 INTO dbo.Employment
FROM dbo.ChicagoSalary CS
INNER JOIN dbo.Employee E on CS.Name = E.EmployeeName and CS.Salary = E.Salary 
INNER JOIN dbo.Position P on P.PositionTitle = CS.PositionTitle  
INNER JOIN dbo.Department D on D.DepartmentName = CS.Department;


select * from dbo.Employment

/* Q4. (1 point)
	Display the same output as the dbo.ChicagoSalary table but use the new 4 tables you created.
*/

/* Q4. Syntax*/

select 
	e.EmployeeID, p.PositionTitle, d.DepartmentName, e.Salary
from dbo.Employee e
left join dbo.Employment emp
on e.EmployeeID = emp.EmployeeID
left join dbo.Position p
on p.PositionID = emp.PositionID
left join dbo.Department d
on d.DepartmentID = emp.DepartmentID



/* Q5. (1 point)
	Using the new tables and JOINs to display Number of Employees and Average Salary in the Police department.
*/

/*Q5. Syntax*/

select 
	count(e.EmployeeName) as NumberOfEmployees,
	avg(e.Salary) as AverageSalary
from dbo.Employee e
left join dbo.Employment emp
on e.EmployeeID = emp.EmployeeID
left join dbo.Department d
on d.DepartmentID = emp.DepartmentID
where d.DepartmentName = 'POLICE'


/* Q6. (2 point)
	Using the new tables and JOINs to provide the Number of Employees and Total Salary of Each Department.
	Sort the output by Department A->Z.
*/

/*Q6. Syntax*/

select 
	d.DepartmentName,
	count(e.EmployeeName) as NumberOfEmployees,
	sum(e.Salary) as TotalSalary
from dbo.Employee e
left join dbo.Employment emp
on e.EmployeeID = emp.EmployeeID
left join dbo.Department d
on d.DepartmentID = emp.DepartmentID
group by d.DepartmentName
order by d.DepartmentName



/* Q7. (1 point)
	Using the new table(s) and subqueries to list the name(s) and salary of employee(s) whose last name is 
	Aaron and work for the POLICE department. 
*/ 

/*Q7. Syntax*/

select 
	e.EmployeeName,
	e.Salary
from dbo.Employee e
left join dbo.Employment emp
on e.EmployeeID = emp.EmployeeID
where emp.DepartmentID in	(
							select DepartmentID from dbo.Department
							where DepartmentName = 'POLICE'
							)
	and e.EmployeeName like 'Aaron,%'


/*Q7. Answer:
Name= AARON,  JEFFERY M
Salary= 75372.00
*/

 

/* Q8. (1 point)
	Display the name(s) of the people who have the longest name(s) 
*/

/* Q8. Syntax */

select
	EmployeeName,
	len(EmployeeName) as LengthEmployeeName
from dbo.Employee
where len(EmployeeName) in (select max(len(EmployeeName)) from dbo.Employee)
group by EmployeeName


/* Q8.Answer: 
EmployeeName: CLEMONS SAMS,  MICHAEL ANTHONY C, WRZESNIEWSKA KOZAK,  ANNABELLA M
LengthEmployeeName: 32
*/
					 
/*Q9. (Bonus: 0.1 point)
	You may share any challenge(s) you face while finishing the assignment and how you overcome the challenge.
*/

 /* Q9.Answer: 

 HW4a) 
 Q3: Initially I had 2 separate queries for actors not directors and directors not actors, but later did union all 
 to have it in one list. Since I thought it is required in a single query. I still feel having them in 2 queries
 makes more sense for consumption.

 HW4b)
 Q6: There are 13626 distinct employee names with some of them having multiple salaries. This can be multiple 
 employees with same names or the same employee having different salaries. If I had taken distinct count of 
 employees, my average would become incorrect since it would have been based on 13672 employee salaries.
 If we take only the distinct employee names, then we don't know which salary rows should be eliminated for
 correct average.

 Q7: Same as Q6 above.

*/
