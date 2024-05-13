-- Revenue by customer

With customer_info as (
SELECT 
  oi.created_at as month, 
  us.id as user_id,
  count(distinct oi.order_id) as TPO,
  round(sum(oi.sale_price),2) as TPV,
  round(sum(pr.cost),2) as Total_cost,
  round(sum(oi.sale_price) - sum(pr.cost),2) as Total_profit,
  round((sum(oi.sale_price) - sum(pr.cost))/sum(pr.cost),2) as Profit_to_cost_ratio 
FROM `bigquery-public-data.thelook_ecommerce.order_items` as oi
join bigquery-public-data.thelook_ecommerce.products as pr
on oi.product_id = pr.id
join bigquery-public-data.thelook_ecommerce.users as us
on us.id = oi.order_id
where cast(us.id as string) <> ""
group by  oi.created_at, us.id
having count(distinct oi.order_id) >0 and sum(pr.cost)>0 and sum(oi.sale_price)>0
order by oi.created_at, us.id

)
-- check duplicates
, customer_clean as(
select *
from(
select *,
row_number() over (partition by user_id, month, TPO ) as number
from customer_info
) as a
where number = 1
)

-- Create cohort elements
, cohort_chart as(
select
  user_id,
  format_datetime('%Y-%m', first_purchase) as cohort_date,
  (extract(year from month) - extract(year from first_purchase))*12 + (extract(month from month) - extract(month from first_purchase)) +1 as index_cohort,
  Total_profit
from (
select 
  month,
  user_id,
  Total_profit,
  min(month) over (partition by user_id) as first_purchase
from customer_clean
) as t
)
select 
  cohort_date,
  index_cohort,
  count(distinct user_id),
  sum(Total_profit)
from cohort_chart
group by cohort_date, index_cohort



-- Revenue by categories

With revenue as (
SELECT 
  format_datetime('%Y-%m', oi.created_at) as month, 
  extract(year from oi.created_at) as Year,
  extract(month from oi.created_at) as month_for_update,
  pr.category as Product_category,
  count(distinct oi.order_id) as TPO,
  round(sum(oi.sale_price),2) as TPV,
  round(sum(pr.cost),2) as Total_cost,
  round(sum(oi.sale_price) - sum(pr.cost),2) as Total_profit,
  round((sum(oi.sale_price) - sum(pr.cost))/sum(pr.cost),2) as Profit_to_cost_ratio 
FROM `bigquery-public-data.thelook_ecommerce.order_items` as oi
join bigquery-public-data.thelook_ecommerce.products as pr
on oi.product_id = pr.id
group by  extract(year from oi.created_at),extract(month from oi.created_at), format_datetime('%Y-%m', oi.created_at), pr.category
order by Product_category, Year, month
), revenue_summary as(
select
  month,
  month_for_update,
  year,
  Product_category, 
  TPV,
  COALESCE(round((100*(TPV-lag(TPV) over(partition by Product_category order by Product_category, year, month )))/TPV,2),0) || '%' as Revenue_growth,
  TPO,
  COALESCE(round(100*((TPO- lag(TPO) over(partition by Product_category order by Product_category, year, month ))/TPO),2),0) ||'%' as Order_growth,
  Total_cost, 
  Total_profit,
  Profit_to_cost_ratio, 
  min(month_for_update) over (partition by Product_category order by year, month_for_update) as first_purchase_month,
  min(year) over (partition by Product_category order by year) as first_purchase_year
from revenue
order by Product_category, year, month
)
select 
  month,
  (Year-first_purchase_year)*12 + (month_for_update -first_purchase_month) +1 as index_cohort,
  Product_category,
  TPV,
  Revenue_growth,
  TPO,
  Order_growth,
  Total_cost,
  Total_profit,
  Profit_to_cost_ratio
from revenue_summary

