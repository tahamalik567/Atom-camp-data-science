-- Common Table Expressions (CTEs) 
-- Temporary result Table that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement, 
-- often used with window functions to simplify queries and improve readability.


-- Common Table Expressions (CTEs)
-- WITH keyword
/*
WITH cte_name as (
	select column1, column2
		from  table_name
        )
select * from cte_name;
*/


select * from customer;
select * from billing;

select distinct billing_cycle from billing;


With aug_billing as
(
	select * from billing where billing_cycle = "23-Aug"
)
Select * from aug_billing
where amount_due > 9000;


-- Exercise: Find customer name and id for all customers with length of subscription more than 4000 days 
select * from subscriptions;
select * from customer;

select customer_id, datediff(end_date,start_date) as "Subscription Length"
 from subscriptions
 where datediff(end_date,start_date) > 4000;
 
 
 With subscription_days as (
 select customer_id, datediff(end_date,start_date) as Subscription_Length
 from subscriptions
 where datediff(end_date,start_date) > 4000
 )
select c.*, sd.Subscription_Length
 from customer c
 join subscription_days sd
 on c.customer_id = sd.customer_id;
 
 
 
 -- Multiple CTEs
select * from customer;
select * from billing;
select * from service_usage;

with customer_details as
(
	select customer_id, concat(first_name," ",last_name) as Full_Name, Email
    from customer
),
amount_details as
(
	select customer_id, sum(amount_due) as Total_amount_due
    from billing
    group by customer_id
),
Usage_details as
(
	select customer_id, sum(minutes_used) as Total_minutes_Used, avg(data_used) as Average_Data_used
    from service_usage
    group by customer_id
)
Select * from 
customer_details c
left join amount_details ad on c.customer_id = ad.customer_id
left join Usage_details ud on c.customer_id = ud.customer_id
where Total_amount_due >9900;


-- Database Design
-- ●  Requirements Analysis 
-- 	- Business Requirement
--     - Requirement Specification
--     - Set priorities ( Data confidential, every employee must have access)
--     - Requirement Validation
--     

-- ●  Conceptual Design 
-- 	- Identify tables or entities
--     - Define relationship (Pk, fk, 1-to-1 or 1- many)
-- 		- customer_id will be primary key
--     - Entity Relationaship Diagram (ERD)
--     - Normalization ( to avoid redundancy, to ensure integrity)
-- (single table with customer, order and produ
-- (single table with customer, order and product details)


-- ●  Logical Design
-- 	- Identify data types, constraints, null fk 
--     - Index (Table of content = > page no. for each chapter)  To ease the process of data access    

-- ●  Implementation
-- 	- SQL or ANy Database tool
-- 	- Create the databases and tables
--     - load the important data

-- ●  Deployment
-- ●  Maintenance and Evaluation