-- Total customer and order in each month 
SELECT 
  format_datetime('%Y-%m',t1.created_at) as order_time,
  count(distinct t1.user_id) as total_customer,
  count(t1.order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders as t1
Join bigquery-public-data.thelook_ecommerce.order_items as t2 
on t1.order_id=t2.order_id
Where t1.status='Complete' and 
t2.delivered_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00' 
group by format_datetime('%Y-%m',t1.created_at)
order by order_time
LIMIT 1000
-- Revenue and customer, in general, increase by time
  
--avg revenue and total customer each month
select 
  format_datetime('%Y-%m', created_at) as order_time,  
  round(sum(sale_price)/ count(order_id),2) as avg_revenue,
  count(distinct user_id) as total_customer  
from bigquery-public-data.thelook_ecommerce.order_items
where (not status in ('Returned', 'Processing', 'Cancelled'))
  and (created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00')
group by format_datetime('%Y-%m',created_at)
order by order_time

--Oldest and Youngest customer by gender from 1/2019 to 4/2022
  --Youngest: 12 years old (1010 in total with more F than M)
  --Oldest:70 years old (933 in total with F and M similar)

With age_calculation as(
select 
  first_name,
  last_name,
  gender,
  age,
  "youngest" as tag
from (
select 
  first_name,
  last_name,
  gender,
  age,
  (select min(age) from bigquery-public-data.thelook_ecommerce.users) as min_age
from bigquery-public-data.thelook_ecommerce.users
where format_datetime('%Y-%m', created_at) between '2019-01' and '2022-04'
) as min_age_table
where age = min_age

UNION ALL

select 
  first_name,
  last_name,
  gender,
  age,
  "oldest" as tag
from (
select 
  first_name,
  last_name,
  gender,
  age,
  (select max(age) from bigquery-public-data.thelook_ecommerce.users) as max_age
from bigquery-public-data.thelook_ecommerce.users
where format_datetime('%Y-%m', created_at) between '2019-01' and '2022-04'
) as max_age_table
where age = max_age
)
select tag, gender, count(tag) as total
from age_calculation
group by tag, gender


-- Top 5 product generating highest revenue for each month
with product_revenue as(
SELECT 
  format_datetime('%Y-%m', oi.created_at) as yearmonth, 
  oi.product_id as product_id, 
  pr.name as product_name,
  round(sum(pr.cost), 2) as cost,
  round(sum(oi.sale_price),2) as sales,
  round(sum(oi.sale_price - pr.cost),2) as profit,
FROM `bigquery-public-data.thelook_ecommerce.order_items` as oi
join bigquery-public-data.thelook_ecommerce.products as pr
on oi.product_id = pr.id
where oi.status='Complete'
group by format_datetime('%Y-%m', oi.created_at), oi.product_id, pr.name
), ranking as(
select *,
  dense_rank() over (partition by yearmonth order by profit desc) as rank_product
from product_revenue
)
select *
from ranking
where ranking.rank_product<=5
order by yearmonth, profit desc

--Daily revenune by category in the last three months
select 
  format_datetime('%Y-%m-%d', oi.created_at) as dates,
  pr.category as product_category,
  round(sum(sale_price),2) as revenue
from bigquery-public-data.thelook_ecommerce.products as pr
join bigquery-public-data.thelook_ecommerce.order_items as oi
on pr.id = oi.product_id
where date_diff(cast(format_datetime('%Y-%m-%d', oi.created_at) as date), cast('2022-04-15' as date), month) =3
group by format_datetime('%Y-%m-%d', oi.created_at), pr.category
order by dates





