/* Construction Site Employee Data Cleaning */

------------------------------------------------------------------------------------------------------------------------------------------------

/* Creating Tamp Table */

--- Joins all the tables

select *
	into company
	from salaries s
	left join companies c on (s.comp_code = c.company_name)
	left join "functions" f on (s.func_code = f.function_code)
	left join employees e on (s.employee_id = e.employee_code_emp)
	
------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a unique identity code table column from 2 different columns

select
	concat(employee_id, cast(date as date)) as id,
	cast (date as date) as month_year,
	employee_id,
	employee_name,
	"GEN(M_F)",
	age,
	salary,
	function_group,
	company_name,
	company_city,
	company_state,
	company_type,
	const_site_category
from company c;

------------------------------------------------------------------------------------------------------------------------------------------------

--- Change bad table names to clear table names

ALTER TABLE company.company RENAME COLUMN "GEN(M_F)" TO gender;

------------------------------------------------------------------------------------------------------------------------------------------------

--- Transform this new table into a dataset (df_employee) for analysis

select
	concat(employee_id, cast(date as date)) as id,
	employee_name,
	cast (date as date) as entry_date,
	gender,
	age,
	salary,
	function_group,
	company_name,
	company_city,
	company_state,
	company_type,
	const_site_category
into df_employee
from company;

------------------------------------------------------------------------------------------------------------------------------------------------

--- Use 'TRIM' to remove all unwanted spaces from all text columns

update df_employee
set id = trim(id),
	employee_name = trim(employee_name),
	gender = trim(gender),
	function_group = trim(function_group),
	company_name = trim(company_name),
	company_city = trim(company_city),
	company_state = trim(company_state),
	company_type = trim(company_type),
	const_site_category = trim(const_site_category)
where true;

------------------------------------------------------------------------------------------------------------------------------------------------

--- Check for 'NULL' values

select *
from df_employee
where id is null
or employee_name is null
or entry_date is null
or gender is null
or age is null
or salary is null
or function_group is null
or company_name is null
or company_city is null
or company_state is null
or company_type is null
or const_site_category is null

------------------------------------------------------------------------------------------------------------------------------------------------

--- Confirm missing values in all columns

select count(id) as count_missing_id 
from df_employee
where id = ' '


select count(employee_name) as count_missing_name
from df_employee
where id = ' '


select count(entry_date) as count_missing_date 
from df_employee
where id = ' '


select count(age) as count_missing_age 
from df_employee
where id = ' '


select count(salary) as count_missing_salary 
from df_employee
where id = ' '


select count(function_group) as count_missing_function_group 
from df_employee
where id = ' '


select count(company_name) as count_missing_company_name 
from df_employee
where id = ' '


select count(company_city) as count_missing_company_city
from df_employee
where id = ' '


select count(company_state) as count_missing_id_company_state 
from df_employee
where id = ' '


select count(company_type) as count_missing_id_company_type 
from df_employee
where id = ' '


select count(const_site_category) as count_missing_id_site_category
from df_employee
where id = ' '

------------------------------------------------------------------------------------------------------------------------------------------------

--- Changing the gender column 'M' in 'Male' and 'F' in 'Female'

select distinct id 
from df_employee
group by id 

update df_employee
set gender = case gender
				when 'M' then 'Male'
				when 'F' then 'Female'
				else  gender
			end
where true 

------------------------------------------------------------------------------------------------------------------------------------------------

--- Check for duplicated rows in 'id' column

select id, count(id) as duplicat
from df_employee
group by id
having count(id) > 1

------------------------------------------------------------------------------------------------------------------------------------------------

--- Removing duplicate rows by creating a CTE with the WINDOW function ROWNUMBER
--- The duplicates are those that contain repeated id and entry_date
--- Afterwards, apply the DELETE statement with the condition that the row_num is greater than 1

with cte_employee as (
	select *,
			row_number()over(
			partition by entry_date, id order by id ) row_num
	from df_employee
)
delete from df_employee
where id in(
	select id
	from cte_employee 
	where row_num > 1
)



