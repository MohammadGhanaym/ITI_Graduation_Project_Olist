# Olist E-Commerce Business Intelligence Project

This is our graduation project at ITI where we built a complete Business Intelligence solution for Olist, a Brazilian e-commerce company. We took the project from raw data all the way through to advanced analytics and interactive dashboards.

## What We Built

We worked with Olist's e-commerce data to create an end-to-end BI system that helps answer business questions about sales, customers, marketing campaigns, and payment trends. The project covers everything from database design to machine learning models.

## Project Flow

Here's how we approached this project, step by step:

### 1. Database Design (ERD)

**Folder:** `DB Physical Model/`

We started by designing the operational database structure. We mapped out all the entities and their relationships:
- Customers and their locations
- Sellers and where they operate
- Products with detailed attributes
- Orders and individual items
- Payments with installment details
- Marketing leads and sales reps
- Closed deals with business metrics

The diagrams show how everything connects - like how orders link to customers and sellers, how payments relate to orders, and how the marketing funnel works.

### 2. Building the Operational Database

**Folder:** `DB Implementation/`

Next, we implemented the actual database in SQL Server. The `db_ddl.sql` file creates all the tables with proper relationships and constraints. The main tables include:

- `geolocation` - Cities and states across Brazil
- `customers` - Customer demographics and info
- `sellers` - Seller profiles
- `products` - Product catalog
- `orders` - Order transactions with reviews
- `order_items` - Line items in each order
- `order_payment` - Payment details
- `marketing_qualified_leads` - Marketing data
- `sales_rep` - Sales team information
- `closed_deals` - Successfully closed deals

### 3. Data Prep and Cleaning

**File:** `Olist Data Prep.ipynb`

The raw Olist data needed some work. We used Python (pandas, numpy) to:
- Check data quality - finding nulls, duplicates, data type issues
- Enrich the dataset with the Faker library to generate realistic customer names, demographics, and seller info (since the original data was anonymized)
- Prepare everything for loading into our database

This notebook walks through the whole data assessment and enrichment process.

### 4. Loading the Data

**Folder:** `Loading Data into DB/`

We built SSIS packages to load all the prepared CSV files into SQL Server. These packages handle:
- Reading source files
- Data type conversions
- Error handling
- Loading data into the right tables

### 5. Data Warehouse Design

**Folder:** `DWH Schema/`

Instead of running analytics on the operational database (which would slow things down), we designed a separate data warehouse with dimensional modeling. We created three data marts:

**Sales Mart** - Everything related to product sales
**Marketing Mart** - Lead tracking and conversion metrics
**Payment Mart** - Payment methods and provider analysis

The schema uses both star and snowflake designs, with dimension tables like:
- `dim_customers` (with SCD Type 2 for tracking history)
- `dim_sellers` (also using SCD Type 2)
- `dim_products`
- `dim_geolocation` (snowflake design)
- `dim_date` and `dim_time` for time-based analysis
- `dim_order_details`
- `dim_payment_type`
- `dim_sales_rep`
- `dim_leads`

And fact tables capturing the metrics:
- `fact_sales` - Each line item in an order
- `fact_payment` - Payment transactions
- `fact_marketing_leads` - Marketing outcomes

### 6. Implementing the Data Warehouse

**Folder:** `DWH Implementation/`

We wrote SQL scripts to build the warehouse structure:
- `dwh_ddl.sql` creates all dimensions and facts
- `dim_date.sql` and `dim_time.sql` populate the time dimensions
- `staging table and SCD.sql` implements Slowly Changing Dimensions

For SCD, we used:
- **Type 1** for things that don't need history (like current age)
- **Type 2** for things we want to track over time (like when a customer moves). We use StartDate and EndDate columns to maintain the full history.

### 7. ETL Pipeline

**Folder:** `ETL using SSIS/dwh_creation/`

We built a comprehensive set of SSIS packages to move data from the operational database into the warehouse. There's a package for each dimension and fact table:

Dimension packages:
- `Dim_Date_Time.dtsx`
- `Dim_Geolocation_Sellers_Customers.dtsx`
- `Dim_Products.dtsx`
- `Dim_Order_Details.dtsx`
- `Dim_Payment_Type.dtsx`
- `Dim_Sales_Rep.dtsx`
- `Dim_Leads.dtsx`

Fact packages:
- `Fact_Sales.dtsx` - Calculates metrics like delivery times and review scores
- `Fact_Payment.dtsx`
- `Fact_Marketing_Leads.dtsx`

The `Master.dtsx` package runs everything in the right order - dimensions first (so we have the foreign keys ready), then facts.

### 8. OLAP Cubes (SSAS)

**Folder:** `Analysis in SSAS/Olist_DA/`

To make querying faster and enable multidimensional analysis, we built SSAS cubes:

**Sales Cube** - Slice and dice sales by product, customer, seller, time, geography
**Payment Cube** - Analyze payment methods, providers, installments
**Marketing Cube** - Track leads, conversions, and sales rep performance

We defined custom measures like:
- Conversion Rate = Closed Deals / Total Leads
- Average Deal Close Time = Total Days / Number of Deals

The `Filter.mdx` file shows examples of MDX queries for filtering and slicing the cube data.

### 9. Reports (SSRS)

**Folder:** `Reporting in SSRS/Olist_Reporting/`

We created professional paginated reports in SQL Server Reporting Services:

- Sales Performance by State
- Seller Performance
- Sales Rep Performance  
- Delivery Performance over Time
- Payment Provider Performance
- Marketing Channel Performance

These reports are interactive with parameters, drill-through features, and can be exported to PDF or Excel. They're scheduled to run automatically and get delivered to stakeholders.

### 10. Power BI Dashboard

**Folder:** `Analysis in Power BI/`

We built an interactive Power BI dashboard (`Olist_DA.pbix`) that pulls from our SSAS cubes and data warehouse. Users can explore the data themselves with filters and slicers, and the visuals update in real-time.

### 11. Market Basket Analysis

**File:** `market_basket_analysis.ipynb`

This was a fun part - we used the Apriori algorithm to find which products customers buy together. The notebook connects directly to the data warehouse using SQLAlchemy and runs association rule mining with the mlxtend library.

The results show things like "customers who buy product A also buy product B with 85% confidence." These insights help with:
- Product recommendations
- Bundle deals
- Store layout optimization
- Cross-selling strategies

We visualize the product associations using network graphs with networkx.

### 12. Sentiment Analysis (NLP)

**Files:** `Sentiment Analysis.ipynb` and `NLP1(BERT_model).ipynb`

We analyzed customer review comments (which are in Portuguese) to understand sentiment. The process:

1. Clean the text (remove URLs, special characters, extra spaces)
2. Remove Portuguese stopwords
3. Use TF-IDF to convert text to features
4. Train a Logistic Regression classifier
5. We also experimented with BERT models for better accuracy

This helps identify unhappy customers quickly and spot product quality issues before they become major problems.

## Tech Stack

**Databases:** SQL Server (for both OLTP and OLAP)

**ETL:** SQL Server Integration Services (SSIS)

**Multidimensional Analysis:** SQL Server Analysis Services (SSAS)

**Reporting:** SQL Server Reporting Services (SSRS)

**Visualization:** Power BI Desktop

**Programming:** Python with pandas, numpy, Faker, SQLAlchemy, scikit-learn, mlxtend, NLTK, matplotlib, seaborn, networkx

**Tools:** SQL Server Management Studio, Visual Studio with SSDT, Jupyter Notebook, Draw.io

## What We Learned

This project taught us the full lifecycle of a BI project:
- How to design databases properly with normalization
- Dimensional modeling with star and snowflake schemas
- Handling slowly changing dimensions
- Building robust ETL pipelines
- Optimizing for query performance
- Creating meaningful visualizations
- Applying machine learning to business problems

## Running the Project

If you want to set this up locally:

1. **Set up the operational database:** Run the scripts in `DB Implementation/`
2. **Prepare the data:** Run the `Olist Data Prep.ipynb` notebook
3. **Load the data:** Execute the SSIS packages in `Loading Data into DB/`
4. **Create the warehouse:** Run scripts in `DWH Implementation/`
5. **Run the ETL:** Execute the Master package in `ETL using SSIS/dwh_creation/`
6. **Deploy the cubes:** Open and deploy the SSAS project
7. **Set up reports:** Deploy the SSRS reports
8. **Open Power BI:** Connect to your warehouse and refresh the data
9. **Run analytics:** Open the Jupyter notebooks and update connection strings

You'll need SQL Server (with SSIS, SSAS, and SSRS), Power BI Desktop, Python 3.8+, and Visual Studio with SQL Server Data Tools.

## Team

This is our ITI graduation project. We learned a ton working through this end-to-end BI solution and applying everything from database fundamentals to machine learning.

---

Feel free to explore the code, and if you have any questions, open an issue!