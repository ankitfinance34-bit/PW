create database sqlsubquires
use sqlsubquires

create table Employees
(emp_id int primary key, 
name varchar(50), 
department_id varchar(50), 
salary int);

insert into Employees
(emp_id, name, department_id, salary)
values
(101, 'Abhishek', 'D01', 62000),
(102, 'Shubham', 'D01', 58000),
(103, 'Priya', 'D02', 67000),
(104, 'Rohit', 'D02', 64000),
(105, 'Neha', 'D03', 72000),
(106, 'Aman', 'D03', 55000),
(107, 'Ravi', 'D04', 60000),
(108, 'Sneha', 'D04', 75000),
(109, 'Kiran', 'D05', 70000),
(110, 'Tanuja', 'D05', 65000);

create table Department
(department_id varchar(50) primary key, 
department_name varchar(50), 
location varchar(50))

insert into Department
(department_id, department_name, location)
values
('D01', 'Sales', 'Mumbai'),
('D02', 'Marketing', 'Delhi'),
('D03', 'Finance', 'Pune'),
('D04', 'HR', 'Bengaluru'),
('D05', 'IT', 'Hyderabad');

create table Sales
(sale_id int primary key, 
emp_id int, 
sale_amount int, 
sale_date date);

insert into Sales
(sale_id, emp_id, sale_amount, sale_date)
values
(201, 101, 4500, '2025-01-05'),
(202, 102, 7800, '2025-01-10'),
(203, 103,  6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105, 9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107, 3200, '2025-02-09'),
(209, 109, 3900, '2025-02-20'),
(210, 110, 7200, '2025-03-01');

-- Basic Level

-- Q1. Retrieve the names of employees who earn more than the average salary of all employees

select name
from Employees
where salary > (select avg(salary) from Employees)

-- Q2 Find the employees who belong to the department with the highest average salary.

select e.name, d.department_name 
from Employees as e join Department as d
on e.department_id = d.department_id
where e.department_id = (

select department_id
from Employees 
group by department_id 
order by avg(salary) desc
limit 1)

-- Q3 List all employees who have made at least one sale.

select name
from Employees
where emp_id in (

select emp_id
from sales)


-- Q4 Find the employee with the highest sale amount.

select e.name
from Employees as e join Sales as s
on e.emp_id = s.emp_id
where s.sale_amount =(

select sale_amount
from Sales
order by sale_amount desc
limit 1)


-- Q5 Retrieve the names of employees whose salaries are higher than Shubham’s salary.

select name
from Employees
where salary > (

select salary
from Employees
where name = 'Shubham')


-- Intermediate Level

-- Q1 Find employees who work in the same department as Abhishek

select name
from employees
where department_id = (

select department_id
from employees
where name = 'Abhishek')


-- Q2 List departments that have at least one employee earning more than ₹60,000.

select department_name
from department
where department_id in (

select distinct department_id
from employees
where salary > 60000)

-- Q3 Find the department name of the employee who made the highest sale.

select d.department_name
from employees as e join department as d
on e.department_id = d.department_id
where e.emp_id = (

select e.emp_id
from employees as e join sales as s
on e.emp_id = s.emp_id
group by e.emp_id
order by max(s.sale_amount) desc
limit 1)


-- Q4 Retrieve employees who have made sales greater than the average sale amount

select e.name
from employees as e join sales as s
on e.emp_id = s.emp_id 
where (s.sale_amount) > (

select avg(sale_amount)
from Sales)

-- Q5 Find the total sales made by employees who earn more than the average salary.

select sum(s.sale_amount) as Total_sales
from employees as e join sales as s
on e.emp_id = s.emp_id 
where (e.salary) > (

select avg(salary)
from Employees)


-- Advanced Level

-- Q1 Find employees who have not made any sales.

select e.name
from employees as e join sales as s
on e.emp_id = s.emp_id
where e.emp_id not in (

select emp_id
from sales)


-- Q2 List departments where the average salary is above ₹55,000.

select distinct d.department_name
from employees as e join department as d
on e.department_id = d.department_id
where e.emp_id in (

select emp_id
from employees
where salary > 55000)


-- Q3 Retrieve department names where the total sales exceed ₹10,000.

select d.department_name
from employees as e join department as d
on e.department_id = d.department_id 
where e.emp_id in (


select emp_id
from sales
where sale_amount > 10000)


-- Q4 Find the employee who has made the second-highest sale.

select e.name
from employees as e join sales as s
on e.emp_id = s.emp_id
where s.sale_amount  = (
select max(sale_amount) 
from sales
where sale_amount < (
select max(sale_amount) 
from sales) )


-- Q5  Retrieve the names of employees whose salary is greater than the highest sale amount recorded.

select name
from employees
where salary > (

select max(sale_amount)
from sales)

