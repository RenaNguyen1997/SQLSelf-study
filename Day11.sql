--Question 1
select co.continent, floor(avg(ci.population))
from COUNTRY as co left join CITY as ci
on co.Code  = ci. CountryCode
group by co.continent

-- Question 2 - Solution 1
with rate as(
select 
  sum(CASE
    When signup_action = 'Confirmed' then 1 else 0
  END) as confirmrate,
  count(signup_action) as total
from texts)
select round(confirmrate/total,2) as activation_rate
from rate

-- Question 2 - Solution 2
SELECT round(count(t.email_id)/count(distinct e.email_id),2) as activation_rate
from emails as e left join texts as t   
on e.email_id=t.email_id
and signup_action ='Confirmed'

-- Question 3
with summary as(
SELECT 
  b.age_bucket,
  sum(CASE
    when activity_type = 'send' then time_spent else 0
  END) as send_sum,
  sum(CASE
    when activity_type = 'open' then time_spent else 0
  END) as open_sum,
  sum(time_spent) as total
FROM activities a  join  age_breakdown as b 
on a.user_id = b. user_id
WHERE activity_type IN ('send', 'open') 
group by b.age_bucket
)

select 
  age_bucket,
  round(100.0*send_sum/(send_sum+open_sum),2) as send_perc,
  round(100.0*open_sum/(send_sum+open_sum),2) as open_perc 
from summary 

-- Question 4
SELECT c.customer_id
FROM customer_contracts as c join  products as p   
on  c.product_id= p.product_id
group by c.customer_id
HAVING count(distinct p.product_category) = 3

-- Question 5
select mng. reports_to as employee_id  , e.name, count(mng. name) as reports_count, round(avg(mng.age)) as average_age 
from Employees e join Employees mng 
on e. employee_id  = mng. reports_to 
group by mng. reports_to, e.name

-- Question 6
select p.product_name, sum(o.unit) as unit 
from Products as p join Orders as o
on p.product_id = o. product_id
where extract(month from order_date) = '02'
and extract(year from order_date) = '2020'
group by product_name           
having sum(unit ) >= 100 

-- Question 7
SELECT pp.page_id
FROM pages as pp left join page_likes as pk
on pp.page_id = pk. page_id
where liked_date is NULL
order by pp.page_id
