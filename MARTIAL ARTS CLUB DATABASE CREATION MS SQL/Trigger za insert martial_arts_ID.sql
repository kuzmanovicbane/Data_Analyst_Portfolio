CREATE TRIGGER trgAfterInsert_MA_Name
ON dbo.MARTIAL_ARTS_NAMES
AFTER INSERT
AS
BEGIN 
    INSERT INTO dbo.MARTIAL_ARTS_PERFORMANCES (martial_art_ID)
    SELECT i.martial_art_ID
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.MARTIAL_ARTS_PERFORMANCES p
        WHERE p.martial_art_ID = i.martial_art_ID
    );
END;

INSERT INTO MARTIAL_ARTS_NAMES (ma_name, origin_country)
VALUES ('Karate', 'Okinawa')

SELECT * FROM MARTIAL_ARTS_NAMES

UPDATE MARTIAL_ARTS_PERFORMANCES
SET 
    clinching = 3,
    full_hand_punching = 6,
    legs = 6,
    throws = 4,
    ground_work = 2,
    vital_points_punching = 7
WHERE martial_art_ID = 7;

SELECT * FROM MARTIAL_ARTS_PERFORMANCES

CREATE VIEW ma_total_paymants_per_months AS
SELECT 
    ma_name, 
    YEAR(payment_date) AS Year, 
    MONTH(payment_date) AS Month, 
    SUM(amount) AS Total_Paymant_Amount 
FROM 
    MARTIAL_ARTS_NAMES mn
JOIN 
    membership_payments mp ON mn.martial_art_ID = mp.martial_art_ID
GROUP BY 
    ma_name, YEAR(payment_date), MONTH(payment_date);

SELECT TOP (1000) [ma_name]
      ,[Year]
      ,[Month]
      ,[Total_Paymant_Amount]
  FROM [MARTIAL_ARTS].[dbo].[ma_total_paymants_per_months]
  ORDER BY [Year] ASC, [Month] ASC, [Total_Paymant_Amount] DESC

 
CREATE VIEW ma_avg_price_VS_performance AS
SELECT 
    m.ma_name, 
    p.average_score, 
    AVG(mp.amount) AS Average_membership_amount
FROM 
    MARTIAL_ARTS_NAMES m
JOIN 
    MARTIAL_ARTS_PERFORMANCES p ON m.martial_art_ID = p.martial_art_ID
JOIN 
    membership_payments mp ON m.martial_art_ID = mp.martial_art_ID
GROUP BY 
    m.ma_name, p.average_score;

SELECT TOP (1000) [ma_name]
      ,[average_score]
      ,[Average_membership_amount]
	  ,ROUND([Average_membership_amount]/[average_score],2) AS amount_per_score
  FROM [MARTIAL_ARTS].[dbo].[ma_avg_price_VS_performance]
  ORDER BY [Average_membership_amount]/[average_score] DESC


CREATE TABLE self_defence_course_participants (
    Name VARCHAR(100) PRIMARY KEY,
    Age INT,
    Gender VARCHAR(50),
    Occupation VARCHAR(100),
    Nationality VARCHAR(100),
    SatisfactionScore INT
);


INSERT INTO self_defence_course_participants (Name, Age, Gender, Occupation, Nationality, SatisfactionScore)
SELECT Name, Age, Gender, Occupation, Nationality, SatisfactionScore
FROM [MARTIAL_ARTS].[dbo].[self_defense_course_participant$]


ALTER TABLE membership_payments
ALTER COLUMN member_name VARCHAR(100) NOT NULL;

CREATE VIEW MA_pyments_and_AVGsatisfaction_Gender AS
SELECT MARTIAL_ARTS_NAMES.ma_name, Gender, SUM(amount) AS Total_Amount, AVG(SatisfactionScore) AS AVG_Score
FROM membership_payments
JOIN MARTIAL_ARTS_NAMES ON membership_payments.martial_art_ID = MARTIAL_ARTS_NAMES.martial_art_ID
JOIN self_defence_course_participants sdp ON membership_payments.member_name = sdp.Name
GROUP BY ma_name, Gender

SELECT TOP (1000) [ma_name]
      ,[Gender]
      ,[Total_Amount]
      ,[AVG_Score]
  FROM [MARTIAL_ARTS].[dbo].[MA_pyments_and_AVGsatisfaction_Gender]
  ORDER BY [Total_Amount] DESC