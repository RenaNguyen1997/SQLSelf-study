--Question 1
select distinct replacement_cost
from public.film
order by replacement_cost

--Question 2
select 
	sum(Case
		When replacement_cost <= 19.99 then 1 else 0
	   End) as Low,
	sum(Case
		When replacement_cost between 20.00 and 24.99 then 1 else 0
	   End) as medium, 
	sum(Case
		When replacement_cost >= 25 then 1 else 0
	   End) as high	
from public.film

--Question 3
select f.title, f.length, ct.name
from public.film as f
join public.film_category as fc on f.film_id= fc.film_id
join public.category as ct on ct.category_id= fc.category_id
where ct.name in ('Drama', 'Sports')
order by f.length DESC

--Question 4
select ct.name, count(f.title) as total_number
from public.film as f
join public.film_category as fc on f.film_id= fc.film_id
join public.category as ct on ct.category_id= fc.category_id
group by ct.name
order by total_number desc

--Question 5
select ac.first_name|| ' ' || ac.last_name as Full_name, count(f.film_id) as number_of_film
from public.actor as ac 
join public.film_actor as fa on ac.actor_id= fa.actor_id
join public.film as f on fa.film_id= f.film_id
group by ac.first_name|| ' ' || ac.last_name
order by number_of_film desc

--Question 6
select count(ad. address_id)
from public.address as ad
left join public.customer as cu on ad.address_id= cu.address_id
where cu.customer_id IS NULL

--Question 7
select ci.city, sum(amount) as total
from public.customer cu
join public.address ad on cu.address_id= ad.address_id
join public.payment pa on pa.customer_id = cu.customer_id
join public.city ci on ci.city_id = ad.city_id
group by ci.city
order by total desc


--Question 8
select co.country||', '||ci.city as Country_and_City, sum(amount) as total
from public.customer cu
join public.address ad on cu.address_id= ad.address_id
join public.payment pa on pa.customer_id = cu.customer_id
join public.city ci on ci.city_id = ad.city_id
join public.country co on ci.country_id = co.country_id
group by co.country, ci.city 
order by total desc

