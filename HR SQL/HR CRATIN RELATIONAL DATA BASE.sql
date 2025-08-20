ALTER TABLE Job_position_structure
ALTER COLUMN dep_job_lev_ID NVARCHAR(255) NOT NULL

ALTER TABLE Job_position_structure
ADD CONSTRAINT PK_jps_dep_job_lev_ID PRIMARY KEY (dep_job_lev_ID)

ALTER TABLE [HR Employee data]
ADD dep_job_lev_ID NVARCHAR(255);


UPDATE [HR Employee data]
SET dep_job_lev_ID = Department + ' ' + JobLevel_updated;

ALTER TABLE [HR Employee data]
ADD CONSTRAINT FK_dep_job_lev_ID FOREIGN KEY (dep_job_lev_ID)
REFERENCES Job_position_structure.dep_job_lev_ID

ALTER TABLE [HR Employee data]
ALTER COLUMN EmployeeID INT NOT NULL

ALTER TABLE [HR Employee data]
ADD CONSTRAINT PK_EmployeeID PRIMARY KEY(EmployeeID)

ALTER TABLE Employee_office_survey
ALTER COLUMN emp_id INT 

ALTER TABLE Employee_office_survey
ADD CONSTRAINT FK_emp_id FOREIGN KEY (emp_id)
REFERENCES [HR Employee data] (EmployeeID);

ALTER TABLE Office_codes
ALTER COLUMN office_code varchar(50) NOT NULL 

ALTER TABLE Office_codes
ADD CONSTRAINT PK_office_code PRIMARY KEY (office_code)

ALTER TABLE [HR Employee data]
ADD CONSTRAINT FK_office_code FOREIGN KEY (office_code)
REFERENCES Office_codes(office_code);

ALTER TABLE Employee_office_survey 
ALTER COLUMN rating DECIMAL(38,2)

ALTER TABLE [HR Employee data]
ALTER COLUMN MonthlyIncome DECIMAL(38,2)

ALTER TABLE [HR Employee data]
ALTER COLUMN JobSatisfaction INT

ALTER TABLE [HR Employee data]
ALTER COLUMN NumCompaniesWorked INT

ALTER TABLE [HR Employee data]
ALTER COLUMN Age INT