-- 1. Find employees who have more than 5 years of experience and work overtime
SELECT 
	EmployeeID,
	dep_job_lev_ID
FROM
	[HR Employee data]
WHERE
	TotalWorkingYears > 5 AND OverTime = 'Yes'

-- 2. Show average rating per office for the last 3 years

WITH MaxYear AS (
    SELECT MAX(rated_year) AS max_year
    FROM Employee_office_survey
)

SELECT
    oc.office_code,
    AVG(eos.rating) AS avg_rating
FROM
    Office_codes oc
LEFT JOIN [HR Employee data] hr
    ON oc.office_code = hr.office_code
LEFT JOIN Employee_office_survey eos
    ON hr.EmployeeID = eos.emp_id
JOIN MaxYear my
    ON eos.rated_year BETWEEN my.max_year - 2 AND my.max_year
GROUP BY oc.office_code
ORDER BY AVG(eos.rating) DESC


-- 3. Find employees with the highest JobSatisfaction and the lowest MonthlyIncome (lowest income up to + 100 dollars)

WITH Max_job_satisf AS (
    SELECT MAX(JobSatisfaction) AS MaxSatis
    FROM [HR Employee data]
),
MinIncomeValue AS (
    SELECT MIN(MonthlyIncome) AS MinInc
    FROM [HR Employee data]
)

SELECT 
    EmployeeID,
    JobSatisfaction,
    MonthlyIncome
FROM [HR Employee data], Max_job_satisf, MinIncomeValue
WHERE 
    JobSatisfaction = MaxSatis
    AND MonthlyIncome BETWEEN MinInc AND (MinInc + 100)


-- 4. Show the number of employees who left the company by reason for leaving

SELECT
    Reason,
    COUNT(EmployeeID) AS Number_of_Employees
FROM [HR Employee data]
WHERE Attrition = 'Yes' 
GROUP BY Reason
ORDER BY Number_of_Employees DESC;


-- 5. How many employees are there in each combination of department and job role?

SELECT
    jps.Department,
    jps.JobRole,
    COUNT(hr.EmployeeID) AS Number_of_Employees
FROM
    Job_position_structure jps
JOIN 
    [HR Employee data] hr
    ON jps.dep_job_lev_ID = hr.dep_job_lev_ID
WHERE 
    hr.Attrition = 'No'
GROUP BY 
    jps.Department,
    jps.JobRole
ORDER BY 
    Number_of_Employees DESC;

-- 6. Show the total number of employees by category of number of companies they worked for (categories to be created in the query)

SELECT 
	MAX([HR Employee data].NumCompaniesWorked) AS Max_num_companies_worked,
	AVG([HR Employee data].NumCompaniesWorked) AS Avg_num_companies_worked,
	MIN([HR Employee data].NumCompaniesWorked) AS Min_num_companies_worked
FROM 
	[HR Employee data]

SELECT
    CASE
        WHEN NumCompaniesWorked <= 2 THEN '0-2 companies before'
        WHEN NumCompaniesWorked BETWEEN 3 AND 5 THEN '3-5 companies before'
        WHEN NumCompaniesWorked > 5 THEN 'a lot of companies before'
    END AS CompaniesWorkedCategory,
    COUNT(EmployeeID) AS Number_of_employees
FROM
    [HR Employee data]
GROUP BY
    CASE
        WHEN NumCompaniesWorked <= 2 THEN '0-2 companies before'
        WHEN NumCompaniesWorked BETWEEN 3 AND 5 THEN '3-5 companies before'
        WHEN NumCompaniesWorked > 5 THEN 'a lot of companies before'
    END
ORDER BY Number_of_employees DESC;


-- 7. Show the number of employees by education level who received their last promotion within 5 years or less, and who have been with the company for less than 9 years

SELECT
	EducationField,
	COUNT(EmployeeID) AS Number_of_employees
FROM
	[HR Employee data]
WHERE
	YearsSinceLastPromotion <= 5 AND
	YearsAtCompany < 9
GROUP BY 
	EducationField
ORDER BY
	COUNT(EmployeeID) DESC

-- 8. Show the number of employees by department and country

SELECT
	country,
	Department,
	COUNT(EmployeeID) AS Number_of_employees
FROM
	[HR Employee data]
JOIN Employee_office_survey ON [HR Employee data].office_code = Employee_office_survey.off_cde
JOIN Office_codes ON Employee_office_survey.off_cde = Office_codes.office_code
GROUP BY 
	country, Department
ORDER BY
	COUNT(EmployeeID) DESC

-- 9. Show all employees who had JobSatisfaction below 3 and PerformanceRating below 3

SELECT 
	EmployeeID
FROM 
	[HR Employee data]
WHERE
	JobSatisfaction < 3 AND
	PerformanceRating < 3


-- 10. Show all offices that have at least one employee with a rating of 5

SELECT 
	DISTINCT HighPerformers.office_code AS office_codes,
	PerformanceRating
FROM

	(SELECT 
		*
	FROM 
		[HR Employee data]
	WHERE 
		PerformanceRating = 5) AS HighPerformers

JOIN Employee_office_survey ON HighPerformers.office_code = Employee_office_survey.off_cde
JOIN Office_codes ON Employee_office_survey.off_cde = Office_codes.office_code	
	


-- 11. Find employees who have OverTime = 'Yes' and WorkLifeBalance = 1

SELECT 
	EmployeeID,
	OverTime,
	WorkLifeBalance
FROM 
	[HR Employee data]
WHERE
    OverTime = 'Yes' AND WorkLifeBalance = 1


-- 13. Show average age by department

SELECT 
	jps.Department,
	AVG(hr.Age) as Average_Age
FROM 
	Job_position_structure jps
JOIN 
	[HR Employee data] hr
ON jps.dep_job_lev_ID = hr.dep_job_lev_ID
GROUP BY
	jps.Department
ORDER BY
	AVG(hr.Age) DESC
	

-- 14. Show the top 5 highest paid employees per office

WITH CleanedData AS (
    SELECT DISTINCT
        eos.off_cde,
        hr.EmployeeID,
        hr.MonthlyIncome
    FROM 
        Employee_office_survey eos
    JOIN 
        [HR Employee data] hr
        ON eos.emp_id = hr.EmployeeID
),

Top5ByOffice AS (
    SELECT
        off_cde,
        EmployeeID,
        MonthlyIncome,
        ROW_NUMBER() OVER (
            PARTITION BY off_cde 
            ORDER BY MonthlyIncome DESC
        ) AS RowNum
    FROM 
        CleanedData
)

SELECT
    off_cde,
    EmployeeID,
    MonthlyIncome,
    RowNum
FROM 
    Top5ByOffice
WHERE 
    RowNum <= 5
ORDER BY 
    off_cde,
    RowNum;


-- 15. Pivot the Employee_office_survey table so you can easily see the change of average rating per office year by year.

SELECT
    off_cde,
    AVG(CASE WHEN rated_year = 2017 THEN rating END) AS Year_2017_AvgRating,
    AVG(CASE WHEN rated_year = 2018 THEN rating END) AS Year_2018_AvgRating,
    AVG(CASE WHEN rated_year = 2019 THEN rating END) AS Year_2019_AvgRating,
    AVG(CASE WHEN rated_year = 2020 THEN rating END) AS Year_2020_AvgRating,
    AVG(CASE WHEN rated_year = 2021 THEN rating END) AS Year_2021_AvgRating,
    AVG(CASE WHEN rated_year = 2022 THEN rating END) AS Year_2022_AvgRating,
	AVG(rating) AS Average_rating_all_years
FROM 
    Employee_office_survey
GROUP BY 
    off_cde
