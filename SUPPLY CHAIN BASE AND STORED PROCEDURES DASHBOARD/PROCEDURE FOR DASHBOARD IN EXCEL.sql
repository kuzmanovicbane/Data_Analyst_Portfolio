SELECT
    accounts.name,
    MONTH(occurred_at) AS Month_,
    YEAR(occurred_at) AS Year_,
    SUM(orders.standard_qty) AS Quantity,
    SUM(orders.standard_amt_usd) AS Amount
FROM orders
JOIN accounts ON orders.account_id = accounts.id
GROUP BY 
    accounts.name,
    MONTH(occurred_at),
    YEAR(occurred_at);

CREATE PROCEDURE QuantityAndAmount_per_yearANDmonth
	@groupby_qty_amt_Option VARCHAR(20),
	@summing_qty_Option VARCHAR(20),
	@summing_amt_Option VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @grouping NVARCHAR(100);
	DECLARE @summing_qty NVARCHAR(100);
	DECLARE @summing_amt NVARCHAR(100);
	DECLARE @sql NVARCHAR(MAX);

	-- Grupisanje po opciji
	SET @grouping = CASE 
						WHEN @groupby_qty_amt_Option = 'company name' THEN 'accounts.name'
						WHEN @groupby_qty_amt_Option = 'sales representative' THEN 'sales_rep.name'
						WHEN @groupby_qty_amt_Option = 'region' THEN 'region.name'
						ELSE 'accounts.website'
					END;

	-- Kolona za sabiranje količine
	SET @summing_qty = CASE 
						  WHEN @summing_qty_Option = 'standard' THEN 'orders.standard_qty'
						  WHEN @summing_qty_Option = 'gloss' THEN 'orders.gloss_qty'
						  WHEN @summing_qty_Option = 'poster' THEN 'orders.poster_qty'
						  ELSE 'orders.total'
					   END;

	-- Kolona za sabiranje iznosa (ispravka u grani)
	SET @summing_amt = CASE
						  WHEN @summing_amt_Option = 'standard' THEN 'orders.standard_amt_usd'
						  WHEN @summing_amt_Option = 'gloss' THEN 'orders.gloss_amt_usd'
						  WHEN @summing_amt_Option = 'poster' THEN 'orders.poster_amt_usd'
						  ELSE 'orders.total_amt_usd'
					   END;

	-- Sastavljanje dinamičkog SQL-a
	SET @sql = '
		SELECT ' + @grouping + ' AS GroupingValue,
		       MONTH(orders.occurred_at) AS Month_,
		       YEAR(orders.occurred_at) AS Year_,
		       SUM(' + @summing_qty + ') AS Quantity,
		       SUM(' + @summing_amt + ') AS Amount
		FROM orders
		JOIN accounts ON orders.account_id = accounts.id
		LEFT JOIN sales_rep ON accounts.sales_rep_id = sales_rep.id
		LEFT JOIN region ON sales_rep.region_id = region.id
		GROUP BY ' + @grouping + ', MONTH(orders.occurred_at), YEAR(orders.occurred_at);';

	-- Pokretanje dinamičkog SQL-a
	EXEC sp_executesql @sql;
END;
