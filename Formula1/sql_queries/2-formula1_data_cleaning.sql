
/* Data cleaning */

-- Cleaning qualifying table
DROP TABLE IF EXISTS formula1.qualifying_clean;
CREATE TABLE formula1.qualifying_clean AS (
	SELECT *
	FROM formula1.qualifying
);

-- Fill in empty fields with NULL
UPDATE qualifying_clean
SET q1 = IFNULL(NULLIF(q1, ''), NULL)
WHERE q1 IS NOT NULL; 

UPDATE qualifying_clean
SET q2 = IFNULL(NULLIF(q2, ''), NULL)
WHERE q2 IS NOT NULL; 

UPDATE qualifying_clean
SET q3 = IFNULL(NULLIF(q3, ''), NULL)
WHERE q3 IS NOT NULL; 

-- Add columns to separate q1,q2,q3 time into mm, ss, ms
ALTER TABLE qualifying_clean ADD q1_mm INT UNSIGNED;
ALTER TABLE qualifying_clean ADD q1_ss INT UNSIGNED;
ALTER TABLE qualifying_clean ADD q1_ms INT UNSIGNED;

ALTER TABLE qualifying_clean ADD q2_mm INT UNSIGNED;
ALTER TABLE qualifying_clean ADD q2_ss INT UNSIGNED;
ALTER TABLE qualifying_clean ADD q2_ms INT UNSIGNED;

ALTER TABLE qualifying_clean ADD q3_mm INT UNSIGNED;
ALTER TABLE qualifying_clean ADD q3_ss INT UNSIGNED;
ALTER TABLE qualifying_clean ADD q3_ms INT UNSIGNED;

-- Update q1 mm, ss, ms
UPDATE qualifying_clean
SET q1_mm = CAST(SUBSTRING(q1, 1, POSITION(':' IN q1) - 1) AS UNSIGNED)
WHERE q1 IS NOT NULL; 

UPDATE qualifying_clean
SET q1_ss = CAST(SUBSTRING(q1, (POSITION(':' IN q1) + 1), 2) AS UNSIGNED)
WHERE q1 IS NOT NULL; 

UPDATE qualifying_clean
SET q1_ms = CAST(SUBSTRING(q1, (POSITION('.' IN q1) + 1), 3) AS UNSIGNED)
WHERE q1 IS NOT NULL;

-- Update q2 mm, ss, ms
UPDATE qualifying_clean
SET q2_mm = CAST(SUBSTRING(q2, 1, POSITION(':' IN q2) - 1) AS UNSIGNED)
WHERE q2 IS NOT NULL;

UPDATE qualifying_clean
SET q2_ss = CAST(SUBSTRING(q2, (POSITION(':' IN q2) + 1), 2) AS UNSIGNED)
WHERE q2 IS NOT NULL;  

UPDATE qualifying_clean
SET q2_ms = CAST(SUBSTRING(q2, (POSITION('.' IN q2) + 1), 3) AS UNSIGNED)
WHERE q2 IS NOT NULL;

-- Update q3 mm, ss, ms
UPDATE qualifying_clean
SET q3_mm = CAST(SUBSTRING(q3, 1, POSITION(':' IN q3) - 1) AS UNSIGNED)
WHERE q3 IS NOT NULL;

UPDATE qualifying_clean
SET q3_ss = CAST(SUBSTRING(q3, (POSITION(':' IN q3) + 1), 2) AS UNSIGNED)
WHERE q3 IS NOT NULL;  

UPDATE qualifying_clean
SET q3_ms = CAST(SUBSTRING(q3, (POSITION('.' IN q3) + 1), 3) AS UNSIGNED)
WHERE q3 IS NOT NULL;

-- Add new fields for total time in msec for q1, q2, q3
ALTER TABLE qualifying_clean ADD q1_msec INT UNSIGNED; 
ALTER TABLE qualifying_clean ADD q2_msec INT UNSIGNED; 
ALTER TABLE qualifying_clean ADD q3_msec INT UNSIGNED; 

UPDATE qualifying_clean
SET q1_msec = (q1_mm * 60 * 1000) + (q1_ss * 1000) + q1_ms
WHERE q1_mm IS NOT NULL;

UPDATE qualifying_clean
SET q2_msec = (q2_mm * 60 * 1000) + (q2_ss * 1000) + q2_ms
WHERE q2_mm IS NOT NULL;

UPDATE qualifying_clean
SET q3_msec = (q3_mm * 60 * 1000) + (q3_ss * 1000) + q3_ms
WHERE q3_mm IS NOT NULL;

-- Remove columns
ALTER TABLE qualifying_clean DROP COLUMN q1_mm;
ALTER TABLE qualifying_clean DROP COLUMN q1_ss;
ALTER TABLE qualifying_clean DROP COLUMN q1_ms;

ALTER TABLE qualifying_clean DROP COLUMN q2_mm;
ALTER TABLE qualifying_clean DROP COLUMN q2_ss;
ALTER TABLE qualifying_clean DROP COLUMN q2_ms;

ALTER TABLE qualifying_clean DROP COLUMN q3_mm;
ALTER TABLE qualifying_clean DROP COLUMN q3_ss;
ALTER TABLE qualifying_clean DROP COLUMN q3_ms;

-- Cleaning results table
DROP TABLE IF EXISTS results_clean;
CREATE TABLE results_clean (
	SELECT *
	FROM formula1.results
);

-- Add columns to separate fatestLapTime into mm, ss, ms
ALTER TABLE results_clean ADD fatestLapTime_mm INT UNSIGNED;
ALTER TABLE results_clean ADD fatestLapTime_ss INT UNSIGNED;
ALTER TABLE results_clean ADD fatestLapTime_ms INT UNSIGNED;


-- Update fastestLapTime mm, ss, ms
UPDATE results_clean
SET fatestLapTime_mm = CAST(SUBSTRING(fastestLapTime, 1, POSITION(':' IN fastestLapTime) - 1) AS UNSIGNED)
WHERE fastestLapTime IS NOT NULL; 

UPDATE results_clean
SET fatestLapTime_ss = CAST(SUBSTRING(fastestLapTime, (POSITION(':' IN fastestLapTime) + 1), 2) AS UNSIGNED)
WHERE fastestLapTime IS NOT NULL; 

UPDATE results_clean
SET fatestLapTime_ms = CAST(SUBSTRING(fastestLapTime, (POSITION('.' IN fastestLapTime) + 1), 3) AS UNSIGNED)
WHERE fastestLapTime IS NOT NULL; 

-- Add new fields for total time in msec for fastestLapTime
ALTER TABLE results_clean ADD fastestLapTime_msec INT UNSIGNED; 

UPDATE results_clean
SET fastestLapTime_msec = (fatestLapTime_mm * 60 * 1000) + (fatestLapTime_ss * 1000) + fatestLapTime_ms
WHERE fatestLapTime_mm IS NOT NULL;

-- Drop columns after msec calculation
ALTER TABLE results_clean DROP COLUMN fatestLapTime_mm;
ALTER TABLE results_clean DROP COLUMN fatestLapTime_ss;
ALTER TABLE results_clean DROP COLUMN fatestLapTime_ms;

-- Cleaning sprint results table
DROP TABLE IF EXISTS sprint_results_clean;
CREATE TABLE sprint_results_clean (
	SELECT *
	FROM formula1.sprint_results
);

-- Add columns to separate fatestLapTime into mm, ss, ms
ALTER TABLE sprint_results_clean ADD fatestLapTime_mm INT UNSIGNED;
ALTER TABLE sprint_results_clean ADD fatestLapTime_ss INT UNSIGNED;
ALTER TABLE sprint_results_clean ADD fatestLapTime_ms INT UNSIGNED;

-- Update fastestLapTime mm, ss, ms
UPDATE sprint_results_clean
SET fatestLapTime_mm = CAST(SUBSTRING(fastestLapTime, 1, POSITION(':' IN fastestLapTime) - 1) AS UNSIGNED)
WHERE fastestLapTime IS NOT NULL; 

UPDATE sprint_results_clean
SET fatestLapTime_ss = CAST(SUBSTRING(fastestLapTime, (POSITION(':' IN fastestLapTime) + 1), 2) AS UNSIGNED)
WHERE fastestLapTime IS NOT NULL; 

UPDATE sprint_results_clean
SET fatestLapTime_ms = CAST(SUBSTRING(fastestLapTime, (POSITION('.' IN fastestLapTime) + 1), 3) AS UNSIGNED)
WHERE fastestLapTime IS NOT NULL; 

-- Add new fields for total time in msec for fastestLapTime
ALTER TABLE sprint_results_clean ADD fastestLapTime_msec INT UNSIGNED; 

UPDATE sprint_results_clean
SET fastestLapTime_msec = (fatestLapTime_mm * 60 * 1000) + (fatestLapTime_ss * 1000) + fatestLapTime_ms
WHERE fatestLapTime_mm IS NOT NULL;

-- Drop columns after msec calculation
ALTER TABLE sprint_results_clean DROP COLUMN fatestLapTime_mm;
ALTER TABLE sprint_results_clean DROP COLUMN fatestLapTime_ss;
ALTER TABLE sprint_results_clean DROP COLUMN fatestLapTime_ms;
