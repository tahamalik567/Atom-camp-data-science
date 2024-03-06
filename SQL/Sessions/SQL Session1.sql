-- DDL
-- Create Database
create database Practice;
Use  Practice;

-- DML
-- SELECT retrieves the desired data 
Select * from billing;    -- * refers to "ALL columns" 
Select * from customer;   -- Use Cntrl+Enter to run the query

-- Exercise: List only the first names and subscription dates of the customer.
Select First_name, Last_name from customer;


-- Exercise: Fetch all unique email addresses from the `customer` table 
select email from customer;

select distinct email from customer;

select distinct billing_cycle from billing;


-- Create and Use database
-- import tables
-- Select or display the data.

-- Exercise: Display all columns from the `billing` table.
Select * from billing;

-- Exercise: Show only the bill ID and the amount due from the `billing` table.
 Select bill_id, amount_due from billing;
 
 
-- WHERE 
-- refers to conditional statements. 
Select * from customer;
Select * from customer where Customer_id = 7;


--  Exercise: Find bills in the `billing` table with an amount_due greater than 1000.
Select * from billing;
Select * from billing where amount_due < 1000;

--  Exercise: Find all the late fee less than 500
Select * from billing where late_fee < 500;


--  Show bills that were generated for `customer_id' 5
Select * from billing where customer_id = 5;



-- WHERE with (IN, OR, AND, NOT EQUAL TO, NOT IN)
Select * from billing;
Select * from billing where customer_id <10 and late_fee<500;


-- Exercise: using or and AND

-- Exercise: Identify customer who live at either '5 Northridge Road', '814 Kinsman Lane’ 
-- and Phone Number Starts with 277
SELECT 
    *
FROM
    customer
WHERE
    Address IN ('5 Northridge Road' , '814 Kinsman Lane')
        AND phone_number LIKE '277%';

-- Like

-- Exercise: List down the customers whose Name starts with either A or Z;
Select * from customer;
Select * from customer where email Like "%gnu.org"  ;


-- Exercise: Display customer whose phone number is NOT '1233253784'.
Select * from customer where Phone_number !='1233253784';
Select * from customer where Phone_number <>'1233253784';

-- Exercise: List all bills except those with billing cycles in "January" and "February
-- 23-Feb and 23-Jan
Select * from billing where billing_cycle Not in ("23-Feb","23-Jan");


-- Billing cycle = YY-MMM


-- ORDER BY
-- Exercise: Order customer by their names in ascending order
-- Exercise: Display bills from the `billing` table ordered by `amount_due` in descending order.

-- LIMIT
-- Exercise: Show only the first 10 customer.
-- Exercise: List the top 5 highest bills from the `billing` table.
-- Exercise: Retrieve the latest 3 bills based on the due date.



