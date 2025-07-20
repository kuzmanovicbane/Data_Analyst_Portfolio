-- 1. Pronađi ukupan broj porudžbina po proizvodu u poslednjih 6 meseci.
SELECT
    COUNT(CASE WHEN standard_qty <> 0 THEN 1 END) AS Standard_Paper_Orders,
    COUNT(CASE WHEN gloss_qty <> 0 THEN 1 END) AS Gloss_Paper_Orders,
    COUNT(CASE WHEN poster_qty <> 0 THEN 1 END) AS Poster_Paper_Orders
FROM orders
WHERE occurred_at >= DATEADD(MONTH, -6, (SELECT MAX(occurred_at) FROM orders));

-- 2. Prikaži broj web događaja (web_events) po regionu u poslednjih 6 meseci.

SELECT
	reg.name,
	COUNT(we.id) AS NumberOfWebEvents
FROM 
	web_events we
LEFT JOIN 
	accounts a 
ON we.account_id = a.id
LEFT JOIN 
	sales_rep sr
ON a.sales_rep_id = sr.id
LEFT JOIN
	region reg
ON
	sr.region_id = reg.id
GROUP BY 
	reg.name
ORDER BY 
	COUNT(we.id) DESC


-- 3. Prikaži prosečnu vrednost porudžbina po prodajnom predstavniku (sales_rep).

SELECT
	sr.name,
	AVG(o.total_amt_usd) AS AverageTotalAmt
FROM 
	orders o
LEFT JOIN 
	accounts a 
ON o.account_id = a.id
LEFT JOIN 
	sales_rep sr
ON a.sales_rep_id = sr.id
LEFT JOIN
	region reg
ON
	sr.region_id = reg.id
GROUP BY 
	sr.name
ORDER BY 
	AVG(o.total_amt_usd) DESC

-- 4. Prikaži broj naloga koji su napravili porudžbine u svakom regionu (region.name).

SELECT
    r.name AS region_name,
    COUNT(DISTINCT a.id) AS accounts_with_orders
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_rep sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
GROUP BY r.name
ORDER BY accounts_with_orders DESC;
	

-- 5. Prikaži ukupnu vrednost porudžbina po mesecu za poslednjih 12 meseci.

SELECT 
    YEAR(o.occurred_at) AS Year_,
    MONTH(o.occurred_at) AS Month_,
    SUM(o.total_amt_usd) AS Total_Order_Value
FROM orders o
WHERE o.occurred_at >= DATEADD(MONTH, -12, (SELECT MAX(occurred_at) FROM orders))
GROUP BY YEAR(o.occurred_at), MONTH(o.occurred_at)
ORDER BY Year_, Month_


-- 6. Pronađi prodajne predstavnike koji su ostvarili više od 1M ukupne prodaje.

SELECT
    sr.name AS sales_representative_name,
    SUM(total_amt_usd) AS TotalAmt
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_rep sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
GROUP BY sr.name
HAVING SUM(total_amt_usd) > 1000000
ORDER BY SUM(total_amt_usd) DESC;

-- 7. Pronađi naloge koji nisu napravili više od 5 porudžbina.

SELECT
    a.name AS account_name,
    COUNT(o.id) AS number_of_orders
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_rep sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
GROUP BY 
	a.name
HAVING
	COUNT(o.id) <= 5
ORDER BY
	COUNT(o.id) ASC


-- 8. Prikaži broj web događaja po tipu (`web_events.channel`) i regionu.

SELECT
	we.channel,
	reg.name,
	COUNT(we.id) AS NumberOfWebEvents
FROM 
	web_events we
LEFT JOIN 
	accounts a 
ON we.account_id = a.id
LEFT JOIN 
	sales_rep sr
ON a.sales_rep_id = sr.id
LEFT JOIN
	region reg
ON
	sr.region_id = reg.id
GROUP BY 
	reg.name,
	we.channel
ORDER BY 
	we.channel ASC, COUNT(we.id) DESC, reg.name ASC 

-- 9. Pronađi prodajne predstavnike koji pokrivaju više od jednog regiona.

SELECT
    sr.name AS sales_rep_name,
    COUNT(DISTINCT r.id) AS regions_covered
FROM accounts a
JOIN sales_rep sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
GROUP BY sr.name
HAVING COUNT(DISTINCT r.id) > 1;


-- 10. Prikaži broj porudžbina i prosečnu vrednost po prodajnom predstavniku u svakom regionu.

SELECT
    sr.name AS sales_rep_name,
	r.name AS region_name,
    COUNT(o.id) AS number_of_orders,
	AVG(o.total_amt_usd) AverageTotalAmt
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_rep sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
GROUP BY sr.name, r.name
ORDER BY AVG(o.total_amt_usd) DESC

