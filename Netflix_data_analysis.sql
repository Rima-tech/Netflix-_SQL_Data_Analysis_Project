-- data Analysis Project on Netflix Data set
CREATE DATABASE Netflix_DB;
use Netflix_DB;


--Load the data

SELECT * FROM netflix_titles ;

-- Change the table name
EXEC sp_rename 'netflix_titles', 'Netflix';

SELECT * FROM Netflix;

--No of Total Rows
SELECT COUNT (*) as total_count FROM Netflix ;

SELECT DISTINCT TYPE 
FROM Netflix ;




-- Business Problems

-- Q1  Count the Number of Movies vs TV Shows
SELECT type,
Count (*) as total_number
FROM Netflix
GROUP BY type ;


--Q2.Find the Most Common Rating for Movies and TV Shows
SELECT type, rating
FROM (
    SELECT type, rating, 
           COUNT(*) AS count_rating,
           RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS Ranking
    FROM Netflix
    GROUP BY type, rating
) AS rank_table
WHERE Ranking = 1;


-- Q3 List All Movies Released in a Specific Year (e.g., 2020)
SELECT * FROM Netflix 
WHERE release_year =2020;


-- Q4 Find the Top 5 Countries with the Most Content on Netflix

SELECT TOP 5 
    LTRIM(RTRIM(split_country.value)) AS country, 
    COUNT(*) AS total_count
FROM Netflix
CROSS APPLY STRING_SPLIT(country, ',') AS split_country
WHERE country IS NOT NULL
GROUP BY LTRIM(RTRIM(split_country.value))
ORDER BY total_count DESC;


-- Q5 (a) Find Out  the  Longest Movie
SELECT * 
FROM Netflix
WHERE 
type='Movie'
AND
duration=(SELECT MAX(duration) FROM Netflix);




-- Q5 (b) Find out the TV show with largest seasons

WITH TV_Seasons AS(
               SELECT *,
               CAST(LEFT(duration, CHARINDEX(' ',duration)-1) as INT) as Season_Count
               FROM Netflix
               WHERE Type='TV Show')

SELECT * 
FROM TV_Seasons
WHERE  Season_Count= (SELECT MAX(Season_Count) FROM TV_Seasons);


-- Q6 Find Content Added in the Last 5 Years
SELECT *
FROM Netflix
WHERE date_added IS NOT NULL
AND
TRY_CAST(date_added as DATE)>= DATEADD(year, -5, GETdate());

-- Q7 Find TVShows Added in last 3 years
SELECT *
FROM Netflix
WHERE date_added IS NOT NULL
AND
type='TV Show'
AND
TRY_CAST(date_added as DATE)>= DATEADD(year, -5, GETdate());

-- Q 8 Find All Movies/TV Shows by Specific Director Name( eg. Brett Haley)
SELECT * 
FROM Netflix
WHERE director LIKE '%Brett Haley%';

--Q 9 List All TV Shows with More Than 5 Seasons
SELECT type,title,duration
FROM Netflix
where type='TV Show'
AND 
CAST (LEFT(duration,CHARINDEX(' ',duration)-1) as INT) =5 ;



--Q 10 Count the Number of Content Items in Each Genre

SELECT 
      LTRIM(RTRIM(split_Genre.value)) as Genre,
      COUNT(*) as total_Count
FROM Netflix
CROSS APPLY STRING_SPLIT(listed_in, ',') as split_Genre
WHERE listed_in IS NOT NULL
GROUP BY LTRIM(RTRIM(split_Genre.value)) 
ORDER BY total_count DESC


-- 11.Find the average numbers of content produced in India each Year 
 SELECT AVG(Total_yearly_content) as AVG_no_of_content_per_year
 FROM
     (SELECT release_year ,count(*) as Total_yearly_content
FROM Netflix
WHERE country LIKE '%India%'
GROUP by release_year ) as Yearly_data


--12. List All TV show that are listed as Kids' TV

SELECT * FROM Netflix
WHERE listed_in LIKE '%Kids'' TV%';


--13. Find the title , country , rating , duration,cast of the movies where Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT title, country,rating, duration ,cast
FROM Netflix 
Where cast LIKE '%Salman Khan%'
AND release_year >YEAR(GETDATE()) -10;

select * from Netflix

--14 Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT TOP 10
     LTRIM(RTRIM(split_cast.value)) as TOP_Actors,
     COUNT(*) as Total_count

FROM Netflix
CROSS APPLY STRING_SPLIT( cast , ',') as split_cast
WHERE cast is NOT NULL and country LIKE '%India%'
GROUP BY split_cast.value
ORDER BY total_count DESC ;


--15 FIND OUT the number of CRIME TV SHOWS released in 2020 
SELECT  COUNT(*) as Number_OF_CRIME_TV_SHOWS_In_2020
FROM Netflix
where listed_in like '%Crime%'

--16  Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords .

SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Negative'
        ELSE 'Positive'
    END AS content_category,
    COUNT(*) AS total_items
FROM Netflix
WHERE description IS NOT NULL
GROUP BY 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Negative'
        ELSE 'Positive'
    END;






