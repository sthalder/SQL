/* Exam Query Questions */

/*
24.  Create a new table dbo.WineRating by following these steps:
A. Check if the table exists and drop the table;
B. Create Table: The first column of the table should be WineID which is an auto incrementing integer and is set as the PRIMARY KEY;
C. Insert Data: INSERT your data from the imported table "dbo.ImportWineRating" into the dbo.WineRating table.
*/
create database final_exam;
use final_exam;

if object_id('dbo.WineRating', 'U') is not null drop table dbo.WineRating
create table dbo.WineRating 
(
	WineID int identity primary key,
	WineName nvarchar (100),
	Store nvarchar(100),
	Variety nvarchar (100),
	Type nvarchar (100),
	Cost money,
	Review varchar (100),
	ReviewDate datetime,
	TasteRating float,
	ValueRating float
);

insert into dbo.WineRating(WineName, Store, Variety, Type, Cost, Review, ReviewDate, TasteRating, ValueRating)
select * from dbo.ImportWineRating

-- Table check
select * from dbo.WineRating


/*	   
25. Write the SQL syntax to ALTER and UPDATE the WineRating table. 
Add a column OverallRating to the table. Update the value of the OverallRating as the sum of TasteRating and ValueRating.
*/

alter table dbo.WineRating
add OverallRating float;

update dbo.WineRating
set OverallRating = TasteRating + ValueRating

-- Table check
select OverallRating from dbo.WineRating


/*
26. List the name, variety, and overall rating for red wines at Costco in an ascending order of cost.
*/

-- select * from dbo.WineRating

select WineName, Variety, OverallRating
from dbo.WineRating
where Store = 'Costco' and Type = 'Red'
order by Cost;



/*
27. What is the minimum and maximum price for red wines produced in 2012? 
[hint: wine production year is the number embedded WineName.]
*/

-- select * from dbo.WineRating

select
	min(Cost) as min_price,
	max(Cost) as max_price
from dbo.WineRating
where WineName like '2012%'



/*
28. Which store has the most variety of wine?
*/
-- select * from dbo.WineRating

select Store, count(distinct Variety) as distinct_wines
from dbo.WineRating
group by Store
order by distinct_wines desc;



/*
29. List the number of wines and the average value rating (rounded up with no decimal places)
 	for each type of wine. Sort your results by average cost in a descending order.
*/

select 
	Type,
	count(distinct WineName) as number_of_wines,
	cast(avg(ValueRating) as decimal (4,0)) as avg_rating
from dbo.WineRating
group by Type
order by avg(Cost) desc



/*
30. Display the unique varieties of red wine that have more than 10 reviews.
*/

select 
	Variety
from dbo.WineRating
where Type = 'Red'
group by Variety
having count(Review) > 10


/*
31. Using a subquery to display the red wine(s) with the lowest taste rating.
*/

select
	WineName
from dbo.WineRating
where Type = 'Red' and TasteRating in 
									(select min(TasteRating) as min_taste_rating from 
									dbo.WineRating where Type = 'Red')



/*
32. Display a one column output by formatting the data into the following format: 

2008 Oreana Syrah Project Happiness: Type- Red / Syrah - Price $5.99 - Skip It

Please apply this format to all red wines that have a review of "Skip It".
*/

select concat(WineName, ': Type- ', Type, ' / ', Variety, ' - Price $', Cost, ' - ', Review) as wine_description
from dbo.WineRating
where Type = 'Red' and Review = 'Skip It'




/*
33. Please do the following steps to normalize the data in the dbo.WineRating table. 

A. Write the syntax to DROP and CREATE four tables in the following order: 
   dbo.Store, dbo.Type, dbo.Variety, dbo.Wine. The relationships among these four tables are described in the attached relational schema. 

B. Please populate data to the dbo.Store, dbo.Type, and dbo.Variety tables from the dbo.WineRating table.

C. Run the following query to populate the dbo.Wine table to help build the relationship between the above three tables. 
   Please adjust the table/column names if needed.

   	INSERT INTO dbo.Wine (TypeID  
		, VarietyID
		, StoreID   
		, WineName 
		, Cost 
		, Review
		, ReviewDate 
		, TasteRating 
		, ValueRating 
		, OverallRating)
	SELECT TypeID  
		, VarietyID
		, StoreID   
		, WineName 
		, Cost 
		, Review
		, ReviewDate 
		, TasteRating 
		, ValueRating 
		, OverallRating 
	FROM dbo.WineRating WR
	INNER JOIN dbo.Type T on T.Type = WR.Type 
	INNER JOIN dbo.Variety V on V.Variety = WR.Variety 
	INNER JOIN dbo.Store S on S.Store = WR.Store 

*/

-- creating table dbo.Store
if object_id('dbo.Store', 'U') is not null drop table dbo.Store
create table dbo.Store
(
	StoreID int identity primary key,
	Store nvarchar(100)
);

-- creating table dbo.Type
if object_id('dbo.Type', 'U') is not null drop table dbo.Type
create table dbo.Type
(
	TypeID int identity primary key,
	Type nvarchar (100)
);

-- creating table dbo.Variety
if object_id('dbo.Variety', 'U') is not null drop table dbo.Variety
create table dbo.Variety
(
	VarietyID int identity primary key,
	Variety nvarchar (100)
);

-- creating table dbo.Wine
if object_id('dbo.Wine', 'U') is not null drop table dbo.Wine
create table dbo.Wine
(
	WineID int identity primary key,
	StoreID int foreign key references dbo.Store (StoreID),
	VarietyID int foreign key references dbo.Variety (VarietyID),
	TypeID int foreign key references dbo.Type (TypeID),
	WineName nvarchar (100),
	Cost money,
	Review varchar (100),
	ReviewDate datetime,
	TasteRating float,
	ValueRating float,
	OverallRating float
);

-- Inserting values into above tables created
insert into dbo.Store (Store)
select distinct Store
from dbo.WineRating

insert into dbo.Type (Type)
select distinct Type
from dbo.WineRating

insert into dbo.Variety (Variety)
select distinct Variety
from dbo.WineRating

INSERT INTO dbo.Wine (TypeID  
		, VarietyID
		, StoreID   
		, WineName 
		, Cost 
		, Review
		, ReviewDate 
		, TasteRating 
		, ValueRating 
		, OverallRating)
	SELECT TypeID  
		, VarietyID
		, StoreID   
		, WineName 
		, Cost 
		, Review
		, ReviewDate 
		, TasteRating 
		, ValueRating 
		, OverallRating 
	FROM dbo.WineRating WR
	INNER JOIN dbo.Type T on T.Type = WR.Type 
	INNER JOIN dbo.Variety V on V.Variety = WR.Variety 
	INNER JOIN dbo.Store S on S.Store = WR.Store 


/*
34. Using the new tables and JOINs to display all information in the dbo.WineRating table. 
*/

select
	w.WineID,
	w.WineName,
	s.Store,
	v.Variety,
	t.Type,
	w.Cost,
	w.Review,
	w.ReviewDate,
	w.TasteRating,
	w.ValueRating,
	w.OverallRating
from dbo.Wine w
inner join dbo.Store s
on w.StoreID = s.StoreID
inner join dbo.Type t
on w.TypeID = t.TypeID
inner join dbo.Variety v
on w.VarietyID = v.VarietyID





/*   
35. Using the new tables and JOINs to show the name, type and value rating for wines cheaper than $7.
*/

select
	w.WineName,
	t.Type,
	w.ValueRating
from dbo.Wine w
inner join dbo.Type t
on w.TypeID = t.TypeID
where w.Cost < 7




/*
36. Using the new tables and JOINs to answer the following question:
	Display the number of wines, highest and lowest cost, and average overall rating 
	for each type and variety of wines. Sort the output by type and variety in ascending orders.
*/

select 
	t.Type,
	v.Variety,
	count(distinct w.WineName) as number_of_wines,
	max(w.Cost) as highest_cost,
	min(w.Cost) as lowest_cost,
	avg(w.OverallRating) as avg_overall_rating
from dbo.Wine w
inner join dbo.Type t
on w.TypeID = t.TypeID
inner join dbo.Variety v
on w.VarietyID = v.VarietyID
group by t.Type, v.Variety
order by t.Type, v.Variety




/*
37. Using the new tables and JOINs to answer the following question:
	List the number of wines and the number of varieties in each store.
*/

select
	s.Store,
	count(distinct w.WineName) as number_of_wines,
	count(distinct v.Variety) as number_of_varieties
from dbo.Wine w
inner join dbo.Store s
on w.StoreID = s.StoreID
inner join dbo.Variety v
on w.VarietyID = v.VarietyID
group by s.Store


/*
38. Using the new tables, JOINs and subqueries to answer the following question:
    List the stores where the average TasteRating of wines is greater than the average TasteRating of all wines.
*/


select 
	s.Store
from dbo.Wine w
inner join dbo.Store s
on w.StoreID = s.StoreID
group by s.Store
having avg(w.TasteRating) > (select avg(TasteRating) as avg_taste_rating from dbo.Wine)



/*
39. Using the dbo.Wine table and CASE to answer the following question:
  	Bucket the Cost of wines into these buckets: 
	Cost < 5.00							"01. Lower than $5" 
	Cost >= 5.00 and Cost <= 9.99		"02. Between $5-$10"
	Cost>= 10.00						"03. Higher than $10"
	Display the average Cost and average Overall Rating for each bucket, order by the Cost bucket.
*/

select
	case 
		when Cost < 5.00 then '01. Lower than $5'
		when Cost >= 5.00 and Cost <= 9.99 then '02. Between $5-$10'
		when Cost >= 10.00 then '03. Higher than $10'
	end as cost_bucket,
	avg(Cost) as avg_cost,
	avg(OverallRating) as avg_overall_rating
from dbo.Wine
group by 
	case 
		when Cost < 5.00 then '01. Lower than $5'
		when Cost >= 5.00 and Cost <= 9.99 then '02. Between $5-$10'
		when Cost >= 10.00 then '03. Higher than $10'
	end
order by cost_bucket




/*
Bonus Question: 

List your favorite Cincinnati area restaurant and your favorite dish from there. 
Also name your favorite dish that you make or your parents/family makes. 
*/

/*
So far I like the food from Bibibop and Curritos. Both these restaurants are located at Calhoun Street. Mostly I prefer rice bowl from there.
I also like Ambar located at Ludlow Avenue.
My favorite dishes that entire family loves are butter chicken and chicken tikka masala.
*/