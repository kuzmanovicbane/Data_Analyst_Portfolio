-- Show the categories (CategoryName column) from the Categories table and all products for each category, where the prices (Price column) of the products are between 30 and 80.

SELECT 
    categories.CategoryName,
    GROUP_CONCAT(products.ProductName ORDER BY products.ProductName ASC) AS ProductList
FROM products
JOIN categories ON products.CategoryID = categories.CategoryID
WHERE products.Price BETWEEN 30 AND 80
GROUP BY categories.CategoryName;

-- For each customer (CustomerName column) from the Customers table, display the order date (OrderDate column) from the Orders table, the employee's first name (FirstName column) from the Employees table who received the order, and the name of the shipper (ShipperName column) from the Shippers table.

SELECT 
	customers.CustomerName,
    orders.OrderDate,
    employees.FirstName AS Employe,
    shippers.ShipperName
FROM
	orders
JOIN customers ON orders.CustomerID = customers.CustomerID
JOIN employees ON orders.EmployeeID = employees.EmployeeID
JOIN shippers ON orders.ShipperID = shippers.ShipperID;

-- Show the names of the suppliers (SupplierName column) from the suppliers table, number of products they supplying and in which of 3 categories they are: 1. TheMostProducts (who has shipped 5 products); 2. MiddleProducts (who has shipped 3-4 products), and 3. OneOrTwoProducts who has shipped 1-2 products.

SELECT 
    suppliers.SupplierName, 
    COUNT(products.ProductID) AS NumberOfProducts,
    CASE  
        WHEN COUNT(products.ProductID) = 5 THEN 'TheMostProducts'
        WHEN COUNT(products.ProductID) BETWEEN 3 AND 4 THEN 'MiddleProducts'
        WHEN COUNT(products.ProductID) BETWEEN 1 AND 2 THEN 'OneOrTwoProducts'
	END AS Number_of_supplying_products
FROM products
JOIN suppliers ON products.SupplierID = suppliers.SupplierID
GROUP BY suppliers.SupplierName;

-- Show categories where the average product price is greater than the overall average price of all products.

WITH Average_Product_Price AS (
    SELECT AVG(Price) AS AvgPrice FROM products
)
SELECT 
    categories.CategoryName,
    AVG(products.Price) AS Average_category_price
FROM 
    products
JOIN categories ON products.CategoryID = categories.CategoryID
GROUP BY 
    categories.CategoryName
HAVING 
    AVG(products.Price) > (SELECT AvgPrice FROM Average_Product_Price);

-- Show the total ordered quantity for each product, but only if the orders have a quantity (Quantity column) greater than 20.

SELECT 
	products.ProductName,
    SUM(order_details.Quantity) AS TotalOrders
FROM 
	order_details
JOIN products ON order_details.ProductID = products.ProductID
WHERE order_details.Quantity > 20
GROUP BY products.ProductID
ORDER BY SUM(order_details.Quantity) DESC;

-- Show the first and last names of employees who have participated in more than 15 orders.

SELECT
    employees.FirstName,
    employees.LastName,
    COUNT(orders.EmployeeID) AS NumberOfOrders
FROM orders
JOIN employees ON orders.EmployeeID = employees.EmployeeID
GROUP BY employees.EmployeeID
HAVING COUNT(orders.EmployeeID) > 15;

-- For category number 6, show the maximum price of all products.

SELECT 
	MAX(products.Price) AS MaxPrice, 
    categories.CategoryID, categories.CategoryName 
FROM products
INNER JOIN categories ON products.CategoryID = categories.CategoryID
WHERE products.CategoryID = 6
GROUP BY products.CategoryID;

-- Show the names of employees who have had more than 12 orders.

SELECT 
	employees.LastName, 
    employees.FirstName, 
    COUNT(orders.OrderID) 
FROM orders 
INNER JOIN employees ON orders.EmployeeID = employees.EmployeeID 
GROUP BY orders.EmployeeID 
HAVING COUNT(orders.OrderID) > 12;

-- Show whether the employee named Davolio or Fuller had more than 21 orders.

SELECT 
	employees.FirstName, 
    employees.LastName, 
    COUNT(orders.OrderID) AS NumberOfOrders 
FROM orders
INNER JOIN employees ON orders.EmployeeID = employees.EmployeeID
WHERE employees.LastName = 'Davolio' OR employees.LastName = 'Fuller'
GROUP BY orders.EmployeeID
HAVING NumberOfOrders > 21;

-- Show all products whose category description contains the word ‘Cheeses’ anywhere.

SELECT
	products.ProductName,
    categories.Description
FROM
	products
JOIN categories ON products.CategoryID = categories.CategoryID
WHERE categories.Description LIKE '%Cheeses%';

