use avd;
-- Find all employees whose salary is greater than the average salary of their own department.

select employee_id, employee_name, department_id, salary 
from (
    select employee_id, employee_name, department_id, salary,
    avg(salary) over(partition by department_id) as dept_avg
    from employees
) t
where salary > dept_avg;


-- Find employees whose salary is exactly equal to their department's average salary.

select employee_id, employee_name, department_id, salary 
from (
    select employee_id, employee_name, department_id, salary,
    avg(salary) over(partition by department_id) as dept_avg
    from employees
) t
where salary = dept_avg;


-- Find employees whose salary is greater than the department average AND less than the company average.

with vicky as (
  select employee_id, employee_name, department_id,
  salary, 
  avg(salary) over(partition by department_id) as  dept_avg,
  avg(salary) over() as com_avg
  from employees
  ) 
  select * from  vicky 
  where salary > dept_avg and
    salary < com_avg;
    
    
    
-- Find employees whose salary is greater than their department average, and also display the difference between their salary and department average.


with vicky as (
  select employee_id, employee_name, department_id,
  salary, 
  avg(salary) over(partition by department_id) as  dept_avg
 
  from employees
  ) 
  select employee_id, employee_name, department_id,
  salary, 
  dept_avg,
  salary - dept_avg as salary_difference
  from vicky
  where salary > dept_avg and
   salary = salary - dept_avg;
    
    
 
