-- Setting up 12 empty columns and assigning them data types
CREATE TABLE SKILL_MIGRATION (
	COUNTRY_CODE VARCHAR(5),
	COUNTRY_NAME VARCHAR(30),
	WB_INCOME VARCHAR(50),
	WB_REGION VARCHAR(50),
	SKILL_GROUP_ID BIGINT,
	SKILL_GROUP_CATEGORY VARCHAR(50),
	SKILL_GROUP_NAME VARCHAR(50),
	NET_PER_10K_2015 DECIMAL(8, 2),
	NET_PER_10K_2016 DECIMAL(8, 2),
	NET_PER_10K_2017 DECIMAL(8, 2),
	NET_PER_10K_2018 DECIMAL(8, 2),
	NET_PER_10K_2019 DECIMAL(8, 2)
);

--copying rows from the csv file
COPY SKILL_MIGRATION
FROM
	'C:\Program Files\PostgreSQL\16\data\data_copy\skill_migration.csv' DELIMITER ',' CSV HEADER;

--checking the table to see the result
SELECT
	*
FROM
	SKILL_MIGRATION
LIMIT
	5;

/*Summarize the net migration per 10k population 
for each skill_group_category by wb_region from 2015 to 2019. */
SELECT
	WB_REGION,
	SUM(NET_PER_10K_2015) AS "2015 Net Migration Cost",
	SUM(NET_PER_10K_2016) AS "2016 Net Migration Cost",
	SUM(NET_PER_10K_2017) AS "2017 Net Migration Cost",
	SUM(NET_PER_10K_2018) AS "2018 Net Migration Cost",
	SUM(NET_PER_10K_2019) AS "2019 Net Migration Cost"
FROM
	SKILL_MIGRATION
GROUP BY
	WB_REGION
ORDER BY
	WB_REGION DESC;

-- Identify which region had the highest net migration for tech skills in 2019
SELECT
	WB_REGION,
	SUM(NET_PER_10K_2019) AS "2019 Net Migration Cost"
FROM
	SKILL_MIGRATION
GROUP BY
	WB_REGION
ORDER BY
	SUM(NET_PER_10K_2019) DESC;

-- Europe & Central Asia had the highest net migration of $279653.78 per 10k as shown above
/*Write a query to calculate the average net_per_10k migration rate
for each wb_income group and skill_group_category from 2015 to 2019*/
SELECT
	WB_INCOME,
	SKILL_GROUP_CATEGORY,
	AVG(NET_PER_10K_2015) AS "2015 Avg Migration Cost",
	AVG(NET_PER_10K_2016) AS "2016 Avg Migration Cost",
	AVG(NET_PER_10K_2017) AS "2017 Avg Migration Cost",
	AVG(NET_PER_10K_2018) AS "2018 Avg Migration Cost",
	AVG(NET_PER_10K_2019) AS "2019 Avg Migration Cost"
FROM
	SKILL_MIGRATION
GROUP BY
	WB_INCOME,
	SKILL_GROUP_CATEGORY
ORDER BY
	AVG(NET_PER_10K_2015),
	AVG(NET_PER_10K_2016),
	AVG(NET_PER_10K_2017),
	AVG(NET_PER_10K_2018),
	AVG(NET_PER_10K_2019);

-- Which wb_income and skill_group category combination had the lowest average net migration?
-- The combination of Upper middle income and Disruptive Tech Skills had the lowest net migration over the four years
--Show the top 5 countries with the highest net migration rate for tech skill in 2019
SELECT
	COUNTRY_NAME,
	SKILL_GROUP_CATEGORY,
	SUM(NET_PER_10K_2019)
FROM
	SKILL_MIGRATION
GROUP BY
	COUNTRY_NAME,
	SKILL_GROUP_CATEGORY
HAVING
	(SKILL_GROUP_CATEGORY = 'Tech Skills')
ORDER BY
	SUM(NET_PER_10K_2019) DESC;

