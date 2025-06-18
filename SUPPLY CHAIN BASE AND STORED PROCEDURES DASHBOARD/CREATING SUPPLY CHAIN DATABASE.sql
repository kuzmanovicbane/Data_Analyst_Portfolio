CREATE DATABASE USA_SUPPLY_CHAIN

SELECT * FROM accounts

ALTER TABLE accounts
ALTER COLUMN lat DECIMAL(9,6) 

ALTER TABLE accounts
ALTER COLUMN long DECIMAL(9,6)

SELECT * FROM orders

ALTER TABLE orders
ALTER COLUMN occurred_at DATE

ALTER TABLE orders
ALTER COLUMN standard_qty INT

ALTER TABLE orders
ALTER COLUMN gloss_qty INT

ALTER TABLE orders
ALTER COLUMN poster_qty INT

ALTER TABLE orders
ALTER COLUMN total INT

ALTER TABLE orders
ALTER COLUMN standard_amt_usd DECIMAL(10,2)

ALTER TABLE orders
ALTER COLUMN gloss_amt_usd DECIMAL(10,2)

ALTER TABLE orders
ALTER COLUMN poster_amt_usd DECIMAL(10,2)

ALTER TABLE orders
ALTER COLUMN poster_amt_usd DECIMAL(10,2)

ALTER TABLE orders
ALTER COLUMN total_amt_usd DECIMAL(10,2)

ALTER TABLE web_events 
ALTER COLUMN occurred_at DATE

ALTER TABLE accounts
ALTER COLUMN id INT NOT NULL

ALTER TABLE accounts
ADD CONSTRAINT PK_accounts_id PRIMARY KEY (id)

ALTER TABLE orders
ALTER COLUMN id INT NOT NULL

ALTER TABLE orders
ALTER COLUMN account_id INT NOT NULL

ALTER TABLE orders
ADD CONSTRAINT FK_orders_account_id
FOREIGN KEY (account_id) REFERENCES accounts(id) 

ALTER TABLE orders
ALTER COLUMN id INT NOT NULL

ALTER TABLE orders
ADD CONSTRAINT PK_orders_id PRIMARY KEY (id)

ALTER TABLE sales_rep
ALTER COLUMN id INT NOT NULL

ALTER TABLE sales_rep
ADD CONSTRAINT PK_sales_rep_id PRIMARY KEY (id)

ALTER TABLE sales_rep
ALTER COLUMN region_id INT 

ALTER TABLE region
ALTER COLUMN id INT NOT NULL

ALTER TABLE region
ADD CONSTRAINT PK_region_id PRIMARY KEY (id)

ALTER TABLE sales_rep
ADD CONSTRAINT FK_region_id_id
FOREIGN KEY (region_id) REFERENCES region(id)

ALTER TABLE accounts
ALTER COLUMN sales_rep_id INT NOT NULL

ALTER TABLE accounts
ADD CONSTRAINT FK_accounts_sales_rep_id
FOREIGN KEY (sales_rep_id) REFERENCES sales_rep(id)


ALTER TABLE web_events
ALTER COLUMN id INT NOT NULL

ALTER TABLE web_events
ALTER COLUMN account_id INT NOT NULL

ALTER TABLE web_events
ADD CONSTRAINT FK_web_events_account_id
FOREIGN KEY (account_id) REFERENCES accounts(id)
