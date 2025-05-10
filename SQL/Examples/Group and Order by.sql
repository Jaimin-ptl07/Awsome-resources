select * 
from employee_demographics;

select * 
from employee_demographics
order by age ASC;

select * 
from employee_demographics
order by first_name DESC, last_name DESC;

select gender, avg(age) as avg_age 
from employee_demographics
group by gender;

SELECT gender, MIN(age), MAX(age), COUNT(age),AVG(age)
FROM employee_demographics
GROUP BY gender
;