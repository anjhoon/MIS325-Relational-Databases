-- Andrew Chen
-- MIS325 HW4
-- ac68644

-- Question 1
select first_name, salary, commission_pct, hire_date
from employees
where salary < 10000;

-- Question 2
select first_name, hire_date
from employees
where job_id = 'IT_PROG' or job_id = 'SA_MAN';

-- Question 3
select job_title, max_salary-min_salary
from jobs
where max_salary between 10000 and 20000
order by job_title asc;

-- Question 4
select first_name||' '||last_name as FirstName_LastName
from employees
where first_name like 'S%' or last_name like 'S%';

-- Question 5
select manager_id, count(employee_id)
from employees
group by manager_id;

-- Question 6
select department_id, avg(salary)
from employees
group by department_id;

-- Question 7
select department_id, avg(salary)
from employees
group by department_id
having avg(salary) > 10000;

-- Question 8
select department_name, avg(salary)
from departments, employees
where departments.department_id = employees.department_id
group by department_name
having avg(salary) > 10000;

-- Question 9
select distinct department_name, department_id
from departments
where department_id in (select department_id from employees where last_name like 'H%');

-- Question 10
select distinct t1.first_name, t1.last_name, t1.salary
from employees t1, employees t2
where t1.employee_id = t2.manager_id;