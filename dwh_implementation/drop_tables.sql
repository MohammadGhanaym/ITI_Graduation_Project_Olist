IF OBJECT_ID('dbo.[fact_marketing_leads]', 'U') IS NOT NULL
    DROP TABLE [fact_marketing_leads]

IF OBJECT_ID('dbo.[fact_sales]', 'U') IS NOT NULL
    DROP TABLE fact_sales

IF OBJECT_ID('dbo.fact_payment', 'U') IS NOT NULL
    DROP TABLE fact_payment

IF OBJECT_ID('dbo.fact_payment', 'U') IS NOT NULL
    DROP TABLE fact_payment

IF OBJECT_ID('dbo.dim_sales_rep', 'U') IS NOT NULL
    DROP TABLE dim_sales_rep

IF OBJECT_ID('dbo.dim_time', 'U') IS NOT NULL
    DROP TABLE dim_time

IF OBJECT_ID('dbo.[dim_date]', 'U') IS NOT NULL
    DROP TABLE dim_date

IF OBJECT_ID('dbo.dim_order_details', 'U') IS NOT NULL
    DROP TABLE dim_order_details

IF OBJECT_ID('dbo.dim_payment_type', 'U') IS NOT NULL
    DROP TABLE dim_payment_type

IF OBJECT_ID('dbo.dim_products', 'U') IS NOT NULL
    DROP TABLE dim_products

IF OBJECT_ID('dbo.dim_sellers', 'U') IS NOT NULL
    DROP TABLE dim_sellers

IF OBJECT_ID('dbo.dim_customers', 'U') IS NOT NULL
    DROP TABLE dim_customers

IF OBJECT_ID('dbo.dim_geolocation', 'U') IS NOT NULL
    DROP TABLE dim_geolocation