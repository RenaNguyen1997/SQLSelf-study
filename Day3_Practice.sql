--Exercise_1
select NAME
from CITY
where POPULATION >120000
and COUNTRYCODE = 'USA'
  
--Exercise_2
Select *
from CITY
where COUNTRYCODE = 'JPN'
  
--Exercise_3
Select CITY, STATE
from STATION
  
--Exercise_4
select distinct CITY
from STATION
where CITY like 'a%'
or CITY like 'e%'
or CITY like 'i%'
or CITY like 'o%'
or CITY like 'u%'
  
--Exercise_5
select distinct CITY
from STATION
where CITY like '%a'
or CITY like '%e'
or CITY like '%i'
or CITY like '%o'
or CITY like '%u'
  
--Exercise_6
select distinct CITY
from STATION
where CITY NOT like 'a%'
and CITY NOT like 'e%'
and CITY NOT like 'i%'
and CITY NOT like 'o%'
and CITY NOT like 'u%'
  
--Exercise_7
Select name
from Employee
order by name
  
--Exercise_8
select name
from Employee
where salary>2000
and months<10
order by employee_id

--Exercise_9
select product_id
from Products
where low_fats ='Y'
and recyclable = 'Y'

--Exercise_10
select name
from Customer
where not referee_id  = 2
or referee_id IS NULL

--Exercise_11
select name, population, area
from World
where area >= 3000000
or population >= 25000000

--Exercise_12
select distinct author_id  as ID   
from Views
where author_id = viewer_id
order by author_id

--Exercise_13
SELECT * FROM parts_assembly
where finish_date IS NULL
and assembly_step >=1

--Exercise_14
select * from lyft_drivers
where yearly_salary<= 30000
or yearly_salary >= 70000

--Exercise_15
select * from uber_advertising
where money_spent > 100000
and year = 2019
