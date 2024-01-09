CREATE DATABASE PROJECT;

USE PROJECT;

CREATE TABLE Finance_Table1(
Id INT,
Loan_Amount INT,
Grade VARCHAR(5),
Sub_Grade VARCHAR(5),
Home_Ownership VARCHAR(20),
Verification_Status VARCHAR(20),
Issue_Date DATE,
Loan_Status VARCHAR(20),
Addr_State VARCHAR(20)
);

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance1.csv"
INTO TABLE Finance_Table1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;

select * from finance_Table1;

create table finance_2(
id int,
open_acc int unsigned ,
revol_bal int unsigned,	
total_acc int unsigned,
total_pymnt	decimal(10,4),
total_rec_prncp	decimal(10,4),
recoveries	int unsigned,
last_pymnt_d date );

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_2.csv"
INTO TABLE Finance_2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;

select * from finance_2;

-- Year wise Loan Amount

Select year(issue_date) as Issue_Year ,
	   concat(format(Sum(loan_amount)/1000000,0),'M') as total_amount 
       from finance_table1 group by issue_year order by Issue_Year;
       
-- Grade and sub grade wise revol_bal

Select f1.Grade, f1.sub_grade,concat(format(sum(f2.revol_bal)/1000000,0),'M') as revolving_bal from finance_Table1 as f1 
inner join 
finance_2 as f2 on f1.id = f2.id
group by grade,sub_grade
order by grade;

-- Total Payment for Verified Status Vs Total Payment for Non Verified Status

Select f1. Verification_status, concat(format(sum(f2.total_pymnt)/1000000,0),'M') as total_payment from finance_Table1 as f1 
inner join finance_2 as f2 on f1.id = f2.id 
group by f1.verification_status limit 2;

-- State wise and month wise loan status

select addr_state,loan_status,count(loan_status) from finance_table1 group by addr_state,loan_status;

select addr_state,loan_status,monthname(f2.last_pymnt_d) Month,count(f1.loan_status) Count_of_Cust from finance_table1 f1
join
finance_2 as f2
on f1.id = f2.id
group by addr_state,loan_status,Month;

-- Home ownership Vs last payment date stats

select year(f2.last_pymnt_d) payment_year, monthname(f2.last_pymnt_d) payment_month, f1.home_ownership, 
count(f1.home_ownership) home_ownership
from finance_table1 as f1 
inner join 
finance_2 as f2
on f1.id = f2.id
group by year(f2.last_pymnt_d), monthname(f2.last_pymnt_d), f1.home_ownership
order by payment_year;


