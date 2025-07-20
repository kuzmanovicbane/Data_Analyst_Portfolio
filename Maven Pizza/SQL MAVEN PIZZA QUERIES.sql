-- 1. Koji je ukupan broj porudžbina u bazi?

SELECT 
	COUNT(DISTINCT(orders.order_id))
FROM 
	orders

-- 2. Koji je prosečan prihod po porudžbini?

SELECT ROUND(AVG(order_total), 2) FROM (
  SELECT o.order_id, SUM(od.quantity * p.price) AS order_total
  FROM orders o
  JOIN order_details od ON o.order_id = od.order_id
  JOIN pizzas p ON od.pizza_id = p.pizza_id
  GROUP BY o.order_id
) AS per_order;

-- 3. Koliko ukupno prihoda je ostvareno po tipu pice?

SELECT 
	pt.category,
	ROUND(SUM(od.quantity*p.price),2) AS Total_Revenue
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
	pt.category
ORDER BY 
	ROUND(SUM(od.quantity*p.price),2) DESC

-- 4. Koji su top 5 najprodavanijih artikala po količini?

SELECT 
	pt.name,
	SUM(od.quantity) AS Total_Quantity
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
	pt.name
ORDER BY
	SUM(od.quantity) DESC
LIMIT 5

-- 5. Koji je dan sa najviše porudžbina?

SELECT 
	DAYOFWEEK(o.formatted_date) AS DayOfWeek,
	COUNT(DISTINCT(o.order_id)) AS Number_of_orders
FROM 
	orders o
GROUP BY 
	DAYOFWEEK(o.formatted_date)
ORDER BY 
	COUNT(DISTINCT(o.order_id)) DESC

-- 6. Koliko porudžbina je bilo po svakoj vrsti veličine pice?

SELECT 
	p.size,
	SUM(od.quantity) AS Total_Qty
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
	p.size
ORDER BY 
	SUM(od.quantity) DESC


-- 7. Koji su najčešći dodaci (toppings) koji se nalaze na picama koje su naručene više od 1000 puta?

SELECT 
	pt.ingredients,
	COUNT(od.pizza_id) AS Orders_of_Pizzas_Number
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
	pt.ingredients
HAVING
	COUNT(od.pizza_id) > 1000
ORDER BY 
	COUNT(od.pizza_id) DESC
    
-- 8. Koliko je ukupno pica prodato po vrstama pice?

SELECT 
	pt.name,
	SUM(od.quantity) AS TotalQTY
FROM 
	orders o
JOIN
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p 
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
	pt.name
ORDER BY 
	SUM(od.quantity) DESC
    
-- 9. Koliki je udeo svake vrste pice u ukupnom prihodu?

WITH SumedTotal_Revenue AS(
SELECT
	SUM(od.quantity*p.price) AS SummedTotalRevenue
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id)

SELECT 
	pt.name,
	ROUND(SUM(od.quantity*p.price),2) AS Total_Pizza_Revenue,
    str.SummedTotalRevenue AS SummedTotalRevenue,
    ROUND(SUM(od.quantity * p.price) / str.SummedTotalRevenue * 100, 2) AS Percent_in_TOTAL
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN 
	SumedTotal_Revenue str
GROUP BY
	pt.name, str.SummedTotalRevenue   
ORDER BY 
	ROUND(SUM(od.quantity * p.price) / str.SummedTotalRevenue * 100, 2) DESC

-- 10. Koji je prosečan broj pica po porudžbini?
WITH TotalQuantityPerOrder AS (
SELECT 
	od.order_id,
	SUM(od.quantity) AS TotalQtyPerOrder
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
	od.order_id)
SELECT
	AVG(tqpo.TotalQtyPerOrder) AS AverageTotalQtyPerOrder
FROM 
	TotalQuantityPerOrder 	tqpo
	
-- 11. Pronađi porudžbine koje su imale više od 5 različitih pica.

WITH TotalQuantityPerOrder AS (
SELECT 
	od.order_id,
	SUM(od.quantity) AS TotalQtyPerOrder
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
	od.order_id)
SELECT o.order_id
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
HAVING COUNT(DISTINCT od.pizza_id) > 5;
    
-- 12. Koji mesec ima najviši ukupan prihod i koliki je taj prihod?

SELECT 
	MONTH(o.formatted_date),
	ROUND(SUM(od.quantity*p.price),2) AS Total_Pizza_Revenue
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
	MONTH(o.formatted_date)  
ORDER BY
	ROUND(SUM(od.quantity*p.price),2) DESC
LIMIT 1

-- 13. Koja je prosečna cena po komadu pice po tipu (npr. veggie, classic, supreme)?

SELECT 
  pt.category,
  ROUND(SUM(od.quantity * p.price) / SUM(od.quantity), 2) AS Avg_Price_Per_Piece
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- 14. Koji je odnos porudžbina koje sadrže supreme pizze u odnosu na sve porudžbine?

WITH TotalOrders AS (
SELECT
	COUNT(o.order_id) AS TotalOrders
FROM
	orders o )
SELECT 
	pt.category,
	COUNT(o.order_id) AS Total_Pizza_Orders,
    tor.TotalOrders,
    COUNT(o.order_id)/tor.TotalOrders*100 AS Percent_of_Category
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN
	TotalOrders tor
WHERE pt.category = 'Supreme'
GROUP BY
	pt.category, tor.TotalOrders

-- 15. Napravi rang listu pica po prihodima, koristeći RANK() funkciju.

SELECT 
	pt.name,
	ROUND(SUM(od.quantity*p.price),2) AS Total_Revenue,
    RANK() OVER(ORDER BY ROUND(SUM(od.quantity*p.price),2) DESC) AS RevenueRANK
FROM 
	orders o
JOIN 
	order_details od
ON o.order_id = od.order_id
JOIN 
	pizzas p
ON od.pizza_id = p.pizza_id
JOIN 
	pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
	pt.name
ORDER BY 
	ROUND(SUM(od.quantity*p.price),2) DESC
    
-- 16. Koji dan u nedelji ima najviši prosek prihoda po porudžbini?

SELECT 
    WEEKDAY(order_revenues.formatted_date) AS day_of_week,
    ROUND(AVG(order_total), 2) AS avg_order_revenue
FROM (
    SELECT 
        o.order_id,
        o.formatted_date,
        SUM(od.quantity * p.price) AS order_total
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY o.order_id, o.formatted_date
) AS order_revenues
GROUP BY WEEKDAY(order_revenues.formatted_date)
ORDER BY avg_order_revenue DESC;


