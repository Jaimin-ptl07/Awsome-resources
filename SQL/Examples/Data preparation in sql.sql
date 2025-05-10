-- profile distributing | histograms and Frequencies
--categorical data

--frequencies
select gender, count(*) 
	from employee_demographics
	group by gender;

--no of categories
select count(*)
from(
	select gender, count(*) 
	from employee_demographics
	group by gender
) a
group by a;

--continuous data | binning
select count(*)
from(
	select *,
	case when salary<25000 then 'low'
		 when salary<50000 then 'medium'
		 else 'high'
	end as bins
	from employee_salary
) as b
group by bins;


--ntile | quertiles
select * from employee_salary;

select salary, ntile(5) over(order by salary)
from employee_salary;

select ntiles, min(salary), max(salary), count(ntiles)
from(
	select salary, ntile(5) over(order by salary) as ntiles
	from employee_salary
)as a
group by ntiles;


--profiling data quailty

-- Detecting duplicates

--using subquery
select *
from(
	select *, count(*) as record
	from employee_demographics
	group by 1,2,3,4,5,6
)as a
where record >1

--using having claues
select *
from employee_demographics
group by 1,2,3,4,5,6
having count(*)=2


--deduplication with group by distinct

select distinct a.employee_id, a.first_name, a.last_name
from employee_demographics a
join employee_salary b on a.employee_id = b.employee_id 


select a.employee_id, a.first_name, a.last_name
from employee_demographics a
join employee_salary b on a.employee_id = b.employee_id
group by 1, 2, 3


-- Preparing data cleaning
--1. CASE transformations
--2. adjusting for null
--3. changing data types

--1. CASE transformations

select * from employee_demographics

select *,
case when gender='Female' then 'F' else 'M' end as new_gender
from employee_demographics


--2. Type conversion ( input::datatype | cast(input as datatype))
select age::float from employee_demographics;

select cast(age as int) from employee_demographics;


--3. Dealing with Nulls

select 
case when b.salary is null then 0 else b.salary end,
case when a.age is null then 0 else a.age end
--case when columna is null then 'columnb' else 'columna' end
from employee_demographics a
left join employee_salary b on a.employee_id = b.employee_id;


select 
coalesce(salary, 0),
coalesce(age, 0)
--coalesce(column_a, 'column_b'),
from employee_demographics a
left join employee_salary b on a.employee_id = b.employee_id;


--preparing: shaping data

--pivot table | postgres does not have pivot function
SELECT 
    AVG(CASE WHEN gender = 'Male' THEN age ELSE 0 END) AS Male,
    AVG(CASE WHEN gender = 'Female' THEN age ELSE 0 END) AS Female
FROM 
    employee_demographics;



