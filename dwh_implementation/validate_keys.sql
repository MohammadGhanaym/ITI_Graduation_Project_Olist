SELECT *
FROM dim_geolocation

SELECT *
FROM dim_customers
WHERE geo_key NOT IN(SELECT Geolocation_SK FROM dim_geolocation)


SELECT *
FROM dim_sellers
WHERE geo_key NOT IN(SELECT Geolocation_SK FROM dim_geolocation)

SELECT *
FROM dim_products

SELECT *
FROM dim_date


SELECT  *
FROM dim_leads

SELECT SUM(CAST(lead_closed as int))
FROM fact_marketing_leads

SELECT *
FROM fact_marketing_leads
WHERE declared_monthly_revenue IS NOT NULL

SELECT *
FROM dim_order_details

SELECT *
FROM dim_payment_type

SELECT *
FROM fact_payment
LEFT JOIN dim_payment_type
ON payment_type_fk = payment_sk


SELECT fs.order_item_id,
c.[Customer Full Name],
ds.[Seller Full Name],
od.order_status,
p.Product_name,
p.Product_category_name
FROM fact_sales fs
LEFT JOIN dim_customers c
ON fs.customer_fk = c.Customer_SK
LEFT JOIN dim_sellers ds
ON fs.seller_fk = ds.Seller_SK
LEFT JOIN dim_order_details od
ON fs.order_details_fk = od.order_details_sk
LEFT JOIN dim_products p
ON fs.product_fk = p.Product_SK


SELECT *
FROM dim_sales_rep

SELECT 
	fk.mql_id,
	fk.lead_closed,
	dl.lead_type,
	sr.sales_rep_name,
	s.[Seller Full Name]
FROM fact_marketing_leads fk
LEFT JOIN dim_leads dl
ON dl.lead_SK = fk.lead_FK
LEFT JOIN dim_sales_rep sr
ON sr.Sales_Rep_SK = fk.Sr_Employee_FK
LEFT JOIN dim_sellers s
ON s.seller_sk = fk.seller_fk


SELECT COUNT(Order_Details_SK)
FROM dim_order_details


SELECT customer_id, COUNT(*)
FROM fact_sales
GROUP BY customer_id
HAVING COUNT(*) > 1

SELECT DISTINCT state
FROM dim_geolocation

