-- Case Study Questions

-- 1. How many customers has Foodie-Fi ever had?

SELECT COUNT(DISTINCT(CUSTOMER_ID)) AS TOTAL_NUMBER_OF_CUSTOMERS FROM SUBSCRIPTIONS ;

-- 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start
-- of the month as the group by value

SELECT DATE_FORMAT(start_date, '%Y-%m-01') AS start_of_month, COUNT(*) AS trials_started
FROM subscriptions
WHERE plan_id IN (
    SELECT plan_id 
    FROM plans 
    WHERE plan_name = 'trial'
)
GROUP BY DATE_FORMAT(start_date, '%Y-%m-01');


-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown
-- by count of events for each plan_name
SELECT p.plan_name, 
	   p.plan_id,
       COUNT(*) AS events_count
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE YEAR(s.start_date) > 2020
GROUP BY p.plan_name, p.plan_id;


-- 4. What is the customer count and percentage of customers who have churned rounded to 1
-- decimal place?

SELECT COUNT(DISTINCT(CUSTOMER_ID)) AS CUSTOMER_COUNT,
ROUND( (COUNT(DISTINCT(CUSTOMER_ID)) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions) ) *100 ,1) AS PERCENTAGE
FROM SUBSCRIPTIONS
WHERE PLAN_ID IN (
    SELECT PLAN_ID
    FROM plans 
    WHERE PLAN_NAME = 'churn' OR PRICE IS NULL
);

-- 5. How many customers have churned straight after their initial free trial - what percentage is
-- this rounded to the nearest whole number?

SELECT COUNT(DISTINCT(SUB.CUSTOMER_ID)) AS CUSTOMER_COUNT,
ROUND( (COUNT(DISTINCT(SUB.CUSTOMER_ID)) / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions) ) *100 ,1) AS PERCENTAGE
FROM SUBSCRIPTIONS SUB
JOIN PLANS P ON SUB.PLAN_ID = P.PLAN_ID
WHERE
P.PLAN_NAME="churn" AND
DAY(SUB.START_DATE) <= 8;	

-- 6. What is the number and percentage of customer plans after their initial free trial?
WITH cte_next_plan AS (
    SELECT *, 
        LEAD(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY start_date) AS next_plan 
    FROM subscriptions
)  
 SELECT 
 next_plan, 
 COUNT(*) AS num_cust, 
 ROUND (COUNT(*) * 100/(SELECT COUNT(DISTINCT customer_id) FROM subscriptions),1) AS perc_next_plan 
 FROM cte_next_plan 
 WHERE next_plan is not null and plan_id = 0 
 GROUP BY next_plan 
 ORDER BY next_plan;

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020- 12-31?

SELECT 
    p.plan_name,
    COUNT(DISTINCT s.customer_id) AS customer_count,
    ROUND((COUNT(DISTINCT (s.customer_id)) * 100.0 / total_customers.total_customer_count), 1) AS percentage
FROM 
    subscriptions s
JOIN 
    plans p ON s.plan_id = p.plan_id
JOIN
    (SELECT COUNT(DISTINCT (customer_id)) AS total_customer_count FROM subscriptions WHERE start_date <= '2020-12-31') AS total_customers
    -- Subquery to calculate the total customer count as of December 31, 2020
GROUP BY 
    p.plan_name, total_customers.total_customer_count;

-- 8. How many customers have upgraded to an annual plan in 2020?
SELECT 
	COUNT(customer_id) AS num_customer 
    FROM subscriptions 
    WHERE plan_id = 3 AND start_date <= '2020-12-31';


-- 9. How many days on average does it take for a customer to an annual plan from the day they joined Foodie-Fi?
WITH first_subscription_dates AS (
    SELECT 
        customer_id,
        MIN(start_date) AS joined_date
    FROM 
        subscriptions
    GROUP BY 
        customer_id
),
upgrade_dates AS (
    SELECT 
        s.customer_id,
        MIN(s.start_date) AS upgrade_date
    FROM 
        subscriptions s
    JOIN 
        plans p ON s.plan_id = p.plan_id
    WHERE 
        p.plan_name = 'pro annual'
    GROUP BY 
        s.customer_id
)
SELECT 
    ROUND(AVG(DATEDIFF(u.upgrade_date, f.joined_date)),0) AS average_days_to_upgrade
FROM 
    first_subscription_dates f
JOIN 
    upgrade_dates u ON f.customer_id = u.customer_id;
    
-- 10. Can you further breakdown this average value into 30 day periods? (i.e. 0–30 days, 31–60 days etc)
WITH annual_plan AS (
    SELECT 
        customer_id, 
        start_date AS annual_date 
    FROM 
        subscriptions 
    WHERE 
        plan_id = 3
), 
trial_plan AS (
    SELECT 
        customer_id, 
        start_date AS trial_date 
    FROM 
        subscriptions 
    WHERE 
        plan_id = 0
), 
day_period AS (
    SELECT 
        DATEDIFF(ap.annual_date, tp.trial_date) AS diff 
    FROM 
        trial_plan tp 
    LEFT JOIN 
        annual_plan ap ON tp.customer_id = ap.customer_id 
    WHERE 
        ap.annual_date IS NOT NULL
) 
SELECT 
    CONCAT((bins * 30) + 1, ' - ', (bins + 1) * 30, ' days') AS days_range,
    COUNT(*) AS total 
FROM (
    SELECT 
        FLOOR(diff / 30) AS bins 
    FROM 
        day_period
) AS bins
GROUP BY 
    bins;



-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
SELECT 
    COUNT(DISTINCT s1.customer_id) AS downgrade_count
FROM 
    subscriptions s1
JOIN 
    subscriptions s2 ON s1.customer_id = s2.customer_id
JOIN 
    plans p1 ON s1.plan_id = p1.plan_id
JOIN 
    plans p2 ON s2.plan_id = p2.plan_id
WHERE 
    p1.plan_name = 'pro' AND p1.price = 19.90  -- pro monthly plan
    AND p2.plan_name = 'basic' AND p2.price = 9.90  -- basic monthly plan
    AND YEAR(s1.start_date) = 2020 AND YEAR(s2.start_date) = 2020
    AND s1.start_date < s2.start_date;


