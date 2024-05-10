-- Total customer and order in each month 
SELECT 
  format_datetime('%Y-%m',created_at) as order_time,
  count(distinct user_id),
  count(order_id)
FROM `bigquery-public-data.thelook_ecommerce.orders` 
group by format_datetime('%Y-%m',created_at)
order by order_time
LIMIT 1000 

--avg revenue and total customer each month
select 
  format_datetime('%Y-%m', created_at) as order_time,  
  round(sum(sale_price)/ count(order_id),2) as avg_revenue,
  count(distinct user_id) as total_customer  
from bigquery-public-data.thelook_ecommerce.order_items
where not status in ('Returned', 'Processing', 'Cancelled')
group by format_datetime('%Y-%m',created_at)
order by order_time

--Oldest and Youngest customer by gender from 1/2019 to 4/2022

with youngest_age as(
select 
  first_name,
  last_name,
  gender,
  age,
  'youngest' as tag
from bigquery-public-data.thelook_ecommerce.users
where format_datetime('%Y-%m', created_at) between '2019-01' and '2022-04'
order by age 
