-- ===========================
-- Staging Tables
-- ===========================
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
    dim_customers_stage_update_type1 AS updates ON target_dim.customer_id = updates.customer_id
WHERE
    target_dim.EndDate IS NULL; 


-- Lookup Code
SELECT *
FROM dim_customers
WHERE EndDate IS NULL


-- Type 2 Update
BEGIN TRANSACTION;

-- Step 1: Expire the CURRENT active record (this is the corrected part)
UPDATE target_dim
SET EndDate = GETDATE()
FROM dim_customers AS target_dim
JOIN dim_customers_stage_update_type2 AS updates 
    ON target_dim.customer_id = updates.customer_id
WHERE target_dim.EndDate IS NULL; -- This line is essential!

-- Step 2: Insert the new active record (this part was already correct)
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