-- Players whose spring 2023 Glicko score increased compared to a year ago
CREATE TABLE spring2023_vs_spring2022 AS (
SELECT s2023.player,
	s2023.rank AS spring_2023_rank,
	s2023.points AS spring_2023_points, 
	f2022.rank AS fall_2022_rank, 
	f2022.points AS fall_2022_points
FROM spring_2023_ranking AS s2023
	INNER JOIN fall_2022_ranking AS f2022
	ON (f2022.player = s2023.player)
	WHERE (s2023.points > f2022.points)
);

-- Players whose spring 2023 Glicko score increased compared to the previous semester
-- (fall 2022)
CREATE TABLE spring2023_vs_fall_2022 AS (
SELECT s2023.player, 
	s2023.rank AS spring_2023_rank,
	s2023.points AS spring_2023_points,
	s2022.rank AS spring_2022_rank,
	s2022.points AS spring_2022_points
FROM spring_2023_ranking AS s2023
	INNER JOIN spring_2022_ranking AS s2022
	ON (s2022.player = s2023.player)
	WHERE (s2023.points > s2022.points)
);
	
-- Players who were active in both the very first and very latest semesters
CREATE TABLE active_since_beginning AS (
SELECT s2023.player
FROM spring_2023_ranking AS s2023
	INNER JOIN spring_2019_ranking AS s2019
	ON (s2019.player = s2023.player)
);
	
-- Creating a new table combining rankings for every semester
CREATE TABLE all_rankings AS (
	SELECT "player", "rank", "points", 'Spring 2019' AS semester FROM spring_2019_ranking
    UNION ALL
    SELECT "player", "rank", "points", 'Fall 2019' AS semester FROM fall_2019_ranking
    UNION ALL
    SELECT "player", "rank", "points", 'Spring 2020' AS semester FROM spring_2020_ranking
    UNION ALL
    SELECT "player", "rank", "points", 'Fall 2021' AS semester FROM fall_2021_ranking
	UNION ALL
    SELECT "player", "rank", "points", 'Spring 2022' AS semester FROM spring_2022_ranking
	UNION ALL
    SELECT "player", "rank", "points", 'Fall 2022' AS semester FROM fall_2022_ranking
	UNION ALL
    SELECT "player", "rank", "points", 'Spring 2023' AS semester FROM spring_2023_ranking
);

-- Players whose Glicko score has ever exceeded 1900 points,
-- ordered from highest to lowest peak score
CREATE TABLE glicko_above_1900 AS (
	SELECT "player", semester, "rank", "points"
	FROM all_rankings
	WHERE "points" > 1900
	ORDER BY "points" DESC, semester
);

-- Peak Glicko scores for every player, ordered from highest to lowest
CREATE TABLE peak_glicko_scores AS (
	
WITH Ranked AS (
    SELECT "player", semester, "rank", "points" AS peak_points,
           ROW_NUMBER() OVER (PARTITION BY "player" ORDER BY "points" DESC) AS rn
    FROM all_rankings
)

SELECT "player", semester, "rank", peak_points
FROM Ranked
WHERE rn = 1
ORDER BY peak_points DESC);

-- Peak rank for every player, ordered from highest to lowest
CREATE TABLE peak_ranks AS (
	
WITH Ranked AS (
    SELECT "player", semester, "rank" AS peak_rank, "points",
           ROW_NUMBER() OVER (PARTITION BY "player" ORDER BY "rank") AS rn
    FROM all_rankings
)

SELECT "player", semester, peak_rank, "points"
FROM Ranked
WHERE rn = 1
ORDER BY peak_rank);

-- Every player that reached their peak Glicko score in spring 2023
CREATE TABLE peaked_in_spring2023 AS (
SELECT "player", "rank", "peak_points"
FROM peak_glicko_scores
WHERE semester = 'Spring 2023');

-- Every player that reached their peak Glicko score at the beginning of the game
CREATE TABLE peaked_in_spring2019 AS (
SELECT "player", "rank", "peak_points"
FROM peak_glicko_scores
WHERE semester = 'Spring 2019');

-- Every player that reached their peak Glicko score pre-quarantine
CREATE TABLE peaked_pre_quarantine AS (
SELECT "player", semester, "rank", "peak_points"
FROM peak_glicko_scores
WHERE semester = 'Spring 2019' OR semester = 'Fall 2019' OR semester = 'Spring 2020');

-- Every player that reached their peak Glicko score post-quarantine
CREATE TABLE peaked_post_quarantine AS (
SELECT "player", semester, "rank", "peak_points"
FROM peak_glicko_scores
WHERE semester = 'Fall 2021' OR semester = 'Spring 2022' OR semester = 'Fall 2022' OR semester = 'Spring 2023');

-- Every player who has ever been ranked in the top 10
CREATE TABLE ever_ranked_top10 AS (
SELECT "player", semester, "rank", "points"
FROM all_rankings
WHERE "rank" <= 10
ORDER BY "player", "semester");

-- Every player who hit their peak rank post-quarantine
CREATE TABLE peak_rank_post_quarantine AS (
SELECT "player", semester, "peak_rank", "points"
FROM peak_ranks
WHERE semester = 'Fall 2021' OR semester = 'Spring 2022' OR semester = 'Fall 2022' OR semester = 'Spring 2023');

-- Players who hit their peak score AND rank pre-quarantine
CREATE TABLE peak_score_and_rank_pre_quarantine AS (
SELECT pg.player, pr.peak_rank, pg.peak_points, pr.semester AS peak_rank_semester, pg.semester AS peak_points_semester
FROM peak_glicko_scores AS pg
	INNER JOIN peak_ranks AS pr
	ON (pg.player = pr.player)
WHERE (pg.semester = 'Spring 2019' OR pg.semester = 'Fall 2019' OR pg.semester = 'Spring 2020') 
ORDER BY pr.peak_rank);

-- Players who hit their peak score AND rank post-quarantine
CREATE TABLE peak_score_and_rank_post_quarantine AS (
SELECT pg.player, pr.peak_rank, pg.peak_points, pr.semester AS peak_rank_semester, pg.semester AS peak_points_semester 
FROM peak_glicko_scores AS pg
	INNER JOIN peak_ranks AS pr
	ON (pg.player = pr.player)
WHERE (pg.semester = 'Fall 2021' OR pg.semester = 'Spring 2022' OR pg.semester = 'Fall 2022' OR pg.semester = 'Spring 2023') 
ORDER BY pr.peak_rank);

-- A full table of every players' peak scores and ranks, and when they earned them
CREATE TABLE peak_scores_and_ranks AS (
SELECT pg.player, pr.peak_rank, pg.peak_points, pr.semester AS peak_rank_semester, pg.semester AS peak_points_semester 
FROM peak_glicko_scores AS pg
	INNER JOIN peak_ranks AS pr
	ON (pg.player = pr.player)
);

-- All players who had their peak Glicko score and rank in the same semester
CREATE TABLE peak_score_rank_same_semester AS (
SELECT "player", "peak_rank", "peak_points", "peak_rank_semester" AS "semester"
FROM peak_scores_and_ranks
WHERE "peak_rank_semester" = "peak_points_semester");