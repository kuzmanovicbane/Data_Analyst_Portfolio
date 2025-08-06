CREATE VIEW PivotPizzaCategoryRevenue AS 
SELECT
    YEAR(sub.formatted_date) AS order_year,
    MONTH(sub.formatted_date) AS order_month,
    SUM(CASE WHEN sub.category = 'Chicken' THEN sub.TotalRevenue ELSE 0 END) AS ChickenRevenue,
    SUM(CASE WHEN sub.category = 'Classic' THEN sub.TotalRevenue ELSE 0 END) AS ClassicRevenue,
    SUM(CASE WHEN sub.category = 'Supreme' THEN sub.TotalRevenue ELSE 0 END) AS SupremeRevenue,
    SUM(CASE WHEN sub.category = 'Veggie' THEN sub.TotalRevenue ELSE 0 END) AS VeggieRevenue,
    SUM(sub.TotalRevenue) AS TotalSumRevenue
FROM 
(
    SELECT
        o.formatted_date,
        pt.category,
        (od.quantity * p.price) AS TotalRevenue
    FROM orders o 
    JOIN order_details od ON od.order_id = o.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
) AS sub
GROUP BY 
    YEAR(sub.formatted_date),
    MONTH(sub.formatted_date);



    


