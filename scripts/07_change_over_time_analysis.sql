/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
-- Analyse sales performance over time (by year & month)
SELECT
    EXTRACT(YEAR  FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount)               AS total_sales,
    COUNT(DISTINCT customer_key)    AS total_customers,
    SUM(quantity)                   AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    EXTRACT(YEAR  FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY
    order_year,
    order_month;


-- DATETRUNC()
-- Using DATE_TRUNC (month buckets)
SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    SUM(sales_amount)                    AS total_sales,
    COUNT(DISTINCT customer_key)         AS total_customers,
    SUM(quantity)                        AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    DATE_TRUNC('month', order_date)::date
ORDER BY
    order_month;


-- FORMAT()
-- Using TO_CHAR to format month labels (yyyy-Mon)
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_month_label,
    SUM(sales_amount)               AS total_sales,
    COUNT(DISTINCT customer_key)    AS total_customers,
    SUM(quantity)                   AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY
    order_month_label;
