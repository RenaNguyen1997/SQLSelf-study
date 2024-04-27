
-- Question 1
SELECT 
sum(CASE
  When device_type in ('tablet', 'phone') then 1 
  else 0
END) as mobile_views,
sum(CASE
  When device_type ='laptop' then 1 
  else 0
END) as laptop_views
FROM viewership
group by laptop_views, mobile_views

--Question 2
select x,y,z, 
case
    when x+y < z or x+z<y or z+y<x then 'No'
    else 'Yes'
end as 'Triangle'
from Triangle

-- Question 3

SELECT
sum(CASE
  When COALESCE(call_category, 'n/a') = 'n/a' then 1 else 0 
end) as uncategorized,
count(case_id	) as total_calls,
round(sum(CASE
  When COALESCE(call_category, 'n/a') = 'n/a' then 1 else 0 
end) / count(case_id), 1)
FROM callers

--Question 4
select name
from Customer
where not referee_id  = 2
or referee_id IS NULL

-- Question 5
select 
   Case
        when survived = 1 then 'survivors'
        else 'non-survivors'
    end as Total_number,
   sum(case
        when pclass = 1 then 1 else 0
    end) First_class,
    sum(case
        when pclass = 2 then 1 else 0
    end) Second_class,
    sum(case
        when pclass = 3 then 1 else 0
    end) Third_class
from titanic
group by survived
