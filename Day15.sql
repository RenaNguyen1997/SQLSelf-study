--Question 1 (Link:https://datalemur.com/questions/yoy-growth-rate)
with summary as(
SELECT 
  extract (year from transaction_date) as year, 
  product_id,
  sum(spend) over (partition by product_id, extract (year from transaction_date)) as current_year_spend
FROM user_transactions
)
select
  year,
  product_id,
  current_year_spend,
  lag(current_year_spend) over (order by product_id, year) as prev_year_spend,
  round(100* (current_year_spend - (lag(current_year_spend) over (order by product_id, year)))/lag(current_year_spend) over (order by product_id, year),2)
  as yoy_rate
from summary 

--Question 2 (link: https://datalemur.com/questions/card-launch-success)
with summary as (
SELECT 
  card_name,
  issued_amount,
  issue_month,
  issue_year,
  RANK() over(PARTITION BY card_name order by issue_year, issue_month ) as rank
FROM monthly_cards_issued
)
select 
  card_name,
  issued_amount
from summary
where rank = 1
order by issued_amount DESC

--Question 3 (Link: https://datalemur.com/questions/sql-third-transaction)
With summary as(
SELECT 
  user_id,
  spend,
  transaction_date,
  rank() over (partition by user_id order by transaction_date )
FROM transactions
)
Select 
  user_id,
  spend,
  transaction_date
from summary
where rank = 3

-- Question 4 (Link: https://datalemur.com/questions/histogram-users-purchases)
With summary as(
SELECT 
  user_id,
  transaction_date,
  count(distinct product_id ) as purchase_count,
  rank() over (partition by user_id order by transaction_date DESC) 
FROM user_transactions
group by user_id, transaction_date
)
select transaction_date, user_id,  purchase_count
from summary
where rank = 1
order by transaction_date

--Question 5 (Link: https://datalemur.com/questions/rolling-average-tweets)
With summary as(
SELECT 
  user_id,
  tweet_date,
  tweet_count,
  lag(tweet_count,1,0) over (partition by user_id order by tweet_date) as lag1,
  lag(tweet_count,2,0) over (partition by user_id order by tweet_date) as lag2, 
  row_number() over (partition by user_id order by tweet_date ) as count_total
from tweets 
)
select 
  tweet_date,
  user_id,
  lag1, lag2, tweet_count,
  CASE
    when count_total = 1 then round((tweet_count + lag1 + lag2)/1, 2)
    when count_total = 2 then round((tweet_count + lag1 + lag2)/2, 2)
    else round((tweet_count + lag1 + lag2)/3 , 2)
  END as rolling_avg_3d
from summary

-- Question 6 (link: https://datalemur.com/questions/repeated-payments)
With summary as(
SELECT 
  merchant_id,
  credit_card_id,
  amount,
  transaction_timestamp,
  extract (EPOCH from (transaction_timestamp - 
  lag(transaction_timestamp) over (partition by merchant_id, credit_card_id, amount 
  order by transaction_timestamp))/60) as time_diff
FROM transactions
)
select 
  count(merchant_id) as payment_count
from summary
where time_diff <= 10

--Question 7 (https://datalemur.com/questions/sql-highest-grossing)
with gross as(
SELECT 
  category,
  product,
  sum (spend) as total_spend,
  RANK() OVER(PARTITION BY category ORDER BY sum (spend) DESC) as ranking
FROM product_spend
where extract (year from transaction_date) = 2022
group by category,product
)
select 
  category,
  product,
  total_spend
from gross
where ranking <3

-- Question 8 (link: https://datalemur.com/questions/top-fans-rank)

With summary as (
SELECT 
  st.artist_name,
  dense_rank() over (order by count(so.song_id) DESC) as artist_rank
FROM artists as st 
join songs as so on st.artist_id = so.artist_id
join global_song_rank  as gsr on gsr.song_id = so.song_id
where gsr.rank <=10
group by st.artist_name
)
select 
  artist_name,
  artist_rank
from summary
where artist_rank <= 5

