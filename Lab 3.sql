RETURN;

--Homework #4a Querying Multiple Tables
--Your Name:

/*--------------------------------------------------------------------------------------
Instructions:

If you haven't done so in class, please download and run the entire syntax in the MovieDatabase.sql file to establish a Movies database.
Answer the following questions as best as possible.
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/

USE Movies;

/*Q1. (1 point)
List Film Name, Director Name, Studio Name, and Country Name of all films.*/

/*Q1. Syntax*/

select distinct
	film.FilmName, 
	dir.DirectorName, 
	stud.StudioName, 
	country.CountryName
from dbo.tblFilm film
left join dbo.tblDirector dir
on film.FilmDirectorID = dir.DirectorID
left join dbo.tblStudio stud
on film.FilmStudioID = stud.StudioID
left join dbo.tblCountry country
on film.FilmCountryID =  country.CountryID


/*Q2. (1 point)
List people who have been actors but not directors.*/

/*Q2. Syntax*/

select distinct act.ActorName
from dbo.tblFilm film
left join dbo.tblCast cst
on film.FilmID = cst.CastFilmID
left join dbo.tblActor act
on cst.CastActorID = act.ActorID
where act.ActorName not in 
				(select distinct DirectorName from dbo.tblDirector)


/*Q3. (1 point)
List actors that have never been directors and directors that have never been actors.*/

/*Q3. Syntax*/

-- actors that have never been directors
select distinct ActorName as Name
from dbo.tblActor
where ActorName not in 
				(select distinct DirectorName from dbo.tblDirector)

union all

-- directors that have never been actors
select distinct DirectorName as Name
from dbo.tblDirector
where DirectorName not in 
				(select distinct ActorName from dbo.tblActor)



/*Q4. (1 point)
List all films that are released in the same year when the film Casino is released.*/

/*Q4. Syntax*/

-- select * from tblFilm

select FilmName
from tblFilm 
where datepart(year, FilmReleaseDate) in
								(select datepart(year, FilmReleaseDate)
								from tblFilm
								where FilmName = 'Casino')



/*Q5. (1 point)
Using JOIN to list films whose directors were born between '1946-01-01' AND '1946-12-31'. */

/*Q5. Syntax*/

select FilmName
from dbo.tblFilm film
left join dbo.tblDirector dir
on film.FilmDirectorID = dir.DirectorID
where convert(date, DirectorDOB) between '1946-01-01' and '1946-12-31'



/*Q6. (1 point)
Using subquery to list films whose directors were born between '1946-01-01' AND '1946-12-31'. */

/*Q6. Syntax*/

select FilmName
from dbo.tblFilm
where FilmDirectorID in	(
						select DirectorID from dbo.tblDirector
						where convert(date, DirectorDOB) between '1946-01-01' and '1946-12-31'
						)

