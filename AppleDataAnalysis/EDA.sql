--EXPLORATORY DATA ANALYSIS --

-- check number of unique apps in AppleStore--

SELECT count(DISTINCT id) AS UniqueAppIDs FROM AppleStore

SELECT count(DISTINCT ID) AS UniqueAppIDs FROM appleStore_description_combines

--check for missing values in AppleStore--

SELECT COUNT(*) AS MissingValues 
FROM AppleStore 
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL OR cont_rating IS NULL

SELECT COUNT(*) AS MissingValues 
FROM appleStore_description_combines
WHERE track_name IS NULL OR id IS NULL OR app_desc IS NULL

-- check number of apps per genre--
SELECT prime_genre, COUNT(*) AS NumApps 
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--get an overview of the apps ratings
SELECT 
MIN(user_rating) AS MinRatings,
MAX(user_rating) AS MaxRatings,
AVG(user_rating) AS AvgRatings
FROM AppleStore



--DATA ANALYSIS--

--Determine whether paid apps have higher rating than unpaid apps--
SELECT CASE
							WHEN price > 0 THEN 'Paid'
							ELSE 'Free'
					END AS App_Type,
					avg(user_rating) AS Rating
FROM AppleStore
GROUP BY App_Type
ORDER BY Rating DESC


--check if apps with more supported languages have higher ratings--
SELECT CASE
							WHEN lang_num < 10 THEN '<10 Languages'
							WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'
							ELSE  '>30 Languages'
				END AS language_Bucket,
				avg(user_rating) AS Rating							
FROM AppleStore
GROUP BY language_Bucket
ORDER BY Rating DESC


--Genres with lower ratings--
SELECT prime_genre,  avg(user_rating) AS Avg_Ratings
 FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Ratings ASC
LIMIT 10

--check if there is correlation between the length of the app description and user ratings
SELECT CASE 
							WHEN length(B.app_desc)<500 THEN 'Short'
							WHEN length(B.app_desc) BETWEEN 500 and 1000 THEN 'Medium'
							ELSE 'Long' 
				END AS  Length_app_desc,
				avg(user_rating) AS Ratings
FROM AppleStore A
JOIN
 appleStore_description_combines B
ON A.id = B.id
GROUP BY Length_app_desc
ORDER BY Ratings DESC

--- check top rated apps by genre--
SELECT 
	prime_genre, 
	track_name,  
	user_rating
 FROM 
(
		SELECT 
		prime_genre, 
		track_name,  
		user_rating,
		RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
		FROM 
		AppleStore
 )  AS  a
 WHERE
 a.rank = 1


