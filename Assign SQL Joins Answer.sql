create database sqljoins
use sqljoins

Create table Customers
(CustomerID int primary key,
CustomerName varchar(50),
City varchar(50))

Insert into Customers
(CustomerID, CustomerName, City)
Values
(1, 'John Smith', 'New York'),
(2, 'Mary Johnson', 'Chicago'),
(3, 'Peter Adams', 'Los Angeles'),
(4, 'Nancy Miller', 'Houston'),
(5, 'Robert White', 'Miami');


Create table Orders
(OrderID int primary key,
CustomerID int,
OrderDate date,
Amount numeric)

Insert into Orders
(OrderID, CustomerID, OrderDate, Amount)
Values
(101, 1, '2024-10-01', 250),
(102, 2, '2024-10-05', 300),
(103, 1, '2024-10-07', 150),
(104, 3, '2024-10-10', 450),
(105, 6, '2024-10-12', 400);


Create table Payments	
(PaymentID varchar(50) primary key,
CustomerID int,
PaymentDate date,
Amount numeric)

Insert into Payments
(PaymentID, CustomerID, PaymentDate, Amount)
Values
('P001', 1, '2024-10-02', 250),
('P002', 2, '2024-10-06', 300),
('P003', 3, '2024-10-11', 450),
('P004', 5, '2024-10-15', 200);


Create table Employees	
(EmployeeID int primary key,
EmployeeName varchar(50),
ManagerID int)

Insert into Employees
(EmployeeID, EmployeeName, ManagerID)
Values
(1, 'Alex Green', Null),
(2, 'Brian Lee', 1),
(3, 'Carol Ray', 1),
(4, 'David Kim', 2),
(5, 'Eva Smith', 2);


-- Q1  Retrieve all customers who have placed at least one order

select CustomerName 
from Customers as c join Orders as o 
on c.CustomerID = o.CustomerID;

-- Q2 Retrieve all customers and their orders, including customers who have not placed any orders.

select *
from Customers as c left join Orders as o
on c.CustomerID = o.CustomerID;

-- Q3  Retrieve all orders and their corresponding customers, including orders placed by unknown customers

select *
from Customers as c right join Orders as o
on c.CustomerID = o.CustomerID;

-- Q4 Display all customers and orders, whether matched or not.

select *
from Customers as c outer join Orders as o
on c.CustomerID = o.CustomerID;

-- Q5  Find customers who have not placed any orders.

select c.*
from Customers as c left join Orders as o
on c.CustomerID = o.CustomerID
where o.CustomerID is null;

-- Q6 . Retrieve customers who made payments but did not place any orders.

Select c.*
from Customers as c join Payments as p
on c.CustomerID = p.CustomerID
left join Orders as o
on C.CustomerID = o.CustomerID
where o.CustomerID is null

-- Q7 Generate a list of all possible combinations between Customers and Orders.

select *
from Customers as c cross join Orders as o

-- Q8 Show all customers along with order and payment amounts in one table.

select c.CustomerID, c.CustomerName, o.OrderID, o.Amount as OrderAmount, p.Amount as PaymentAmount
from Customers as c left join Orders as o
on c.CustomerID = o.CustomerID
left join Payments as p
on c.customerID = p.customerID

-- Q9 Retrieve all customers who have both placed orders and made payments

select distinct c.*
from Customers as c  join Orders as o
on c.CustomerID = o.CustomerID
inner join Payments as p
on o.CustomerID = p.CustomerID



