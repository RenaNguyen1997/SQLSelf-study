With revenue as (
SELECT 
  format_datetime('%Y-%m', oi.created_at) as yearmonth, 
  format_datetime('%Y', oi.created_at) as Year,
  pr.category as Product_category,
  count(distinct oi.order_id) as TPO,
  round(sum(oi.sale_price),2) as TPV,
  round(sum(pr.cost),2) as Total_cost,
  round(sum(oi.sale_price) - sum(pr.cost),2) as Total_profit,
  round((sum(oi.sale_price) - sum(pr.cost))/sum(pr.cost),2) as Profit_to_cost_ratio
FROM `bigquery-public-data.thelook_ecommerce.order_items` as oi
join bigquery-public-data.thelook_ecommerce.products as pr
on oi.product_id = pr.id
group by format_datetime('%Y', oi.created_at),format_datetime('%Y-%m', oi.created_at), pr.category
order by Product_category, yearmonth
)
select
  yearmonth,
  year,
  Product_category, 
  TPV,
  round((100*(TPV-lag(TPV) over(order by Product_category, yearmonth )))/TPV,2) || '%' as Revenue_growth,
  TPO,
  round(100*((TPO- lag(TPO) over(order by Product_category, yearmonth ))/TPO),2) ||'%' as Order_growth,
  Total_cost, 
  Total_profit,
  Profit_to_cost_ratio
from revenue
order by Product_category, yearmonth
