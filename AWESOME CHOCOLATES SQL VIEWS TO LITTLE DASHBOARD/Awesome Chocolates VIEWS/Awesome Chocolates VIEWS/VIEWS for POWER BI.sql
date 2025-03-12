CREATE VIEW Total_Per_Category AS
SELECT 
    SUM(sales.Amount) AS Total_Amount, 
    SUM(sales.Boxes) AS Total_Boxes, 
    products.Category, 
    MONTH(sales.SaleDate) AS SaleMonth
FROM 
    sales
JOIN 
    products
ON sales.PID = products.PID
GROUP BY 
    products.Category, MONTH(sales.SaleDate)
ORDER BY 
    SaleMonth ASC, Total_Amount DESC;
    
CREATE VIEW Total_Per_Team AS
SELECT 
    SUM(sales.Amount) AS Total_Amount, 
    SUM(sales.Boxes) AS Total_Boxes, 
    CASE 
        WHEN people.Team IS NULL OR people.Team = '' THEN 'OTHER TEAMS'
        ELSE people.Team
    END AS Team, 
    MONTH(sales.SaleDate) AS SaleMonth
FROM sales
JOIN people
ON sales.SPID = people.SPID
GROUP BY 
    CASE 
        WHEN people.Team IS NULL OR people.Team = '' THEN 'OTHER TEAMS'
        ELSE people.Team
    END,
    MONTH(sales.SaleDate)
ORDER BY 
    SaleMonth ASC, Total_Amount DESC;
    
CREATE VIEW total_per_country AS
SELECT 
    SUM(sales.Amount) AS Total_Amount, 
    SUM(sales.Boxes) AS Total_Boxes, 
    geo.Geo, 
    MONTH(sales.SaleDate) AS SaleMonth
FROM 
	sales
JOIN geo
ON	sales.GeoID = geo.GeoID
GROUP BY 
    geo.Geo, MONTH(sales.SaleDate)
ORDER BY 
    SaleMonth ASC, Total_Amount DESC;
    
CREATE VIEW calendar_table AS
SELECT 
	sales.SaleDate, 
    MONTH(sales.SaleDate) AS _Month_, 
    WEEKDAY(sales.SaleDate) + 1 AS _Weekday_, 
    DAYNAME(sales.SaleDate) AS _Day_Name_
FROM 
	sales;

