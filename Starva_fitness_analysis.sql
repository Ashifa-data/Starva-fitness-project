Starva Fitness Project SQL Analysis
Author: Ashifa | Date: June 10, 2025

-- ====================================
-- 1. CLEANING & PREPARATION
-- ====================================

-- 1.1 Clean dailyActivity table (remove nulls)
 CREATE TABLE cleaned_dailyActivity AS
SELECT *
FROM dailyActivity
WHERE TotalSteps IS NOT NULL
  AND Calories IS NOT NULL;

-- 1.2 Clean sleepDay table (remove duplicates)

DELETE FROM sleepDay
WHERE rowid NOT IN (
  SELECT MIN(rowid)
  FROM sleepDay   GROUP BY Id, ActivityDay
);

-- 1.3 Clean minuteIntensitiesNarrow_merged (remove nulls) 

CREATE TABLE cleaned_minuteIntensities AS
SELECT *
FROM minuteIntensitiesNarrow_merged
WHERE Intensity IS NOT NULL;

-- ====================================
-- 2. JOINING DATASETS
-- ====================================

-- 2.1 Join sleepDay and dailyActivity 
SELECT s.Id, s.ActivityDay, s.TotalMinutesAsleep, d.Calories
FROM sleepDay s
JOIN cleaned_dailyActivity d
  ON s.Id = d.Id AND s.ActivityDay = d.ActivityDay;

-- ====================================
-- 3. ANALYSIS QUERIES
-- ====================================

-- 3.1 Total Daily Steps by User

SELECT Id, ActivityDay, TotalSteps
FROM cleaned_dailyActivity
ORDER BY ActivityDay;

-- 3.2 Average Calories Burned per User

SELECT Id, AVG(Calories) AS AvgCalories FROM cleaned_dailyActivity
GROUP BY Id;

-- 3.3 Total Active Minutes (sum of activity levels)

SELECT ActivityDay,
       SUM(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes) AS
TotalActiveMinutes
FROM cleaned_dailyActivity
GROUP BY ActivityDay;

-- 3.4 Average Sleep Duration per User
 
SELECT Id, AVG(TotalMinutesAsleep) AS AvgSleepMinutes
FROM sleepDay
GROUP BY Id;

-- 3.5 Sleep vs. Calories Burned 

SELECT s.Id, s.ActivityDay, s.TotalMinutesAsleep, d.Calories
FROM sleepDay s
JOIN cleaned_dailyActivity d   ON s.Id = d.Id AND s.ActivityDay = d.ActivityDay;

-- 3.6 Intensity Level Distribution

SELECT 
  CASE 
    WHEN Intensity < 3 THEN 'Low'     WHEN Intensity BETWEEN 3 AND 6 THEN 'Medium'
    ELSE 'High'
  END AS Intensity_Level,
  COUNT(*) AS Frequency
FROM cleaned_minuteIntensities
GROUP BY Intensity_Level;

-- 3.7 Average Daily Steps per User 

SELECT Id, AVG(TotalSteps) AS AvgDailySteps FROM cleaned_dailyActivity
GROUP BY Id;
