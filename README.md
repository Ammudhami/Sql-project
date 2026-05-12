E-Commerce Sales Analytics — SQL Project
A SQL project built using Microsoft SQL Server to analyze e-commerce sales data and generate business insights.
The project focuses on:
Sales and revenue analysis
Customer behaviour analysis
Product performance tracking
Order and payment trends
Advanced SQL concepts like Window Functions, Views, and Stored Procedures
---
Project Structure
```bash
ecommerce_sql_project/
│
├── 01_schema_and_data.sql
├── 02_analysis_queries.sql
├── 03_advanced_sql.sql
└── README.md
```
---
Database Design
The database contains 4 related tables:
Customers
Orders
OrderItems
Products
Relationships
One customer can place multiple orders
One order can contain multiple products
One product can appear in many orders
---
SQL Concepts Used
CREATE TABLE
PRIMARY KEY & FOREIGN KEY
JOINs
GROUP BY
CASE WHEN
CTEs
Window Functions
Views
Stored Procedures
Aggregate & Date Functions
Window Functions
RANK()
DENSE_RANK()
ROW_NUMBER()
LAG()
NTILE()
SUM() OVER()
---
Business Insights Generated
Identified top-selling products and categories
Analyzed monthly revenue trends
Compared customer spending behaviour
Found the most used payment methods
Calculated customer lifetime value
Tracked high-profit product categories
---
Tools Used
Microsoft SQL Server
SQL Server Management Studio (SSMS)
---
What I Learned
Writing efficient SQL queries
Designing relational databases
Using SQL for business analysis
Working with advanced SQL features
Building reports using Views and Stored Procedures
