
-- Prep Fact Sales Source
SELECT * FROM (
SELECT
	product_id,
	customer_id,
	seller_id,
	CONVERT(INT, CONVERT(VARCHAR(8), CONVERT(DATE, order_purchase_timestamp), 112)) purchase_date_FK,
	CAST(FORMAT(DATEADD(MINUTE, DATEDIFF(MINUTE, 0, order_purchase_timestamp), 0), 'HHmmss') AS INT) AS TimeKey,
	o.order_id,
	i.order_item_id,
	DATEDIFF(HOUR, order_purchase_timestamp, order_approved_at) order_payment_approval_time,
	DATEDIFF(DAY, order_approved_at, order_delivered_carrier_date) order_seller_fulfillment_time,
	DATEDIFF(DAY, order_delivered_carrier_date, order_delivered_customer_date) order_shipping_time,
	DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) order_total_delivery_time,
	DATEDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date) order_delivery_delay,
	DATEDIFF(DAY, review_creation_date, review_answer_timestamp) order_review_response_time,
	review_score,
	i.price,
	i.freight_value
FROM order_items i
LEFT JOIN orders o
ON i.order_id = o.order_id
) fact
LEFT JOIN olist_dwh.dbo.dim_time tm
ON tm.TimeKey = fact.Timekey
LEFT JOIN olist_dwh.dbo.dim_date dt
ON dt.Date_SK = fact.purchase_date_FK



-- Prep Fact Marketing Lead
SELECT * FROM
(
SELECT 
	ql.mql_id,
	seller_id,
	sdr_id,
	sr_id,
	cd.lead_type,				-- Will be used to get the Lead_SK
	cd.lead_behavior_profile,	-- Will be used to get the Lead_SK
	cd.business_segment,		-- Will be used to get the Lead_SK
	cd.business_type,			-- Will be used to get the Lead_SK
	ql.origin,					-- Will be used to get the Lead_SK
	ql.landing_page_id,
	CONVERT(INT, CONVERT(VARCHAR(8), CONVERT(DATE, won_date), 112)) won_date_key,
	DATEDIFF(DAY, first_contact_date, won_date) deal_close_time,
	CASE WHEN cd.mql_id IS NULL THEN 0 ELSE 1 END lead_closed,
	declared_monthly_revenue,
	product_catalog_size
FROM marketing_qualified_leads ql
LEFT JOIN closed_deals cd
ON ql.mql_id = cd.mql_id
) fact
LEFT JOIN olist_dwh.dbo.dim_date dt
ON dt.Date_SK = fact.won_date_key


-- dim lead
SELECT DISTINCT 
	business_segment, 
	business_type, 
	lead_type, 
	lead_behavior_profile, 
	origin
FROM marketing_qualified_leads ql
LEFT JOIN closed_deals  cd
ON ql.mql_id = cd.mql_id


-- dim order details
SELECT
	order_id, 
	order_status,
	review_comment_title, 
	review_comment_message
FROM orders

-- dim payment_type
SELECT DISTINCT
	REPLACE(UPPER(LEFT(payment_type,1)) + LOWER(SUBSTRING(payment_type,2,LEN(payment_type))), '_', ' ') payment_type,
	[provider]
FROM order_payment
WHERE payment_type != 'not_defined'



