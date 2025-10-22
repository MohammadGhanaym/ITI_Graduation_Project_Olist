-- geo_location
IF OBJECT_ID('dbo.geolocation', 'U') IS NOT NULL
    DROP TABLE geolocation
CREATE TABLE geolocation(
    geo_id INT PRIMARY KEY,
    zip_code_prefix INT,
    city NVARCHAR(255),
    [state] NVARCHAR(255)
)

-- customers
IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL
    DROP TABLE customers
CREATE TABLE customers (
    customer_id NVARCHAR(255) PRIMARY KEY,
    first_name NVARCHAR(255),
    last_name NVARCHAR(255),
    gender NVARCHAR(255),
    age INT,
    geo_id INT,
    CONSTRAINT FK_geo_id_customers
        FOREIGN KEY (geo_id)
        REFERENCES geolocation(geo_id)
)

-- sellers
IF OBJECT_ID('dbo.sellers', 'U') IS NOT NULL
    DROP TABLE sellers
CREATE TABLE sellers(
    seller_id NVARCHAR(255) PRIMARY KEY,
    seller_first_name NVARCHAR(255),
    seller_last_name NVARCHAR(255),
    gender NVARCHAR(255),
    geo_id INT,
        CONSTRAINT FK_geo_id_sellers
        FOREIGN KEY (geo_id)
        REFERENCES geolocation(geo_id)
)

-- orders
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL
    DROP TABLE orders
create table orders (
order_id NVARCHAR(255) Primary key,
order_status NVARCHAR(255),
order_purchase_timestamp datetime,
order_approved_at datetime,
order_delivered_carrier_date datetime,
order_delivered_customer_date datetime,
order_estimated_delivery_date datetime,
review_score INT,
review_comment_title NVARCHAR(500),
review_comment_message NVARCHAR(500),
review_creation_date datetime,
review_answer_timestamp datetime,
customer_id NVARCHAR(255),
CONSTRAINT FK_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
)


--products
-- orders
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL
    DROP TABLE products
CREATE TABLE products (
product_id NVARCHAR(255) PRIMARY KEY,
product_name NVARCHAR(255),  
brand NVARCHAR(255),  
category_name NVARCHAR(255),  
product_name_length INT,
product_description_length INT,
product_photos_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT,
product_width_cm INT
)

-- order_items
IF OBJECT_ID('dbo.order_items', 'U') IS NOT NULL
    DROP TABLE order_items
CREATE TABLE order_items (
    order_id NVARCHAR(255),
    order_item_id INT,
    product_id NVARCHAR(255),
    seller_id NVARCHAR(255),
    shipping_limit_date DATETIME,
    price FLOAT,
    freight_value FLOAT,
    CONSTRAINT PK_order_items PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT FK_prd_item FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CONSTRAINT FK_seller_item FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
)







-- marketing_qualified_leads (Done)
IF OBJECT_ID('dbo.marketing_qualified_leads', 'U') IS NOT NULL
    DROP TABLE marketing_qualified_leads
CREATE TABLE marketing_qualified_leads (
mql_id NVARCHAR(255) primary key,
first_contact_date date,
landing_page_id NVARCHAR (255),
origin NVARCHAR(255)
)



-- employees

IF OBJECT_ID('dbo.sales_rep', 'U') IS NOT NULL
    DROP TABLE sales_rep
CREATE TABLE sales_rep (

    sales_rep_id NVARCHAR(255) primary key,
    first_name NVARCHAR(255),
    last_name NVARCHAR(255),
    gender NVARCHAR(255),
    position NVARCHAR(255),
    facebook_user_id NVARCHAR(255)
)


-- order_payment
IF OBJECT_ID('dbo.order_payment', 'U') IS NOT NULL
    DROP TABLE order_payment
CREATE TABLE order_payment (
    order_id NVARCHAR(255),
    payment_sequential INT,
    payment_type NVARCHAR(255),
    payment_installments INT,
    payment_value FLOAT,
    provider NVARCHAR(255),

    CONSTRAINT PK_order_payment PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT FK_order_payment_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
)



-- closed_deals
IF OBJECT_ID('dbo.closed_deals', 'U') IS NOT NULL
    DROP TABLE closed_deals
CREATE TABLE closed_deals (
    mql_id NVARCHAR(255) PRIMARY KEY,
    seller_id NVARCHAR(255),
    sdr_id NVARCHAR(255),
    sr_id NVARCHAR(255),
    won_date DATE,
    business_segment NVARCHAR(255),
    lead_type NVARCHAR(255),
    lead_behavior_profile NVARCHAR(255),
    has_company BIT,
    business_type NVARCHAR(255),
    declared_monthly_revenue DECIMAL(18,2),
    product_catalog_size INT,

    CONSTRAINT FK_closed_deals_mql
        FOREIGN KEY (mql_id)
        REFERENCES marketing_qualified_leads(mql_id),

    CONSTRAINT FK_closed_deals_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id),

    CONSTRAINT FK_closed_deals_sdr
        FOREIGN KEY (sdr_id)
        REFERENCES sales_rep(sales_rep_id),

    CONSTRAINT FK_closed_deals_sr
        FOREIGN KEY (sr_id)
        REFERENCES sales_rep(sales_rep_id)
)