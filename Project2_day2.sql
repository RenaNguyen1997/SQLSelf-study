--Original data for col1, col2
-- select 
--   format_datetime('%Y-%m',od.created_at) as month,
--   format_datetime('%Y', od.created_at) as Year,
--   pd.category as Product_category
-- from bigquery-public-data.thelook_ecommerce.orders as od
-- join bigquery-public-data.thelook_ecommerce.order_items as oi on od.order_id = oi.order_id
-- join bigquery-public-data.thelook_ecommerce.products as pd on oi.product_id = pd.id
-- order by year, month


--Col3,col4, monthly revenue by category: TPV, TPO
With revenue as (
SELECT 
  format_datetime('%Y-%m', oi.created_at) as yearmonth, 
  pr.category as Product_category,
  count(distinct oi.order_id) as TPO,
  round(sum(oi.sale_price),2) as TPV
FROM `bigquery-public-data.thelook_ecommerce.order_items` as oi
join bigquery-public-data.thelook_ecommerce.products as pr
on oi.product_id = pr.id
group by format_datetime('%Y-%m', oi.created_at), pr.category
order by Product_category, yearmonth
)
select
  yearmonth,
  Product_category, 
  TPV,
  lag(TPV) over(order by Product_category, yearmonth ) as previous_month_TPV
from revenue
order by Product_category, yearmonth
