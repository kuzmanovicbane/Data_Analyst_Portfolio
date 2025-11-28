-- SALES THROUGHT TIME

CREATE VIEW sales_throuht_time AS (
	SELECT 
		YEAR(o.orderDate) as Year_,
		MONTH(o.orderDate) as Month_,
		SUM(od.quantity) as TotalQuantity,
		SUM(od.quantity * od.unitPrice) as TotalRevenue,
		SUM(o.freight) as TotalFreightCosts,
		SUM(od.quantity * od.unitPrice) - SUM(o.freight) as TotalNetRevenue
	FROM orders o
	LEFT JOIN order_details od ON o.orderID = od.orderID
	GROUP BY 
		YEAR(o.orderDate),
		MONTH(o.orderDate)
);

-- CATEGORIES OF PRODUCTS THROUGHT TIME

CREATE VIEW product_categories_throuht_time AS (
	SELECT
		c.categoryName,
		YEAR(o.orderDate) as Year_,
		MONTH(o.orderDate) as Month_,
		SUM(od.quantity) as TotalQuantity,
		SUM(od.quantity * od.unitPrice) as TotalRevenue,
		SUM(o.freight) as TotalFreightCosts,
		SUM(od.quantity * od.unitPrice) - SUM(o.freight) as TotalNetRevenue
	FROM orders o
	LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN products p ON od.productID = p.productID
    LEFT JOIN categories c ON p.categoryID = c.categoryID
	GROUP BY 
		c.categoryName,
		YEAR(o.orderDate),
		MONTH(o.orderDate)
);

-- PRODUCTS THROUGHT TIME

CREATE VIEW products_throuht_time AS (
	SELECT
		p.productName,
		YEAR(o.orderDate) as Year_,
		MONTH(o.orderDate) as Month_,
		SUM(od.quantity) as TotalQuantity,
		SUM(od.quantity * od.unitPrice) as TotalRevenue,
		SUM(o.freight) as TotalFreightCosts,
		SUM(od.quantity * od.unitPrice) - SUM(o.freight) as TotalNetRevenue
	FROM orders o
	LEFT JOIN order_details od ON o.orderID = od.orderID
    LEFT JOIN products p ON od.productID = p.productID
    LEFT JOIN categories c ON p.categoryID = c.categoryID
	GROUP BY 
		p.productName,
		YEAR(o.orderDate),
		MONTH(o.orderDate)
);

-- CUSTOMERS THROUGHT TIME

CREATE VIEW customers_throught_time AS (
SELECT
		c.companyName,
        c.city,
        c.country,
		YEAR(o.orderDate) as Year_,
		MONTH(o.orderDate) as Month_,
		SUM(od.quantity) as TotalQuantity,
		SUM(od.quantity * od.unitPrice) as TotalRevenue,
		SUM(o.freight) as TotalFreightCosts,
		SUM(od.quantity * od.unitPrice) - SUM(o.freight) as TotalNetRevenue
	FROM orders o
	LEFT JOIN order_details od ON o.orderID = od.orderID
	LEFT JOIN customers c ON o.customerID = o.customerID
	GROUP BY 
		c.companyName,
        c.city,
        c.country,
		YEAR(o.orderDate),
		MONTH(o.orderDate)
);

-- SHIPPERS TO CUSTOMERS QUANTITY AND REVENUE THROUGHT TIME

CREATE VIEW shippers_throught_time_per_country  AS (
	SELECT
		c.country,
		YEAR(o.orderDate) AS Year_,
		MONTH(o.orderDate) AS Month_,

		-- SPEEDY EXPRESS
		SUM(CASE WHEN s.companyName = 'Speedy Express' THEN od.quantity ELSE 0 END) AS Total_Speedy_Express_Quantity,
		SUM(CASE WHEN s.companyName = 'Speedy Express' THEN od.quantity * od.unitPrice ELSE 0 END) AS Total_Speedy_Express_Revenue,
		SUM(CASE WHEN s.companyName = 'Speedy Express' THEN o.freight ELSE 0 END) AS Total_Speedy_Express_FreightCosts,
		SUM(CASE WHEN s.companyName = 'Speedy Express' THEN od.quantity * od.unitPrice ELSE 0 END)
		  - SUM(CASE WHEN s.companyName = 'Speedy Express' THEN o.freight ELSE 0 END) 
		  AS Total_Speedy_Express_NetRevenue,

		-- UNITED PACKAGE
		SUM(CASE WHEN s.companyName = 'United Package' THEN od.quantity ELSE 0 END) AS Total_United_Package_Quantity,
		SUM(CASE WHEN s.companyName = 'United Package' THEN od.quantity * od.unitPrice ELSE 0 END) AS Total_United_Package_Revenue,
		SUM(CASE WHEN s.companyName = 'United Package' THEN o.freight ELSE 0 END) AS Total_United_Package_FreightCosts,
		SUM(CASE WHEN s.companyName = 'United Package' THEN od.quantity * od.unitPrice ELSE 0 END)
		  - SUM(CASE WHEN s.companyName = 'United Package' THEN o.freight ELSE 0 END)
		  AS Total_United_Package_NetRevenue,

		-- FEDERAL SHIPPING
		SUM(CASE WHEN s.companyName = 'Federal Shipping' THEN od.quantity ELSE 0 END) AS Total_Federal_Shipping_Quantity,
		SUM(CASE WHEN s.companyName = 'Federal Shipping' THEN od.quantity * od.unitPrice ELSE 0 END) AS Total_Federal_Shipping_Revenue,
		SUM(CASE WHEN s.companyName = 'Federal Shipping' THEN o.freight ELSE 0 END) AS Total_Federal_Shipping_FreightCosts,
		SUM(CASE WHEN s.companyName = 'Federal Shipping' THEN od.quantity * od.unitPrice ELSE 0 END)
		  - SUM(CASE WHEN s.companyName = 'Federal Shipping' THEN o.freight ELSE 0 END)
		  AS Total_Federal_Shipping_NetRevenue

	FROM order_details od
	LEFT JOIN orders o ON od.orderID = o.orderID
	LEFT JOIN customers c ON o.customerID = c.customerID
	LEFT JOIN shippers s ON o.shipperID = s.shipperID

	GROUP BY 
		c.country,
		YEAR(o.orderDate),
		MONTH(o.orderDate)
);
