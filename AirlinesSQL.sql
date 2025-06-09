
# 1 Date Fields from Year, Month, Day:
-- This query generates comprehensive date fields, including formatted date strings, quarters, and weekday details, based on Year, Month, and Day columns.
SELECT 
    Year, 
    `Month (#)` AS Month, 
    Day, 
    CONCAT(Year, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(Day, 2, '0')) AS `#DateField`,
    CONCAT(Year, '-', LPAD(`Month (#)`, 2, '0')) AS `#YearMonth`,
    CASE 
        WHEN `Month (#)` IN (1, 2, 3) THEN 'Q1'
        WHEN `Month (#)` IN (4, 5, 6) THEN 'Q2'
        WHEN `Month (#)` IN (7, 8, 9) THEN 'Q3'
        ELSE 'Q4'
    END AS `#Quater`,
    CASE 
        WHEN `Month (#)` IN (1, 2, 3) THEN 'Q4'
        WHEN `Month (#)` IN (4, 5, 6) THEN 'Q1'
        WHEN `Month (#)` IN (7, 8, 9) THEN 'Q2'
        ELSE 'Q3'
    END AS `#FinQuater`,
    DAYOFWEEK(CONCAT(Year, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(Day, 2, '0'))) AS `#WeekDayNo.`,
    DAYNAME(CONCAT(Year, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(Day, 2, '0'))) AS `#WeekDayName`
FROM 
    AirlineWork;

# 2 Load Factor Percentage (Yearly, Quarterly, Monthly):
-- Calculates the load factor percentage, representing the ratio of transported passengers to available seats, grouped by year, month, and quarter.
SELECT
    Year, 
    `Month (#)`,
    CASE 
        WHEN `Month (#)` IN (1, 2, 3) THEN 'Q1'
        WHEN `Month (#)` IN (4, 5, 6) THEN 'Q2'
        WHEN `Month (#)` IN (7, 8, 9) THEN 'Q3'
        ELSE 'Q4'
    END AS `#Quater`,
    SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100 AS Load_Factor_Percentage
FROM
    AirlineWork
GROUP BY
    Year, `Month (#)`;
    
    # 3 Load Factor Percentage by Carrier Name:
    -- Determines the load factor percentage for each carrier by comparing the number of transported passengers to the available seats
    SELECT
    `Carrier Name`,
    SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100 AS Load_Factor_Percentage
FROM
    AirlineWork
GROUP BY
    `Carrier Name`;
    
    # 4 Top 10 Carrier Names based on Passenger Preference:
    -- Identifies the top 10 carriers with the highest number of transported passengers, to highlight passenger preference
   SELECT
    `Carrier Name`,
   concat("$",format((SUM(`# Transported Passengers`) / 1000000),2),"M") AS Total_Passengers
FROM
    AirlineWork
GROUP BY
    `Carrier Name`
ORDER BY
    Total_Passengers DESC
LIMIT 10;

# 5 Top Routes (from-to City) based on Number of Flights:
-- Lists the most popular flight routes by counting the number of flights between origin and destination cities
SELECT
    `Origin City`,
    `Destination City`,
    COUNT(*) AS Number_of_Flights
FROM
    AirlineWork
GROUP BY
    `Origin City`, `Destination City`
ORDER BY
    Number_of_Flights DESC;
    
    # 6 Load Factor on Weekend vs Weekdays:
    -- Compares the load factor percentage on weekends versus weekdays to analyze differences in passenger demand
    SELECT
    CASE
        WHEN DAYOFWEEK(CONCAT(Year, '-', LPAD(`Month (#)`, 2, '0'), '-', LPAD(Day, 2, '0'))) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100 AS Load_Factor_Percentage
FROM
    AirlineWork
GROUP BY
    Day_Type;
    
    # 7  Number of Flights based on Distance Group:
    -- Counts the total number of flights categorized by different distance groups.
    SELECT
    CASE
        WHEN Distance < 500 THEN 'Short Haul (< 500 miles)'
        WHEN Distance BETWEEN 500 AND 1000 THEN 'Medium Haul (500 - 1000 miles)'
        WHEN Distance BETWEEN 1001 AND 2000 THEN 'Long Haul (1001 - 2000 miles)'
        ELSE 'Ultra Long Haul (> 2000 miles)'
    END AS Distance_Group,
    COUNT(*) AS Number_of_Flights
FROM
    AirlineWork
GROUP BY
    Distance_Group
ORDER BY
    Number_of_Flights DESC;
    
    
    SELECT
    `%Distance Group ID`,
    COUNT(*) AS Number_of_Flights
FROM
    AirlineWork
GROUP BY
    `%Distance Group ID`;
    
    
# 8 Total Freight and Mail Transported by Year:
-- Summarizes the total freight and mail transported annually to understand cargo volume trends
    SELECT
    Year,
    concat("$",format((SUM(`# Transported Freight`) / 1000000),2),"M") AS Total_Freight,
    concat("$",format((SUM(`# Transported Mail`) / 1000000),2),"M") AS Total_Mail
FROM
    AirlineWork
GROUP BY
    Year;
    
    # 9 Top 5 Aircraft Types by Number of Flights:
    -- Identifies the five most frequently used aircraft types based on the number of flights.
    SELECT
    `%Aircraft Type ID`,
    concat(format((COUNT(*) / 1000),2),"K") AS Number_of_Flights
FROM
    AirlineWork
GROUP BY
    `%Aircraft Type ID`
ORDER BY
    Number_of_Flights DESC
LIMIT 5;

# 10 Monthly Freight and Mail Transported by Origin Country:
-- Provides the monthly total of freight and mail transported from different origin countries.
SELECT
    `Origin Country`,
    Year,
    `Month (#)`,
     concat("$",format((  SUM(`# Transported Freight`) / 1000000),2),"M") AS Total_Freight,
      concat("$",format(( SUM(`# Transported Mail`) / 1000000),2),"M") AS Total_Mail
FROM
    AirlineWork
GROUP BY
    `Origin Country`, Year, `Month (#)`;