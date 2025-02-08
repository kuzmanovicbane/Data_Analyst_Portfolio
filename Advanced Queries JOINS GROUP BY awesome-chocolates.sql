SELECT * FROM sales;

SELECT * FROM people;

SELECT s.SaleDate, s.Amount, p.Salesperson, s.SPID, p.spid
FROM sales AS s
JOIN people AS p ON s.SPID = p.SPID;

SELECT MONTH(s.SaleDate) AS WhichMonth, pr.Product, SUM(s.Amount)
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
GROUP BY MONTH(s.SaleDate), pr.Product
ORDER BY SUM(s.Amount) DESC;

SELECT MONTH(s.SaleDate) AS WhichMonth, p.Salesperson, pr.Product, SUM(s.Amount)
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
JOIN people AS p ON s.SPID = p.SPID
GROUP BY MONTH(s.SaleDate), pr.Product, p.Salesperson
ORDER BY SUM(s.Amount) DESC;

SELECT MONTH(s.SaleDate) AS WhichMonth, p.Salesperson, pr.Product, SUM(s.Amount)
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
JOIN people AS p ON s.SPID = p.SPID
WHERE pr.Product LIKE '%Choco%'
GROUP BY MONTH(s.SaleDate), pr.Product, p.Salesperson
ORDER BY SUM(s.Amount) DESC;

SELECT MONTH(s.SaleDate) AS WhichMonth, p.Salesperson, pr.Product, g.Geo, SUM(s.Amount) AS Total_Amount, SUM(s.Boxes) AS Total_Quantity
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
JOIN people AS p ON s.SPID = p.SPID
JOIN geo AS g ON s.GeoID = g.GeoID
GROUP BY MONTH(s.SaleDate), pr.Product, p.Salesperson, g.Geo
ORDER BY SUM(s.Amount) DESC;

SELECT s.SaleDate, s.Amount, p.Salesperson, s.SPID, p.spid
FROM sales AS s
JOIN people AS p ON s.SPID = p.SPID;

SELECT MONTH(s.SaleDate) AS WhichMonth, pr.Product, SUM(s.Amount)
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
GROUP BY MONTH(s.SaleDate), pr.Product
ORDER BY SUM(s.Amount) DESC;

SELECT MONTH(s.SaleDate) AS WhichMonth, p.Salesperson, pr.Product, SUM(s.Amount)
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
JOIN people AS p ON s.SPID = p.SPID
GROUP BY MONTH(s.SaleDate), pr.Product, p.Salesperson
ORDER BY SUM(s.Amount) DESC;

SELECT MONTH(s.SaleDate) AS WhichMonth, p.Salesperson, pr.Product, SUM(s.Amount)
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
JOIN people AS p ON s.SPID = p.SPID
WHERE pr.Product LIKE '%Choco%'
GROUP BY MONTH(s.SaleDate), pr.Product, p.Salesperson
ORDER BY SUM(s.Amount) DESC;

SELECT MONTH(s.SaleDate) AS WhichMonth, p.Salesperson, pr.Product, g.Geo, SUM(s.Amount) AS Total_Amount, SUM(s.Boxes) AS Total_Quantity
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
JOIN people AS p ON s.SPID = p.SPID
JOIN geo AS g ON s.GeoID = g.GeoID
WHERE g.Region = 'Europe'
GROUP BY MONTH(s.SaleDate), pr.Product, p.Salesperson, g.Geo
ORDER BY SUM(s.Amount) DESC;

SELECT MONTH(s.SaleDate) AS WhichMonth, pr.Product, g.Geo, SUM(s.Amount) AS Total_Amount, SUM(s.Boxes) AS Total_Quantity
FROM sales AS s
JOIN products AS pr ON s.PID = pr.PID
JOIN geo AS g ON s.GeoID = g.GeoID
WHERE g.Region = 'Americas'
GROUP BY MONTH(s.SaleDate), pr.Product, g.Geo
ORDER BY SUM(s.Amount) DESC;

SELECT g.Geo, ROUND(AVG(s.Customers)) AS Average_Customers, SUM(s.Customers) AS Total_Customers
FROM sales AS s
JOIN geo AS g ON s.GeoID = g.GeoID
GROUP BY g.Geo 
ORDER BY ROUND(AVG(s.Customers)) DESC;

SELECT g.Geo, ROUND(AVG(s.Customers)) AS Average_Customers, SUM(s.Customers) AS Total_Customers
FROM sales AS s
JOIN geo AS g ON s.GeoID = g.GeoID
GROUP BY g.Geo HAVING g.Geo LIKE '%Ind%'
ORDER BY ROUND(AVG(s.Customers)) DESC;





