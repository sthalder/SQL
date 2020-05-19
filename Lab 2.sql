RETURN;

--Homework 3 Querying from One Single Table


/*--------------------------------------------------------------------------------------
Instructions:

Assume you have a table with the following information for all countries. 

CCODE	CNAME			CONTINENT	LANGUAGE	POPULATION		LAND		WATER
1		Afghanistan		AS  		fa    		30419928.00		652230		NULL
2		Albania			EU  		sq    		3002859.00		27398		1350
3		Algeria			AF  		ar    		35406303.00		2381741		NULL
бн	бн	бн	бн	бн	бн	бн

Use this table to answer Q1-Q10 (1 Point Each).
Answer each question as best as possible.  
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/


CREATE DATABASE HW3;
USE HW3;

/*
Q1. Write the SQL syntax to drop a table Country if it exists in the current database.
*/

IF OBJECT_ID('dbo.Country', 'U') IS NOT NULL DROP TABLE dbo.Country;




/*
Q2.	Write the SQL syntax to create a table Country. Please check whether table Country already exists in the database. If so, drop it before you create a new table.
*/

IF OBJECT_ID('dbo.Country', 'U') IS NOT NULL DROP TABLE dbo.Country;
CREATE TABLE dbo.Country (CCODE INT PRIMARY KEY
						,CNAME VARCHAR (20)	
						,CONTINENT VARCHAR (15)
						,LANGUAGE VARCHAR (15)
						,POPULATION DECIMAL (12,2)
						,LAND DECIMAL (10,2)
						,WATER DECIMAL (10,2)
);


/*
Q3.	Write the SQL syntax to insert the three records into the table you just created.
*/

INSERT INTO dbo.Country VALUES (1, 'Afghanistan', 'AS', 'fa', 30419928125.12, 652230, NULL);
INSERT INTO dbo.Country VALUES (2, 'Albania', 'EU', 'sq', 3002859, 27398, 1350);
INSERT INTO dbo.Country VALUES (3, 'Algeria', 'AF', 'ar', 35406303, 2381741, NULL);


/*
Q4.	Use the UPDATE statement to update the country table. If a country's WATER is not listed (i.e., it is null) update it to 30% of its LANDSIZE. 
*/

UPDATE dbo.Country
SET WATER = 0.3 * LAND
WHERE WATER IS NULL


-- Table Check
SELECT * FROM dbo.Country

/*
Q5.	Write a SQL query to answer: What is the total water area in the continent of Africa? ('AF')?
*/

SELECT SUM(WATER) AS Total_Water_Area
FROM dbo.Country
WHERE CONTINENT = 'AF'


/*
Q6.	Write a SQL query to answer: What is the average population of countries who speak English ('en') and whose name start and end with 'a'. 
*/

SELECT AVG(POPULATION) AS Average_Population
FROM dbo.Country
WHERE LANGUAGE IN ('en') AND CNAME LIKE 'a%a'


/*
Q7.	Write a SQL query to show a number that represents the number of unique languages spoken.
*/

SELECT COUNT(DISTINCT LANGUAGE) AS Unique_Languages
FROM dbo.Country


/*
Q8.	Your friend can speak English (en), German (de), Spanish (es), and French (fr). 
Without using the OR operator, write a SQL query to answer: How many countries can she 
visit by speaking the local language. 
*/

SELECT COUNT(DISTINCT CNAME) AS Country_Visit_Count
FROM dbo.Country
WHERE LANGUAGE IN ('en', 'de', 'es', 'fr')


/*
Q9.	Write a SQL query to show continents with a total population larger than 500 million. 
Please list the continents and the average Population Density of all countries in each of these continents. 
Population Density is defined as POPULATION/Total Area. 
Total Area is the sum of LAND and WATER. 
List the continents in the descending order of the population density.
*/


SELECT 
	CONTINENT,
	Total_Population/(Total_Land + Total_Water) AS Average_Population_Density
	FROM
	(
		SELECT 
			CONTINENT,
			SUM(POPULATION) AS Total_Population,
			SUM(LAND) AS Total_Land,
			SUM(WATER) AS Total_Water
		FROM dbo.Country
		GROUP BY CONTINENT
	)Total
	WHERE Total_Population > 500000000
ORDER BY Average_Population_Density DESC



/*
Q10. Write a SQL query to show the following message in the output: 
(CName) is a country with a population of (the whole number of the population).
Example: Afghanistan is a country with a population of 30419928.
*/

SELECT CONCAT(CNAME, ' is a country with a population of ', CAST(POPULATION AS INT)) AS Country_Population
FROM dbo.Country




/*Q11. (Bonus: 0.1 point)
	You may share any challenge(s) you face while finishing the assignment and how you overcome the challenge.
*/

/*
Q9: I initially wrote a query which calculated individual population density(PD) of countries and at an overall level
it calculated the average of average of PD. I updated data in the table, generated results and found this error 
in calculation. Finally, I rewrote the above query which gives the correct output required.
*/
