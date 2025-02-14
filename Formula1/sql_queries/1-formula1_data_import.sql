
/* Create Formula 1 database */

-- Create database
DROP DATABASE IF EXISTS formula1;
CREATE DATABASE formula1;
USE formula1;

-- Create circuits table
DROP TABLE IF EXISTS circuits;
CREATE TABLE circuits (
	circuitId INT UNSIGNED NOT NULL PRIMARY KEY,
	circuitRef VARCHAR(255),
   	name VARCHAR(255),
	location VARCHAR(255),
	country VARCHAR(255),
	lat FLOAT	
	lng FLOAT,
	alt INT,
	URL VARCHAR(255)
);

-- CREATE races table
DROP TABLE IF EXISTS races;
CREATE TABLE races (
	raceId INT UNSIGNED NOT NULL PRIMARY KEY,
	year YEAR,
	round TINYINT,
	circuitId INT UNSIGNED NOT NULL,
	name VARCHAR(32),
	date DATE,
	time TIME,
	URL VARCHAR(255),
	fp1_date DATE,
	fp1_time TIME,
	fp2_date DATE,
	fp2_time TIME,
	fp3_date DATE,
	fp3_time TIME,
	quali_date DATE,
	quali_time TIME,
	sprint_date DATE,
	sprint_time TIME,
	FOREIGN KEY (circuitId) REFERENCES circuits(circuitId)
);

-- Create constructors table
DROP TABLE IF EXISTS constructors;
CREATE TABLE constructors (
	constructorId INT UNSIGNED NOT NULL PRIMARY KEY,
	constructorRef VARCHAR(255),
	name VARCHAR(255),
	nationality VARCHAR(32),
	url VARCHAR(255)
);

-- Create constructor_results table
DROP TABLE IF EXISTS constructor_results;
CREATE TABLE constructor_results (
	constructorResultsId INT UNSIGNED NOT NULL PRIMARY KEY,
	raceId INT UNSIGNED NOT NULL,
	constructorId INT UNSIGNED NOT NULL,
	FOREIGN KEY (raceId) REFERENCES races (raceId),
	FOREIGN KEY (constructorId) REFERENCES constructors (constructorId),
	points INT,
	status VARCHAR(5)
);

-- Create constructor_standings table
DROP TABLE IF EXISTS constructor_standings;
CREATE TABLE constructor_standings (
	constructorStandingsId INT UNSIGNED NOT NULL PRIMARY KEY,
	raceId INT UNSIGNED NOT NULL,
	constructorId INT UNSIGNED NOT NULL,
	FOREIGN KEY (raceId) REFERENCES races (raceId),
	FOREIGN KEY (constructorId) REFERENCES constructors (constructorId),
	points INT,
	position TINYINT UNSIGNED,
	positionText VARCHAR(8),
	wins INT
);

-- Create drivers table
DROP TABLE IF EXISTS drivers;
CREATE TABLE drivers (
	driverId INT UNSIGNED NOT NULL PRIMARY KEY,
	driverRef VARCHAR(64),
	number INT,
	code VARCHAR(5),
	forename VARCHAR(64),
	surname  VARCHAR(64),
	dob DATE,
	nationality VARCHAR(64),
	URL VARCHAR(255)
);

-- Create driver_standings table
DROP TABLE IF EXISTS driver_standings;
CREATE TABLE driver_standings (
	driverStandingsId INT UNSIGNED NOT NULL PRIMARY KEY,
	raceId INT UNSIGNED NOT NULL, 
	driverId INT UNSIGNED NOT NULL,
	points INT,
	position TINYINT UNSIGNED,
	positionText VARCHAR(8),
	wins INT,
	FOREIGN KEY (raceId) REFERENCES races(raceId),
	FOREIGN KEY (driverId) REFERENCES drivers(driverId)
);

-- Create lap_times table
DROP TABLE IF EXISTS lap_times; 
CREATE TABLE lap_times (
	raceId INT UNSIGNED NOT NULL,
	driverId INT UNSIGNED NOT NULL,
	lap TINYINT UNSIGNED, 
	position TINYINT UNSIGNED,
	-- time TIME,
	-- Note: modify time to be a string as there is
	-- a formatting error with some of the inputs 
	time VARCHAR(32),
	milliseconds INT UNSIGNED,
	FOREIGN KEY (raceId) REFERENCES races(raceId),
	FOREIGN KEY (driverId) REFERENCES drivers(driverId)
);

-- Create pit_stops table
DROP TABLE IF EXISTS pit_stops;
CREATE TABLE pit_stops (
	raceId INT UNSIGNED NOT NULL,
	driverId INT UNSIGNED NOT NULL,
	stop  TINYINT UNSIGNED,
	lap TINYINT UNSIGNED,
	time TIME,
	/* 
	-- duration FLOAT,
	-- Note: modify duration to be a string as there is
	-- a formatting error with some of the inputs
	*/
	duration VARCHAR(32),
	milliseconds BIGINT UNSIGNED,
	FOREIGN KEY (raceId) REFERENCES races(raceId),
	FOREIGN KEY (driverId) REFERENCES drivers(driverId)
);

-- Create qualifying table
-- Note: q2, q3 fields haves missing values and
-- is truncated to 00:00:00.
DROP TABLE IF EXISTS qualifying;
CREATE TABLE qualifying (
	qualifyId INT UNSIGNED NOT NULL PRIMARY KEY,
	raceId INT UNSIGNED NOT NULL,
	driverId INT UNSIGNED NOT NULL,
	constructorId INT UNSIGNED NOT NULL,
	number TINYINT UNSIGNED, 
	position TINYINT UNSIGNED,
	-- q1 TIME, 
	-- q2 TIME,
	-- q3 TIME,
	-- Note: modify q1, q2 & q3 to be a string as there is
	-- a formatting error with some of the inputs 
	q1 VARCHAR(32),
	q2 VARCHAR(32),
	q3 VARCHAR(32),
	FOREIGN KEY (raceId) REFERENCES races(raceId),
	FOREIGN KEY (driverId) REFERENCES drivers(driverId),
	FOREIGN KEY (constructorId) REFERENCES constructors(constructorId)
);

-- Create status table
DROP TABLE IF EXISTS status;
CREATE TABLE status (
	statusId INT UNSIGNED NOT NULL PRIMARY KEY,
	status VARCHAR(32)
); 

-- Create results table
DROP TABLE IF EXISTS results;
CREATE TABLE results (
	resultId INT UNSIGNED NOT NULL PRIMARY KEY,
	raceId INT UNSIGNED NOT NULL,
	driverId INT UNSIGNED NOT NULL,
	constructorId INT UNSIGNED NOT NULL,
	number TINYINT UNSIGNED,
	grid TINYINT UNSIGNED,
	position TINYINT UNSIGNED,
	positionText VARCHAR(8),
	positionOrder TINYINT UNSIGNED,
	points INT,
	laps TINYINT UNSIGNED,
	time VARCHAR(32),
	milliseconds INT SIGNED,
	fastestLap TINYINT UNSIGNED,
	rank TINYINT UNSIGNED,
	/*
	fastestLapTime TIME,
	-- Note: modify time to be a string as there is
	-- a formatting error with some of the inputs
	*/
	fastestLapTime VARCHAR(32),
	fastestLapSpeed FLOAT,
	statusId INT UNSIGNED NOT NULL,
	FOREIGN KEY (raceId) REFERENCES races(raceId),
	FOREIGN KEY (driverId) REFERENCES drivers(driverId),
	FOREIGN KEY (constructorId) REFERENCES constructors(constructorId),
	FOREIGN KEY (statusId) REFERENCES status(statusId)
);

-- Create seasons table
DROP TABLE IF EXISTS seasons;
CREATE TABLE seasons (
	year YEAR,
	url VARCHAR(255)
);

-- Create sprint_results table
DROP TABLE IF EXISTS sprint_results;
CREATE TABLE sprint_results (
	resultId INT UNSIGNED NOT NULL PRIMARY KEY,
	raceId INT UNSIGNED NOT NULL,
	driverId INT UNSIGNED NOT NULL,
	constructorId INT UNSIGNED NOT NULL,
	number TINYINT UNSIGNED,
	grid TINYINT UNSIGNED,
	position TINYINT UNSIGNED,
	positionText VARCHAR(8),
	positionOrder TINYINT UNSIGNED,
	points INT,
	laps TINYINT UNSIGNED,
	time VARCHAR(32),
	milliseconds INT UNSIGNED,
	fastestLap TINYINT UNSIGNED,
	/*
	fastestLapTime TIME,
	-- Note: modify time to be a string as there is
	-- a formatting error with some of the inputs
	*/
	fastestLapTime VARCHAR(32),
	statusId INT UNSIGNED NOT NULL,
	FOREIGN KEY (raceId) REFERENCES races(raceId),
	FOREIGN KEY (driverId) REFERENCES drivers(driverId),
	FOREIGN KEY (constructorId) REFERENCES constructors(constructorId),
	FOREIGN KEY (statusId) REFERENCES status(statusId)
);

/* Load data into tables */
LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/circuits.csv'
INTO TABLE circuits
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/races.csv'
INTO TABLE races
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/repos/formula1/data/constructors.csv'
INTO TABLE constructors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/constructor_results.csv'
INTO TABLE constructor_results
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/constructor_standings.csv'
INTO TABLE constructor_standings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/drivers.csv'
INTO TABLE drivers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/driver_standings.csv'
INTO TABLE driver_standings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/lap_times.csv'
INTO TABLE lap_times
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/pit_stops.csv'
INTO TABLE pit_stops
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/qualifying.csv'
INTO TABLE qualifying
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/status.csv'
INTO TABLE status
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/results.csv'
INTO TABLE results
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/seasons.csv'
INTO TABLE seasons
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/repos/formula1/data/sprint_results.csv'
INTO TABLE sprint_results
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/* Add primary key to tables without it */
ALTER TABLE lap_times ADD id INT PRIMARY KEY AUTO_INCREMENT FIRST;
ALTER TABLE pit_stops ADD id INT PRIMARY KEY AUTO_INCREMENT FIRST;
ALTER TABLE seasons ADD id INT PRIMARY KEY AUTO_INCREMENT FIRST;


