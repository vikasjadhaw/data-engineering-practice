show databases;
use avd;

-- Find all unique employees who appeared in either 2025 or 2026.
select emp_id, 
  emp_name,
  department
  from employees_2025
  union
select emp_id,
 emp_name,
 department
 from employees_2026;
 
 
--  Find all employee records from both years, including duplicates.

select emp_id, emp_name, department
from employees_2025
union all
select emp_id, emp_name, department
from employees_2026; 


 
-- Find the total number of employee records present across both tables, where an employee appearing in both years should be counted twice.

select count(*)
from(
select emp_id, emp_name, department 
from employees_2025
union all
select emp_id, emp_name, department
from employees_2026
) as all_employees;


-- Find the unique departments that have employees in either 2025 or 2026.

select  department
from employees_2025
union 
select  department
from employees_2026;


-- Find all departments from both years, including repeated departments.

select department
from employees_2025
union all
select department
from employees_2026;


-- Find the employees who appeared in both 2025 and 2026.

select emp_id , emp_name, department
from employees_2025
INTERSECT
select emp_id, emp_name, department
from employees_2026;

-- Find the departments that exist in both 2025 and 2026.
select department
from employees_2025
intersect
select department
from employees_2026;


-- Find the employee IDs that exist in both employees_2025 and employees_2026, but return only the emp_id

select emp_id
from employees_2025
intersect
select emp_id
from employees_2026;

-- Find employees who were present in 2025 but NOT present in 2026.
select emp_id, emp_name
from employees_2025
except
select emp_id, emp_name
from employees_2026;

-- Find the second-highest-paid employee in each department.

select id, name, department_id, salary 
from (
   select id, name, department_id, salary,
   rank() over(partition by department_id order by salary desc) as rnk
   from employees
) as t
where rnk = 2;

# using cte
with second as (
 select id, name, department_id, salary,
 rank() over(partition by department_id order by salary desc) as rnk
 from employees
)
select * from second
where rnk =2;


-- Find employees whose salary is above the average salary of their department but below the company-wide average.

select id , name, department_id, salary,department_avg,
       company_wide_avg
from (select id, name, department_id, salary, 
     avg(salary) over(partition by department_id)as department_avg ,
     avg(salary) over() as company_wide_avg
     from employees
  ) as t
  where salary > department_avg and
        salary < company_wide_avg;


-- Find employees who joined in 2026 but were NOT present in 2025.
select emp_id, emp_name,department
from employees_2026
except
select emp_id, emp_name, department
from employees_2025;

-- Employees whose emp_id exists in both years, but return their 2025 details.

select emp_id, emp_name,department
from employees_2025
where emp_id in(
 select emp_id
 from employees_2025
 intersect
 select emp_id
 from employees_2026
);

-- Find employees who exist in both years, but whose department changed between 2025 and 2026.

select emp_id, emp_name, department as department_2025
from employees_2025
intersect
select emp_id, emp_name, department as department_2026
from employees_2026;


-- Find customers who ordered in both months.
select customer_id
from january_orders
intersect
select customer_id
from february_orders;



-- Find employees who:
-- existed in 2025
-- existed in 2026
-- changed their department

select e25.emp_id,
    e25.emp_name,
    e25.department as department_2025,
    e26.department as department_2026
    from employees_2025 e25
    join employees_2025 e26
    on e25.emp_id = e26.emp_id
        where e25.department <> e26.department;
        
        
-- Combine customers from:
-- January
-- February
-- March

select customer_id
from january_customers
union
select customer_id
from february_customers
union
select customer_id
from march_customers;


-- Combine employees from both years and sort by name.

select emp_id, emp_name, department
from employees_2025
union 
select emp_id, emp_name, department
from employees_2026
order by emp_name;



