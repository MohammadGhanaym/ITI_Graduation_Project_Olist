
-- =================================================================
-- Step 1: Declare variables to hold the dynamic date range
-- =================================================================
DECLARE @MinDate DATE;
DECLARE @MaxDate DATE;

-- =================================================================
-- Step 2: Find the MIN and MAX dates from your source tables
-- This query checks both tables to find the earliest and latest possible dates.
-- =================================================================
SELECT
    @MinDate = MIN(DateValue),
    @MaxDate = MAX(DateValue)
FROM (
    -- Get all purchase timestamps from the orders table
    SELECT order_purchase_timestamp AS DateValue FROM olist_db.dbo.orders
    UNION ALL
    -- Get all won dates from the deals table
    SELECT won_date AS DateValue FROM olist_db.dbo.closed_deals
) AS AllDates;

-- =================================================================
-- Step 3: Create the dim_date table structure
-- =================================================================
IF OBJECT_ID('dbo.dim_date', 'U') IS NOT NULL
    DELETE FROM dim_date;

-- =================================================================
-- Step 4: Use a loop to populate the dim_date table using the variables
-- =================================================================
DECLARE @CurrentDate DATE = @MinDate;

WHILE @CurrentDate <= @MaxDate
BEGIN
    INSERT INTO [dim_date] (
        [Date_SK],
        [FullDate],
        [DayNumberOfWeek],
        [DayNameOfWeek],
        [DayNumberOfMonth],
        [MonthName],
        [MonthNumberOfYear],
        [Quarter],
        [Year]
    )
    VALUES (
        CONVERT(INT, CONVERT(VARCHAR(8), @CurrentDate, 112)), -- Creates YYYYMMDD key
        @CurrentDate,
        DATEPART(weekday, @CurrentDate),
        DATENAME(weekday, @CurrentDate),
        DATEPART(day, @CurrentDate),
        DATENAME(month, @CurrentDate),
        DATEPART(month, @CurrentDate),
        DATEPART(quarter, @CurrentDate),
        DATEPART(year, @CurrentDate)
    );

    SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
END;
GO