-- ===========================
-- Staging Tables
-- ===========================
-- dim_customers

IF OBJECT_ID('dbo.[dim_customers_stage_update_type1]', 'U') IS NOT NULL
    DROP TABLE [dim_customers_stage_update_type1]
CREATE TABLE [dbo].[dim_customers_stage_update_type1](
	[customer_id] [nvarchar](255) NOT NULL,        -- Business Key from the source system
	[Customer Full Name] [nvarchar](255),
	[gender] [nvarchar](255),
	[age] [int],
	[geo_key] [int]
)
IF OBJECT_ID('dbo.[dim_customers_stage_update_type2]', 'U') IS NOT NULL
    DROP TABLE dim_customers_stage_update_type2
CREATE TABLE [dbo].[dim_customers_stage_update_type2](
	[customer_id] [nvarchar](255) NOT NULL,        -- Business Key from the source system
	[Customer Full Name] [nvarchar](255),
	[gender] [nvarchar](255),
	[age] [int],
	[geo_key] [int]
)

-- =================
-- Type 1 Update
UPDATE target_dim
SET
    age = updates.age,
    [Customer Full Name] = updates.[Customer Full Name]
FROM
    dim_customers AS target_dim
JOIN
    dim_customers_stage_update_type1 AS updates 
    ON target_dim.customer_id = updates.customer_id
WHERE
    target_dim.EndDate IS NULL; 


-- Lookup Code
SELECT *
FROM dim_customers
WHERE EndDate IS NULL


-- Type 2 Update
BEGIN TRANSACTION;

-- Step 1: Expire the CURRENT active record
UPDATE target_dim
SET EndDate = GETDATE()
FROM dim_customers AS target_dim
JOIN dim_customers_stage_update_type2 AS updates 
    ON target_dim.customer_id = updates.customer_id
WHERE target_dim.EndDate IS NULL; -- This line is essential!

-- Step 2: Insert the new active record
INSERT INTO dbo.dim_customers (
    customer_id,
    [Customer Full Name],
    gender,
    age,
    geo_key,
    StartDate,
    EndDate
)
SELECT 
    stg.customer_id,
    stg.[Customer Full Name],
    stg.gender,
    stg.age,
    stg.geo_key,
    GETDATE() AS StartDate,
    NULL AS EndDate  
FROM dbo.dim_customers_stage_update_type2 AS stg;

COMMIT TRANSACTION;

-- ============================
-- dim_order_details
-- ============================
IF OBJECT_ID('dbo.[stg_order_details]', 'U') IS NOT NULL
    DROP TABLE [stg_order_details]
CREATE TABLE [dbo].[stg_order_details](
    [order_id] NVARCHAR(255) NULL,
    [order_status] NVARCHAR(255) NULL,
    [review_comment_title] NVARCHAR(500) NULL,
    [review_comment_message] NVARCHAR(500) NULL
)


-- Update Type1
UPDATE target_dim
SET
    order_status = updates.order_status,
    review_comment_title = updates.review_comment_title,
    review_comment_message = updates.review_comment_message
FROM
    dim_order_details AS target_dim
JOIN
    [stg_order_details] AS updates ON target_dim.order_id = updates.order_id
