create database pwskills_filtering
use pwskills_filtering

Create table Employees
(Emp_id int primary key,
Empname varchar(50),
Department varchar(50), 
City varchar(50),
Salary int,
HireDate date);

INSERT INTO Employees (Emp_id, EmpName, Department, City, Salary, HireDate)
VALUES
(101, 'Rahul Mehta', 'Sales', 'Delhi', 55000, '2020-04-12'),
(102, 'Priya Sharma', 'HR', 'Mumbai', 62000, '2019-09-25'),
(103, 'Aman Singh', 'IT', 'Bengaluru', 72000, '2021-03-10'),
(104, 'Neha Patel', 'Sales', 'Delhi', 48000, '2022-01-14'),
(105, 'Karan Joshi', 'Marketing', 'Pune', 45000, '2018-07-22'),
(106, 'Divya Nair', 'IT', 'Chennai', 81000, '2019-12-11'),
(107, 'Raj Kumar', 'HR', 'Delhi', 60000, '2020-05-28'),
(108, 'Simran Kaur', 'Finance', 'Mumbai', 58000, '2021-08-03'),
(109, 'Arjun Reddy', 'IT', 'Hyderabad', 70000, '2022-02-18'),
(110, 'Anjali Das', 'Sales', 'Kolkata', 51000, '2023-01-15');


-- Q1 Show employees working in either the ‘IT’ or ‘HR’ departments.

select * from Employees
where Department in ('IT', 'HR')
 
-- Q2 Retrieve employees whose department is in ‘Sales’, ‘IT’, or ‘Finance

Select * from Employees
Where Department in ('Sales', 'IT', 'Finance')

-- Q3 Display employees whose salary is between ₹50,000 and ₹70,000

Select * from Employees
where Salary between 50000 and 70000;

-- Q4 List employees whose names start with the letter ‘A’

Select * from Employees
where EmpName like 'A%'

-- Q5 Find employees whose names contain the substring ‘an’.

Select * from Employees
where EmpName like '%an%'

-- Q6 Show employees who are from ‘Delhi’ or ‘Mumbai’ and earn more than ₹55,000

Select * from Employees
Where city in ('Delhi','Mumbai') and salary > 55000

-- Q7 Display all employees except those from the ‘HR’ department.

select * from Employees
where Department <> 'HR'

-- Q8 Get all employees hired between 2019 and 2022, ordered by HireDate (oldest first)

select * from Employees
where HireDate between 2019-01-01 and 2022-12-31
order by HireDate asc