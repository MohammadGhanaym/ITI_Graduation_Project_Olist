
-- =============================================================================
-- DIMENSION TABLES
-- These tables describe the business entities (the "who, what, where, when").
-- They must be created before the fact tables.
-- =============================================================================

-- Dimension: Location
-- Purpose: Stores geographical information to be shared across customers and sellers.
-- This creates a snowflake schema design.
IF OBJECT_ID('dbo.dim_geolocation', 'U') IS NOT NULL
    DROP TABLE dim_geolocation
CREATE TABLE [dbo].[dim_geolocation](
	[Geolocation_SK] [int] IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key for the dimension
	[geo_id] [int] NOT NULL,                          -- Business Key from the source system
	[city] [nvarchar](255),
	[state] [nvarchar](255)
)

-- Dimension: Customer
-- Purpose: Stores descriptive information about each unique customer.
IF OBJECT_ID('dbo.dim_customers', 'U') IS NOT NULL
    DROP TABLE dim_customers
CREATE TABLE [dbo].[dim_customers](
	[Customer_SK] [int] IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	[customer_id] [nvarchar](255) NOT NULL,        -- Business Key from the source system
	[Customer Full Name] [nvarchar](255),
	[gender] [nvarchar](255),
	[age] [int],
	[geo_key] [int],
    StartDate DATETIME NOT NULL,
    EndDate DATETIME
    CONSTRAINT FK_geo_id_customers
        FOREIGN KEY (geo_key)
        REFERENCES dim_geolocation(Geolocation_SK)
)

-- Dimension: Seller
-- Purpose: Stores descriptive information about each unique seller.
IF OBJECT_ID('dbo.dim_sellers', 'U') IS NOT NULL
    DROP TABLE dim_sellers
CREATE TABLE [dbo].[dim_sellers](
	[Seller_SK] [int] IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	[seller_id] [nvarchar](255) NOT NULL,        -- Business Key from the source system
	[Seller Full Name] [nvarchar](1025) NULL,
	[gender] [nvarchar](255) NULL,
	[geo_key] [int] NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME
    CONSTRAINT FK_geo_id_sellers
    FOREIGN KEY (geo_key)
    REFERENCES dim_geolocation(Geolocation_SK)
)

-- Dimension: Product
-- Purpose: Stores descriptive information about each unique product.
IF OBJECT_ID('dbo.dim_products', 'U') IS NOT NULL
    DROP TABLE dim_products
CREATE TABLE [dim_products] (
    Product_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    Product_id NVARCHAR(255) NOT NULL,  -- Business Key from the source system
	Product_name NVARCHAR(255),
	Product_brand NVARCHAR(255),
    Product_category_name NVARCHAR(255),
    Product_weight_g INT,
    Product_length_cm INT,
    Product_height_cm INT,
    Product_width_cm INT,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME
);

-- dim_payment_type
IF OBJECT_ID('dbo.dim_payment_type', 'U') IS NOT NULL
    DROP TABLE dim_payment_type
CREATE TABLE dim_payment_type (
    Payment_SK INT IDENTITY(1, 1) PRIMARY KEY,
    payment_type NVARCHAR(255),
    provider NVARCHAR(255)
)



-- dim_order_details
IF OBJECT_ID('dbo.dim_order_details', 'U') IS NOT NULL
    DROP TABLE dim_order_details
CREATE TABLE dim_order_details (
    Order_Details_SK INT IDENTITY(1,1) PRIMARY KEY,
    order_id NVARCHAR(255),
    order_status NVARCHAR(255),
    review_comment_title NVARCHAR(500),
    review_comment_message NVARCHAR(500),
 )

-- Dimension: Date
-- Purpose: A standard date dimension for time-based analysis.
-- Note: This table needs to be populated manually or with a separate script.
IF OBJECT_ID('dbo.[dim_date]', 'U') IS NOT NULL
    DROP TABLE dim_date
CREATE TABLE [dim_date] (
    [Date_SK] INT PRIMARY KEY,
    [FullDate] DATE NOT NULL,
    [DayNumberOfWeek] INT NOT NULL,
    [DayNameOfWeek] NVARCHAR(10) NOT NULL,
    [DayNumberOfMonth] INT NOT NULL,
    [MonthName] NVARCHAR(10) NOT NULL,
    [MonthNumberOfYear] INT NOT NULL,
    [Quarter] INT NOT NULL,
    [Year] INT NOT NULL
);

IF OBJECT_ID('dbo.dim_time', 'U') IS NOT NULL
    DROP TABLE dim_time
CREATE TABLE dbo.dim_time (
    TimeKey INT NOT NULL PRIMARY KEY,     -- e.g., 134500 = 1:45:00 PM
    TimeValue TIME NOT NULL,              -- Actual time of day
    Hour INT NOT NULL,                    -- 0–23
    Minute INT NOT NULL,                  -- 0–59
    Second INT NOT NULL,                  -- 0–59
    Hour12 INT NOT NULL,                  -- 1–12
    AMPM CHAR(2) NOT NULL,                -- 'AM' or 'PM'
    HourMinute CHAR(5) NOT NULL,          -- e.g., '13:45'
    Shift VARCHAR(20) NULL                -- e.g., Morning, Afternoon, Night
);

-- Dimension: DealDetails
-- Purpose: Stores descriptive attributes of a closed deal.
IF OBJECT_ID('dbo.dim_sales_rep', 'U') IS NOT NULL
    DROP TABLE dim_sales_rep
CREATE TABLE [dim_sales_rep] (
    Sales_Rep_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    sales_rep_id NVARCHAR(255),
    Sales_Rep_name NVARCHAR(1025),
	gender NVARCHAR(255),
    Role NVARCHAR(255),
    facebook_user_id NVARCHAR(255),
    StartDate DATETIME NOT NULL,
    EndDate DATETIME
);


-- Dimension: [dim_leads]
-- Purpose: Stores descriptive attributes of a closed deal.
IF OBJECT_ID('dbo.[dim_leads]', 'U') IS NOT NULL
    DROP TABLE [dim_leads]
CREATE TABLE [dim_leads] (
    lead_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    Lead_type NVARCHAR(255),
    Lead_behavior_profile NVARCHAR(255),
    Business_type NVARCHAR(255),
    Business_segment NVARCHAR(255),
    Origin NVARCHAR(255)
);


-- =============================================================================
-- FACT TABLES
-- These tables store the measurements, metrics, and facts of a business process.
-- They are created last as they have foreign key relationships to the dimensions.
-- =============================================================================

-- fact_payment
IF OBJECT_ID('dbo.fact_payment', 'U') IS NOT NULL
    DROP TABLE fact_payment
CREATE TABLE fact_payment (
    order_id NVARCHAR(255),
    payment_sequential INT,
    Order_Details_FK INT FOREIGN KEY REFERENCES  dim_order_details(Order_Details_SK),
    Payment_Type_FK INT FOREIGN KEY REFERENCES  dim_payment_type(Payment_SK),
    payment_installments INT,
    payment_value FLOAT,
    CONSTRAINT PK_order_payment PRIMARY KEY (order_id, payment_sequential)
)

-- Fact Table: Sales
-- Granularity: One row per product line item on an order.
IF OBJECT_ID('dbo.[fact_sales]', 'U') IS NOT NULL
    DROP TABLE fact_sales
CREATE TABLE [fact_sales] (
    -- Foreign Keys to Dimensions
    Product_FK INT FOREIGN KEY REFERENCES [dim_products](Product_SK),
    Customer_FK INT FOREIGN KEY REFERENCES [dim_customers](Customer_SK),
    Seller_FK INT FOREIGN KEY REFERENCES [dim_sellers](Seller_SK),
    order_purchase_date_FK INT FOREIGN KEY REFERENCES [dim_date](Date_SK),
    Order_Details_FK INT FOREIGN KEY REFERENCES [dim_order_details](Order_Details_SK),
    Time_FK INT FOREIGN KEY REFERENCES [dim_time](TimeKey),

    -- Degenerate Dimensions (Descriptive attributes from the transaction, stored in the fact table)
    Order_id NVARCHAR(255) NOT NULL,
    Order_item_id INT NOT NULL,

    -- Measures (The numeric values we want to analyze)
    order_payment_approval_time INT,      -- approved_at - purchase_timestamp (hours)
    order_seller_fulfillment_time INT,    -- delivered_carrier_date - approved_at (days)
    order_shipping_time INT,              -- delivered_customer_date - delivered_carrier_date (days)
    order_total_delivery_time INT,        -- delivered_customer_date - purchases_timestamp (days)
    order_delivery_delay INT,             -- delivered_customer_date - estimated_delivery_date (days)
    order_review_response_time INT,       -- review_answer_timestamp - review_creation_date (days)
    order_review_score INT,

    item_price DECIMAL(18, 2),
    item_freight DECIMAL(18, 2),
    
    -- Composite Primary Key to uniquely identify each row
    PRIMARY KEY (Order_id, Order_item_id)
);
GO

-- Fact Table: Leads
-- Granularity: One row per won deal.
IF OBJECT_ID('dbo.[fact_marketing_leads]', 'U') IS NOT NULL
    DROP TABLE [fact_marketing_leads]
CREATE TABLE [fact_marketing_leads] (
    -- Primary Key (using the business key directly as it's unique per event)
    Mql_id NVARCHAR(255) PRIMARY KEY,

    -- Foreign Keys to Dimensions
    Lead_FK INT FOREIGN KEY REFERENCES [dim_leads](lead_SK),
    Seller_FK INT FOREIGN KEY REFERENCES [dim_sellers](Seller_SK),
    Sdr_Employee_FK INT FOREIGN KEY REFERENCES [dim_sales_rep](Sales_Rep_SK), -- Role-playing dimension
    Sr_Employee_FK INT FOREIGN KEY REFERENCES [dim_sales_rep](Sales_Rep_SK),  -- Role-playing dimension
    Won_Date_FK INT FOREIGN KEY REFERENCES [dim_date](Date_SK),
	Landing_page_id NVARCHAR(255),

    -- Measures
    Lead_to_Win_Days INT,
    lead_closed BIT,
    Declared_monthly_revenue DECIMAL(18, 2),
    product_catalog_size INT,
);

