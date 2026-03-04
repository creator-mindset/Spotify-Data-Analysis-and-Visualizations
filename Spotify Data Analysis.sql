CREATE DATABASE spotify_db
SELECT * FROM  spotify


SELECT COUNT(*) FROM spotify
SELECT COUNT(DISTINCT artist) FROM spotify
SELECT COUNT(DISTINCT album) FROM spotify
SELECT DISTINCT album_type FROM spotify
SELECT duration_min FROM spotify
SELECT MIN(duration_min) FROM spotify
SELECT MAX(duration_min) FROM spotify

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0
SELECT * FROM spotify
WHERE duration_min = 0
SELECT DISTINCT channel FROM spotify
SELECT DISTINCT most_playedon AS most_played_on FROM spotify
-- Retrieve the names of all tracks that have more than 1 billion streams
SELECT * FROM spotify
WHERE Stream > 1000000000
-- List all albums along with their respective artists
SELECT Album,Artist FROM spotify
ORDER BY 1
SELECT DISTINCT album FROM spotify ORDER BY 1
-- Get the total number of comments for tracks where licensed = TRUE
SELECT comments,Licensed FROM spotify
WHERE Licensed = 'TRUE'
SELECT SUM(comments) AS total_comments FROM spotify
WHERE Licensed = 'TRUE'
-- Find all tracks that belong to the album type single.
SELECT * FROM spotify
WHERE  Album_type = 'single'
-- Count the total number of tracks by each artist.
SELECT artist,COUNT(*) as total_no_songs FROM spotify
GROUP BY artist
ORDER BY 2
-- Calculate the average danceability of tracks in each album.
SELECT Album,avg(Danceability) as average_dancability FROM spotify
GROUP BY 1
ORDER BY 2 DESC
-- Find the top 5 tracks with the highest energy values
SELECT track, MAX(Energy)FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- List all tracks along wtih their views and likes where official_video = TRUE
SELECT 
    Track,
    SUM(Views) AS Total_views,
    SUM(Likes) AS Total_likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY Track
ORDER BY Total_views DESC
LIMIT 5;

-- For each album,calculate the total views of all associated tracks
SELECT Album,SUM(Views) AS Total_views FROM spotify
GROUP BY Album
ORDER BY Total_views DESC

-- Retrieve the track names that have been streamed on Spotify more than YouTube
SELECT * FROM 
(SELECT 
    track,
    COALESCE(SUM(CASE WHEN most_playedon='Youtube' THEN stream END),0) AS streamed_on_youtube,
    COALESCE(SUM(CASE WHEN most_playedon='Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY 1
) AS t1
    WHERE
        streamed_on_youtube < streamed_on_spotify
        AND
        streamed_on_youtube <> 0 
-- Find the top 3 most-viewed tracks for each artist using window functions.
SELECT *
FROM (
    SELECT
        Artist,
        Track,
        SUM(Views) AS total_views,
        DENSE_RANK() OVER (
            PARTITION BY Artist
            ORDER BY SUM(Views) DESC
        ) AS rank_no
    FROM spotify
    GROUP BY Artist, Track
) t
WHERE rank_no <= 3
ORDER BY Artist, total_views DESC;
-- Write a query to find tracks where the liveness score is above the average.

SELECT 
Track,
Artist,
Liveness
 FROM spotify
WHERE liveness > (SELECT AVG(Liveness) FROM spotify)

SELECT AVG(Liveness) FROM spotify

-- Use a WITH clause to calculate the difference between
-- the highest and lowest energy values for tracks in each
-- album

WITH cte
AS(
SELECT
album,
MAX(energy) AS highest_energy,
MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1
) 
SELECT 
album,
highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC

-- Query Optimization
EXPLAIN ANALYZE
SELECT
 Artist,
 Track,
 Views
FROM spotify
WHERE Artist = 'Gorillaz'
AND
most_playedon='Youtube'
ORDER BY stream DESC LIMIT 25