-- INNER JOIN 
-- Exercise 1: Write a query to find customers along with their billing information 
select * from customer;
select * from billing;

select c.customer_id, c.first_name, b.bill_id, b.amount_due
from customer c
inner join billing b
on c.customer_id = b.customer_id;

-- Exercise 2: List down customers with their corresponding total due amounts from the billing table.
select c.*, b.amount_due
from billing as b
join customer as c
on b.customer_id = c.customer_id;

-- Exercise 3: Display service packages along with the number of subscriptions each has.
select * from service_packages;
Select * from subscriptions;

select sp.package_id, sp.package_name,count(s.subscription_id) as "Number of subscriptions"
from service_packages sp
join subscriptions s
on sp.package_id = s.package_id
group by sp.package_id, sp.package_name;

-- LEFT JOIN
-- Exercise 1:Write a query to list all customers and any feedback they have given, 
-- including customers who have not given feedback.
Select * from feedback;
Select * from customer;

Select c.customer_id, c.first_name, f.feedback_text
from Customer c
left join feedback f
on c.customer_id = f.customer_id;

-- Exercise 2: Retrieve all customer and the package names of any subscriptions they 
-- might have.
select * from customer;
Select * from subscriptions;
select * from service_packages;

-- customer_id in customers table
-- join customer with subscription table using column customer_id
-- join subscription table with service_packages using column package_id

Select c.Customer_id, c.First_name, s.package_id, sp.package_name
from customer c
left join subscriptions s
on c.customer_id = s.customer_i
s.customer_id;

-- Exercise 3: Find out which customer have never given feedback by left joining customer 
-- to feedback.
select * from customer;
select * from feedback;

select c.customer_id, c.first_name, f.feedback_text
from customer c
left join feedback f
on c.customer_id = f.customer_id
where f.feedback_text is NULL;


-- Write a query to list all feedback entries and the corresponding customer 
-- information, including feedback without a linked customer


-- RIGHT JOIN
-- Exercise 1: Write a query to list all feedback entries and the corresponding customer 
-- information, including feedback without a linked customer.
select c.Customer_id, c.First_name, f.feedback_text
from customer c
right join feedback f
on f.customer_id= c.customer_id;

-- Exercise 2: List all customers, including those without a linked service usage.
select * from customer;
select * from service_usage;

select c.customer_id, c.first_name, su.data_used
from service_usage su
right join customer c
on c.Customer_id = su.customer_id;

-- Multiple JOINs
-- Write a query to list all customer, their subscription packages, and usage data.
select * from customer; -- c
select * from subscriptions; -- s
select * from service_packages; -- sp
select * from service_usage; -- su

select c.customer_id, c.first_name, sp.package_name, su.service_type, su.data_used
from customer c
inner join subscriptions s  on c.Customer_id = s.customer_id
left join service_packages sp on s.package_id = sp.package_id
left join service_usage su on c.Custome

;

-- Exercise 1: Write a query to find the service package with the highest monthly rate.
select max(monthly_rate) from service_packages;
--  99.92
select * from service_packages
where monthly_rate = 99.92;

select * 
from service_packages
where monthly_rate = (select max(monthly_rate) from service_packages);


-- Exercise 2: Find the customer with the smallest total amount of data used 
-- in service_usage.
select min(data_used) from service_usage;
-- 0.11
Select * from service_usage where data_used = 0.11;


-- using subquery
Select * from service_usage where data_used = (select min(data_used) from service_usage);
-- Exercise 3: Identify the service package with the lowest monthly rate.
select * 
from service_packages
where monthly_rate = (select min(monthly_rate) from service_packages);


-- Exercise 4: In service_usage, label data usage as ‘High’ if above the average usage,
-- ‘Low’ if below.
select * from service_usage;
select round(avg(data_used)) as Average_Data from service_usage;
-- average= 501

Select *,
Case
	When data_used > 501 Then "High"
    Else "Low"
End as Usage_Status
from service_usage;
-- using subquery
Select *,
Case
	When data_used > (select round(avg(data_used)) from service_usage) Then "High"
    Else "Low"
End as Usage_Status
from service_usage;











