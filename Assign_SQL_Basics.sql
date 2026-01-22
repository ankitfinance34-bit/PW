--  q1 Create a New Database and  Table for Employees Task: Create a new database named company_db and Create a table named employees with the following columns:

Create database company_db
Use newdatabase
Create table employees
(employee_id int primary key,
First_name varchar(50),
Last_name varchar(50), 
Department varchar(50),
Salary int,
hire_date date);

-- q2 Insert Data into Employees Table

INSERT INTO employees
(employee_id, First_name, Last_name, Department, Salary, hire_date)
VALUES
(101, 'Amit', 'Sharma', 'HR', 50000, '2020-01-15'),
(102, 'Riya', 'Kapoor', 'Sales', 75000, '2019-03-22'),
(103, 'Raj', 'Mehta', 'IT', 90000, '2018-07-11'),
(104, 'Neha', 'Verma', 'IT', 85000, '2021-09-01'),
(105, 'Arjun', 'Singh', 'Finance', 60000, '2022-02-10');

-- q3 Display All Employee Records Sorted by Salary (Lowest to Highest)

Select * from Employees
Order by salary asc

-- q4 Show Employees Sorted by Department (A–Z) and Salary (High → Low)

Select * from Employees
Order by Department asc, salary desc

-- q5 List All Employees in the IT Department, Ordered by Hire Date (Newest First)

Select * from employees
where department = 'IT'
order by hire_date desc;

-- q6 Create and Populate a Sales Table

Create table sales
(sale_id int primary key,
customer_name varchar(50),
amount int,
sale_date date);

INSERT INTO sales
(sale_id, customer_name, amount, sale_date)
VALUES
(1, 'Aditi', 1500, '2024-08-01'),
(2, 'Rohan', 2200, '2024-08-03'),
(3, 'Aditi', 3500, '2024-09-05'),
(4, 'Meena', 2700, '2024-09-15'),
(5, 'Rohan', 4500, '2024-09-25');

-- q7 Display All Sales Records Sorted by Amount (Highest → Lowest)

Select * from sales
Order by amount asc

-- q8 Show All Sales Made by Customer “Aditi”

Select * from sales
Where customer_name = 'Aditi'

-- q9 What is the Difference Between a Primary Key and a Foreign Key?
A primary key is an attribute or a set of attributes that uniquely identifies each record in a table. It ensures that no two rows have the same value and that the value cannot be null. The main purpose of a primary key is to maintain entity integrity in the database.

A foreign key is an attribute or a set of attributes in one table that refers to the primary key of another table. It is used to establish a relationship between two tables and helps maintain referential integrity by ensuring that the data entered in one table matches the data in another related table.

In simple terms, a primary key uniquely identifies records within a table, while a foreign key links records between different tables.


-- q10 What Are Constraints in SQL and Why Are They Used?

To ensure consistent and accurate data storage Constraints in SQL are rules applied to table columns to control the type of data that can be stored in them. They ensure the accuracy, validity, and integrity of data in a database.

Constraints help prevent invalid data from being inserted, updated, or deleted, thereby maintaining the reliability and consistency of the database.

Why constraints are used:

To maintain data integrity

To avoid duplicate or invalid data

To enforce business rules

To maintain relationships between tables


