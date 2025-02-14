/*******************************************
1) Finding the top 10 drivers of all-time 
   by wins and championships
*******************************************/

-- joining drivers, driver standings, results, races and circuits TABLE  
-- to take a look at how the driver standing positions are recorded 
-- by looking at a specifc year and driver's name

SELECT 
	rac.`year`, rac.`round`, rac.`name`,
	d.driverRef, CONCAT(d.forename, ' ', d.surname) AS drivers_name,
	ds.points AS accum_points, ds.wins AS accum_wins, ds.`position`
FROM results_clean AS res
INNER JOIN races AS rac
ON res.raceId = rac.raceId
INNER JOIN drivers AS d
ON res.driverId = d.driverId
INNER JOIN driver_standings AS ds
ON res.raceId = ds.raceId AND res.driverId = ds.driverId
WHERE rac.`year` = '2008' AND (d.driverRef = 'hamilton')

-- To obtain the driver standings position per season, we 
-- partition the table by driver and record their position 
-- in the final round
SELECT 
	rac.`year`, rac.`round`, rac.`name`,
	d.driverRef, CONCAT(d.forename, ' ', d.surname) AS drivers_name,
	ds.points AS accum_points, ds.wins AS accum_wins,
	FIRST_VALUE(ds.`position`) 
		OVER (PARTITION BY d.driverRef, rac.`year` ORDER BY rac.`round` DESC) AS final_ds_position	
FROM results_clean AS res
INNER JOIN races AS rac
ON res.raceId = rac.raceId
INNER JOIN drivers AS d
ON res.driverId = d.driverId
INNER JOIN driver_standings AS ds
ON res.raceId = ds.raceId AND res.driverId = ds.driverId
ORDER BY rac.`year` DESC
LIMIT 10;


-- Now we create a temporary table from the table we previous selected
DROP TEMPORARY TABLE IF EXISTS temp_driver_standing_summary;
CREATE TEMPORARY TABLE temp_driver_standing_summary AS  
(	
	SELECT 
		rac.`year`, rac.`round`, rac.`name`,
		d.driverRef, CONCAT(d.forename, ' ', d.surname) AS drivers_name,
		ds.points AS accum_points, ds.wins AS accum_wins,
		FIRST_VALUE(ds.`position`) 
			OVER (PARTITION BY d.driverRef, rac.`year` ORDER BY rac.`round` DESC) AS final_ds_position	
	FROM results_clean AS res
	INNER JOIN races AS rac
	ON res.raceId = rac.raceId
	INNER JOIN drivers AS d
	ON res.driverId = d.driverId
	INNER JOIN driver_standings AS ds
	ON res.raceId = ds.raceId AND res.driverId = ds.driverId
); 

# Calculate driver's overall career total points and wins (subquery 1)
SELECT sub_ds1.driverRef, SUM(sub_ds1.accum_points) AS total_points, SUM(sub_ds1.accum_wins) AS total_wins
FROM 
(
	SELECT `year`, driverRef, MAX(accum_points) AS accum_points, MAX(accum_wins) AS accum_wins
	FROM temp_driver_standing_summary 
	GROUP BY driverREF, `year`
) AS sub_ds1
GROUP BY sub_ds1.driverRef
ORDER BY total_wins DESC
LIMIT 10;

# Find the driver's that win the drivers championship per season
SELECT `year`, driverRef, accum_points, final_ds_position
FROM temp_driver_standing_summary
GROUP BY driverREF, `year`
HAVING MAX(final_ds_position) = 1
LIMIT 10;


# Calculate the driver's overall career championship wins (subquery 2)
SELECT sub_ds2.driverRef, COUNT(*) AS nof_championships
FROM 
(
	SELECT `year`, driverRef, accum_points
	FROM temp_driver_standing_summary
	GROUP BY driverREF, `year`
	HAVING MAX(final_ds_position) = 1
) AS sub_ds2
GROUP BY sub_ds2.driverRef
LIMIT 10;

# Combine subqueries to get the top 10 drivers of all-time 
# by wins and championships
SELECT 
	ROW_NUMBER() OVER (ORDER BY total_wins DESC) AS ranking,
	sub_ds1_2.drivers_name, sub_ds1_2.total_points, 
	sub_ds1_2.total_wins, sub_ds2_2.nof_championships
FROM
( 
	SELECT sub_ds1_1.drivers_name, SUM(sub_ds1_1.accum_points) AS total_points, SUM(sub_ds1_1.accum_wins) AS total_wins
	FROM 
	(
		SELECT `year`, drivers_name, MAX(accum_points) AS accum_points, MAX(accum_wins) AS accum_wins
		FROM temp_driver_standing_summary 
		GROUP BY drivers_name, `year`
	) AS sub_ds1_1
	GROUP BY sub_ds1_1.drivers_name
) AS sub_ds1_2
INNER JOIN 
(
	SELECT sub_ds2_1.drivers_name, COUNT(*) AS nof_championships
	FROM 
	(
		SELECT `year`, drivers_name, accum_points
		FROM temp_driver_standing_summary
		GROUP BY drivers_name, `year`
		HAVING MAX(final_ds_position) = 1
	) AS sub_ds2_1
	GROUP BY sub_ds2_1.drivers_name
) AS sub_ds2_2
ON sub_ds1_2.drivers_name = sub_ds2_2.drivers_name
ORDER BY total_wins DESC
LIMIT 10;

/*******************************************

	2) Find drivers ranking performances 
	over the years
	
*******************************************/
WITH driver_rankings AS (
	SELECT 
		c.location, c.country,
		rac.`year`, rac.`round`, rac.`name`,
		CONCAT(d.forename, ' ', d.surname) AS drivers_name,
		ds.points AS accum_points, ds.`position` AS ds_position, ds.wins AS accum_wins,
		FIRST_VALUE(ds.`position`) 
			OVER (PARTITION BY d.driverRef, rac.`year` ORDER BY rac.`round` DESC) AS final_ds_position	
	FROM results_clean AS res
	INNER JOIN races AS rac
	ON res.raceId = rac.raceId
	INNER JOIN drivers AS d
	ON res.driverId = d.driverId
	INNER JOIN driver_standings AS ds
	ON res.raceId = ds.raceId AND res.driverId = ds.driverId
	INNER JOIN circuits AS c
	ON rac.circuitId = c.circuitId
)

SELECT 
	`year`, drivers_name, 
	CAST(AVG(final_ds_position) AS INT) AS final_position_each_yr
FROM driver_rankings
GROUP BY drivers_name, `year`
ORDER BY  drivers_name, `year`

/*******************************************

	3) Find the Top 10 constructor by 
	constructors championship
	
*******************************************/
-- Group by constructor ref and year to get the max points for each season
SELECT 
	c.constructorRef, 
	r.`year`, 
	MAX(cs.points) AS total_points, MAX(cs.wins) AS total_wins
FROM constructor_standings AS cs
INNER JOIN races AS r
ON cs.raceId = r.raceId
INNER JOIN constructors AS c
ON cs.constructorId = c.constructorId
GROUP BY c.constructorRef, r.`year`
LIMIT 10;


-- Find the constructors name that is the world champion for every season
-- based on the max points and total wins for the season
SELECT r.`year`, c.`name`, cs.points, cs.wins
FROM constructor_standings AS cs
INNER JOIN races AS r
ON cs.raceId = r.raceId
INNER JOIN constructors AS c
ON cs.constructorId = c.constructorId
WHERE (r.`year`, cs.points) IN
(
	-- Subquery: Group by constructor ref and year to get the max points for each season
	SELECT
		r.year, 
		MAX(cs.points) AS total_points 
	FROM constructor_standings AS cs
	INNER JOIN races AS r
	ON cs.raceId = r.raceId
	INNER JOIN constructors AS c
	ON cs.constructorId = c.constructorId
	GROUP BY r.`year`
)
LIMIT 10;

-- Lotus has changed variations of their team names over the years from lotus ford, lotus climax and team lotus,
-- Therefore, the names are changed to be just lotus so that the number of championship wins can be correctly
-- calculated.
WITH constructors_clean AS (
	SELECT
		constructorId, constructorRef, `name`, nationality, `url`, 
		REPLACE(REPLACE(REPLACE(`name`, 'Team Lotus', 'Lotus'), 'Lotus-Climax', 'Lotus'), 'Lotus-Ford', 'Lotus') AS team_name
	FROM constructors
)

SELECT
	ROW_NUMBER() OVER(ORDER BY total_championships DESC) AS ranking, 
	c.team_name, COUNT(DISTINCT(r.`year`)) AS total_championships
FROM constructor_standings AS cs
INNER JOIN races AS r
ON cs.raceId = r.raceId
INNER JOIN constructors_clean AS c
ON cs.constructorId = c.constructorId
WHERE (r.`year`, cs.points) IN
(
	SELECT
		r.year, 
		MAX(cs.points) AS total_points 
	FROM constructor_standings AS cs
	INNER JOIN races AS r
	ON cs.raceId = r.raceId
	INNER JOIN constructors_clean AS c
	ON cs.constructorId = c.constructorId
	GROUP BY r.`year`
)
GROUP BY c.team_name
ORDER BY total_championships DESC
LIMIT 10;


/*******************************************

	4) Find each circuit fastest 
	lap time 
	
*******************************************/
SELECT 
	rac.`name`,
	cir.location, cir.country, cir.lat, cir.lng, cir.alt,
	CONCAT(d.forename, ' ', d.surname) AS drivers_name,
	cons.`name` AS team_name,
	res.fastestLapTime, res.fastestLapTime_msec
FROM results_clean AS res
INNER JOIN races AS rac
ON res.raceId = rac.raceId
INNER JOIN drivers AS d
ON res.driverId = d.driverId
INNER JOIN constructors AS cons
ON res.constructorId = cons.constructorId
INNER JOIN circuits AS cir
ON rac.circuitID = cir.circuitId
WHERE (rac.`name`, cir.location, cir.country, res.fastestLapTime_msec) IN
(
	SELECT 	
		rac.`name`, 
		cir.location, cir.country,
		MIN(res.fastestLapTime_msec) AS fastest_lap_time
	FROM results_clean AS res
	INNER JOIN races AS rac
	ON res.raceId = rac.raceId
	INNER JOIN drivers AS d
	ON res.driverId = d.driverId
	INNER JOIN circuits AS cir
	ON rac.circuitID = cir.circuitId
	GROUP BY rac.`name`, cir.location, cir.country
)
ORDER BY rac.`name`	


