--Question 1: Convert data type

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric USING (ordernumber::numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING (quantityordered::numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (priceeach::numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE numeric USING (orderlinenumber::numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING (sales::numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE numeric USING (msrp::numeric)

alter table sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE DATE USING (orderdate::DATE)

--Question 2: 
select *
from sales_dataset_rfm_prj
where ordernumber is NULL
or quantityordered is NULL 
or priceeach is NULL
or orderlinenumber is NULL
or sales is NULL
or orderdate is NULL

--Question 3: Add firstname and lastanme column deriving from fullname
Alter table sales_dataset_rfm_prj
	add column contactlastname varchar(50),
	add column contactfirtname varchar(50)

update sales_dataset_rfm_prj
set contactfirtname = upper(left(contactfullname,1)) || substring(contactfullname from 2 for position('-' IN contactfullname)-2),
contactlastname = upper(substring(contactfullname from position('-' in contactfullname)+1 for 1))|| substring(contactfullname from position('-' in contactfullname)+2 for length(contactfullname))

Alter table sales_dataset_rfm_prj
rename column contactfirtname to contactfirstname

--Question 4: Add quarter, month and year column deriving from orderdate
Alter table sales_dataset_rfm_prj
add column qtr_id numeric,
add column month_id = meric,
add column year_id numeric 

Update sales_dataset_rfm_prj
set qtr_id = extract(quarter from orderdate),
month_id = extract(month from orderdate),
year_id = extract (year from orderdate)


--Question 5: Find outlier 
--Solution 1: Boxplot
with iqr_range as(
select 
	q1 - 1.5*iqr as min_value,
	q3 + 1.5*iqr as max_value
from 
(select 
	percentile_cont(0.25) within group (order by quantityordered) as Q1,
	percentile_cont(0.75) within group (order by quantityordered) as Q3,
	percentile_cont(0.75) within group (order by quantityordered) - percentile_cont(0.25) within group (order by quantityordered) as IQR
from sales_dataset_rfm_prj) as a
)
select quantityordered
from sales_dataset_rfm_prj
where quantityordered < (select min_value from IQR_range)
or quantityordered > (Select max_value from IQR_range)

--Solution 2: Z-score 
with ctes as (
select
	quantityordered,
	(select avg(quantityordered) from sales_dataset_rfm_prj ) as avg,
	(select stddev(quantityordered) from sales_dataset_rfm_prj ) as std
from sales_dataset_rfm_prj
)
select 
	quantityordered, 
	(quantityordered - avg)/ std as z_score
from ctes
where abs((quantityordered - avg)/ std) >3

--Question 6: Save clean data into new table 
Create table SALES_DATASET_RFM_PRJ_CLEAN as
(select ordernumber, quantityordered, priceeach, sales, qtr_id, month_id,year_id, contactfirstname, contactlastname 
from sales_dataset_rfm_prj)
