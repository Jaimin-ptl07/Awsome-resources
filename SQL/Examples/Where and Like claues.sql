select*
from employee_salary;

select *
from employee_salary
where salary>=50000
;

select first_name, last_name, salary
from employee_salary
where salary>=50000 AND dept_id=1
;

select *
from employee_demographics
where birth_date > '1985-07-26'
;

select *
from employee_salary
where occupation='Office Manager'
;

select *
from employee_salary
where first_name like 'Jer%'
;

select *
from employee_salary
where first_name like 'Jer__'
;