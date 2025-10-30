/*
================================================================================
-- Author:         Sondos
-- Create date:    2025-10-14
-- Description:    Creates the complete schema for the Olist Data Warehouse,
--                 including all dimension and fact tables for both Sales and
--                 Marketing data marts.
================================================================================
*/

-- =============================================================================
-- DIMENSION TABLES
-- These tables describe the business entities (the "who, what, where, when").
-- They must be created before the fact tables.
-- =============================================================================

-- Dimension: Location
-- Purpose: Stores geographical information to be shared across customers and sellers.
-- This creates a snowflake schema design.
CREATE TABLE [Dim Location] (
    Location_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key for the dimension
    Geo_id NVARCHAR(50),                       -- Business Key from the source system
    City NVARCHAR(100),
    State NVARCHAR(50)
);
GO

-- Dimension: Customer
-- Purpose: Stores descriptive information about each unique customer.
CREATE TABLE [Dim Customer] (
    Customer_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    Customer_unique_id NVARCHAR(50) NOT NULL,    -- Business Key from the source system
    First_name NVARCHAR(100),
    Last_name NVARCHAR(100),
    Gender NVARCHAR(20),
    Location_FK INT FOREIGN KEY REFERENCES [Dim Location](Location_SK) -- Foreign key link to the location dimension
);
GO

-- Dimension: Seller
-- Purpose: Stores descriptive information about each unique seller.
CREATE TABLE [Dim Seller] (
    Seller_SK INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key
    Seller_id NVARCHAR(50) NOT NULL,           -- Business Key from the source system
    First_name NVARCHAR(100),
    Last_name NVARCHAR(100),
    Gender NVARCHAR(20),
    Location_FK INT FOREIGN KEY REFERENCES [Dim Location](Location_SK) -- Foreign key link to the location dimension
);
GO

-- Dimension: Product
-- Purpose: Stores descriptive information about each unique product.
CREATE TABLE [Dim Product] (
    Product_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    Product_id NVARCHAR(50) NOT NULL,  -- Business Key from the source system
	Product_name NVARCHAR(100),
	Product_brand NVARCHAR(100),
    Product_category_name NVARCHAR(100),
    Product_weight_g DECIMAL(18, 2),
    Product_length_cm DECIMAL(18, 2),
    Product_height_cm DECIMAL(18, 2),
    Product_width_cm DECIMAL(18, 2)
);
GO

-- Dimension: Date
-- Purpose: A standard date dimension for time-based analysis.
-- Note: This table needs to be populated manually or with a separate script.
CREATE TABLE [Dim Date] (
    Date_SK INT PRIMARY KEY,                  -- Smart key (e.g., 20251014), no IDENTITY
    FullDate DATE,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    DayOfWeek NVARCHAR(20)
);
GO

-- Dimension: Employee
-- Purpose: Stores information about employees (SDRs and SRs).
CREATE TABLE [Dim Employee] (
    Employee_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    Employee_id NVARCHAR(50) NOT NULL,         -- Business Key from a source system
    Employee_name NVARCHAR(200),
	Employee_gender NVARCHAR(200),
    Role NVARCHAR(100)
);
GO


-- Dimension: DealDetails
-- Purpose: Stores descriptive attributes of a closed deal.
CREATE TABLE [Dim Deal Details] (
    DealDetails_SK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    Business_segment NVARCHAR(100),
    Lead_type NVARCHAR(100),
    Lead_behavior_profile NVARCHAR(100),
    Business_type NVARCHAR(100),
    Origin NVARCHAR(100)
);
GO


-- =============================================================================
-- FACT TABLES
-- These tables store the measurements, metrics, and facts of a business process.
-- They are created last as they have foreign key relationships to the dimensions.
-- =============================================================================

-- Fact Table: Sales
-- Granularity: One row per product line item on an order.
CREATE TABLE [Fact Sales] (
    -- Foreign Keys to Dimensions
    Product_FK INT FOREIGN KEY REFERENCES [Dim Product](Product_SK),
    Customer_FK INT FOREIGN KEY REFERENCES [Dim Customer](Customer_SK),
    Seller_FK INT FOREIGN KEY REFERENCES [Dim Seller](Seller_SK),
    Date_FK INT FOREIGN KEY REFERENCES [Dim Date](Date_SK),

    -- Degenerate Dimensions (Descriptive attributes from the transaction, stored in the fact table)
    Order_id NVARCHAR(50) NOT NULL,
    Order_item_id INT NOT NULL,

    -- Measures (The numeric values we want to analyze)
    Price DECIMAL(18, 2),
    Freight DECIMAL(18, 2),

    -- Composite Primary Key to uniquely identify each row
    PRIMARY KEY (Order_id, Order_item_id)
);
GO

-- Fact Table: Leads
-- Granularity: One row per won deal.
CREATE TABLE [Fact Leads] (
    -- Primary Key (using the business key directly as it's unique per event)
    Mql_id NVARCHAR(50) PRIMARY KEY,

    -- Foreign Keys to Dimensions
    Lead_FK INT FOREIGN KEY REFERENCES [Dim Lead](Lead_SK),
    Seller_FK INT FOREIGN KEY REFERENCES [Dim Seller](Seller_SK),
    Sdr_Employee_FK INT FOREIGN KEY REFERENCES [Dim Employee](Employee_SK), -- Role-playing dimension
    Sr_Employee_FK INT FOREIGN KEY REFERENCES [Dim Employee](Employee_SK),  -- Role-playing dimension
    Won_Date_FK INT FOREIGN KEY REFERENCES [Dim Date](Date_SK),
    DealDetails_FK INT FOREIGN KEY REFERENCES [Dim Deal Details](DealDetails_SK),
	Landing_page_id NVARCHAR(50),
	First_contact_date DATETIME2,
    -- Measures
    Declared_monthly_revenue DECIMAL(18, 2)
);
GO