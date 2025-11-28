CREATE database NORTHWIND_TRADERS;

ALTER TABLE categories
ADD CONSTRAINT pk_categories PRIMARY KEY (categoryID);

ALTER TABLE customers
MODIFY customerID VARCHAR(50) NOT NULL;

ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY (customerID);

ALTER TABLE employees
ADD CONSTRAINT pk_employees PRIMARY KEY (employeeID);

ALTER TABLE orders
ADD CONSTRAINT orders PRIMARY KEY (orderID);

ALTER TABLE products
ADD CONSTRAINT products PRIMARY KEY (productID);

ALTER TABLE shippers
ADD CONSTRAINT pk_shippers PRIMARY KEY (shipperID);

ALTER TABLE customers
MODIFY customerID VARCHAR(50) NOT NULL;

ALTER TABLE orders
MODIFY customerID VARCHAR(50) NOT NULL;

ALTER TABLE orders
ADD CONSTRAINT fk_orders
FOREIGN KEY (customerID) REFERENCES customers(customerID);

DELETE FROM employees
WHERE employeeID IS NULL;

DELETE FROM orders
WHERE employeeID IS NULL;

SELECT DISTINCT employeeID
FROM orders
WHERE employeeID NOT IN (SELECT employeeID FROM employees)
   OR employeeID IS NULL;

INSERT INTO employees (employeeID, employeeName, title, city, country, reportsTo)
VALUES (2, 'Andrew Fuller', 'Vice President Sales', 'New York', 'USA', NULL);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_employees
FOREIGN KEY (employeeID) REFERENCES employees(employeeID);

DELETE FROM shippers
WHERE shipperID IS NULL;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_shippers
FOREIGN KEY (shipperID) REFERENCES shippers(shipperID);

ALTER TABLE order_details
ADD CONSTRAINT fk_orders_details_orders
FOREIGN KEY (orderID) REFERENCES orders(orderID);

DELETE FROM products
WHERE productID IS NULL;

DELETE FROM categories
WHERE categoryID IS NULL;

ALTER TABLE order_details
ADD CONSTRAINT fk_orders_details_products
FOREIGN KEY (productID) REFERENCES products(productID);

ALTER TABLE products
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (categoryID) REFERENCES categories(categoryID);