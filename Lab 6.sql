
/*	
	IS6030 Homework 6b 
*/

--Answer Key

/*--------------------------------------------------------------------------------------
Instructions:

You will be using the Baltimore Parking Citations data set (14,705 rows)
(this is only a snapshot of all citations for Baltimore).

The name of your table should be called dbo.ParkingCitations.

Answer each question as best as possible.  
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/

/* You can run this query to check your table, if it does not run or you do not get 14,705 rows,
   you should revisit your import/table.  Before you do anything, make sure your data/table 
   is correct!
   
	SELECT *
	FROM DEMO.dbo.ParkingCitations 
*/



/* Q1.  Show the number of Citations, Total Fine amount, by Make and Violation Date. 
        Sort your results in a descending order of Violation Date and in an ascending order of Make.

		Hint: Check the data type for ViolDate and see whether any transformation is needed.
*/

/* Q1. Answer */
		SELECT COUNT(*) as NumberOfCitations 
			, SUM(ViolFine) as TotalFine 
			, Make 
			, CAST (ViolDate as DATE) as ViolDay 
		FROM dbo.ParkingCitations
		GROUP BY CAST (ViolDate as DATE) 
			, Make
		ORDER BY CAST (ViolDate as DATE)  DESC
			, Make


/* Q2. Display just the State (2 character abbreviation) that has the most number of violations */

/* Q2. Answer */ 
		--Approach 1
		SELECT TOP 1 State, COUNT(*) AS NumViol
		FROM dbo.ParkingCitations 
		GROUP BY State
		ORDER BY COUNT(*) DESC

		--Approach 2
		SELECT State, COUNT(*) AS NumViol
		FROM dbo.ParkingCitations 
		GROUP BY State
		HAVING Count (*) > = ALL
			(
				SELECT COUNT (*)
				FROM dbo.ParkingCitations 
				GROUP BY State
			)
		
/* Q3. Display the number of violations and the tag, for any tag that is registered at Maryland (MD) and has 6 or more violations. 
	   Order your results in a descending order of number of violations.
*/

/* Q3 Answer */
		SELECT COUNT(*) as NumberOfViolations, Tag 
		FROM dbo.ParkingCitations 
		WHERE State = 'MD'
		GROUP BY Tag 
		HAVING COUNT(*) >= 6
		ORDER BY COUNT(*) DESC



/* 
Q4. Use functions and generate a one column output by formatting the data into this format 
	(I'll use the first record as an example of the format, you'll need to apply this to all records with State of MD):
		
			15TLR401 - Citation: 98348840 - OTH - Violation Fine: $502.00 
*/

/* Q4. Answer */
		SELECT Tag + ' - Citation: ' + CAST(Citation as varchar(50)) + ' - ' + Make + ' - Violation Fine: $' + CAST(ViolFine as varchar(10))
		FROM dbo.ParkingCitations 
		WHERE State = 'MD'

		--Test Query
		SELECT *, Tag + ' - Citation: ' + CAST(Citation as varchar(50)) + ' - ' + Make + ' - Violation Fine: $' + CAST(ViolFine as varchar(10))
		FROM dbo.ParkingCitations 
		WHERE Tag = '15TLR401'

/* Q5. 
	   Write a query to calculate which states MAX ViolFine differ more than 200 from MIN VioFine 
	   Display the State Name and the Difference.  Sort your output by State A->Z.
*/

/* Q5. Answer */

SELECT MaxState.State, MaxFine - MinFine as FineSalaryDifference
--SELECT *
FROM 
	(SELECT MAX(ViolFine) as MaxFine, State 
		FROM dbo.ParkingCitations
	 GROUP BY State) MaxState
INNER JOIN
	(SELECT MIN(ViolFine) as MinFine, State
		FROM dbo.ParkingCitations
	GROUP BY State) MinState
ON MaxState.State = MinState.State 
WHERE MaxFine- MinFine > 200
ORDER BY MaxState.State asc

--Another way...
SELECT State, MAX(ViolFine) - MIN(ViolFine) as FineDifference 
FROM dbo.ParkingCitations
GROUP BY State
HAVING (MAX(ViolFine) - MIN(ViolFine)) > 200
ORDER BY State


/* Q6. You will need to bucket the entire ParkingCitations database into three segments by ViolFine. 
	   Your first segment will include records with ViolFine between $0.00 and $50.00 and will be labled as "01. $0.00 - $50.00".
	   The second segment will include records with ViolFine between $50.01 and $100.00 and will be labled as "02. $50.01 - $100.00".
	   The final segment will include records with ViolFine larger than $100.00 and will be labled as"03. larger than $100.00". 

	   Display Citation, Make, VioCode, VioDate, VioFine, and the Segment information in an descending order of ViolDate. 
		    
*/ 

/* Q6. Answer */

	SELECT Citation
			, Make
			, ViolCode
			, ViolDate
			, CASE 
				WHEN ViolFine >= 0.00 and ViolFine <= 50.00 THEN '01. $0.00 - $50.00'
				WHEN ViolFine>= 50.01 and ViolFine <= 100.00 THEN '02. $50.01 - $100.00'
				WHEN ViolFine > 100.00 THEN '03. Larger than $100.00'
				-- ELSE '03. Larger than $100.00' --You can do an ELSE as your final BUCKET
			  END as FineCategory
	 FROM dbo.ParkingCitations



/* Q7. 
	   
	   Based on the three segments you created in Q6, display the AVG ViolFine and number of records for each segment. 
	   Order your output by the lowest -> highest segments.
		    
*/ 

/* Q7. Answer */

	SELECT FineCategory, COUNT(*) as NumberOfRecords, AVG(ViolFine) as AvgFine
	FROM (
		SELECT *
			, CASE 
				WHEN ViolFine >= 0.00 and ViolFine <= 50.00 THEN '01. $0.00 - $50.00'
				WHEN ViolFine>= 50.01 and ViolFine <= 100.00 THEN '02. $50.01 - $100.00'
				WHEN ViolFine > 100.00 THEN '03. Larger than $100.00'
				-- ELSE '03. Larger than $100.00' --You can do an ELSE as your final BUCKET
			  END as FineCategory
		 FROM dbo.ParkingCitations
	) OarkingFineCategory
	GROUP BY FineCategory 
	ORDER BY FineCategory ASC

	--OR

	WITH OarkingFineCategory AS
	(	SELECT *
			, CASE 
				WHEN ViolFine >= 0.00 and ViolFine <= 50.00 THEN '01. $0.00 - $50.00'
				WHEN ViolFine>= 50.01 and ViolFine <= 100.00 THEN '02. $50.01 - $100.00'
				WHEN ViolFine > 100.00 THEN '03. Larger than $100.00'
				-- ELSE '03. Larger than $100.00' --You can do an ELSE as your final BUCKET
			  END as FineCategory
		 FROM dbo.ParkingCitations
	)

	SELECT FineCategory, COUNT(*) as NumberOfRecords, AVG(ViolFine) as AvgFine
	FROM OarkingFineCategory
	GROUP BY FineCategory 
	ORDER BY FineCategory ASC


/*Bonus Question 

Q8. You may share any challenge(s) you face while finishing the assignment and how you overcome the challenge.

*/