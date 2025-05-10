-- Data cleaning

select * from layoffs;


--1. remove duplicates
--2. standardize the data
--3. remove null and blank values
--4. remove columns

--create stagging tables
create table layoffs_stagging (like layoffs including all);

select * from layoffs_stagging;

insert into layoffs_stagging
select * from layoffs;

select * from layoffs_stagging;


--1. duplicate data

select *,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country ,funds_raised_millions
)
from layoffs_stagging;

--one way
with duplicate_cte as
(
select *,
row_number() over (partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country ,funds_raised_millions)as row_num
from layoffs_stagging
)
select *
from duplicate_cte
where row_num >1;

--another way
select *
from(
	select *,
	row_number() over (partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country ,funds_raised_millions)as row_num
	from layoffs_stagging
)as a
where row_num>1;

-- another one
with dup_cte as 
(
	select *,
	count(*) as record
	from layoffs_stagging
	group by 1,2,3,4,5,6,7,8,9
)
select *
from dup_cte
where record >1;

-- we can't directly delete from ctes, so we will create a new stagging table with row num
insert into layoffs_stagging2
select *,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country ,funds_raised_millions
)
from layoffs_stagging;

select * from layoffs_stagging2;

--deleting duplicates
Delete from layoffs_stagging2
where row_num>1;


--2. Standardization

select * from layoffs_stagging2;

select company, trim(company) from layoffs_stagging2;

--update the trim company
update layoffs_stagging2
set company = trim(company);

--working with industry col
select distinct industry
from layoffs_stagging2
order by industry
;

select distinct(company), industry
from layoffs_stagging2
where industry like 'Crypto%';


update layoffs_stagging2
set industry = 'Crypto'
where industry like 'Crypto%';


--working with country col
select distinct country
from layoffs_stagging2
order by country;

update layoffs_stagging2
set country = 'United States'
where country like 'United States.';


--change date columne to date datatype
select date,
to_date(date, '%mm/%dd/%YYYY')
from layoffs_stagging2
order by date desc;

update layoffs_stagging2
set date = to_date(date, '%mm/%dd/%YYYY');

alter table layoffs_stagging2
alter column date type DATE using date::date;

select date from layoffs_stagging2;


--3. Handling nulls or blank values

-- In Industry col
select *
from layoffs_stagging2
where industry = '' or industry is null;

select *
from layoffs_stagging2
where company like 'Ball%';


select t1.industry,t1.company, t2.industry 
from layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
	and t1.location = t2.location
where (t1.industry = '' or t1.industry is null)
and t2.industry is not null
;

-- as we can't use update and join in postgres | we will manually change the industry

update layoffs_stagging2
set industry='Travel'
where company='Airbnb';

update layoffs_stagging2
set industry='Transportation'
where company='Carvana';

update layoffs_stagging2
set industry='Consumer'
where company='Juul';

delete from layoffs_stagging2
where industry is null;


-- In total_laid_off col

select * 
from layoffs_stagging2
where total_laid_off is null 
and percentage_laid_off is null;


delete 
from layoffs_stagging2
where total_laid_off is null 
and percentage_laid_off is null;

alter table layoffs_stagging2
drop column row_num;

select * from layoffs_stagging2;