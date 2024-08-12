-- Setting up 12 empty columns and assigning them data types
create table skill_migration(
country_code varchar(5),
country_name varchar(30),
wb_income varchar(50),
wb_region varchar(50),
skill_group_id bigint,
skill_group_category varchar(50),
skill_group_name varchar(50),
net_per_10k_2015 decimal(8,2),
net_per_10k_2016 decimal(8,2),
net_per_10k_2017 decimal(8,2),
net_per_10k_2018 decimal(8,2),
net_per_10k_2019 decimal(8,2)
);

--copying rows from the csv file
copy skill_migration from 'C:\Program Files\PostgreSQL\16\data\data_copy\skill_migration.csv' delimiter ',' csv header;

--checking the table to see the result
select * from skill_migration limit 5;

/*Summarize the net migration per 10k population 
for each skill_group_category by wb_region from 2015 to 2019. */

select wb_region, sum(net_per_10k_2015) as "2015 Net Migration Cost", sum(net_per_10k_2016) as "2016 Net Migration Cost", sum(net_per_10k_2017) as "2017 Net Migration Cost", sum(net_per_10k_2018) as "2018 Net Migration Cost", sum(net_per_10k_2019) as "2019 Net Migration Cost" from skill_migration group by wb_region order by wb_region desc;

-- Identify which region had the highest net migration for tech skills in 2019
select wb_region, sum(net_per_10k_2019) as "2019 Net Migration Cost" from skill_migration group by wb_region order by sum(net_per_10k_2019) desc;
-- Europe & Central Asia had the highest net migration of $279653.78 per 10k as shown above

/*Write a query to calculate the average net_per_10k migration rate
for each wb_income group and skill_group_category from 2015 to 2019*/
select wb_income, skill_group_category, avg(net_per_10k_2015) as "2015 Avg Migration Cost", avg(net_per_10k_2016) as "2016 Avg Migration Cost", avg(net_per_10k_2017) as "2017 Avg Migration Cost",avg(net_per_10k_2018) as "2018 Avg Migration Cost",avg(net_per_10k_2019) as "2019 Avg Migration Cost" from skill_migration group by wb_income,skill_group_category order by avg(net_per_10k_2015),avg(net_per_10k_2016),avg(net_per_10k_2017),avg(net_per_10k_2018),avg(net_per_10k_2019);
-- Which wb_income and skill_group category combination had the lowest average net migration?
-- The combination of Upper middle income and Disruptive Tech Skills had the lowest net migration over the four years


--Show the top 5 countries with the highest net migration rate for tech skill in 2019
select country_name, skill_group_category, sum(net_per_10k_2019) from skill_migration group by country_name, skill_group_category having (skill_group_category = 'Tech Skills') order by sum(net_per_10k_2019) desc; 




/*Write a query to find the difference in net migration rates between
Tech Skills and Business Skills for each country and year*/
