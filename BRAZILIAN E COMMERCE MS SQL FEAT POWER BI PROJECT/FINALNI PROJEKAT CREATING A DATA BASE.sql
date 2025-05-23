-- CREATE DATABASE Brazilian_E_Commerce

SELECT * FROM olist_customers_dataset

SELECT * FROM olist_geolocation_dataset

SELECT * FROM olist_order_items_dataset

SELECT * FROM olist_order_payments_dataset

SELECT * FROM olist_orders_dataset

SELECT * FROM olist_products_dataset

SELECT * FROM olist_sellers_dataset

SELECT * FROM product_category_name_translation



ALTER TABLE dbo.olist_customers_dataset
ALTER COLUMN ["customer_id"] VARCHAR(255) NOT NULL;


ALTER TABLE dbo.olist_customers_dataset
ADD CONSTRAINT PK_Customers_customer_ID PRIMARY KEY (["customer_id"]);



ALTER TABLE olist_orders_dataset
ALTER COLUMN ["order_id"] VARCHAR(255) NOT NULL;

ALTER TABLE olist_orders_dataset
ADD CONSTRAINT PK_order_id PRIMARY KEY (["order_id"]);


ALTER TABLE olist_products_dataset
ALTER COLUMN ["product_id"] VARCHAR(255) NOT NULL;

ALTER TABLE olist_products_dataset
ADD CONSTRAINT PK_product_id PRIMARY KEY (["product_id"]);


ALTER TABLE product_category_name_translation
ALTER COLUMN [product_category_name] VARCHAR(255) NOT NULL;

ALTER TABLE product_category_name_translation
ADD CONSTRAINT PK_product_category PRIMARY KEY ([product_category_name]);

ALTER TABLE olist_sellers_dataset
ALTER COLUMN ["seller_id"] VARCHAR(255) NOT NULL;

ALTER TABLE olist_sellers_dataset
ADD CONSTRAINT PK_seller_id PRIMARY KEY (["seller_id"]);


ALTER TABLE olist_orders_dataset
ALTER COLUMN ["order_purchase_timestamp"] DATE;

ALTER TABLE olist_orders_dataset
ALTER COLUMN ["order_approved_at"] DATE;

ALTER TABLE olist_orders_dataset
ALTER COLUMN ["order_delivered_carrier_date"] DATE;

ALTER TABLE olist_orders_dataset
ALTER COLUMN ["order_delivered_customer_date"] DATE;

ALTER TABLE olist_orders_dataset
ALTER COLUMN ["order_estimated_delivery_date"] DATE;


ALTER TABLE olist_orders_dataset
ALTER COLUMN ["customer_id"] VARCHAR(255) NOT NULL

ALTER TABLE olist_order_payments_dataset
ALTER COLUMN ["order_id"] VARCHAR(255) NOT NULL

ALTER TABLE olist_order_items_dataset
ALTER COLUMN ["order_id"] VARCHAR(255) NOT NULL

ALTER TABLE olist_order_items_dataset
ALTER COLUMN ["product_id"] VARCHAR(255) NOT NULL

ALTER TABLE olist_order_items_dataset
ALTER COLUMN ["seller_id"] VARCHAR(255) NOT NULL

ALTER TABLE olist_products_dataset
ALTER COLUMN ["product_category_name"] VARCHAR(255) NOT NULL


-- 1. olist_orders_dataset.customer_id → olist_customers_dataset.customer_id
ALTER TABLE olist_orders_dataset
ADD CONSTRAINT FK_orders_customers
FOREIGN KEY (["customer_id"]) REFERENCES olist_customers_dataset(["customer_id"]);


-- 2. olist_order_payments_dataset."order_id" → olist_orders_dataset."order_id"
ALTER TABLE [olist_order_payments_dataset]
ADD CONSTRAINT [FK_payments_orders]
FOREIGN KEY (["order_id"]) REFERENCES [olist_orders_dataset] (["order_id"]);

-- 3. olist_order_items_dataset."order_id" → olist_orders_dataset."order_id"
ALTER TABLE [olist_order_items_dataset]
ADD CONSTRAINT [FK_items_orders]
FOREIGN KEY (["order_id"]) REFERENCES [olist_orders_dataset] (["order_id"]);

-- 4. olist_order_items_dataset."product_id" → olist_products_dataset."product_id"
ALTER TABLE [olist_order_items_dataset]
ADD CONSTRAINT [FK_items_products]
FOREIGN KEY (["product_id"]) REFERENCES [olist_products_dataset] (["product_id"]);

-- 5. olist_order_items_dataset."seller_id" → olist_sellers_dataset."seller_id"
ALTER TABLE [olist_order_items_dataset]
ADD CONSTRAINT [FK_items_sellers]
FOREIGN KEY (["seller_id"]) REFERENCES [olist_sellers_dataset] (["seller_id"]);


-- adding translation column in products

ALTER TABLE [olist_products_dataset]
ADD [product_category_translation] VARCHAR(255);

UPDATE p
SET p.[product_category_translation] = t.[product_category_name_english]
FROM [olist_products_dataset] p
LEFT JOIN [product_category_name_translation] t
    ON p.["product_category_name"] = t.[product_category_name];

UPDATE [olist_products_dataset]
SET [product_category_translation] = 'NO TRANSLATION'
WHERE [product_category_translation] IS NULL;

ALTER TABLE dbo.olist_order_items_dataset
ALTER COLUMN ["shipping_limit_date"] DATE

ALTER TABLE dbo.olist_order_items_dataset
ALTER COLUMN ["price"] DECIMAL(10,2)

ALTER TABLE dbo.olist_order_items_dataset
ALTER COLUMN ["freight_value"] DECIMAL(10,2)

ALTER TABLE dbo.olist_order_payments_dataset
ALTER COLUMN ["payment_installments"] int

ALTER TABLE dbo.olist_order_payments_dataset
ALTER COLUMN ["payment_value"] DECIMAL(10,2)



SELECT *
INTO olist_reviews
FROM [olist_order_reviews_dataset_exc$];

ALTER TABLE olist_reviews
ADD CONSTRAINT [FK_order_id_in_reviews]
FOREIGN KEY ([order_id]) REFERENCES [olist_orders_dataset] (["order_id"])

