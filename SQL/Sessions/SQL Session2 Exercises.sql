-- note that i am only seeing 1000 records in the thable cant see the new entries there is an option to fix that in mysql workbench



-- DML
-- 1) Changing Data Types for Date Columns:
 
-- Back up customer data:
Select * from customer;

create table customer_backup As Select * from customer;
Select * from customer_backup;

create table billing_backup as select * from billing;
select * from billing_backup;


-- SQL safe updates off
Set sql_safe_updates = 0;

-- Change Subscription_Date
select * from customer;

update customer set Subscription_Date = str_to_date(Subscription_Date, "%m/%d/%Y");
Alter table customer modify Subscription_Date DATETIME;

-- Change Date_of_Birth
select * from customer;
update customer set date_of_birth = str_to_date(date_of_birth,"%m/%d/%Y");
ALter table customer Modify Date_of_Birth datetime;

-- Change datetime to DATE
ALter table customer Modify Date_of_Birth date;
ALter table customer Modify Subscription_Date date;
select * from customer;

-- Change last_interaction_date
select * from customer;
update customer set last_interaction_date = str_to_date(last_interaction_date,"%m/%d/%Y");
select * from customer;
ALter table customer Modify last_interaction_date date;



-- 2) Setting Primary Keys and Autoincremental Values:
-- for customer table
ALTER table customer ADD Primary key (Customer_id);
ALTER table customer modify Customer_id int auto_increment;

-- for billing table
ALTER table billing ADD Primary key (bill_id);
ALTER table billing modify bill_id int auto_increment;


-- 3) INSERT Statements:
-- Insert new customer:
select * from customer;
insert into customer ( First_name,email)
values ("Maimoona","M.khilji@gmail.com");
Select * from customer;

insert into customer  
values (1002,"Maimoona","Khilji","M.khilji@gmail.com","Peshawar",01234567,"2023-06-23","2023-06-23","2023-06-23");

select * from customer;


-- Adding a new billing entry:
select * from billing;
insert into billing (customer_id,amount_due)
values (1001,123);
select * from billing;


-- Adding billing with only the billing cycle specified
select * from billing;
insert into billing (billing_cycle)
values ("Aug-2023");
select * from billing;



-- 4) UPDATE Statements:

-- Update last_interaction_date of customers with a subscription_date before 2023-01-01:
select * from customer where subscription_date <"2023-01-01";
update customer set last_interaction_date ="2024-03-05"
where subscription_date <"2023-01-01";

select * from customer where subscription_date <"2023-01-01";

-- Update email for customer last name "Khilji":
select * from customer where last_name="khilji";
update customer set email = "maimoon.khilji@gmail.com"
where last_name="khilji";

select * from customer where last_name="khilji";

-- Increase late fee for overdue payments:
select * from billing;
select * from billing where payment_Date > due_date;
update billing set late_fee = late_fee +1000
where payment_date > due_date;

select * from billing where payment_Date > due_date;

-- Changing (update) phone number for customer ID 10:
select * from customer where Customer_id=10;
update customer set phone_number = "102005009" where customer_id=10;
select * from customer where Customer_id=10;


-- 5) DELETE Statements:
Select * from customer;

-- Delete customers without subscription or last interaction date:
Select * from customer where Subscription_Date is NUll or last_interaction_date is NULL;

Delete from customer where Subscription_Date is NUll or last_interaction_date is NULL;

Select * from customer where Subscription_Date is NUll or last_interaction_date is NULL;

-- Erase customers named "Maimoona":
select * from customer where first_name = "maimoona";
delete from customer where first_name = "maimoona";

-- Deleting entries in the billing table with due date before 2022-01-01:
-- change the datatype of due date in billing table

update billing set due_date = str_to_date(due_date, "%m/%d/%Y");
Alter table billing modify due_date DATE;


Select * from billing where due_date < "2023-10-01";
delete from billing where due_date < "2023-10-01";

select * from billing;

-- 6) Data Cleaning:

-- marital status
-- unmarried or single  or not married  =>value inconcistency

-- Replace "Road" with "Rd." in address field:
select * from customer;
Update customer set address = replace(address,"Road","Rd.");
select * from customer;

-- update emails with google.com to gmail.com
select * from customer where email like "%google.com";
update customer set email = REPLACE(email,"google.com","gmail.com");
select * from customer where email like "%gmail.com";



-- Convert billing cycle to uppercase:
select * from billing;
update billing set billing_cycle = Upper(billing_cycle);
select * from billing;


-- Remove leading/trailing whitespaces from the name field
-- TRIM
select * from customer;
update customer set first_name = TRIM(first_name);


-- 7) Data Transformation:

-- Extracting the year from subscription dates
Select * from customer;
Select distinct Subscription_Date from customer;
Select * , Year(Subscription_Date) from customer;
Select Distinct(Year(Subscription_Date)) from customer;

-- Adding a month to all subscription dates:
select * from customer;
update customer set Subscription_Date = date_add(Subscription_Date, interval 2 month);
select * from customer;
--  '2022-06-12'

-- Concatenating First name and Last name:
Select concat(first_name," ", Last_name) from customer;

select subscription_date,year(subscription_date) from customer;

Select *, late_fee + 2000 from billing;


-- Drop the updated table
DROP TABLE billing;  -- because it has only 250 rows
DROP TABLE customer; 

-- Create new tables using the backup tables
create table billing as select * from billing_backup;
select * from billing;

create table customer as select * from customer_backup;
select * from customer;
