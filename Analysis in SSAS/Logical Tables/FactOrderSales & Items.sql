
SELECT Order_id, Customer_FK, order_purchase_date_FK, Order_Details_FK, Time_FK,
    -- Use MAX() to get the single, non-duplicated value for each order
    MAX(order_payment_approval_time) AS order_payment_approval_time,
    MAX(order_seller_fulfillment_time) AS order_seller_fulfillment_time,
    MAX(order_shipping_time) AS order_shipping_time,
    MAX(order_total_delivery_time) AS order_total_delivery_time,
    MAX(order_delivery_delay) AS order_delivery_delay,
    MAX(order_review_response_time) AS order_review_response_time,
    MAX(order_review_score) AS order_review_score
FROM
    fact_sales
GROUP BY Order_id, Customer_FK, order_purchase_date_FK, Order_Details_FK, Time_FK