WITH monthly_sales_by_category AS (
    SELECT
        YEAR(s.SaleDate) AS Year_,
        MONTH(s.SaleDate) AS Month_,
        p.Category,
        SUM(s.Amount) AS TotalSales
    FROM 
        sales s
    JOIN 
        products p ON s.PID = p.PID
    GROUP BY
        YEAR(s.SaleDate),
        MONTH(s.SaleDate),
        p.Category
)

SELECT
	Year_,
    Month_,
    SUM(CASE WHEN SalesByCatYtd.Category = "Bites" THEN SalesByCatYtd.TotalSales ELSE 0 END) AS BitesSales,
    SUM(CASE WHEN SalesByCatYtd.Category = "Bites" THEN SalesByCatYtd.SalesYtd ELSE 0 END) AS BitesSalesYtd,
    SUM(CASE WHEN SalesByCatYtd.Category = "Bars" THEN SalesByCatYtd.TotalSales ELSE 0 END) AS BarsSales,
    SUM(CASE WHEN SalesByCatYtd.Category = "Bars" THEN SalesByCatYtd.SalesYtd ELSE 0 END) AS BarsSalesYtd,
    SUM(CASE WHEN SalesByCatYtd.Category = "Other" THEN SalesByCatYtd.TotalSales ELSE 0 END) AS OtherSales,
    SUM(CASE WHEN SalesByCatYtd.Category = "Other" THEN SalesByCatYtd.SalesYtd ELSE 0 END) AS OtherSalesYtd
FROM

(SELECT 
    Year_,
    Month_,
    Category,
    TotalSales,
    SUM(TotalSales) OVER (
        PARTITION BY Year_, Category
        ORDER BY Month_
    ) AS SalesYtd
FROM
    monthly_sales_by_category) AS SalesByCatYtd
GROUP BY
	Year_,
    Month_
    ;

	