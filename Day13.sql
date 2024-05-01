--Question 1
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

--Question 2
with gross as(
SELECT 
  category,
  product,
  sum (spend) as total_spend,
  RANK() OVER(PARTITION BY category ORDER BY sum (spend) DESC) as ranking
FROM product_spend
where extract (year from transaction_date) = 2022
group by category,product
)
select 
  category,
  product,
  total_spend
from gross
where ranking <3

--Question 3
WITH count_table
as(
SELECT policy_holder_id, count(case_id) as total_number
FROM callers
group by policy_holder_id
)
select count(policy_holder_id)
from count_table
where total_number >=3

--Question 4
SELECT pp.page_id
FROM pages as pp left join page_likes as pk
on pp.page_id = pk. page_id
where liked_date is NULL
order by pp.page_id

--Question 5
with summary as(
SELECT user_id
FROM user_actions
where extract (month from event_date) = 7
group by user_id, extract (month from event_date)
having count(event_type) >=1

INTERSECT 

SELECT user_id
FROM user_actions
where extract (month from event_date) = 6
group by user_id, extract (month from event_date)
having count(event_type) >=1
)
select 7 as month, count(*) as monthly_active_users
from summary 

--Question 6
with total as(
select 
    country, 
    concat(extract(year from trans_date), '-', extract(month from trans_date)) as month, 
    count(id) as trans_count,
    sum(amount) as trans_total_amount 
from Transactions 
group by country, concat(extract(year from trans_date), '-', extract(month from trans_date))
), approve as(
select 
    country, 
    concat(extract(year from trans_date), '-', extract(month from trans_date)) as month, 
    count(id) as approved_count,
    sum(amount) as approved_total_amount 
from Transactions 
where state = 'approved'
group by country, concat(extract(year from trans_date), '-', extract(month from trans_date))
)
select total. country, total. month, total. trans_count, approve.approved_count, total. trans_total_amount, approve.approved_total_amount 
from total join approve
on total.country = approve. country and total.month = approve.month 

--Question 7
with firstyear as(
select product_id, min(year) as first_year
from Sales 
group by product_id
)
select fy.product_id, fy. first_year, p.quantity, p.price 
from firstyear as fy join Sales  as p on fy.product_id= p.product_id and fy. first_year= p.year 

-- Question 8
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




