-- 1. For each product, show the ProductName column from the Products table and its total ordered quantity (Quantity column) from the Order_Details table. Display the Quantity as 'TotalOrderedProductQuantity'. Show the results ordered from the highest value to the lowest for the 'TotalOrderedProductQuantity'. Finally, display the top 3 most ordered products.

SELECT 
      products.ProductName, 
      SUM(order_details.Quantity) AS TotalOrderedProductQuantity
FROM
     products
JOIN
     order_details
ON 
     products.ProductID = order_details.ProductID
GROUP BY 
     products.ProductName
ORDER BY 
     TotalOrderedProductQuantity DESC
LIMIT 3;

-- 2. For each employee, display their first and last name (FirstName and LastName columns) from the Employees table and the number of orders they have received (OrderID column).

SELECT 
    employees.FirstName, 
    employees.LastName, 
    COUNT(orders.OrderID) AS NumberOfOrders
FROM
    employees
JOIN
    orders
ON 
    employees.EmployeeID = orders.EmployeeID
GROUP BY 
    employees.EmployeeID
ORDER BY COUNT(orders.OrderID) DESC;

-- 3. Join the following tables: Products, Categories, and Suppliers.

SELECT products.ProductName, categories.CategoryName, suppliers.SupplierName, suppliers.City, suppliers.Country
FROM products
JOIN categories
ON products.CategoryID = categories.CategoryID
JOIN suppliers
ON products.SupplierID = suppliers.SupplierID;

-- 4. Display the customer name (CustomerName column) from the Customers table and the number of orders they have placed. Then, show the employee with the most orders.

SELECT customers.CustomerName, COUNT(orders.OrderID) AS Total_Orders
FROM customers
JOIN orders
ON customers.CustomerID = orders.CustomerID
GROUP BY customers.CustomerName
ORDER BY COUNT(orders.OrderID) DESC;

-- 5. Display the number of orders for the shipper (ShipperName column) from the Shippers table with ID 1 (ShipperID column) and for employees (FirstName and LastName columns) from the Employees table with IDs between 5 and 10.

SELECT shippers.ShipperName, employees.FirstName, employees.LastName, COUNT(orders.OrderID) AS Total_Orders
FROM orders
JOIN shippers ON orders.ShipperID = shippers.ShipperID
JOIN employees ON orders.EmployeeID = employees.EmployeeID
WHERE orders.ShipperID = 1 AND orders.EmployeeID BETWEEN 5 AND 10
GROUP BY employees.FirstName, employees.LastName, shippers.ShipperName;

-- 6. Join the following tables: Products and Suppliers.

SELECT products.ProductName, suppliers.SupplierName
FROM products
JOIN suppliers
ON products.SupplierID = suppliers.SupplierID;

-- 7. Join the following tables: Customers, Employees, Shippers, and Orders.

SELECT *
FROM orders
JOIN customers ON orders.CustomerID = customers.CustomerID
JOIN employees ON orders.EmployeeID = employees.EmployeeID
JOIN shippers ON orders.ShipperID = shippers.ShipperID;

-- 8. For each product (ProductName column) from the Products table, show the total ordered quantity (Quantity column) from the Order_Details table.

SELECT products.ProductName, SUM(order_details.Quantity) AS Total_Quantity
FROM products
JOIN order_details ON products.ProductID = order_details.ProductID
GROUP BY products.ProductName;

-- 9. For each category (CategoryName column) from the Categories table, display the number of products whose price (ProductPrice column) from the Products table is higher than the average price of all products.

SELECT categories.CategoryName, COUNT(products.ProductID)
FROM categories
JOIN products
ON categories.CategoryID = products.CategoryID
WHERE products.Price > (SELECT AVG(products.Price) FROM products)
GROUP BY categories.CategoryName;

-- 10. Show the category name (CategoryName column) from the Categories table which has the highest average price (Price column) for products from the Products table.

SELECT categories.CategoryName, AVG(products.Price) AS Average_Price
FROM categories
JOIN products ON categories.CategoryID = products.CategoryID
GROUP BY categories.CategoryName
ORDER BY AVG(products.Price) DESC LIMIT 1;

-- 11. Display the shipper's name (ShipperName column) from the Shippers table and the number of orders they have processed from the Orders table.

SELECT shippers.ShipperName, COUNT(orders.OrderID) AS UkupnoPorudzbina FROM `orders` 
INNER JOIN shippers ON orders.ShipperID = shippers.ShipperID
GROUP BY orders.ShipperID;

-- 12. For each order (OrderID column) from the Orders table, show the total ordered quantity (Quantity column) from the Order_Details table where the quantity is greater than 40.

SELECT SUM(order_details.Quantity), orders.OrderID, orders.OrderDate FROM `order_details` 
INNER JOIN orders ON order_details.OrderID = orders.OrderID
GROUP BY order_details.OrderID
HAVING SUM(order_details.Quantity) > 50;

-- 13. Show the total ordered quantities (Quantity column) from the Order_Details table for products (ProductName column) from the Products table starting with 'a', 'd', or 'g' and with a price greater than 15.

SELECT products.ProductName, SUM(order_details.Quantity) AS TotalQuantity
FROM products
JOIN order_details ON products.ProductID = order_details.ProductID
WHERE    products.ProductName LIKE 'a%' 
      OR products.ProductName LIKE 'd%' 
	  OR products.ProductName LIKE 'g%'
      AND products.Price > 15
GROUP BY products.ProductName;
      
-- 14. Show the product name (ProductName column) for each product from the Products table and a new column 'ProductPrice' based on the quantity (Quantity column) from the Order_Details table and the price (Price column) of the product.

SELECT products.ProductName, order_details.Quantity,  products.Price, order_details.Quantity * products.Price AS TotalnaCena 
FROM `order_details`
INNER JOIN products ON order_details.ProductID = products.ProductID;

-- 15. Show orders in which customers (CustomerName column) from America, Germany, or France (Country column) from the Customers table participated, as well as employees (FirstName column) whose names start with 'a'. At the end, show the number of such orders per supplier (ShipperName column).

SELECT 
    COUNT(orders.OrderID) AS NumberOfOrders, 
    customers.CustomerName, 
    customers.Country, 
    employees.FirstName, 
    shippers.ShipperID, 
    shippers.ShipperName 
FROM 
    orders
INNER JOIN 
    customers ON orders.CustomerID = customers.CustomerID
INNER JOIN 
    employees ON orders.EmployeeID = employees.EmployeeID
INNER JOIN 
    shippers ON orders.ShipperID = shippers.ShipperID
WHERE 
    customers.Country IN ('USA', 'Germany', 'France') 
    AND employees.FirstName LIKE 'a%'
GROUP BY 
    shippers.ShipperID, customers.CustomerName, customers.Country, employees.FirstName, shippers.ShipperName;


-- 16. Show the maximum price of products (Price column) from the Products table for category 6 (CategoryID column) from the Categories table.

SELECT categories.CategoryName, MAX(products.Price) AS MAX FROM `products` 
INNER JOIN categories ON products.CategoryID = categories.CategoryID
WHERE categories.CategoryID = 6
GROUP BY products.CategoryID;

-- 17. Show the product name and ID (ProductName and ProductID columns) from the Products table and the number of orders (OrderID column) for the product where the quantity (Quantity column) is greater than the average quantity of the column.

SELECT products.ProductName, order_details.ProductID, COUNT(order_details.Quantity)   FROM `order_details` 
INNER JOIN products ON order_details.ProductID = products.ProductID
WHERE order_details.Quantity > (SELECT AVG(Quantity) FROM order_details)
GROUP BY order_details.ProductID;

-- 18. Show the addresses of suppliers (Address column) from the Suppliers table that start with the letter V and their categories (CategoryName column) from the Categories table that contain the letter 'T' in their name.

SELECT  suppliers.SupplierName, categories.CategoryName, suppliers.Address FROM `products` 
INNER JOIN suppliers ON products.SupplierID = suppliers.SupplierID
INNER JOIN categories ON products.CategoryID = categories.CategoryID
WHERE suppliers.Address LIKE 'v%' AND categories.CategoryName LIKE '%t%';

-- 19. Show the first and last names of employees (FirstName and LastName columns) from the Employees table and the number of orders (OrderID column) they have received from customers from Sweden, Mexico or Portugal (Country column) from the Customers table, in descending order.

SELECT 
    employees.FirstName, 
    employees.LastName, 
    COUNT(orders.OrderID) AS NumberOfOrders, 
    customers.Country
FROM 
    orders
INNER JOIN 
    employees ON orders.EmployeeID = employees.EmployeeID
INNER JOIN  
    customers ON orders.CustomerID = customers.CustomerID
WHERE 
    customers.Country IN ('Sweden', 'Mexico', 'Portugal')
GROUP BY 
    employees.EmployeeID, employees.FirstName, employees.LastName, customers.Country
ORDER BY 
    NumberOfOrders DESC;

-- 20. Show the first and last names (FirstName and LastName columns) from the Employees table who have had more than 12 orders.

SELECT employees.FirstName, employees.LastName, COUNT(orders.OrderID) AS Porudzbine FROM `orders` 
INNER JOIN employees ON orders.EmployeeID = employees.EmployeeID
GROUP BY orders.EmployeeID
HAVING Porudzbine > 12;

-- 21. Show the shipper's name (ShipperName column) from the Shippers table who has had the most orders from customers (Customer table) from England or Mexico (Country column).

SELECT shippers.ShipperName, COUNT(orders.OrderID) AS NumberOfOrders FROM `orders` 
INNER JOIN shippers ON orders.ShipperID = shippers.ShipperID
INNER JOIN customerS ON orders.CustomerID = customers.CustomerID
WHERE customers.Country = 'Mexico' OR customers.Country='UK'
GROUP BY orders.ShipperID
ORDER BY NumberOfOrders DESC
LIMIT 1;
