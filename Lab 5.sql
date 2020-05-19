/*	
	IS6030 Homework 6a 
*/

USE Week5Exercise

/*--------------------------------------------------------------------------------------
Instructions:

You will be using the StudentDinner database we created in class to answer the following questions.

Please download the StudentDinner.sql and execute the file to create the StudentDinner database
if you have not done so in class.

Answer each question as best as possible.  
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/


/*1. List the restaurant according to their average ratings, from the highest to the lowest.*/
SELECT r.RName, AVG(CAST (d.Rating AS DECIMAL (3,2))) AS AvgRating
FROM Restaurant r
	INNER JOIN Dinner d
	ON r.RID=d.RID
GROUP BY r.RName
ORDER BY AVG(CAST (d.Rating AS DECIMAL (3,2))) DESC;


/*2. List the names of student who eat out every single day of the week.*/
SELECT s.SName
FROM Student s
	INNER JOIN Dinner d
	ON s.SID = d.SID 
GROUP BY s.SName
HAVING   COUNT(d.SID)=7;


/*3. List the restaurant whose total earning is greater than $100 and does not have a phone number, with the highest earning restaurant at the top.*/
SELECT r.RName, SUM(d.Cost) AS TotEarning
FROM Restaurant r
	INNER JOIN Dinner d
	ON r.RID=d.RID
WHERE r.Phone IS NULL
GROUP BY r.RName
HAVING SUM(d.Cost)>50
ORDER BY SUM(d.Cost) DESC;



/*4. List the student according to the total distance they travel for dinner.*/
SELECT s.SName, SUM(r.LCBDistance) as TotalDistanceTravelled
FROM Student s
	INNER JOIN Dinner d
	ON s.SID=d.SID 
	INNER JOIN Restaurant r
	ON r.RID=d.RID
GROUP BY s.SName
ORDER BY  TotalDistanceTravelled DESC;


/*5. List the names of student who do not like to eat out on Thursdays.*/
SELECT DISTINCT s.SName
FROM Student s
	INNER JOIN Dinner d
	ON s.SID=d.SID 
WHERE s.SID NOT IN 
	(   
		SELECT SID 
		FROM Dinner 
		WHERE DinnerDay ='Thursday'
	);


/*6. For each major, list the total amount of money students spent on dinner
and their number of visits to restaurants during the weekends (Saturdays and Sundays).*/	

SELECT M.Major, SUM(d.Cost) as MoneySpent, COUNT(d.Cost) as VisitTimes, SUM(d.Cost)/COUNT(d.Cost) as AvgSpent
FROM Major m
INNER JOIN Student s
ON m.MID=s.MID 
INNER JOIN Dinner d
ON s.SID=d.SID
WHERE d.DinnerDay='Saturday' OR d.DinnerDay='Sunday' 
GROUP BY m.Major
ORDER BY MoneySpent DESC;
