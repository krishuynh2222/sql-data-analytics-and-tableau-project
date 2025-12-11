/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
SELECT * FROM gold.report_products;
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

CREATE OR REPLACE VIEW gold.report_products AS

WITH base_query AS (
    /*-----------------------------------------------------------------------
    1) Base Query: Retrieves core columns from fact_sales and dim_products
    -----------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL  -- only consider valid sales dates
),

product_aggregations AS (
    /*-----------------------------------------------------------------------
    2) Product Aggregations: Summarizes key metrics at the product level
    -----------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        cost,

        -- Lifespan in months (from first to last sale)
        (
            EXTRACT(YEAR  FROM AGE(MAX(order_date), MIN(order_date))) * 12
          + EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date)))
        )::int AS lifespan_months,

        MAX(order_date)               AS last_sale_date,
        COUNT(DISTINCT order_number)  AS total_orders,
        COUNT(DISTINCT customer_key)  AS total_customers,
        SUM(sales_amount)             AS total_sales,
        SUM(quantity)                 AS total_quantity,

        -- Average selling price (unit price), rounded to 1 decimal
        ROUND(
            AVG(sales_amount::numeric / NULLIF(quantity, 0)),
            1
        ) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        cost
)

    /*-----------------------------------------------------------------------
      3) Final Query: Combines all product results into one output
    -----------------------------------------------------------------------*/
SELECT 
    product_key,
    product_name,
    category,
    cost,
    last_sale_date,

    -- Recency: months since last sale
    (
        EXTRACT(YEAR  FROM AGE(CURRENT_DATE, last_sale_date)) * 12
      + EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date))
    )::int AS recency_in_months,

    -- Product segment by total revenue
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan_months,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR), rounded to 2 decimals
    ROUND(
        CASE 
            WHEN total_orders = 0 THEN 0
            ELSE total_sales::numeric / total_orders
        END,
        0
    ) AS avg_order_revenue,

    -- Average Monthly Revenue, rounded to 2 decimals
    ROUND(
        CASE
            WHEN lifespan_months = 0 THEN total_sales::numeric
            ELSE total_sales::numeric / lifespan_months
        END,
        0
    ) AS avg_monthly_revenue

FROM product_aggregations;
