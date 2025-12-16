-- 1. Trend prodaje po proizvodima
-- 1. Sales trend by products
-- Pronađi top 5 proizvoda po rastu ukupnog prihoda mesec po mesec u poslednjih 12 meseci koristeći window funkcije.
-- Find the top 5 products by month-over-month revenue growth in the last 12 months using window functions.

WITH monthly_revenue_last_12 AS (
    SELECT
        p.productName,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        SUM(od.quantity * od.unitPrice) AS TotalRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN products p ON od.productID = p.productID
    WHERE o.orderDate >= '2014-06-01' AND o.orderDate <= '2015-05-31'
    GROUP BY p.productName, YEAR(o.orderDate), MONTH(o.orderDate)
),
products_revenue_growth AS (
		SELECT
			mr.productName,
			Year_,
			Month_,
			(TotalRevenue - LAG(TotalRevenue) OVER(PARTITION BY mr.productName ORDER BY Year_,Month_)) AS RevenueGrowth
		FROM 
			monthly_revenue_last_12 mr
		ORDER BY Year_, Month_
        )
SELECT
	prg.productName,
    SUM(IFNULL(RevenueGrowth,0)) AS TotalRevenueGrowth
FROM 
	products_revenue_growth prg
GROUP BY 
	prg.productName
LIMIT 5;

-- 2. Mesečna prodaja po zaposlenima
-- 2. Monthly sales by employees
-- Izračunaj mesečni rast prodaje po zaposlenima koristeći LAG funkciju.
-- Calculate monthly sales growth by employees using the LAG function.

WITH monthly_revenue_by_emplyees AS (
   SELECT
        e.employeeName,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        SUM(od.quantity * od.unitPrice) AS TotalRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN employees e ON o.employeeID = e.employeeID
    GROUP BY e.employeeName, YEAR(o.orderDate), MONTH(o.orderDate)
    )
SELECT
	mre.employeeName,
    Year_,
    Month_,
    TotalRevenue - LAG(TotalRevenue) OVER (PARTITION BY mre.employeeName ORDER BY Year_,Month_) AS RevenueGrowthYoY
FROM
	monthly_revenue_by_emplyees mre;

-- 3. Top kupci po prihodu
-- 3. Top customers by revenue
-- Pronađi top 10 kupaca po ukupnom prihodu u poslednjih 6 meseci koristeći CTE i ROW_NUMBER().
-- Find the top 10 customers by total revenue in the last 6 months using CTE and ROW_NUMBER().

WITH total_revenue_by_customers AS (
    SELECT
        c.companyName,
        SUM(od.quantity * od.unitPrice) AS TotalRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN customers c ON o.customerID = c.customerID
    GROUP BY c.companyName
)
SELECT
    trc.companyName,
    trc.TotalRevenue,
    ROW_NUMBER() OVER (ORDER BY trc.TotalRevenue DESC) AS ROWNUMBER
FROM 
	total_revenue_by_customers trc
ORDER BY 
	ROWNUMBER
LIMIT 
	10;



-- 4. Najprofitabilniji šiper
-- 4. Most profitable shipper
-- Odredi šipera sa najvećim neto prihodom po zemlji koristeći SUM() CASE(WHEN ) - pivot.
-- Identify the shipper with the highest net revenue per country using SUM() CASE(WHEN ) - pivot.

SELECT
	DISTINCT(c.country)
FROM
	customers c;

SELECT 
	s.companyName,
    SUM(CASE WHEN c.country = 'Germany' THEN  od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueGermany,
    SUM(CASE WHEN c.country = 'Mexico' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueMexico,
    SUM(CASE WHEN c.country = 'UK' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueUK,
    SUM(CASE WHEN c.country = 'Sweden' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueSweden,
    SUM(CASE WHEN c.country = 'France' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueFrance,
    SUM(CASE WHEN c.country= 'Spain' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueSpain,
    SUM(CASE WHEN c.country = 'Canada' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueCanada,
    SUM(CASE WHEN c.country = 'Argentina' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueArgentina,
    SUM(CASE WHEN c.country = 'Switzerland' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueSwitzerland,
    SUM(CASE WHEN c.country = 'Brazil' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueBrazil,
    SUM(CASE WHEN c.country = 'Austria' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueAustria,
    SUM(CASE WHEN c.country = 'Italy' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueItaly,
    SUM(CASE WHEN c.country = 'Portugal' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenuePortugal,
    SUM(CASE WHEN c.country = 'USA' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueUSA,
    SUM(CASE WHEN c.country = 'Venezuela' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueVenezuela,
    SUM(CASE WHEN c.country = 'Ireland' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueIreland,
    SUM(CASE WHEN c.country = 'Belgium' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueBelgium,
    SUM(CASE WHEN c.country = 'Norway' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueNorway,
    SUM(CASE WHEN c.country = 'Denmark' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueDenmark,
    SUM(CASE WHEN c.country = 'Finland' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenueFinland,
    SUM(CASE WHEN c.country = 'Poland' THEN od.quantity * od.unitPrice ELSE 0 END) AS TotalRevenuePoland
FROM orders o
LEFT JOIN 
	order_details od ON o.orderID = od.orderID
LEFT JOIN 
	customers c ON o.customerID = c.customerID
LEFT JOIN
	shippers s ON o.shipperID = s.shipperID
GROUP BY 
	s.companyName;

-- 5. Analiza prosečne količine po zaposlenom
-- 5. Average order quantity per employee analysis
-- Za svakog zaposlenog izračunaj prosečnu količinu narudžbi po mesecu i rangiraj ih po mesecu.
-- Calculate the average order quantity per employee per month and rank them by month.

   SELECT
        e.employeeName,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        AVG(od.quantity) AS AvgQuantitySold,
        RANK() OVER(ORDER BY AVG(od.quantity)) AS RANKING
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN employees e ON o.employeeID = e.employeeID
    GROUP BY e.employeeName, YEAR(o.orderDate), MONTH(o.orderDate)
    ORDER BY RANKING ASC;
    
-- 6. Kumulativni prihod po proizvodu
-- 6. Cumulative revenue by product
-- Prikaži kumulativni prihod po proizvodu kroz vreme koristeći SUM() OVER (ORDER BY ...).
-- Show cumulative revenue by product over time using SUM() OVER (ORDER BY ...).

WITH monthly_product_revenue AS (
    SELECT
        p.productName,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        SUM(od.quantity * od.unitPrice) AS MonthlyRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN products p ON od.productID = p.productID
    GROUP BY
        p.productName,
        YEAR(o.orderDate),
        MONTH(o.orderDate)
)
SELECT
    productName,
    Year_,
    Month_,
    MonthlyRevenue,
    SUM(MonthlyRevenue) OVER (
        PARTITION BY productName
        ORDER BY Year_, Month_
    ) AS CumulativeRevenue
FROM monthly_product_revenue
ORDER BY productName, Year_, Month_;

-- 7. Najveći skok prihoda po kategoriji
-- 7. Highest revenue jump by category
-- Pronađi kategoriju proizvoda koja je imala najveći rast / najmanji pad prihoda poslednjeg meseca u odnosu na prethodni mesec koristeći CTE i LAG().
-- Find the product category with the highest revenue growth / the lowest revenue fall of last month compared to the previous month using CTE and LAG().

WITH monthly_category_revenue AS (
    SELECT
        c.categoryName,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        SUM(od.quantity * od.unitPrice) AS MonthlyRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN products p ON od.productID = p.productID
    LEFT JOIN categories c ON p.categoryID = c.categoryID
    GROUP BY
        c.categoryName,
        YEAR(o.orderDate),
        MONTH(o.orderDate)
),
revenue_growth AS (
    SELECT
        categoryName,
        Year_,
        Month_,
        MonthlyRevenue,
        MonthlyRevenue - LAG(MonthlyRevenue) OVER (PARTITION BY categoryName ORDER BY Year_, Month_) AS MonthlyRevenueGrowth
    FROM monthly_category_revenue
)

SELECT *
FROM revenue_growth
WHERE (Year_, Month_) = (
    SELECT Year_, Month_
    FROM revenue_growth
    ORDER BY Year_ DESC, Month_ DESC
    LIMIT 1
)
ORDER BY MonthlyRevenue DESC
LIMIT 1;

-- 8. Prosečan prihod po kupcu i mesecu
-- 8. Average revenue per customer per month
-- Izračunaj prosečan prihod po kupcu po mesecu i rangiraj kupce unutar svake zemlje po proseku prihoda koristeći RANK().
-- Calculate average revenue per customer per month and rank customers within each country using RANK().

WITH customer_monthly_revenue AS (
    SELECT
        c.country,
        c.companyName,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        AVG(od.quantity * od.unitPrice) AS AvgRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN customers c ON o.customerID = c.customerID
    GROUP BY 
        c.country,
        c.companyName,
        YEAR(o.orderDate),
        MONTH(o.orderDate)
)

SELECT
    country,
    companyName,
    Year_,
    Month_,
    AvgRevenue,
    RANK() OVER (PARTITION BY country ORDER BY AvgRevenue DESC) AS Ranking
FROM customer_monthly_revenue
ORDER BY 
    country,
    Ranking;

-- 9. Efikasnost prodaje po jedinici tereta
-- 9. Sales and Freight Efficiency
-- Meseci kada je prihod po jedinici tovara bio najveci u svakoj zemlji
-- Months when revenue per freight unit was the highest for each country.

WITH order_totals AS (
    SELECT
        o.orderID,
        c.country,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        SUM(od.quantity * od.unitPrice) AS Revenue,
        o.freight AS Freight
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN customers c ON o.customerID = c.customerID
    GROUP BY 
        o.orderID,
        c.country,
        YEAR(o.orderDate),
        MONTH(o.orderDate),
        o.freight -- we must have one freight from orders paralel to SUM(od.quantity * od.unitPrice) from order_details (because of that it is in group by...)
),
monthly_revenue_per_freight AS (
    SELECT
        country,
        Year_,
        Month_,
        ROUND(SUM(Revenue) / SUM(Freight), 2) AS RevenuePerFreightUnit -- when we have one freight row to one Revenue row, it`s time for aggregation
    FROM order_totals
    GROUP BY 
        country,
        Year_,
        Month_
)

SELECT
    country,
    Year_,
    Month_,
    RevenuePerFreightUnit,
    RANK() OVER (PARTITION BY country ORDER BY RevenuePerFreightUnit DESC) AS RankingRevPerFreUnit
FROM monthly_revenue_per_freight
ORDER BY 
    country,
    RankingRevPerFreUnit;


-- 10. Najlošije prodavani proizvodi
-- 10. Worst-selling products
-- Prikaži top 5 proizvoda sa najmanjom količinom prodatih jedinica poslednjih 6 meseci koristeći CTE.
-- Show the top 5 products with the lowest sold quantity in the last 6 months using CTE.

WITH monthly_product_revenue AS (
    SELECT
        p.productName,
        SUM(od.quantity) AS TotalQuantity
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN products p ON od.productID = p.productID
    WHERE o.orderDate >= '2014-12-1' and o.orderDate <= '2015-5-31'
    GROUP BY
        p.productName
        )
SELECT
	*
FROM 
	monthly_product_revenue mpr
ORDER BY 
	mpr.TotalQuantity ASC
LIMIT 
	5;		

-- 11. Sezonska analiza prodaje
-- 11. Seasonal sales analysis
-- Izračunaj ukupan prihod po kvartalu i identifikuj sezonske trendove pivotirajuci po QUARTERima.
-- Calculate total revenue per quarter and identify seasonal trends pivoting quarters revenue per years.

WITH revenue_by_quarter_and_month AS (
    SELECT
        YEAR(o.orderDate) AS Year_,
        QUARTER(o.orderDate) AS Quarter_,
        ROUND(SUM(od.quantity * od.unitPrice),2) AS QuarterRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    GROUP BY
        YEAR(o.orderDate),
        QUARTER(o.orderDate)
)

SELECT 
	rqm.Year_,
    SUM(CASE WHEN Quarter_ = 1 THEN QuarterRevenue ELSE 0 END) AS Q1,
    SUM(CASE WHEN Quarter_ = 2 THEN QuarterRevenue ELSE 0 END) AS Q2,
    SUM(CASE WHEN Quarter_ = 3 THEN QuarterRevenue ELSE 0 END) AS Q3,
    SUM(CASE WHEN Quarter_ = 4 THEN QuarterRevenue ELSE 0 END) AS Q4
FROM
	revenue_by_quarter_and_month rqm
GROUP BY
	rqm.Year_
ORDER BY
	rqm.Year_;

-- 12. Retention kupaca
-- 12. Customer retention
-- Pronađi kupce koji su pravili narudžbine u 2014. godini, ali nisu u 2015. koristeći CTE i JOIN.
-- Find customers who placed orders last year but not this year using CTE and JOIN.

WITH customer_monthly_revenue_in_2015 AS (
    SELECT
        c.companyName,
        YEAR(o.orderDate) AS Year_,
        SUM(od.quantity * od.unitPrice) AS TotalRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN customers c ON o.customerID = c.customerID
    GROUP BY 
        c.companyName,
        YEAR(o.orderDate)
	HAVING 
		Year_ = 2015
),
customer_monthly_revenue_in_2014 AS (
	SELECT
        c.companyName,
        YEAR(o.orderDate) AS Year_,
        SUM(od.quantity * od.unitPrice) AS TotalRevenue
    FROM orders o
    LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN customers c ON o.customerID = c.customerID
    GROUP BY 
        c.companyName,
        YEAR(o.orderDate)
	HAVING 
		Year_ = 2014
)

SELECT
	*
FROM 
	customer_monthly_revenue_in_2014 cmr14
LEFT JOIN
	customer_monthly_revenue_in_2015 cmr15 ON cmr14.companyName = cmr15.companyName
WHERE 
	cmr15.companyName IS NULL
ORDER BY 
	cmr14.TotalRevenue DESC;

-- 13. Mesečni rast obrađenih proudzbina od strane zaposlenih
-- 13. Monthly growth of orders done by employees 
-- Prikaži koliko je zaposlenih obrađivalo narudžbina po mesecu i izračunaj mesečni rast broja narudzbina zaposlenih koristeći window funkcije.
-- Show the number of orders handling by employees per month and calculate monthly orders growth using window functions.

WITH orders_by_employees_months AS (
	SELECT
        e.employeeName,
        YEAR(o.orderDate) AS Year_,
        MONTH(o.orderDate) AS Month_,
        COUNT(o.orderID) AS TotalOrders
    FROM orders o
    LEFT JOIN employees e ON o.employeeID = e.employeeID
    GROUP BY 
		e.employeeName, 
        YEAR(o.orderDate), 
        MONTH(o.orderDate)
        )
SELECT
	oem.employeeName,
    Year_,
    Month_,
    TotalOrders,
    (TotalOrders - LAG(TotalOrders) OVER (PARTITION BY oem.employeeName ORDER BY Year_,Month_)) AS OrdersGrowthFall
FROM
	orders_by_employees_months oem
ORDER BY
	oem.employeeName,
    Year_,
    Month_;
    

-- 14. Najveći doprinos po zaposlenom
-- 14. Top contributor per employee
-- Za svaku godinu prikaži zaposlenog koji je generisao najveći prihod koristeći CTE i RANK() OVER(PARTITION BY YEAR).
-- For each year, show the employee generating the highest revenue using CTE and RANK() OVER(PARTITION BY YEAR).

WITH revenue_per_name_in_years AS (
	SELECT
		e.employeeName,
		YEAR(o.orderDate) AS Year_,
		ROUND(SUM(od.quantity * od.unitPrice),2) AS TotalRevenue
	FROM orders o
	LEFT JOIN order_details od ON o.orderID = od.orderID
	LEFT JOIN employees e ON o.employeeID = e.employeeID
	GROUP BY 
		e.employeeName, 
		YEAR(o.orderDate)
        )
SELECT
	employeeName,
	Year_,
	TotalRevenue,
    RANK() OVER(PARTITION BY Year_ ORDER BY TotalRevenue DESC) AS RANKING_REVENUE_IN_EVERY_YEAR
FROM 
	revenue_per_name_in_years
GROUP BY
	employeeName,
	Year_,
	TotalRevenue;
       
-- 15. Analiza tezine tovara po kupcu
-- 15. Freight analysis per customer
-- Pronađi prosečanu tezinu tovara po kupcu po mesecu i identifikuj kupce sa iznadprosečnim tovarom koristeći CTE.
-- Find average freight per customer per month and identify customers with above-average freight using CTE.

WITH CustomerMonthlyAverageFreight AS (
	SELECT
		c.companyName,
        YEAR(orderDate) as Year_,
        MONTH(orderDate) as Month_,
        AVG(freight) as AverageFreight
	FROM 
		orders o 
	LEFT JOIN 
		customers c ON o.customerID = c.customerID
	GROUP BY
		c.companyName,
        YEAR(orderDate),
        MONTH(orderDate)
        ),
    MonthlyAverageFreight AS (
	SELECT
        YEAR(orderDate) as Year_,
        MONTH(orderDate) as Month_,
        AVG(freight) as AverageFreight
	FROM 
		orders o 
	GROUP BY
        YEAR(orderDate),
        MONTH(orderDate)
        )

SELECT
	cmaf.companyName,
    cmaf.Year_,
	cmaf.Month_,
	cmaf.AverageFreight,
    maf.AverageFreight AS AverageFreightForAll
FROM 
	CustomerMonthlyAverageFreight cmaf
CROSS JOIN
	 MonthlyAverageFreight maf ON cmaf.Year_ = maf.Year_ AND cmaf.Month_ = maf.Month_ AND cmaf.AverageFreight > maf.AverageFreight
ORDER BY
	cmaf.Year_,
    cmaf.Month_,
    cmaf.companyName;
	

