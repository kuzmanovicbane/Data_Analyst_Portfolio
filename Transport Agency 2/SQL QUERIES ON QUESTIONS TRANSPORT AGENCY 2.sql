-- ================================================================
--  ROAD TRANSPORT AGENCY – 50 SQL QUESTIONS (ta_ prefiks)
--  Autor: ChatGPT (GPT-5)
--  Opis: Komentarisana pitanja za vežbu MySQL upita
-- ================================================================

-- ======================
-- A. OSNOVNI SELECT UPITI
-- ======================

-- 1. Prikaži sve vozače iz tabele ta_drivers.

SELECT 
	CONCAT(d.name," ",d.surname) as Full_Name
FROM 
	ta_drivers as d;
    
-- 2. Prikaži ime, prezime i status svih vozača koji su trenutno aktivni.
 SELECT 
	CONCAT(d.name," ",d.surname) as Full_Name,
    d.status
FROM 
	ta_drivers as d
WHERE
	d.status = "active";
    
-- 3. Izlistaj sve klijente koji se nalaze u Nemačkoj (country = 'Germany').

SELECT
	c.company_name,
    c.country
FROM 
	ta_clients as c
WHERE
	c.country = 'Germany';
    
-- 4. Pronađi sva vozila proizvedena posle 2020. godine.

SELECT
	v.vehicle_id,
    v.model,
    v.year
FROM 
	ta_vehicles as v
WHERE 
	v.year > 2020;
    
-- 5. Prikaži sve pošiljke teže od 10 tona.

SELECT
	sh.shipment_id,
    CONCAT(sh.origin,"-",sh.destination) as Rute,
    sh.weight_tons,
    sh.date_requested
FROM 
	ta_shipments as sh
WHERE 
	sh.weight_tons > 10
ORDER BY
	sh.date_requested;

-- 6. Prikaži pošiljke sa cenom većom od 5.000 EUR.

SELECT
	sh.shipment_id,
    CONCAT(sh.origin,"-",sh.destination) as Rute,
    sh.price_eur,
    sh.date_requested
FROM 
	ta_shipments as sh
WHERE 
	sh.price_eur > 5000
ORDER BY
	sh.date_requested;
    
-- 7. Izlistaj sve rute koje su trenutno “in_progress”.

SELECT
	sh.shipment_id,
    CONCAT(sh.origin,"-",sh.destination) as Rute,
    sh.price_eur,
    sh.date_requested,
    r.`status`
FROM 
	ta_shipments as sh
LEFT JOIN
	ta_routes as r ON sh.shipment_id = r.shipment_id 
WHERE 
	r.status = "in_progress"
ORDER BY
	sh.date_requested;

-- 8. Prikaži sve troškove koji su tipa “Fuel” for models Skania R500.

SELECT
    exp.*,
    v.vehicle_id,
    v.model
FROM
    ta_expenses AS exp
LEFT JOIN
    ta_routes AS r ON exp.route_id = r.route_id
LEFT JOIN
    ta_vehicles AS v ON r.vehicle_id = v.vehicle_id
WHERE
    exp.type = 'Fuel'
    AND v.model = 'Scania R500';

-- 9. Prikaži sve servise gde je cena održavanja bila preko 1.000 EUR, a u pitanju su vozila na servisu.

SELECT
	m.*
FROM ta_maintenance as m 
LEFT JOIN ta_vehicles as v ON m.vehicle_id = v.vehicle_id
WHERE
	m.cost_eur > 1000 AND v.status = 'in_service';
    
-- 10. Pronađi sve točenja goriva gde je litraža veća od 500 litara.

SELECT 
	*
FROM 
	ta_fuel_logs as fl
WHERE
	fl.liters > 500;

-- ======================
-- B. AGREGATNE FUNKCIJE I GRUPE
-- ======================

-- 11. Pronađi prosečnu cenu pošiljke (AVG(price_eur)).

SELECT 
	AVG(price_eur)
FROM
	ta_shipments as s;
    
-- 12. Pronađi ukupnu vrednost svih pošiljki u 2024. godini.

SELECT 
	YEAR(s.date_requested) as Year_,
	SUM(price_eur)
FROM
	ta_shipments as s
GROUP BY 
	Year_
HAVING 
	Year_ = 2024;

-- 13. Izračunaj prosečnu težinu pošiljke po državi klijenta.

SELECT
	c.country as Client_Country,
    AVG(s.weight_tons) as Average_Weight_in_Tons
FROM
	ta_shipments as s
LEFT JOIN 
	ta_clients as c
ON s.client_id = c.client_id
GROUP BY
	Client_Country
ORDER BY 
	Average_Weight_in_Tons DESC;

-- 14. Pronađi najdužu ,najkraću i prosecnu udaljenost (MAX i MIN i AVG distance_km) po klijentu.

SELECT
	c.company_name,
	MAX(s.distance_km) as Max_Distance_km,
    AVG(s.distance_km) as Average_Distance_km,
    MIN(s.distance_km) as Min_Distance_km
FROM
	ta_shipments as s
LEFT JOIN
	ta_clients as c
ON 
	s.client_id = c.client_id
GROUP BY 
	c.company_name
ORDER BY
	Average_Distance_km DESC;

-- 15. Izračunaj koliko ukupno ima vozača po statusu.

SELECT
	d.status,
    COUNT(d.driver_id) as Total_Drivers
FROM
	ta_drivers as d
GROUP BY
	d.status
ORDER BY
	Total_Drivers;

-- 16. Pronađi ukupno sipano gorivo po modelu vozila i mesecu sipanja.

SELECT 
    v.model,
    MONTH(fl.date) AS MonthOfFuelLogs,
    SUM(fl.liters) AS Total_Fuel_in_Liters
FROM
    ta_fuel_logs AS fl
LEFT JOIN
    ta_vehicles AS v ON fl.vehicle_id = v.vehicle_id
GROUP BY 
    v.model,
    MONTH(fl.date)
ORDER BY
    v.model,
    MONTH(fl.date) ASC;




-- 17. Najčešća godina proizvodnje vozila po modelu 

WITH YearCounts AS (
    SELECT
        model,
        year,
        COUNT(*) AS count_per_year
    FROM
        ta_vehicles
    GROUP BY
        model, year
),
MaxCounts AS (
    SELECT
        model,
        MAX(count_per_year) AS max_count
    FROM
        YearCounts
    GROUP BY
        model
)
SELECT
    y.model,
    y.year AS most_common_year,
    y.count_per_year
FROM
    YearCounts AS y
JOIN
    MaxCounts AS m
    ON y.model = m.model AND y.count_per_year = m.max_count
ORDER BY
    y.model;


-- 17. Koliko je ukupno ruti završeno (status = 'completed')?

SELECT
	r.status,
	COUNT(route_id) as Total_Routes
FROM 
	ta_routes as r
GROUP BY 
	r.status
HAVING 
	r.status = 'completed';
    
-- 18. Koliko je ukupno potrošeno na gorivo (SUM(amount_eur) gde type='Fuel')?

SELECT
	e.type,
	SUM(e.amount_eur) as TotalCost
FROM
	ta_expenses as e
GROUP BY
	e.type
HAVING
	e.type = 'Fuel';
    
-- 19. Koliko ukupno ima točenja goriva po vozilu?

SELECT
	v.plate_number,
	COUNT(fl.fuel_log_id) as TotalFuelLogs
FROM
	ta_fuel_logs as fl
LEFT JOIN
	ta_vehicles as v
ON 
	fl.vehicle_id = v.vehicle_id
GROUP BY 
	v.plate_number
ORDER BY 
	COUNT(fl.fuel_log_id) DESC;


-- 20. Koliki je prosečan trošak po ruti (AVG(amount_eur) po route_id)?

SELECT
	r.route_id,
    CONCAT(sh.origin,"-",sh.destination) as Rute,
    AVG(e.amount_eur) as AverageCostPerRute    
FROM 
	ta_shipments as sh
LEFT JOIN
	ta_routes as r ON sh.shipment_id = r.shipment_id
LEFT JOIN
	ta_expenses as e ON r.route_id = e.route_id
GROUP BY
	r.route_id,
    Rute
HAVING
	AVG(e.amount_eur) IS NOT NULL
ORDER BY
	AVG(e.amount_eur) DESC;
    
-- ======================
-- C. JOIN UPITI
-- ======================

-- 21. Prikaži listu ruta sa imenima vozača i registarskim brojem vozila.

SELECT
	r.route_id,
	r.start_date,
    CONCAT(sh.origin,"-",sh.destination) as Rute,
    CONCAT(d.name," ",d.surname) as FullDriverName,
    v.plate_number,
    v.model
FROM 
	ta_shipments as sh
LEFT JOIN
	ta_routes as r ON sh.shipment_id = r.shipment_id
LEFT JOIN
	ta_drivers as d ON r.driver_id = d.driver_id
LEFT JOIN 
	ta_vehicles as v ON r.vehicle_id = v.vehicle_id
ORDER BY
	r.start_date ASC;
	
-- 22. Prikaži sve pošiljke zajedno u jednoj celiji sa imenom kompanije klijenta koji ih je naručio.

SELECT
	c.company_name,
    GROUP_CONCAT(DISTINCT s.shipment_id ORDER BY s.shipment_id ASC) as AllShipments
FROM
	ta_shipments as s 
LEFT JOIN
	ta_clients as c ON s.client_id = c.client_id
GROUP BY
	c.company_name;

-- 23. Prikazi sve troškove (expenses) po gradu polaska pošiljke.

SELECT
	sh.origin,
    SUM(e.amount_eur) as TotalExpenses
FROM 
	ta_shipments as sh
LEFT JOIN
	ta_routes as r ON sh.shipment_id = r.shipment_id
LEFT JOIN
	ta_expenses as e ON r.route_id = e.route_id
GROUP BY
	sh.origin
HAVING 
	SUM(e.amount_eur) IS NOT NULL
ORDER BY
	SUM(e.amount_eur) DESC;
    

-- 24. Prikaži sve servise (maintenance) zajedno sa modelom vozila na kojem su rađeni.

SELECT 
	v.model,
    m.service_type,
    SUM(m.cost_eur) as TotalServiseCost
FROM
	ta_maintenance as m
LEFT JOIN
	ta_vehicles as v ON m.vehicle_id = v.vehicle_id
GROUP BY
	v.model,
    m.service_type;

-- 25. Prikaži sve rute, zajedno sa imenom vozača i ukupnim troškovima putarine za tu rutu.

SELECT
    CONCAT(sh.origin, ' - ', sh.destination) AS Rute,
    CONCAT(d.name, ' ', d.surname) AS FullDriverName,
    SUM(e.amount_eur) AS TotalExpenses
FROM 
    ta_shipments AS sh
LEFT JOIN 
    ta_routes AS r ON sh.shipment_id = r.shipment_id
LEFT JOIN 
    ta_drivers AS d ON r.driver_id = d.driver_id
LEFT JOIN 
    ta_vehicles AS v ON r.vehicle_id = v.vehicle_id
LEFT JOIN 
    ta_expenses AS e ON r.route_id = e.route_id
WHERE
	e.type = 'Toll'
GROUP BY 
    Rute, FullDriverName
ORDER BY 
    TotalExpenses DESC;

-- 26. Prikaži sve pošiljke koje su prevezene vozilom marke “Volvo FH16”.

SELECT 
	v.model,
    r.route_id,
    sh.shipment_id,
    CONCAT(sh.origin, ' - ', sh.destination) AS Rute
FROM 
	ta_routes as r
LEFT JOIN 
	ta_vehicles as v ON r.vehicle_id = v.vehicle_id
LEFT JOIN 
    ta_shipments AS sh ON r.shipment_id = sh.shipment_id
WHERE v.model = 'Volvo FH16';
    
-- 27. Prikaži sve vozače i broj ruta koje su odvezli.

SELECT 
	CONCAT(d.name," ",d.surname) as FullDriverName,
    COUNT(r.route_id) as NumberOfRutes
FROM
	ta_routes as r
LEFT JOIN
	ta_drivers as d ON r.driver_id = d.driver_id
GROUP BY
	FullDriverName;
    
-- 28. Prikaži sve klijente i broj pošiljki koje su naručili.

SELECT
	c.company_name,
    COUNT(s.shipment_id) as NumberOfShipments
FROM
	ta_shipments as s 
LEFT JOIN
	ta_clients as c ON s.client_id = c.client_id
GROUP BY 
	c.company_name
ORDER BY 
	COUNT(s.shipment_id) DESC;

-- 29. Prikaži sva vozila i ukupnu količinu goriva koje su natočili.

SELECT 
	v.plate_number,
    SUM(fl.liters) as TotalFuelLitres,
    RANK() OVER (ORDER BY SUM(fl.liters) DESC) as RankOfTotalFuelLitres
FROM
	ta_fuel_logs as fl
LEFT JOIN 
	ta_vehicles as v ON fl.vehicle_id = v.vehicle_id
GROUP BY 
	v.plate_number
ORDER BY
	 TotalFuelLitres DESC;
    

-- 30. Pronađi sve vozače koji trenutno imaju neku rutu u toku (status='in_progress').

SELECT 
    DISTINCT d.driver_id,
    CONCAT(d.name, ' ', d.surname) AS FullDriverName
FROM
	ta_routes as r 
LEFT JOIN 
	ta_drivers as d ON r.driver_id = d.driver_id
WHERE
	r.status = 'in_progress';

-- ======================
-- D. FILTRIRANJE, USLOVI I PODUPITI
-- ======================

-- 31. Prikaži sve pošiljke koje su skuplje od prosečne cene svih pošiljki.

WITH shiping_average_price AS (
    SELECT 
        AVG(s.price_eur) AS AverageShipingPrice
    FROM 
        ta_shipments AS s
)
SELECT 
    s1.shipment_id,
    CONCAT(s1.origin,'-',s1.destination) as Rute,
    s1.price_eur,
    avg_price.AverageShipingPrice
FROM 
    ta_shipments AS s1
CROSS JOIN 
    shiping_average_price AS avg_price
WHERE 
    s1.price_eur > avg_price.AverageShipingPrice
ORDER BY 
    s1.price_eur DESC;

-- 32. Pronađi vozila koja nikada nisu imala evidentiran servis.

SELECT
	v.plate_number,
    SUM(m.cost_eur) as TotalMaintanceCost
FROM
	ta_vehicles as v
LEFT JOIN 
	ta_maintenance as m  ON v.vehicle_id = m.vehicle_id 
GROUP BY
	v.plate_number
HAVING
	SUM(m.cost_eur) IS NULL;
    
-- 33. Pronađi klijente koji imaju više od 50 pošiljki.

SELECT
	c.company_name,
    COUNT(s.shipment_id) as TotalNumberOfShipment
FROM
	ta_clients as c 
LEFT JOIN
	ta_shipments as s ON c.client_id = s.client_id
GROUP BY
	c.company_name
HAVING 
	COUNT(s.shipment_id) > 50;

-- 34. Prikaži vozače koji nisu imali nijednu završenu rutu.

SELECT 
	CONCAT(d.name,' ',d.surname) AS FullDriverName
FROM
	ta_drivers as d 
LEFT JOIN
	ta_routes as r ON d.driver_id = r.driver_id AND r.status = 'completed'
WHERE 
	r.route_id IS NULL;
    
-- 35. Pronađi rute koje nisu imale evidentirane troškove.

SELECT 
	r.route_id,
    SUM(e.amount_eur) as TotalExpencesOnRoute
FROM 
	ta_routes as r
LEFT JOIN
	ta_expenses as e ON r.route_id = e.route_id
GROUP BY
	r.route_id
HAVING 
	SUM(e.amount_eur) IS NULL;
    
-- 36. Prikaži vozila koja su koristila oba tipa goriva (“Diesel” i “LPG”).

SELECT 
    v.plate_number
FROM 
    ta_vehicles AS v
WHERE 
    v.fuel_type IN ('Diesel', 'LPG')
GROUP BY 
    v.plate_number
HAVING 
    COUNT(DISTINCT v.fuel_type) = 2
ORDER BY 
    v.plate_number ASC;

-- 37. Pronađi rutu sa najvećim ukupnim troškom. 

SELECT
    r.route_id,
    CONCAT(sh.origin, ' - ', sh.destination) AS Rute,
    SUM(e.amount_eur) AS TotalExpenses
FROM 
    ta_routes AS r
LEFT JOIN
    ta_expenses AS e ON r.route_id = e.route_id
LEFT JOIN
    ta_shipments AS sh ON r.shipment_id = sh.shipment_id
GROUP BY 
    r.route_id, 
    CONCAT(sh.origin, ' - ', sh.destination)
ORDER BY 
    TotalExpenses DESC
LIMIT 1;

-- 38. Pronađi vozilo sa najvećom ukupnom potrošnjom goriva (po liters).

SELECT 
    v.plate_number,
    SUM(fl.liters) as TotalLitersLoad
FROM 
    ta_vehicles AS v
LEFT JOIN
	ta_fuel_logs as fl ON v.vehicle_id = fl.vehicle_id
GROUP BY
	v.plate_number
ORDER BY 
	SUM(fl.liters) DESC
LIMIT 1;
    
-- 39. Pronađi klijenta koji je ostvario najveći promet (SUM(price_eur)).

SELECT
	c.company_name,
    SUM(s.price_eur) as TotalRevenue
FROM 
	ta_clients as c
LEFT JOIN
	ta_shipments as s ON c.client_id = s.client_id
GROUP BY 
	c.company_name
ORDER BY
	SUM(s.price_eur) DESC
LIMIT 1;

-- 40. Prikaži top 5 najskupljih pošiljki sa imenom klijenta i destinacijom.

SELECT
	c.company_name,
    s.destination,
    s.price_eur
FROM 
	ta_clients as c
LEFT JOIN
	ta_shipments as s ON c.client_id = s.client_id
ORDER BY
	s.price_eur DESC
LIMIT 5;

-- ======================
-- E. NAPREDNI UPITI I ANALIZE
-- ======================

-- 41. Izračunaj prosečan trošak goriva po kilometru (ukupni troškovi goriva / ukupna kilometraža).

SELECT
    SUM(e.amount_eur) AS TotalFuelCosts,
    SUM(s.distance_km) AS TotalKM,
    (SUM(e.amount_eur) / SUM(s.distance_km)) AS FuelCostsPerKm
FROM
    ta_expenses AS e
LEFT JOIN
	ta_routes AS r ON e.route_id = r.route_id
LEFT JOIN
    ta_shipments AS s ON r.shipment_id = s.shipment_id
WHERE 
    e.type = 'Fuel';

-- 42. Izračunaj prosečan prihod po ruti (SUM(price_eur)/COUNT(route_id)).

SELECT
	SUM(s.price_eur) as TotalRevenue,
    COUNT(r.route_id) as TotalNumberOfRoutes,
    (SUM(s.price_eur) / COUNT(r.route_id)) as AverageRevenuePerRoute
FROM
	ta_shipments as s 
INNER JOIN
	ta_routes as r ON s.shipment_id = r.shipment_id;

-- 43. Pronađi prosečnu težinu pošiljke po tipu vozila (JOIN ta_routes i ta_vehicles).

SELECT
	v.model,
    AVG(s.weight_tons) as AverageTonsLoad
FROM
	ta_routes as r 
LEFT JOIN 
	ta_vehicles as v ON r.vehicle_id = v.vehicle_id
LEFT JOIN
	ta_shipments as s ON r.shipment_id = s.shipment_id
GROUP BY 
	v.model;

-- 44. Izračunaj mesečni prihod ukljucujuci i potencijalan prihod agencije po godini i mesecu (GROUP BY YEAR, MONTH).

SELECT 
	YEAR(date_requested) as Year_,
    MONTH(date_requested) as Month_,
	SUM(price_eur) as TotalRevenue
FROM
	ta_shipments as s
GROUP BY
	YEAR(date_requested),
    MONTH(date_requested)
ORDER BY
	YEAR(date_requested),
    MONTH(date_requested);

-- 45. Prikaži ukupne troškove održavanja po vozilu i prosečno vreme između servisa.

WITH ServiceIntervals AS (
    SELECT
        vehicle_id,
        date,
        LAG(date) OVER (PARTITION BY vehicle_id ORDER BY date) AS PreviousServiceDate
    FROM
        ta_maintenance
)
SELECT
    m.vehicle_id,
    SUM(m.cost_eur) AS TotalMaintenanceCost,
    ROUND(AVG(DATEDIFF(s.date, s.PreviousServiceDate)),0) AS AvgDaysBetweenServices
FROM
    ta_maintenance AS m
LEFT JOIN
    ServiceIntervals AS s 
    ON m.vehicle_id = s.vehicle_id 
    AND m.date = s.date
GROUP BY
    m.vehicle_id
ORDER BY
    TotalMaintenanceCost DESC;

-- 46. Pronađi sve pošiljke gde je odnos cene po toni veći od 100 EUR/t.

SELECT
	s.shipment_id,
    SUM(s.price_eur) AS TotalPrice,
    SUM(s.weight_tons) AS TotalTons,
    ROUND(SUM(s.price_eur) / SUM(s.weight_tons),2) AS PricePerTon
FROM
    ta_shipments AS s
GROUP BY 
	s.shipment_id
HAVING
	SUM(s.weight_tons) > 0 AND
	SUM(s.price_eur) / SUM(s.weight_tons) > 100
ORDER BY
	SUM(s.price_eur) / SUM(s.weight_tons) DESC;

-- 47.. Izračunaj profit po ruti (shipment.price_eur - SUM(expenses.amount_eur)).

WITH RevenuePerRoute AS (
    SELECT
        r.route_id,
        CONCAT(s.origin, ' - ', s.destination) AS RouteDescription,
        SUM(s.price_eur) AS TotalRevenue
    FROM
        ta_routes AS r
    JOIN
        ta_shipments AS s ON r.shipment_id = s.shipment_id
    WHERE
        r.status = 'completed'
    GROUP BY
        r.route_id, s.origin, s.destination
),
ExpensesPerRoute AS (
    SELECT
        route_id,
        SUM(amount_eur) AS TotalExpenses
    FROM
        ta_expenses
    GROUP BY
        route_id
)
SELECT
    r.route_id,
    r.RouteDescription,
    COALESCE(r.TotalRevenue, 0) AS TotalRevenue,
    COALESCE(e.TotalExpenses, 0) AS TotalExpenses,
    COALESCE(r.TotalRevenue, 0) - COALESCE(e.TotalExpenses, 0) AS TotalProfit
FROM
    RevenuePerRoute r
LEFT JOIN
    ExpensesPerRoute e ON r.route_id = e.route_id
ORDER BY
    TotalProfit DESC;




-- 48. Kumulativan profit u svakoj godini, rast profita u odnosu na prethodni mesec, rast profita u odnosu na proslu godinu

WITH RevenuePerMonth AS (
    SELECT
        YEAR(s.date_requested) AS Year_,
        MONTH(s.date_requested) AS Month_,
        SUM(s.price_eur) AS TotalRevenue
    FROM
        ta_shipments AS s
	INNER JOIN
		ta_routes AS r ON s.shipment_id = r.shipment_id
	WHERE 
		r.status = 'completed'
    GROUP BY
        YEAR(s.date_requested),
        MONTH(s.date_requested)
),
ExpensesPerMonth AS (
    SELECT
        YEAR(e.date) AS Year_,
        MONTH(e.date) AS Month_,
        SUM(e.amount_eur) AS TotalExpenses
    FROM
        ta_expenses AS e
    GROUP BY
        YEAR(e.date),
        MONTH(e.date)
),

-- 🔹 Simulacija FULL JOIN pomoću UNION
Combined AS (
    -- Deo 1: svi meseci sa prihodima 
    SELECT 
        r.Year_,
        r.Month_,
        r.TotalRevenue,
        e.TotalExpenses
    FROM 
        RevenuePerMonth AS r
    LEFT JOIN 
        ExpensesPerMonth AS e 
        ON r.Year_ = e.Year_ AND r.Month_ = e.Month_

    UNION

    -- Deo 2: svi meseci sa troškovima 
    SELECT 
        e.Year_,
        e.Month_,
        r.TotalRevenue,
        e.TotalExpenses
    FROM 
        ExpensesPerMonth AS e
    LEFT JOIN 
        RevenuePerMonth AS r 
        ON r.Year_ = e.Year_ AND r.Month_ = e.Month_
)

-- 🔹 Glavni SELECT – isti kao originalni upit
SELECT
    Year_,
    Month_,
    TotalExpenses,
    TotalRevenue,
    (TotalRevenue - TotalExpenses) AS TotalProfit,
    (LAG(TotalRevenue - TotalExpenses) OVER (ORDER BY Year_, Month_)) AS LastMonthProfit,
    (LAG(TotalRevenue - TotalExpenses) OVER (PARTITION BY Month_ ORDER BY Year_)) AS LastYearProfit,
    SUM(TotalRevenue - TotalExpenses) OVER (PARTITION BY Year_ ORDER BY Month_) AS CumulativeProfit,
    (TotalRevenue - TotalExpenses)
        - LAG(TotalRevenue - TotalExpenses) OVER (ORDER BY Year_, Month_) AS ProfitDifferenceFromPreviousMonth,
    (TotalRevenue - TotalExpenses)
        - LAG(TotalRevenue - TotalExpenses) OVER (PARTITION BY Month_ ORDER BY Year_) AS ProfitDiffFromSameMonthLastYear
FROM
    Combined
ORDER BY
    Year_,
    Month_;

-- 49. Prikazi sve troskove po godinama i mesecima po posebnim kolonama, a svaki trosak odrzavanja kao posebnu kolonu

    SELECT
        YEAR(e.date) AS Year_,
        MONTH(e.date) AS Month_,
        SUM(CASE WHEN e.type = 'Maintenance' THEN e.amount_eur ELSE 0 END) AS MaintenanceCosts,
        SUM(CASE WHEN e.type = 'Toll' THEN e.amount_eur ELSE 0 END) AS TollCosts,
        SUM(CASE WHEN e.type = 'Other' THEN e.amount_eur ELSE 0 END) AS OtherCosts,
        SUM(CASE WHEN e.type = 'Fuel' THEN e.amount_eur ELSE 0 END) AS FuelCosts,
        SUM(CASE WHEN e.type = 'Fine' THEN e.amount_eur ELSE 0 END) AS FineCosts,
        SUM(e.amount_eur) AS TotalCosts
    FROM
        ta_expenses AS e
    GROUP BY
        YEAR(e.date),
        MONTH(e.date)
	ORDER BY
		YEAR(e.date),
        MONTH(e.date);

