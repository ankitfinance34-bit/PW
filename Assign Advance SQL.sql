-- Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?

-- A Common Table Expression (CTE) is a temporary result set in SQL that you can reference within a single query. 
-- CTEs simplify complex queries, make them easier to read, and can be reused multiple times within the same query
-- CTEs improve SQL queries by:
-- Breaking complex queries into smaller logical steps
-- Making code easier to read and understand
-- Avoiding repeated subqueries
-- Improving maintainability


-- Q2. Why are some views updatable while others are read-only? Explain with an example.

-- A View is a virtual table created from a query on one or more base tables.
-- Whether a view is updatable or read-only depends on how it is defined.
-- A view is updatable when:
-- Based on one table only
-- No GROUP BY, DISTINCT, JOIN, aggregate functions
-- No computed/derived columns
-- Contains the primary key

create database assignadvsql
use assignadvsql

create table Products (
    ProductID int primary key,
    Name varchar(20),
    Price decimal(10,2),
    Quantity int)
    
insert into Products (ProductID, Name, Price, Quantity)
values
(1, 'Laptop', 1000, 50),
(2, 'Mouse', 20, 100);

-- Read-Only View
CREATE VIEW View_Product_Totals AS
SELECT COUNT(ProductID) AS TotalProducts, SUM(Quantity) AS TotalQuantity
FROM Products;

-- Updatable View
CREATE VIEW View_All_Products AS
SELECT ProductID, Name, Price, Quantity
FROM Products;


-- Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?

-- A Stored Procedure is a precompiled collection of SQL statements stored inside the database that can be executed whenever needed.
-- Advantages of Stored Procedures
-- Reusability- Write once, use many times, Avoid repeating the same SQL code
-- Better Performance - Precompiled and cached by the database, Faster execution than running raw queries repeatedly
-- Security - Users can execute the procedure without direct table access, Helps restrict permissions
-- Maintainability - Logic stored in one place, Easy to update or modify without changing application code
-- Reduced Network Traffic - Only procedure call is sent instead of multiple SQL statements
-- Supports Business Logic - Can include loops, conditions, validations, and error handling


-- Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential

-- A database trigger is a special type of stored procedure that runs (or "fires") automatically in response to specific events—namely, 
-- INSERT, UPDATE, or DELETE operations—on a table or view. 
-- Purpose of Triggers
-- Enforce business rules - Automatically validate data before/after changes
-- Maintain data integrity - Prevent invalid or inconsistent data
-- Audit and logging - Track changes like who updated or deleted data
-- Automate actions - Perform tasks automatically when data changes


-- Q5. Explain the need for data modelling and normalization when designing a database

-- Data modeling and normalization are foundational, iterative processes in database design that ensure the resulting database is efficient, scalable, and accurate. 
-- Data modeling creates a blueprint that aligns business requirements with data structure, while normalization systematically organizes that data to minimize redundancy and eliminate data modification anomalies. 
-- Need for Data Modelling
-- Clearly organizes data
-- Defines relationships between tables
-- Avoids confusion and redundancy
-- Improves scalability
-- Makes database easier to maintain
-- Normalization is the process of organizing data to reduce redundancy and improve data integrity by dividing data into related tables.
-- Need for Normalization
-- Removes duplicate data - Prevents storing the same data multiple times
-- Saves storage space
-- Improves data integrity - Ensures consistent and accurate data
-- Avoids update anomalies - Insert anomaly, Update anomaly, Delete anomaly
-- Improves query performance




create table Products 
(ProductID int primary key,
ProductName varchar(100),
Category varchar(50),
Price decimal(10,2))

Insert into Products 
(ProductID, ProductName, Category, Price) 
values
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500)

create table Sales 
(SaleID int primary key,
ProductID int,
Quantity int,
SaleDate date,
foreign key(ProductID) references Products(ProductID)
)

insert into Sales 
(SaleID, ProductID, Quantity, SaleDate) 
values
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11')


-- Q6. Write a CTE to calculate the total revenue for each product
-- (Revenues = Price × Quantity), and return only products where  revenue > 3000.

with ProductRevenue as (
select p.ProductID, p.ProductName,  sum(p.price * s.Quantity) as Revenue 
from Products as p join Sales as s 
on p.ProductID = s.ProductID
group by p.ProductID , P.ProductName)
select *
from ProductRevenue
where revenue > 3000

-- Q7. Create a view named vw_CategorySummary that shows:
-- Category, TotalProducts, AveragePrice.

create view vw_CategorySummary as 
select Category, count(productID) as TotalProducts, avg(Price) as AveragePrice
from Products
group by category

select * from vw_CategorySummary


-- Q8. Create an updatable view containing ProductID, ProductName, and Price.
-- Then update the price of ProductID = 1 using the view 

create view vw_Productview as
select ProductID, ProductName, Price 
from Products

update vw_Productview
Set Price = 1500
where ProductID = 1


-- Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category.

DELIMITER //

CREATE PROCEDURE GetProductsByCategory2(IN cat_name VARCHAR(50))
BEGIN
    SELECT *
    FROM Products
    WHERE Category = cat_name;
END //

DELIMITER ;

CALL GetProductsByCategory2('Electronics');

-- Q10. Create an AFTER DELETE trigger on the Products table that archives deleted product rows into a new
-- table ProductArchive . The archive should store ProductID, ProductName, Category, Price, and DeletedAt timestamp.

CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_after_delete_product
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price, NOW());
END //

DELIMITER ;