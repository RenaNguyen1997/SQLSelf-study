--Clean data 
with information as(
select *
from(
select 
	*,
	row_number() over (partition by ordernumber, qtr_id, contactfirstname, contactlastname, month_id, year_id, sales) as stt
from public.sales_dataset_rfm_prj_clean
) as a
where stt = 1
), summary as(
select
	ifn.ordernumber, 
	ifn.quantityordered,
	ifn.priceeach,
	ifn.sales,
	ifn.qtr_id,
	ifn.month_id,
	ifn.year_id,
	ifn.contactfirstname,
	ifn.contactlastname,
	rfm.productline,
	rfm.dealsize,
  rfm.country
from information as ifn
join public.sales_dataset_rfm_prj as  rfm on ifn. ordernumber = rfm.ordernumber
where ifn.ordernumber <> 0 and ifn.quantityordered <>0 and ifn.sales <>0 
and ifn.ordernumber is not NULL and ifn.quantityordered is not NULL and ifn.sales is not NULL
)

--Question 1
select 
	productline,
	dealsize,
	year_id,
	sum(sales) as total_revenue
from summary
group by productline, dealsize, year_id
order by productline, dealsize, year_id, total_revenue DESC

--Question 2: In 2003 and 2004, November leads the revenue, in 2005 May's revenue was the highest (Revenue used to reach its peack during last months of the year in 2003 and 2004, but the trend seems to shift
  -- to starting of the years during 2005)

, monthly_revenue as(
select *,
dense_rank() over (partition by year_id order by revenue desc) as ranking
from(
select 
	month_id,
	year_id,
	sum(sales) as revenue
from summary
group by month_id, year_id
order by sum(sales) desc, month_id
) as b
)
select * from monthly_revenue 
where ranking = 1

-- Question 3: Classic cars is the most ordered items in November each year (2005 does not have records for sales in November)

, product_order as (
select *,
dense_rank() over (partition by year_id order by total_order desc) as ranking
from(
select 
	month_id,
	year_id,
	productline,
	sum(quantityordered) as total_order
from summary
where month_id = 11
group by month_id, year_id, productline
order by sum(quantityordered) desc
) as b
)
select month_id, total_order, revenue from product_order 
where ranking = 1

--Question 4: 
  -- In UK, productline with highest revenue are planes (2003), Trains (2994) and Motorcycles(2005)

select 
	year_id,
	productline,
	revenue,
	rank() over (partition by year_id order by revenue) as ranking
from(
select 
	year_id,
	productline,
	country,
	sum(sales) as revenue
from summary
where country = 'UK'
group by year_id, productline, country
order by revenue DESC
) as c
order by ranking, year_id

--Question 5: Mary Saveley is the best customer with the highest rfm_score as Champions 

, RFM_table as(

select 
	contactfirstname,
	contactlastname,
	ntile(5) over (order by R desc) as r_score,
	ntile(5) over (order by F) as f_score,
	ntile(5) over (order by M) as m_score
from
(select 
	contactfirstname,
	contactlastname,
	max(orderdate)- min(orderdate) as R,
	count(distinct ordernumber) as F,
	sum(sales) as M
from summary
group by contactfirstname, contactlastname) as d
), rfm as(
select 
	contactfirstname,
	contactlastname,
	cast(r_score as varchar) || cast(f_score as varchar) || cast(m_score as varchar) as rfm_score
from RFM_table
) 

select 
	rfm.contactlastname,
	rfm.contactfirstname,
	rfm.rfm_score,
	ss.segment
from rfm
join public.segment_score as ss
on rfm.rfm_score = ss.scores
order by rfm_score desc
