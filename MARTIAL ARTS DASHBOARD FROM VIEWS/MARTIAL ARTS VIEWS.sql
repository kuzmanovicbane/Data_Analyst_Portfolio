SELECT 
	Occupation, 
	MONTH(payment_date) as Month_, 
	YEAR(payment_date) as Year_, 
	SUM(amount) as Total_Amount
FROM self_defence_course_participants sdcp
LEFT JOIN membership_payments mp ON sdcp.Name=mp.member_name
GROUP BY Occupation, YEAR(payment_date), MONTH(payment_date)


CREATE VIEW total_amount_by_occupation AS(
SELECT 
	Occupation, 
	MONTH(payment_date) as Month_, 
	YEAR(payment_date) as Year_, 
	SUM(amount) as Total_Amount
FROM self_defence_course_participants sdcp
LEFT JOIN membership_payments mp ON sdcp.Name=mp.member_name
GROUP BY Occupation, YEAR(payment_date), MONTH(payment_date)
)

SELECT 
	Nationality, 
	MONTH(payment_date) as Month_, 
	YEAR(payment_date) as Year_, 
	SUM(amount) as Total_Amount
FROM self_defence_course_participants sdcp
LEFT JOIN membership_payments mp ON sdcp.Name=mp.member_name
GROUP BY Nationality, YEAR(payment_date), MONTH(payment_date)


CREATE VIEW total_amount_by_nationality AS(
SELECT 
	Nationality, 
	MONTH(payment_date) as Month_, 
	YEAR(payment_date) as Year_, 
	SUM(amount) as Total_Amount
FROM self_defence_course_participants sdcp
LEFT JOIN membership_payments mp ON sdcp.Name=mp.member_name
GROUP BY Nationality, YEAR(payment_date), MONTH(payment_date)
)


CREATE VIEW total_amount_by_gender AS(
SELECT 
	Gender, 
	MONTH(payment_date) as Month_, 
	YEAR(payment_date) as Year_, 
	SUM(amount) as Total_Amount
FROM self_defence_course_participants sdcp
LEFT JOIN membership_payments mp ON sdcp.Name=mp.member_name
GROUP BY Gender, YEAR(payment_date), MONTH(payment_date)
)

CREATE VIEW CALENDAR AS(
SELECT  
	MONTH(payment_date) as Month_, 
	YEAR(payment_date) as Year_
FROM membership_payments
GROUP BY YEAR(payment_date),MONTH(payment_date)
)


CREATE VIEW age_category_total_amount AS (
SELECT 
    MONTH(payment_date) AS Month_, 
    YEAR(payment_date) AS Year_, 
    SUM(amount) AS Total_Amount,
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN 'Young Adult'
        WHEN Age BETWEEN 25 AND 34 THEN 'Adult'
        WHEN Age BETWEEN 35 AND 44 THEN 'Mid-Age Adult'
        WHEN Age BETWEEN 45 AND 54 THEN 'Mature Adult'
        WHEN Age >= 55 THEN 'Senior'
        ELSE 'Unknown'
    END AS Age_Category
FROM self_defence_course_participants sdcp
LEFT JOIN membership_payments mp ON sdcp.Name = mp.member_name
GROUP BY 
    YEAR(payment_date), 
    MONTH(payment_date),
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN 'Young Adult'
        WHEN Age BETWEEN 25 AND 34 THEN 'Adult'
        WHEN Age BETWEEN 35 AND 44 THEN 'Mid-Age Adult'
        WHEN Age BETWEEN 45 AND 54 THEN 'Mature Adult'
        WHEN Age >= 55 THEN 'Senior'
        ELSE 'Unknown'
    END
)
