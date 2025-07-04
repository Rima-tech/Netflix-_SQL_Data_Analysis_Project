# Netflix Movies and TV Shows Analysis Project using SQL
![Netflix_logo](https://github.com/Rima-tech/Netflix-_SQL_Data_Analysis_Project/blob/d09ccdfda05b85c29e53545274b5da0a95f1f02c/logo.png)

## OVERVIEW
This project involves analyzing the Netflix Movies and TV Shows dataset from Kaggle using SQL queries to extract meaningful insights . The dataset contains detailed information about movies and TV shows, including titles, directors, cast, countries, release years, ratings, durations, and genres. By addressing 16 business-related queries, this project uncovers trends, patterns, and key metrics about Netflix’s content distribution, genres, and production details.

### OBJECTIVE
The primary objective of this project is to leverage SQL to perform exploratory data analysis on the Netflix dataset, answering specific business questions to gain insights into content trends and characteristics. The queries aim to:
-Analyze the distribution of movies versus TV shows.
-Identify key metrics such as common ratings, top content-producing countries, and longest-running movies or TV shows.
-Filter content based on specific criteria like release year, director, actor, or genre.
-Explore and categorize content based on specific criteria and keywords.

### Dataset-
The data for this project is sourced from the Kaggle dataset.
Link - https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

### Business Problems and Solutions

-- Q1  Count the Number of Movies vs TV Shows
```sql
SELECT type,
Count (*) as total_number
FROM Netflix
GROUP BY type ;
```
![Output1][]
--Q2.Find the Most Common Rating for Movies and TV Shows
```sql
SELECT type, rating
FROM (
    SELECT type, rating, 
           COUNT(*) AS count_rating,
           RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS Ranking
    FROM Netflix
    GROUP BY type, rating
) AS rank_table
WHERE Ranking = 1;
```
-- Q3 List All Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT * FROM Netflix 
WHERE release_year =2020;
```
-- Q4 Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT TOP 5 
    LTRIM(RTRIM(split_country.value)) AS country, 
    COUNT(*) AS total_count
FROM Netflix
CROSS APPLY STRING_SPLIT(country, ',') AS split_country
WHERE country IS NOT NULL
GROUP BY LTRIM(RTRIM(split_country.value))
ORDER BY total_count DESC;
```
-- Q5 (a) Find Out  the  Longest Movie
```sql
SELECT * 
FROM Netflix
WHERE 
type='Movie'
AND
duration=(SELECT MAX(duration) FROM Netflix);
```
-- Q5 (b) Find out the TV show with largest seasons
```sql
WITH TV_Seasons AS(
               SELECT *,
               CAST(LEFT(duration, CHARINDEX(' ',duration)-1) as INT) as Season_Count
               FROM Netflix
               WHERE Type='TV Show')

SELECT * 
FROM TV_Seasons
WHERE  Season_Count= (SELECT MAX(Season_Count) FROM TV_Seasons);


```
-- Q6 Find Content Added in the Last 5 Years
```sql
SELECT *
FROM Netflix
WHERE date_added IS NOT NULL
AND
TRY_CAST(date_added as DATE)>= DATEADD(year, -5, GETdate());
```
-- Q7 Find TVShows Added in last 3 years
```sql
SELECT *
FROM Netflix
WHERE date_added IS NOT NULL
AND
type='TV Show'
AND
TRY_CAST(date_added as DATE)>= DATEADD(year, -5, GETdate());
```
-- Q 8 Find All Movies/TV Shows by Specific Director Name( eg. Brett Haley)
```sql
SELECT * 
FROM Netflix
WHERE director LIKE '%Brett Haley%';

```
--Q 9 List All TV Shows with More Than 5 Seasons
```sql
SELECT type,title,duration
FROM Netflix
where type='TV Show'
AND 
CAST (LEFT(duration,CHARINDEX(' ',duration)-1) as INT) =5 ;
```
--Q 10 Count the Number of Content Items in Each Genre
```sql
SELECT 
      LTRIM(RTRIM(split_Genre.value)) as Genre,
      COUNT(*) as total_Count
FROM Netflix
CROSS APPLY STRING_SPLIT(listed_in, ',') as split_Genre
WHERE listed_in IS NOT NULL
GROUP BY LTRIM(RTRIM(split_Genre.value)) 
ORDER BY total_count DESC
```
-- Q 11.Find the average numbers of content produced in India each Year
```sql
 SELECT AVG(Total_yearly_content) as AVG_no_of_content_per_year
 FROM
     (SELECT release_year ,count(*) as Total_yearly_content
FROM Netflix
WHERE country LIKE '%India%'
GROUP by release_year ) as Yearly_data
```
--Q 12. List All TV show that are listed as Kids' TV
```sql

SELECT * FROM Netflix
WHERE listed_in LIKE '%Kids'' TV%';
```
--Q 13. Find the title , country , rating , duration,cast of the movies where Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT title, country,rating, duration ,cast
FROM Netflix 
Where cast LIKE '%Salman Khan%'
AND release_year >YEAR(GETDATE()) -10;
```
--Q 14 Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
SELECT TOP 10
     LTRIM(RTRIM(split_cast.value)) as TOP_Actors,
     COUNT(*) as Total_count

FROM Netflix
CROSS APPLY STRING_SPLIT( cast , ',') as split_cast
WHERE cast is NOT NULL and country LIKE '%India%'
GROUP BY split_cast.value
ORDER BY total_count DESC ;
```
--Q 15 FIND OUT the number of CRIME TV SHOWS released in 2020
```sql
SELECT  COUNT(*) as Number_OF_CRIME_TV_SHOWS_In_2020
FROM Netflix
where listed_in like '%Crime%'

```
--Q 16  Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords .
```sql
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

```
### Business Implication
This project offers meaningful insights into Netflix’s global content library, helping businesses understand content trends, regional preferences, and thematic patterns:

-Movies dominate Netflix’s catalog, accounting for over 69% of all content, indicating the platform's focus on standalone viewing experiences.

-TV-MA is the most common rating for both Movies and TV Shows, showing Netflix’s strong emphasis on mature, adult-oriented content.

-The United States leads content production, followed by India and the UK — suggesting Netflix's strategic investment in English-speaking regions and emerging markets like India.

-India contributes an average of 18 titles per year, making it a consistent content hub, particularly for regional and Bollywood content.


-Anupam Kher, Om Puri, and Shah Rukh Khan are among the most featured Indian actors, reinforcing their bankability and audience appeal.

-Majority of content is categorized as 'Positive' (8465 items) with only a small portion (342) containing violent or disturbing themes, reflecting a broadly family-friendly positioning.

These findings provide valuable direction for content strategists, marketers, and production planners aiming to align with audience preferences, regional growth opportunities, and genre diversification strategies.


### Tool Used - Microsoft SQL Server Management Studio (SSMS)
