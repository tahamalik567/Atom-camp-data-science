/*
Types of Sub queries
● Single-row, multiple-row, and multiple-column subqueries.
● Correlated subqueries.

● Window Functions
● LEAD(),LAG(),RANK(),DENSE_RANK(),PARTITION ON
● Over()
● LEAD()
*/

-- Single-row subquery
-- Returns only one row and one column, typically used with single-value comparisons.
-- Exercise: Write a query to find the service package with the highest monthly rate.

select * from service_packages 
where monthly_rate = (select max(monthly_rate) from service_packages);


-- Multiple-row Subquery
-- Returns multiple rows but only one column, often used with operators like IN, ANY, or ALL.
-- Exercise: Find customers whose subscription lengths are longer than the average
-- subscription length of all customers.
select * from subscriptions;
#select datediff("2023-03-24","2023-03-20");

Select *,datediff(end_date,start_date) as subscription_length
from subscriptions;
-- average for each customer
-- we have to compare each length with that average value

Select customer_id, round(avg(datediff(end_date,start_date))) as average_subscription_length
from subscriptions
group by  customer_id;

select round(avg(datediff(end_date,start_date))) as average_subscription_length
from subscriptions
group by  customer_id;  -- multiple rows

select customer_id
from subscriptions
where datediff(end_date,start_date) > ALL( select round(avg(datediff(end_date,start_date))) as average_subscription_length
from subscriptions
group by  customer_id); 


select * from customer
where customer_id in 
(
select customer_id
from subscriptions
where datediff(end_date,start_date) > ALL( select round(avg(datediff(end_date,start_date))) as average_subscription_length
from subscriptions
group by  customer_id));



-- Multiple-column Subquery
-- Returns multiple columns, useful for comparisons involving multiple values.
-- Exercise: Select all feedback entries that match the worst rating given for any service type.

select * from feedback;
select service_impacted, min(rating) from feedback
group by  service_impacted;

select * 
from feedback
where (service_impacted, rating) IN 
(
 select service_impacted, min(rating) from feedback
group by  service_impacted
);




-- Correlated Subquery
-- A correlated subquery is a type of subquery in SQL where the inner query (subquery) is dependent on the outer query (main query). 
-- In other words, the inner query references columns from the outer query and is evaluated for each row processed by the outer query.

-- Exercise: List all packages and information for packages with monthly rates are
-- less than the maximum minutes used for each service type.
select * from service_packages; -- monthly rate
select * from service_usage; -- minutes_used

select service_type, max(minutes_used)
from service_usage
group by service_type;

-- Service_type   max(minutes_used)
-- Broadband.Streaming	9987
-- Mobile	9851

select distinct service_type from service_packages;

select * 
from service_packages sp
where monthly_rate < (
select max(minutes_used)
from service_usage su
where sp.service_type = su.service_type);


-- Exercise: Find customers whose total billing amount is greater than $5000
select * from customer;
select * from billing;

select customer_id,sum(amount_due) as total_billing_amount
from billing group by customer_id;

select customer_id, first_name, last_name
from customer c
where (
select sum(amount_due) as total_billing_amount
from billing b
where c.Customer_id = b.customer_id
) > 5000;


-- Subquery in SELECT
-- Write a query to show each customer's name and the number of subscriptions they have.
select * from customer;
select * from subscriptions;


select customer_id, count(subscription_id) as "number of subscriptions"
from subscriptions group by 1;

select customer_id, first_name, last_name, email, 
(
select count(subscription_id) 
from subscriptions s
where s.customer_id = c.customer_id) as "number of subscriptions"
from customer c;


-- Window Functions
-- Over(): Syntax used to define the window frame for window functions, specifying the partitioning and ordering of rows.
-- PARTITION BY: Divides the result set into partitions to perform calculations separately within each partition or group.
-- Key Window Functions:
	-- RANK(): Assigns a rank to each row based on specified criteria.
	-- DENSE_RANK(): Similar to RANK() but assigns consecutive ranks without gaps.
	-- LEAD(): Accesses data from subsequent rows in the result set.
	-- LAG(): Accesses data from previous rows in the result set.
    

-- PARTITION BY
-- Exercise 1: Find the number of feedback entries for each service type for each customer.
select * from feedback;
select service_impacted, count(*) as " number of feedback entries"
from feedback
group by 1;

select customer_id, service_impacted, count(*) as " number of feedback entries"
from feedback
group by 1,2;

select *,
count(feedback_id) over ( partition by customer_id, service_impacted) as "Number of feedback entries"
from feedback;


-- Exercise 2: Calculate the Average data_used for each service_type for each customer
select * from  service_usage;

select customer_id, service_type,data_used, minutes_used,usage_date, avg(data_used) 
from service_usage
group by 1,2,3,4,5;

select * from service_usage;

select *, 
Avg(data_used) over (partition by customer_id, service_type) as average_data_used
from service_usage;



-- RANK() and DENSE_RANK()
-- Exercise 1: Rank customers according to the number of services they have subscribed to.
select * from subscriptions;

select customer_id, count(subscription_id) as "Subscription Count",
RANK() OVER( order by count(subscription_id) desc ) as "service subscription rank"
from subscriptions
group by customer_id;


select customer_id, count(subscription_id) as "Subscription Count",
dense_rank() OVER( order by count(subscription_id) desc ) as "service subscription rank"
from subscriptions
group by customer_id;


-- Exercise 2: Rank customers based on the total sum of their rating they have ever given.
select * from feedback;

select customer_id , sum(rating) "Total Ratings",
Rank() Over( order by sum(rating) desc) as "Rank"
from feedback
group by 1;

select customer_id , sum(rating) "Total Ratings",
dense_rank() Over(order by sum(rating) desc) as "Rank"
from feedback
group by 1;




-- LEAD():

-- Exercise 1:View next session’s data usage for each customer
select * from service_usage;

select customer_id, data_used as "current data Usage", 
LEAD(data_used) OVER (partition by customer_id order by usage_date) as "Next session’s data Usage"
from service_usage;


-- Exercise 2:Calculate the difference in data usage between the current and next session.
select customer_id, data_used as "current data Usage", 
LEAD(data_used) OVER (partition by customer_id order by usage_date) as "Next session’s",
LEAD(data_used) OVER (partition by customer_id order by usage_date) - data_used as "difference of data usage"
from service_usage;

-- Total Data Usage
select customer_id, data_used as "current data Usage", 
LEAD(data_used) OVER (partition by customer_id order by usage_date) + data_used as "Total data usage"
from service_usage;


-- LAG():
-- Exercise 1:Review Previous Session's Data Usage
Select customer_id, data_used,
Lag(data_used) over (partition by customer_id order by usage_date) as "Previous Session's Data"
from service_usage;


-- Exercise 2:Interval Between Service Usage Sessions
select * from service_usage;

Select customer_id, usage_date,
datediff(usage_date, LAG(usage_date) over( partition by customer_id order by usage_date)) as "Interval"
from service_usage;