/*
===============================================================================
Cumulative Analysis (PostgreSQL)
===============================================================================
Purpose:
    - Running totals (cumulative sums)
    - Moving averages over time
    - Long-term trend analysis
===============================================================================
*/

-- Monthly total + cumulative sales + moving average price
SELECT
    order_month,
    total_sales,
    running_total_sales,
    ROUND(moving_average_price, 2) AS moving_average_price
FROM (
    SELECT
        order_month,
        total_sales,
        SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales,
        AVG(avg_price) OVER (ORDER BY order_month)   AS moving_average_price
    FROM (
        SELECT 
            DATE_TRUNC('month', order_date)::date AS order_month,
            SUM(sales_amount) AS total_sales,
            AVG(price)        AS avg_price
        FROM gold.fact_sales
        WHERE order_date IS NOT NULL
        GROUP BY DATE_TRUNC('month', order_date)
    ) m
) f
ORDER BY order_month;
