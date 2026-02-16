/* =========================================================
   1. Koliko je ukupno pošiljki realizovano?
   ========================================================= */

-- Izračunati ukupan broj zapisa u tabeli shipments.

SELECT 
	COUNT(id) AS Number_of_shipments
FROM
	shipments;



/* =========================================================
   2. Koliki je ukupan prihod (revenue) po klijentu?
   ========================================================= */

-- Prikazati client_name i SUM(revenue_eur).
-- Potrebno je JOIN-ovati shipments i clients.
-- Grupisati po client_name.

SELECT 
	client_name,
	ROUND(SUM(revenue_eur),2) AS Total_Revenue
FROM 
	clients
LEFT JOIN
	shipments
ON 
	clients.id = shipments.client_id
GROUP BY
	client_name
ORDER BY
	Total_Revenue DESC;



/* =========================================================
   3. Koji klijenti su imali više od 100 pošiljki u 2024. godini?
   ========================================================= */

-- Izračunati COUNT po client_id.
-- Filtrirati koristeći HAVING > 100 i gde je YEAR = 2024.
-- Prikazati client_name i broj pošiljki.

SELECT
	client_name,
	YEAR(shipments.shipment_date) AS YearOfShimpent,
	COUNT(shipments.id) AS TotalShipments
FROM 
	clients
LEFT JOIN
	shipments
ON 
	clients.id = shipments.client_id
GROUP BY
	client_name,
	YEAR(shipments.shipment_date)
HAVING 
	COUNT(shipments.id) > 100 AND
	YEAR(shipments.shipment_date) = 2024
ORDER BY 
	TotalShipments DESC;



/* =========================================================
   4. Koliki je prosječan margin_eur po ruti?
   ========================================================= */

-- Grupisati po route_id.
-- Izračunati AVG(margin_eur).

SELECT 
	route_id,
	city,
	ROUND(AVG(margin_eur),2) AS Average_Margin
FROM 
	locations
LEFT JOIN 
	routes
ON
	locations.id = routes.destination_id
LEFT JOIN
	shipments
ON 
	routes.id = shipments.route_id
GROUP BY
	route_id,
	city
ORDER BY
	Average_Margin DESC;



/* =========================================================
   5. Koji tip vozila je najčešće korišten?
   ========================================================= */

-- JOIN shipments i vehicles.
-- COUNT broj pošiljki po vehicle_type.
-- Sortirati opadajuće po broju pošiljki.

SELECT
	vehicle_type,
	COUNT(shipments.id) AS TotalShipments
FROM
	vehicles
LEFT JOIN 
	shipments
ON
	vehicles.id = shipments.vehicle_id
GROUP BY
	vehicle_type
ORDER BY 
	TotalShipments DESC;



/* =========================================================
   6. Kolika je ukupna margina po regionu unutar svake industrije?
   ========================================================= */

-- JOIN shipments i routes i JOIN shipments i clients .
-- SUM(tons) po region PARTITION BY industry.
-- Grupisati po region.

SELECT
    clients.industry,
    routes.region,
    ROUND(SUM(shipments.margin_eur),2) AS total_margin_eur
FROM 
    shipments
LEFT JOIN 
    routes
    ON shipments.route_id = routes.id
LEFT JOIN
    clients
    ON shipments.client_id = clients.id
GROUP BY
    clients.industry,
    routes.region
ORDER BY
    clients.industry,
    routes.region DESC;




/* =========================================================
   7. Koji su top 5 klijenata po prihodu po toni?
   ========================================================= */

-- SUM(revenue_eur)/SUM(tons) po client_name.
-- Sortirati opadajuće.
-- Koristiti TOP 5.

SELECT TOP 5
	client_name,
	SUM(revenue_eur)/SUM(tons) AS RevenuePerTone
FROM 
	shipments
LEFT JOIN
	clients
ON 
	shipments.client_id = clients.id
GROUP BY
	client_name
ORDER BY
	RevenuePerTone DESC;
	



/* =========================================================
   8. Koliki je prosječan revenue po pošiljci po godinama i mesecima?
   ========================================================= */

-- Izračunati AVG(revenue_eur) iz shipments GROUP BY YEAR and MONTH.

SELECT
	YEAR(shipments.shipment_date) AS Year,
	MONTH(shipments.shipment_date) AS Month,
	ROUND(AVG(revenue_eur),2) AS AverageRevenue
FROM 
	shipments
GROUP BY 
	YEAR(shipments.shipment_date),
	MONTH(shipments.shipment_date)
ORDER BY
	Year ASC,
	Month ASC;



/* =========================================================
   9. Koji KAM upravlja najvećim brojem klijenata i koliku marginu po klijentu ima koji?
   ========================================================= */

-- JOIN clients i key_account_managers.
-- COUNT broj klijenata po KAM-u.
-- Sortirati opadajuće po margini po klijentu.

WITH kam_margin AS (
    SELECT
        c.kam_id,
        ROUND(SUM(s.margin_eur),2) AS total_margin
    FROM clients c
    LEFT JOIN shipments s
        ON c.id = s.client_id
    GROUP BY
        c.kam_id
),
kam_clients AS (
    SELECT
        kam_id,
        COUNT(*) AS number_of_clients
    FROM clients
    GROUP BY
        kam_id
)

SELECT
    k.name,
    kc.number_of_clients,
    km.total_margin,
    ROUND(km.total_margin * 1.0 / kc.number_of_clients, 2) AS margin_per_client
FROM key_account_managers k
LEFT JOIN kam_clients kc
    ON k.id = kc.kam_id
LEFT JOIN kam_margin km
    ON k.id = km.kam_id
ORDER BY
    margin_per_client DESC;




/* =========================================================
   10. Koja relacija (origin → destination) ima najveću ukupnu kilometražu?
   ========================================================= */

-- Koristiti tabelu routes.
-- SUM(distance_km) po origin_id i destination_id.
-- Sortirati opadajuće.

SELECT
    r.id,
    o.city AS origin_name,
    d.city AS destination_name,
	SUM(r.distance_km) AS Total_KM
FROM routes r
LEFT JOIN locations o
    ON r.origin_id = o.id
LEFT JOIN locations d
    ON r.destination_id = d.id
GROUP BY
	r.id,
	o.city,
	d.city
ORDER BY 
	Total_KM DESC;



/* =========================================================
   11. Ranking klijenata po prihodu unutar industrije
   (Window Function)
   ========================================================= */

-- Izračunati SUM(revenue_eur) po klijentu.
-- Koristiti RANK() ili DENSE_RANK().
-- PARTITION BY industry.
-- ORDER BY ukupni prihod DESC.

WITH client_revenue AS (
	SELECT
		c.id,
		c.client_name,
		c.industry,
		SUM(s.revenue_eur) AS TotalRevenue
	FROM 
		clients c
	LEFT JOIN
		shipments s
	ON 
		c.id = s.client_id
	GROUP BY
		c.id,
		c.client_name,
		c.industry
		) 
SELECT
	cr.industry,
	cr.client_name,
	cr.TotalRevenue,
	RANK() OVER(PARTITION BY cr.industry ORDER BY cr.TotalRevenue DESC) AS Revenue_Rank
FROM
	client_revenue cr
ORDER BY
	industry,
	Revenue_Rank;
	


/* =========================================================
   12. Mesečni prihod i kumulativni prihod (Running Total)
   ========================================================= */

-- Grupisati po YEAR(shipment_date) i MONTH(shipment_date).
-- Izračunati mjesečni revenue.
-- Koristiti SUM() OVER (ORDER BY godina, mjesec)
-- za kumulativni prihod.

WITH monthly_revenue AS (
    SELECT
        YEAR(shipment_date) AS Year,
        MONTH(shipment_date) AS Month,
        ROUND(SUM(revenue_eur), 2) AS TotalRevenue
    FROM shipments
    GROUP BY
        YEAR(shipment_date),
        MONTH(shipment_date)
)

SELECT
    Year,
    Month,
    TotalRevenue,
    ROUND(
        SUM(TotalRevenue) OVER (ORDER BY Year, Month), 2
    ) AS CumulativeRevenue
FROM monthly_revenue
ORDER BY
    Year,
    Month;


/* =========================================================
   13. Year-over-Year (YoY) i Month-over-Month (MoM) rast prihoda
   ========================================================= */

-- Izračunati godišnji prihod.
-- Koristiti LAG() da dohvatite prihod prethodne godine.
-- Izračunati procentualni rast.


WITH monthly_revenue AS (
    SELECT
        YEAR(shipment_date) AS Year,
        MONTH(shipment_date) AS Month,
        SUM(revenue_eur) AS TotalRevenue
    FROM shipments
    GROUP BY
        YEAR(shipment_date),
        MONTH(shipment_date)
)

SELECT
    Year,
    Month,
    ROUND(TotalRevenue,2) AS TotalRevenue_TY,
    ROUND(LAG(TotalRevenue, 12) OVER (ORDER BY Year, Month),2) AS TotalRevenue_LY,
    ROUND(
        (TotalRevenue - LAG(TotalRevenue, 12) OVER (ORDER BY Year, Month)) * 1.0 
        / LAG(TotalRevenue, 12) OVER (ORDER BY Year, Month), 
        2
    ) AS YoY_Revenue_Growth,
	ROUND(LAG(TotalRevenue) OVER (ORDER BY Year, Month),2) AS TotalRevenue_LastMonth,
	 ROUND(
        (TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY Year, Month)) * 1.0 
        / LAG(TotalRevenue) OVER (ORDER BY Year, Month), 
        2
    ) AS MoM_Revenue_Growth
FROM monthly_revenue
ORDER BY
    Year,
    Month;


/* =========================================================
   14. Profit margin % po klijentu i odstupanje od prosjeka i njihov revenue_share % (učešće svakog klijenta u ukupnom prihodu)
   ========================================================= */

-- Izračunati margin_pct = margin_eur / revenue_eur.
-- Izračunati prosječni margin_pct koristeći AVG() OVER ().
-- Prikazati razliku između klijenta i globalnog prosjeka.

WITH client_metrics AS (
    SELECT
        c.client_name,
        SUM(s.revenue_eur) AS total_revenue,
        SUM(s.margin_eur)  AS total_margin
    FROM clients c
    LEFT JOIN shipments s
        ON c.id = s.client_id
    GROUP BY c.client_name
),
calculated AS (
    SELECT
        client_name,
        total_revenue,
        total_margin,
        total_margin / NULLIF(total_revenue, 0) AS margin_pct
    FROM client_metrics
)

SELECT
    client_name,
    margin_pct,
    AVG(margin_pct) OVER () AS avg_margin_pct,
    margin_pct - AVG(margin_pct) OVER () AS deviation_from_avg,
    total_revenue / NULLIF(SUM(total_revenue) OVER (), 0) AS revenue_share
FROM calculated
ORDER BY deviation_from_avg DESC;



/* =========================================================
   15. Najprofitabilnija ruta po regionu (Top 1 po regionu)
   ========================================================= */

-- Koristiti CTE za agregaciju margin_eur po ruti i regionu.
-- Koristiti ROW_NUMBER().
-- PARTITION BY region.
-- ORDER BY ukupna margina DESC.
-- Filtrirati gdje je row_number = 1.

WITH region_margin_per_route AS (
	SELECT
		region,
		route_id,
		SUM(margin_eur) AS TotalMargin
	FROM
		routes
	LEFT JOIN
		shipments
	ON 
		routes.id = shipments.route_id
	GROUP BY
		region,
		route_id
),
	ranked_routes AS (
	SELECT
		region,
		route_id,
		TotalMargin,
		ROW_NUMBER() OVER (PARTITION BY region ORDER BY TotalMargin DESC) AS rn
	FROM
		region_margin_per_route
	)
SELECT
    region,
    route_id,
    TotalMargin
FROM ranked_routes
WHERE rn = 1;


