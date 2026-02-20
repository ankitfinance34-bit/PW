-- Question 1 : Define Data Quality in the context of ETL pipelines. Why is it more than just data cleaning?

-- Data Quality in ETL (Extract, Transform, Load) refers to the accuracy, completeness, consistency, validity, uniqueness, and 
-- timeliness of data as it flows through the pipeline.
-- It is more than just data cleaning because:
-- Cleaning only removes errors (nulls, duplicates, wrong formats).
-- Data quality ensures:
-- Correct structure
-- Business rule validation
-- Referential integrity
-- Standardization
-- Consistency across systems
-- Monitoring & governance


-- Question 2 : Explain why poor data quality leads to misleading dashboards and incorrect decisions

-- Poor data quality causes:
-- Incorrect Aggregations – Duplicate records inflate totals.
-- Wrong KPIs – Null or incorrect values distort metrics.
-- Misleading Trends – Missing dates affect time analysis.
-- Customer Mismatch – Wrong customer mapping affects segmentation.


-- Question 3 : What is duplicate data? Explain three causes in ETL pipelines.

-- Duplicate data refers to multiple records representing the same business event
-- Causes in ETL:
-- Multiple Source Systems - Same record comes from CRM and Billing systems.
-- Improper Incremental Load- Full data load runs again without truncating old data.
-- Missing Primary/Business Key Constraints - No uniqueness rule on composite keys.


-- Question 4 : Differentiate between exact, partial, and fuzzy duplicates

-- Type	                               Meaning	                             Example
-- Exact Duplicate	             Completely identical records    	Same Customer_ID, Product_ID, Amount, Date
-- Partial Duplicate         	Some fields match, others differ	Same Customer_ID + Date but different Quantity
-- Fuzzy Duplicate             	Slight variations in text	         “Rahul Mehta” vs “Rahul M.”


-- Question 5 : Why should data validation be performed during transformation rather than after loading?
-- Validation during transformation is important because:
-- Errors are caught early.
-- Prevents corrupt data entering warehouse.
-- Reduces rework cost.
-- Ensures clean analytics layer.
-- If validation happens after loading:
-- Reports may already use wrong data.
-- Correction becomes complex.


-- Question 6 : Explain how business rules help in validating data accuracy. Give an example
-- Business rules are logical conditions that data must satisfy.
-- Examples:
-- Txn_Amount must be greater than 0.
-- Quantity cannot be NULL.
-- Customer_ID must exist in Customers_Master.
-- Txn_Date cannot be future date.
-- Business rules ensure data reflects real-world logic


create database assign_data_quality_etl
use assign_data_quality_etl

CREATE TABLE Customers_Master (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
)

INSERT INTO Customers_Master (CustomerID, CustomerName, City) VALUES
('C101', 'Rahul Mehta', 'Mumbai'),
('C102', 'Anjali Rao', 'Bengaluru'),
('C103', 'Suresh Iyer', 'Chennai'),
('C104', 'Neha Singh', 'Delhi');

CREATE TABLE Sales_Transactions (
    Txn_ID INT PRIMARY KEY,
    Customer_ID VARCHAR(10),
    Customer_Name VARCHAR(100),
    Product_ID VARCHAR(10),
    Quantity INT,
    Txn_Amount DECIMAL(10,2),
    Txn_Date DATE,
    City VARCHAR(50)
)

INSERT INTO Sales_Transactions 
(Txn_ID, Customer_ID, Customer_Name, Product_ID, Quantity, Txn_Amount, Txn_Date, City)
VALUES
(201, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(202, 'C102', 'Anjali Rao', 'P12', 1, 1500, '2025-12-01', 'Bengaluru'),
(203, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(204, 'C103', 'Suresh Iyer', 'P13', 3, 6000, '2025-12-02', 'Chennai'),
(205, 'C104', 'Neha Singh', 'P14', NULL, 2500, '2025-12-02', 'Delhi'),
(206, 'C105', 'N/A', 'P15', 1, NULL, '2025-12-03', 'Pune'),
(207, 'C106', 'Amit Verma', 'P16', 1, 1800, NULL, 'Pune'),
(208, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai');

-- Question 7 : Write an SQL query on Sales_Transactions to list all duplicate keys and their counts using the
-- business key (Customer_ID + Product_ID + Txn_Date + Txn_Amount )

select Customer_ID, Product_ID, Txn_Date, txn_Amount, count(*) as duplicate_count
from Sales_Transactions 
group by Customer_ID, Product_ID, Txn_Date, txn_Amount
having count(*) > 1

-- Question 8 : Enforcing Referential Integrity
-- Assume the following Customers_Master table:

select s.Customer_ID
from  sales_transactions as s left join Customers_Master as c
on s.customer_id = c.customerid
where c.customerid is null