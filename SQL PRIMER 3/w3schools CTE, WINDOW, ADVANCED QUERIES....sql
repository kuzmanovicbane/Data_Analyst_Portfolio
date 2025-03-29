-- RANKING OF TOTAL SOLD AMOUNT BY SHIPPER NAME, ALSO SHOW TOTAL QUANTITY SOLD

SELECT suppliers.SupplierName, 
       SUM(order_details.Quantity) AS Total_Quantity, 
       SUM(order_details.Quantity * products.Price) AS Total_Sold,
       RANK() OVER (ORDER BY SUM(order_details.Quantity * products.Price) DESC) AS RANKING
FROM order_details
JOIN products ON order_details.ProductID = products.ProductID
JOIN suppliers ON products.SupplierID = suppliers.SupplierID 
GROUP BY suppliers.SupplierName
ORDER BY RANKING ASC;

-- SHOW THE EMPLOYEES WITH BA UNIVERSETY TITLE WHO HAVE HAD THE HIGHEST TOTAL SOLD OF PRODUCTS BY SUPPLIER Aux joyeux ecclesiastiques, FOR THAT SAME EMPLOYEES SHOW COUNT OF DIFFERENT PRODUCTS THAT THEY HAVE SOLD IN ANOTHER QUERY. 

WITH BA_UNIVERSITY_TITLE_EMPLOYEES AS (
    SELECT *
    FROM employees
    WHERE Notes LIKE "%BA%"
)

SELECT 
    CONCAT(BA_UNIVERSITY_TITLE_EMPLOYEES.FirstName, ' ', BA_UNIVERSITY_TITLE_EMPLOYEES.LastName) AS Employee_Full_Name, 
    SUM(order_details.Quantity) AS Total_Quantity, 
    SUM(order_details.Quantity * products.Price) AS Total_Sold
FROM BA_UNIVERSITY_TITLE_EMPLOYEES
JOIN orders ON BA_UNIVERSITY_TITLE_EMPLOYEES.EmployeeID = orders.EmployeeID
JOIN order_details ON orders.OrderID = order_details.OrderID
JOIN products ON order_details.ProductID = products.ProductID
JOIN suppliers ON products.SupplierID = suppliers.SupplierID
WHERE suppliers.SupplierID = 18
GROUP BY CONCAT(BA_UNIVERSITY_TITLE_EMPLOYEES.FirstName, ' ', BA_UNIVERSITY_TITLE_EMPLOYEES.LastName);

WITH BA_UNIVERSITY_TITLE_EMPLOYEES AS (
    SELECT *
    FROM employees
    WHERE Notes LIKE "%BA%"
)

SELECT 
    CONCAT(BA_UNIVERSITY_TITLE_EMPLOYEES.FirstName, ' ', BA_UNIVERSITY_TITLE_EMPLOYEES.LastName) AS Employee_Full_Name,
	COUNT(DISTINCT order_details.ProductID) AS Number_of_product_types,
    RANK() OVER(ORDER BY COUNT(DISTINCT order_details.ProductID) DESC) AS RANKING
FROM BA_UNIVERSITY_TITLE_EMPLOYEES
JOIN orders ON BA_UNIVERSITY_TITLE_EMPLOYEES.EmployeeID = orders.EmployeeID
JOIN order_details ON orders.OrderID = order_details.OrderID
GROUP BY CONCAT(BA_UNIVERSITY_TITLE_EMPLOYEES.FirstName, ' ', BA_UNIVERSITY_TITLE_EMPLOYEES.LastName)
ORDER BY RANKING ASC;

-- SHOW TOTAL SOLD BY CATEGORIES DISTRIBUTED BY EVERY SHIPPER

SELECT categories.CategoryName,
       shippers.ShipperName,
       SUM(order_details.Quantity) AS Total_Quantity, 
       SUM(order_details.Quantity * products.Price) AS Total_Sold,
       CASE
           WHEN SUM(order_details.Quantity * products.Price) >= 20000 THEN "HIGH SELLING AMOUNT"
           WHEN SUM(order_details.Quantity * products.Price) >= 10000 THEN "MIDDLE SELLING AMOUNT"
           ELSE "SMALL SELLING AMOUNT"
       END AS Sales_Category
FROM order_details
JOIN products ON order_details.ProductID = products.ProductID
JOIN categories ON products.CategoryID = categories.CategoryID
JOIN orders ON order_details.OrderID = orders.OrderID
JOIN shippers ON orders.ShipperID = shippers.ShipperID
GROUP BY categories.CategoryID, shippers.ShipperID
ORDER BY categories.CategoryName, SUM(order_details.Quantity * products.Price) DESC;

-- SHOW TOTAL QUANTIY OF MEAT SOLD TO CUSTOMERS FROM SWEDEN

WITH 
MEAT_PRODUCTS AS (
    SELECT 
        products.ProductID, 
        products.ProductName, 
        products.CategoryID AS Meat_CategoryID,  -- Alias za CategoryID
        categories.CategoryName
    FROM products 
    JOIN categories ON products.CategoryID = categories.CategoryID 
    WHERE categories.CategoryName LIKE "%Meat%" OR categories.CategoryName LIKE "%meat%"
), 
SWEDEN_CUSTOMERS AS (
    SELECT *
    FROM customers
    WHERE customers.Country LIKE "Sweden"
)
SELECT 
    SWEDEN_CUSTOMERS.CustomerName, 
    SUM(order_details.Quantity) AS Total_Quantity_Sold
FROM order_details 
JOIN MEAT_PRODUCTS ON order_details.ProductID = MEAT_PRODUCTS.ProductID
JOIN orders ON order_details.OrderID = orders.OrderID
JOIN SWEDEN_CUSTOMERS ON orders.CustomerID = SWEDEN_CUSTOMERS.CustomerID
GROUP BY SWEDEN_CUSTOMERS.CustomerName;
