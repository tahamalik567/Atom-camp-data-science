-- 1. Exercise: Find the average monthly rate for each service type in service_packages. 
-- Use the ROUND function here to make result set neater
Select * from service_packages;
Select Distinct service_type from service_packages;

select service_type, round(avg(monthly_rate),2) as "Average Monthly Rate" 
from service_packages
group by service_type;



-- 2. Exercise: Identify the customer who has used the most data in a single service_usage record. (covers ORDER BY and LIMIT that we did in last class)
select * from service_usage;
select max(data_used) from service_usage;  -- aggregation

select customer_id, max(data_used) as max_data_used
from service_usage
group by customer_id
order by max_data_used desc
limit 1;


-- 3. Exercise: Calculate the total minutes used by all customers for mobile services.
Select * from service_usage;
Select sum(minutes_used) as Total_Sum
from service_usage
where service_type='mobile';


Select service_type, sum(minutes_used) from service_usage
group by service_type
having service_type='mobile';

-- 4. Exercise: List the total number of feedback entries for each rating level.
select * from feedback;
Select distinct rating from feedback;
select rating, count(*) as Total_entries from feedback
group by rating;


-- 5. Exercise: Calculate the total data and minutes used per customer, per service type.
Select * from service_usage;
Select customer_id, service_type, sum(data_used) as Total_Data ,sum(minutes_used) as Total_Minutes
from service_usage
group by customer_id, service_type;


-- 6. Exercise: Group feedback by service impacted and rating to count the number of feedback entries.
select * from feedback;
Select service_impacted, rating, count(*) as Feedback_entries_count
from feedback
group by service_impacted, rating;


-- 7. Exercise: Show the total amount due by each customer, but only for those who have a total amount greater than $100.
Select * from billing;
select customer_id, sum(amount_due) as Total_Amount_due
from billing
group by customer_id
having Total_Amount_due > 100;


-- 8. Exercise: Determine which customers have provided feedback on more than one type of service, 
-- but have a total rating less than 10.
select * from feedback;
select customer_id
from feedback
group by customer_id
having (count( distinct service_impacted) > 1) AND (Sum(rating)<10);



-- 1. Exercise: Categorize customers based on their subscription date: 
-- ‘New’ for those subscribed after 2023-01-01, ‘Old’ for all others.
select * from customer;
select *,
CASE
	When Subscription_Date >'2023-01-01' THEN "New"
    ELSE "Old"
END as subscription_status
FROM customer;


-- 2. Exercise: Provide a summary of each customer’s billing status, 
-- showing ‘Paid’ if the payment_date is not null, and ‘Unpaid’ otherwise.
select * from billing;
select * from billing
where payment_date ="";

select *,
Case
	When payment_date<>"" Then "Paid"
    Else "unpaid"
End as Billing_status
from billing;


-- 3. Exercise: In service_usage, label data usage as ‘High’ if above the average usage, 
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


-- 4. Exercise: For each feedback given, categorise the service_impacted into ‘Digital’ 
-- for ‘streaming’ or ‘broadband’ and ‘Voice’ for ‘mobile’.
select distinct service_impacted from feedback;
Select *,
Case
	When service_impacted in ('streaming','broadband') Then 'Digital'
	When service_impacted = 'mobile' Then 'voice'
    Else 'Other'
End as service_category
from feedback;


-- 5. Exercise: Update the discounts_applied field in billing to 10%(0.1) of amount_due for 
-- bills with a payment_date past the 2023-01-01, otherwise set it to 5%.(0.05)
select * from billing;

Set sql_safe_updates =0;

update billing
set discounts_applied = 
Case
When payment_date > "2023-01-01" Then amount_due*0.1
Else amount_due * 0.05
End;


select * from billing;



-- 6. Exercise: Classify each customer as ‘High Value’ 
-- if they have a total amount due greater than $500, or ‘Standard Value’ if not.
select * from billing;


-- 7. Exercise: Mark each feedback entry as ‘Urgent’ if the rating is 1 
-- and the feedback text includes ‘outage’ or ‘down’.
select  * from feedback
 where feedback_text like "%outage%" or feedback_text like "%down%";
 
 
 -- 6. Exercise: Classify each customer as ‘High Value’ 
-- if they have a total amount due greater than $500, or ‘Standard Value’ if not.
select * from billing;

select *,
case
	when amount_due > 500 Then "High Value"
	Else "Standard Value"
end as value_category
from billing;

-- 7. Exercise: Mark each feedback entry as ‘Urgent’ if the rating is 1 
-- and the feedback text includes ‘outage’ or ‘down’.
select  * from feedback
where feedback_text like "%outage%" or feedback_text like "%down%";

select *,
case
	when (rating=1) and (feedback_text like "%outage%" or feedback_text like "%down%") then "urgent"
    Else "Normal"
end Urgent_status
from feedback;


-- 8. Exercise: In billing, create a flag for each bill that is ‘Late’ 
-- if the payment_date is after the due_date, ‘On-Time’ if it’s the same, and ‘Early’ if before.
select * from billing;

select *,
case
	When payment_date > due_date then "Late"
    When payment_date = due_date then "On-Time"
    When payment_date < due_date then "Early"
end as Bill_Flag
from billing;


-- Permanently Add Conditional Column
-- 1. Add column to your table
-- will create bill_flag column in billing table
ALTER TABLE billing
ADD Column Bill_Flag varchar(10);

select * from billing;
-- 2. update the values using case statements

set sql_safe_updates = 0;

update billing
set Bill_Flag = 
case
	When payment_date > due_date then "Late"
    When payment_date = due_date then "On-Time"
    When payment_date < due_date then "Early"
end;


select * from billing;
