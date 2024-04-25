--Question 1
select name
from students
where marks>75
order by right(name,3), id

-- Question 2
select 
  user_id, 
  concat(upper(substring(name from 1 for 1)), lower(substring(name from 2 for (length(name)-1)))) as name
from Users

-- Question 3
SELECT 
  manufacturer, 
  '$'||floor(sum(total_sales)/1000000)||' '|| 'million' as sale
FROM pharmacy_sales
group by manufacturer
order by 
  floor(sum(total_sales)/1000000) DESC, 
  manufacturer

-- Question 4
SELECT 
  manufacturer, 
  '$'||floor((sum(total_sales)+500000)/1000000)||' '|| 'million' as sales_mil
FROM pharmacy_sales
group by manufacturer
order by 
  floor(sum(total_sales)/1000000) DESC, 
  manufacturer

-- Question 5 -- bên Lemur báo lỗi: function round(double precision, integer) does not exist. Tại lỗi này nên mình tìm cách convert avg_stars sang numeric trước rồi mới làm tròn. Có điều là code chạy nháp thử thì được, nhưng submit thì Leemur vẫn báo lỗi tương tự
SELECT 
  extract(month from submit_date) as mth, 
  product_id as product, round(cast(avg(stars) as numeric),2) as avg_stars
FROM reviews
group by 
  extract(month from submit_date), 
  product_id
order by mth, product

-- Question 6
SELECT 
  sender_id, 
  count(message_id) as message_count
FROM messages
where 
  extract(year from sent_date) = 2022 
  and extract(month from sent_date) = 8
group by sender_id
order by message_count DESC
Limit 2

-- Question 7
select 
    activity_date as day,
    count(distinct user_id ) as active_users
 from Activity
where DATEDIFF('2019-07-27', activity_date) < 30
group by activity_date

-- Question 8
select count(distinct id) as total_employee
from employees
where extract (year from joining_date) = 2022
and extract (month from joining_date) <= 7

--Question 9
select position('a' in first_name)
from worker
where first_name= 'Amitah'

--Question 10
select title, cast(substring(title from position('2' in title) for 4) as numeric) as vintage_year
from winemag_p2
where country = 'Macedonia'



