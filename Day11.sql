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

  --Question 8
  select customer_id 
from Customer 
group by customer_id
having count(distinct product_key) = (select count(product_key ) from Product)

--Question 9
with salary_s as (
select *
from Employees
where salary < 30000
),
manager_s as(
select mng. manager_id, em. employee_id
from Employees mng left join Employees em on em.employee_id  = mng.manager_id  
where mng.manager_id IS NOT NULL and em.employee_id is NULL
)
select distinct ss.employee_id 
from salary_s ss join manager_s ms on ms. manager_id  = ss.manager_id 
order by ss.employee_id 

--Question 10
WITH count_duplicate as(
select
  company_id,
  title, 
  description, 
  count(job_id) as total_duplicate
from job_listings   
group by company_id, title, description
)
select count(company_id)
from count_duplicate
where total_duplicate >1

--Question 11
(select us.name as results
from MovieRating mr join Users us on mr.user_id = us.user_id
group by us.name
order by count(mr.movie_id) DESC, us.name limit 1)

UNION ALL

(select mo.title as title
from MovieRating mr join Movies mo on mr.movie_id= mo.movie_id
where extract(year_month from mr.created_at) = 202002
group by mo.title
order by avg(mr.rating) DESC, mo.title ASC
limit 1)

--Question 12
with calculate as(
(select requester_id  as friend, accepter_id as friend_now
from RequestAccepted)

union all

(select accepter_id, requester_id
from RequestAccepted)
)
select friend as id, count(*) as num
from calculate
group by friend
order by num desc   
limit 1
