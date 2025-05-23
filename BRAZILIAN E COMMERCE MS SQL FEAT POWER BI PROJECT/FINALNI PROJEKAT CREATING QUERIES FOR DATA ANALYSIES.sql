SELECT
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved, 
	COUNT(o.["order_id"]) AS Number_of_orders, 
	SUM(["price"]) AS Revenue, 
	SUM(["freight_value"]) AS FreightCosts,
	RANK() OVER (ORDER BY SUM(CAST(["price"] AS DECIMAL(10,2))) DESC) AS Revenue_Rank
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oit ON o.["order_id"] = oit.["order_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY YEAR (["order_approved_at"]), MONTH(["order_approved_at"])
ORDER BY YEAR (["order_approved_at"]), MONTH(["order_approved_at"]) ASC

-- CREATING VIEW FOR REVENUE AND COSTS BY YEARS AND MONTHS

CREATE VIEW Revenue_and_Costs_YEARSandMONTHS AS
SELECT
	YEAR(o.["order_approved_at"]) AS Year_Approved,
	MONTH(o.["order_approved_at"]) AS Month_Approved, 
	COUNT(o.["order_id"]) AS Number_of_orders, 
	SUM(oit.["price"]) AS Revenue, 
	SUM(oit.["freight_value"]) AS FreightCosts,
	RANK() OVER (ORDER BY SUM(CAST(oit.["price"] AS DECIMAL(10,2))) DESC) AS Revenue_Rank
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oit ON o.["order_id"] = oit.["order_id"]
WHERE YEAR(o.["order_approved_at"]) > 2016
GROUP BY 
	YEAR(o.["order_approved_at"]), 
	MONTH(o.["order_approved_at"]);

SELECT
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved, 
	COUNT(o.["order_id"]) AS Number_of_orders, 
	SUM(["price"]) AS Revenue, 
	SUM(["freight_value"]) AS FreightCosts,
	["product_category_name"]
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oit ON o.["order_id"] = oit.["order_id"]
LEFT JOIN olist_products_dataset p ON oit.["product_id"] = p.["product_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY ["product_category_name"], YEAR (["order_approved_at"]), MONTH(["order_approved_at"])
ORDER BY YEAR (["order_approved_at"]), MONTH(["order_approved_at"]) ASC

-- CREATING VIEW FOR REVENUE AND COSTS BY YEARS AND MONTHS BY PRUDUCT CATEGORIES

CREATE VIEW CATEGORIES_Revenue_and_Costs_YEARSandMONTHS AS
SELECT
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved, 
	COUNT(o.["order_id"]) AS Number_of_orders, 
	SUM(["price"]) AS Revenue, 
	SUM(["freight_value"]) AS FreightCosts,
	["product_category_name"]
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oit ON o.["order_id"] = oit.["order_id"]
LEFT JOIN olist_products_dataset p ON oit.["product_id"] = p.["product_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY ["product_category_name"], YEAR (["order_approved_at"]), MONTH(["order_approved_at"])

-- INSERTING NEW COLUMN LATE OR NOT LATE

ALTER TABLE olist_orders_dataset
ADD delivery_status VARCHAR(20);

UPDATE olist_orders_dataset
SET delivery_status =
				CASE 
					WHEN ["order_delivered_customer_date"] IS NULL THEN 'NOT DELIVERED'
					WHEN ["order_delivered_customer_date"] > ["order_estimated_delivery_date"] THEN 'LATE'
					ELSE 'NOT LATE'
				END

-- NIJE RESENO 
SELECT
	["customer_state"],
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved, 
	AVG(DATEDIFF(DAY, ["order_purchase_timestamp"], ["order_estimated_delivery_date"])) AS Avg_Estimated_Days,
	AVG(DATEDIFF(DAY, ["order_purchase_timestamp"], ["order_delivered_customer_date"])) AS Avg_Actual_Days
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c ON o.["customer_id"] = c.["customer_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY ["customer_state"], YEAR (["order_approved_at"]), MONTH(["order_approved_at"])

SELECT 
	["payment_type"],
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved,
	COUNT (["payment_type"]) AS numer_of_payments,
	SUM (["payment_value"]) AS Total_payment
FROM olist_orders_dataset ord
LEFT JOIN olist_order_payments_dataset pay ON ord.["order_id"] = pay.["order_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY ["payment_type"], YEAR (["order_approved_at"]), MONTH(["order_approved_at"])

-- VIEW FOR DIFFERENT PAYMENT TYPES BY YEARS AND MONTHS 

CREATE VIEW Payments_By_Years_and_Months AS
SELECT 
	["payment_type"],
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved,
	COUNT (["payment_type"]) AS numer_of_payments,
	SUM (["payment_value"]) AS Total_payment
FROM olist_orders_dataset ord
LEFT JOIN olist_order_payments_dataset pay ON ord.["order_id"] = pay.["order_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY ["payment_type"], YEAR (["order_approved_at"]), MONTH(["order_approved_at"])


-- PERCENT OF REPEATING CUSTOMERS

WITH Repeating_Customers AS (
    SELECT 
        c.["customer_id"],
        COUNT(o.["order_id"]) AS Number_of_orders
    FROM olist_orders_dataset o
    LEFT JOIN olist_customers_dataset c ON o.["customer_id"] = c.["customer_id"]
    GROUP BY c.["customer_id"]
    HAVING COUNT(o.["order_id"]) > 1
)
SELECT 
    (COUNT(DISTINCT Repeating_Customers.["customer_id"]) * 100.0) / 
    (SELECT COUNT(DISTINCT ["customer_id"]) FROM olist_orders_dataset) AS REPEATING_CUSTOMER_PERCENTAGE
FROM Repeating_Customers;

CREATE VIEW States_Revenue_Costs_and_Orders AS (
SELECT
	["customer_state"],
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved, 
	COUNT (o.["order_id"]) AS Number_of_Orders,
	SUM(["price"]) AS Revenue, 
	SUM(["freight_value"]) AS FreightCosts
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c ON o.["customer_id"] = c.["customer_id"]
LEFT JOIN olist_order_items_dataset oit ON o.["order_id"] = oit.["order_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY ["customer_state"], YEAR (["order_approved_at"]), MONTH(["order_approved_at"])
)


CREATE VIEW SellerState_Category_Orders_Revenue_Costs AS (
SELECT
	["seller_state"],
	["product_category_name"],
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved, 
	COUNT (o.["order_id"]) AS Number_of_Orders,
	SUM(["price"]) AS Revenue, 
	SUM(["freight_value"]) AS FreightCosts
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oit ON o.["order_id"] = oit.["order_id"]
LEFT JOIN olist_sellers_dataset s ON oit.["seller_id"] = s.["seller_id"]
LEFT JOIN olist_products_dataset p ON oit.["product_id"] = p.["product_id"]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY ["seller_state"],["product_category_name"], YEAR (["order_approved_at"]), MONTH(["order_approved_at"])
)

CREATE VIEW average_score_by_Month_and_Year AS (
SELECT 
	YEAR (["order_approved_at"]) AS Year_Approved,
	MONTH(["order_approved_at"]) AS Month_Approved,
	ROUND(AVG(review_score),2) AS AvgScore
FROM olist_orders_dataset ord
LEFT JOIN [dbo].[olist_reviews] rev ON ord.["order_id"] = rev.[order_id]
GROUP BY YEAR (["order_approved_at"]), MONTH(["order_approved_at"])
)

CREATE VIEW Score_Distribution_Years_Months AS (
SELECT 
    YEAR(ord.["order_approved_at"]) AS Year_Approved,
    MONTH(ord.["order_approved_at"]) AS Month_Approved,
    rev.review_score,
    COUNT(rev.review_score) AS number_of_same_score
FROM olist_orders_dataset ord
LEFT JOIN dbo.olist_reviews rev ON ord.["order_id"] = rev.[order_id]
WHERE YEAR (["order_approved_at"]) > 2016 
GROUP BY 
    YEAR(ord.["order_approved_at"]),
    MONTH(ord.["order_approved_at"]),
    rev.review_score
)


CREATE VIEW CALENDAR AS (
SELECT 
    YEAR(ord.["order_approved_at"]) AS Year_Approved,
    MONTH(ord.["order_approved_at"]) AS Month_Approved
FROM olist_orders_dataset ord
)