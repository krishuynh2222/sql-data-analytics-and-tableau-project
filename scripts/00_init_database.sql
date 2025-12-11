/*============================================================= Create Database and Schemas ============================================================= 
Script Purpose: 
	This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
	If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold 
WARNING: 
	Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
	All data in the database will be permanently deleted. Proceed with caution and ensure you have proper backups before running this script. 
*/

-- Kill all existing connections to this DB (if it exists)
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'datawarehouseanalytics'
  AND pid <> pg_backend_pid();

-- Drop and recreate the 'DataWarehouseAnalytics' database
DROP DATABASE IF EXISTS DataWarehouseAnalytics;

CREATE DATABASE DataWarehouseAnalytics;


-- Create schema
CREATE SCHEMA IF NOT EXISTS gold;

-- Dimension: Customers
CREATE TABLE gold.dim_customers (
    customer_key      INTEGER,
    customer_id       INTEGER,
    customer_number   VARCHAR(50),
    first_name        VARCHAR(50),
    last_name         VARCHAR(50),
    country           VARCHAR(50),
    marital_status    VARCHAR(50),
    gender            VARCHAR(50),
    birthdate         DATE,
    create_date       DATE
);

-- Dimension: Products
CREATE TABLE gold.dim_products (
    product_key    INTEGER,
    product_id     INTEGER,
    product_number VARCHAR(50),
    product_name   VARCHAR(50),
    category_id    VARCHAR(50),
    category       VARCHAR(50),
    subcategory    VARCHAR(50),
    maintenance    VARCHAR(50),
    cost           INTEGER,
    product_line   VARCHAR(50),
    start_date     DATE
);

-- Fact: Sales
CREATE TABLE gold.fact_sales (
    order_number  VARCHAR(50),
    product_key   INTEGER,
    customer_key  INTEGER,
    order_date    DATE,
    shipping_date DATE,
    due_date      DATE,
    sales_amount  INTEGER,
    quantity      SMALLINT,      
    price         INTEGER
);

SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
SELECT * FROM gold.fact_sales;

