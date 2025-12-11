/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    (
        (EXTRACT(YEAR  FROM MAX(order_date)) - EXTRACT(YEAR  FROM MIN(order_date))) * 12
      + (EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date)))
    ) AS order_range_months
FROM gold.fact_sales;


-- Find the youngest and oldest customers based on birthdate
SELECT 	
	MIN(birthdate) AS oldest_birthdate,
    DATE_PART('year', CURRENT_DATE) - DATE_PART('year', MIN(birthdate)) AS oldest_age,
	MAX(birthdate) AS youngest_birthdate,
	DATE_PART('year', CURRENT_DATE) - DATE_PART('year', MAX(birthdate)) AS youngest_age
FROM gold.dim_customers

