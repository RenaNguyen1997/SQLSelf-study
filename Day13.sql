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




