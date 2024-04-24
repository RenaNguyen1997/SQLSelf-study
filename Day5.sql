--Question 1
select distinct CITY
from STATION
where MOD(ID,2)=0

--Question 2
select COUNT(CITY) - COUNT(DISTINCT CITY)
from STATION

--Question 4
SELECT item_count, round(avg(order_occurrences),1) FROM items_per_order
group by item_count
order by item_count

-- Question 5
select candidate_id
from candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(candidate_id) = 3

-- Question 6
select user_id, DATE(max(post_date)) - DATE(min(post_date)) as days_between
from posts 
where post_date>= '2021-01-01' AND post_date < '2022-01-01'
group by user_id
having count(user_id) >=2

-- Question 7
SELECT card_name, max(issued_amount) - min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference

-- Question 8
SELECT manufacturer, count(product_id) as drug_count, sum(cogs-total_sales) as total_loss
FROM pharmacy_sales
where total_sales<cogs
group by manufacturer

-- Question 9
select *
from Cinema 
where NOT description = 'boring'
and MOD(id,2) = 1
order by rating DESC

--Question 10
select teacher_id, count(distinct subject_id) as cnt 
from Teacher
group by teacher_id

-- Question 11

select user_id, count( distinct follower_id) as followers_count
from Followers 
group by user_id

-- Question 12
select class    
from Courses 
group by class    
having count(student) >= 5



