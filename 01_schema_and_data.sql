-- ============================================================
-- E-COMMERCE SALES ANALYTICS PROJECT
-- Database: MS SQL Server
-- Author: [Your Name]
-- Description: End-to-end SQL analytics project for e-commerce
-- ============================================================

-- Create and use database
CREATE DATABASE EcommerceAnalytics;
GO
USE EcommerceAnalytics;
GO

-- ============================================================
-- TABLE 1: Customers
-- ============================================================
CREATE TABLE Customers (
    CustomerID      INT PRIMARY KEY IDENTITY(1,1),
    FirstName       VARCHAR(50) NOT NULL,
    LastName        VARCHAR(50) NOT NULL,
    Email           VARCHAR(100) UNIQUE NOT NULL,
    City            VARCHAR(50),
    State           VARCHAR(50),
    Country         VARCHAR(50) DEFAULT 'India',
    JoinDate        DATE NOT NULL,
    CustomerSegment VARCHAR(20) CHECK (CustomerSegment IN ('Premium', 'Regular', 'New'))
);
GO

-- ============================================================
-- TABLE 2: Products
-- ============================================================
CREATE TABLE Products (
    ProductID    INT PRIMARY KEY IDENTITY(1,1),
    ProductName  VARCHAR(100) NOT NULL,
    Category     VARCHAR(50) NOT NULL,
    SubCategory  VARCHAR(50),
    CostPrice    DECIMAL(10,2) NOT NULL,
    SellingPrice DECIMAL(10,2) NOT NULL,
    StockQty     INT DEFAULT 0
);
GO

-- ============================================================
-- TABLE 3: Orders
-- ============================================================
CREATE TABLE Orders (
    OrderID        INT PRIMARY KEY IDENTITY(1,1),
    CustomerID     INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate      DATE NOT NULL,
    DeliveryDate   DATE,
    OrderStatus    VARCHAR(20) CHECK (OrderStatus IN ('Delivered','Cancelled','Returned','Pending')),
    PaymentMethod  VARCHAR(30),
    ShippingCity   VARCHAR(50)
);
GO

-- ============================================================
-- TABLE 4: Order Items
-- ============================================================
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID     INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID   INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity    INT NOT NULL,
    UnitPrice   DECIMAL(10,2) NOT NULL,
    Discount    DECIMAL(5,2) DEFAULT 0  -- Discount % (0 to 100)
);
GO

-- ============================================================
-- INSERT SAMPLE DATA: Customers (30 rows)
-- ============================================================
INSERT INTO Customers (FirstName, LastName, Email, City, State, JoinDate, CustomerSegment)
VALUES
('Aarav',    'Sharma',    'aarav.sharma@email.com',    'Mumbai',    'Maharashtra', '2022-01-10', 'Premium'),
('Priya',    'Mehta',     'priya.mehta@email.com',     'Delhi',     'Delhi',       '2022-02-15', 'Regular'),
('Rohit',    'Verma',     'rohit.verma@email.com',     'Bangalore', 'Karnataka',   '2022-03-20', 'New'),
('Sneha',    'Gupta',     'sneha.gupta@email.com',     'Hyderabad', 'Telangana',   '2022-04-05', 'Premium'),
('Vikram',   'Nair',      'vikram.nair@email.com',     'Chennai',   'Tamil Nadu',  '2022-05-12', 'Regular'),
('Ananya',   'Pillai',    'ananya.pillai@email.com',   'Pune',      'Maharashtra', '2022-06-18', 'New'),
('Karan',    'Singh',     'karan.singh@email.com',     'Jaipur',    'Rajasthan',   '2022-07-01', 'Regular'),
('Meera',    'Iyer',      'meera.iyer@email.com',      'Kolkata',   'West Bengal', '2022-08-22', 'Premium'),
('Arjun',    'Patel',     'arjun.patel@email.com',     'Ahmedabad', 'Gujarat',     '2022-09-14', 'New'),
('Divya',    'Reddy',     'divya.reddy@email.com',     'Mumbai',    'Maharashtra', '2022-10-30', 'Regular'),
('Siddharth','Kumar',     'sid.kumar@email.com',       'Delhi',     'Delhi',       '2023-01-05', 'Premium'),
('Kavya',    'Joshi',     'kavya.joshi@email.com',     'Bangalore', 'Karnataka',   '2023-02-19', 'Regular'),
('Nikhil',   'Rao',       'nikhil.rao@email.com',      'Hyderabad', 'Telangana',   '2023-03-25', 'New'),
('Pooja',    'Das',       'pooja.das@email.com',       'Chennai',   'Tamil Nadu',  '2023-04-08', 'Regular'),
('Rahul',    'Mishra',    'rahul.mishra@email.com',    'Pune',      'Maharashtra', '2023-05-17', 'Premium'),
('Shruti',   'Kapoor',    'shruti.kapoor@email.com',   'Jaipur',    'Rajasthan',   '2023-06-02', 'New'),
('Aditya',   'Bose',      'aditya.bose@email.com',     'Kolkata',   'West Bengal', '2023-07-11', 'Regular'),
('Riya',     'Chaudhary', 'riya.chaudhary@email.com',  'Ahmedabad', 'Gujarat',     '2023-08-29', 'New'),
('Manish',   'Trivedi',   'manish.trivedi@email.com',  'Mumbai',    'Maharashtra', '2023-09-03', 'Regular'),
('Neha',     'Saxena',    'neha.saxena@email.com',     'Delhi',     'Delhi',       '2023-10-15', 'Premium'),
('Tarun',    'Pandey',    'tarun.pandey@email.com',    'Bangalore', 'Karnataka',   '2023-11-20', 'New'),
('Anjali',   'Desai',     'anjali.desai@email.com',    'Hyderabad', 'Telangana',   '2023-12-01', 'Regular'),
('Varun',    'Malhotra',  'varun.malhotra@email.com',  'Chennai',   'Tamil Nadu',  '2024-01-14', 'Premium'),
('Ishita',   'Shah',      'ishita.shah@email.com',     'Pune',      'Maharashtra', '2024-02-06', 'New'),
('Deepak',   'Yadav',     'deepak.yadav@email.com',    'Jaipur',    'Rajasthan',   '2024-03-18', 'Regular'),
('Simran',   'Arora',     'simran.arora@email.com',    'Kolkata',   'West Bengal', '2024-04-22', 'New'),
('Abhishek', 'Tiwari',    'abhishek.tiwari@email.com', 'Ahmedabad', 'Gujarat',     '2024-05-09', 'Regular'),
('Pallavi',  'Srivastava','pallavi.sri@email.com',     'Mumbai',    'Maharashtra', '2024-06-30', 'Premium'),
('Yash',     'Menon',     'yash.menon@email.com',      'Delhi',     'Delhi',       '2024-07-25', 'New'),
('Trisha',   'Nambiar',   'trisha.nambiar@email.com',  'Bangalore', 'Karnataka',   '2024-08-11', 'Regular');
GO

-- ============================================================
-- INSERT SAMPLE DATA: Products (20 rows)
-- ============================================================
INSERT INTO Products (ProductName, Category, SubCategory, CostPrice, SellingPrice, StockQty)
VALUES
('iPhone 15',              'Electronics', 'Smartphones',  65000, 79999, 50),
('Samsung Galaxy S24',     'Electronics', 'Smartphones',  55000, 69999, 45),
('Sony WH-1000XM5',        'Electronics', 'Headphones',   18000, 24999, 80),
('Dell XPS 15 Laptop',     'Electronics', 'Laptops',      75000, 99999, 30),
('Nike Air Max 270',       'Footwear',    'Sports Shoes', 4500,  7499,  120),
('Adidas Ultraboost 22',   'Footwear',    'Sports Shoes', 5000,  8999,  100),
('Levi''s 511 Slim Jeans', 'Clothing',    'Jeans',        1500,  2999,  200),
('Allen Solly Formal Shirt','Clothing',   'Shirts',       800,   1799,  150),
('Philips Air Fryer',      'Appliances',  'Kitchen',      4000,  5999,  60),
('Instant Pot Duo',        'Appliances',  'Kitchen',      6500,  9499,  40),
('The Alchemist (Book)',    'Books',       'Fiction',      150,   399,   500),
('Atomic Habits (Book)',   'Books',       'Self-Help',    200,   499,   450),
('Yoga Mat Premium',       'Sports',      'Fitness',      600,   1299,  200),
('Dumbbells Set 10kg',     'Sports',      'Fitness',      1200,  2499,  90),
('Boat Rockerz 450',       'Electronics', 'Headphones',   1200,  1999,  150),
('Puma Track Pants',       'Clothing',    'Activewear',   700,   1499,  180),
('Lakme Foundation',       'Beauty',      'Makeup',       400,   799,   300),
('Mamaearth Face Wash',    'Beauty',      'Skincare',     150,   349,   400),
('IKEA Study Table',       'Furniture',   'Tables',       4000,  6999,  25),
('Wooden Bookshelf',       'Furniture',   'Storage',      5000,  8499,  20);
GO

-- ============================================================
-- INSERT SAMPLE DATA: Orders (50 rows)
-- ============================================================
INSERT INTO Orders (CustomerID, OrderDate, DeliveryDate, OrderStatus, PaymentMethod, ShippingCity)
VALUES
(1,  '2023-01-05', '2023-01-10', 'Delivered',  'Credit Card',  'Mumbai'),
(2,  '2023-01-12', '2023-01-18', 'Delivered',  'UPI',          'Delhi'),
(3,  '2023-01-20', NULL,         'Cancelled',  'Debit Card',   'Bangalore'),
(4,  '2023-02-01', '2023-02-07', 'Delivered',  'Net Banking',  'Hyderabad'),
(5,  '2023-02-15', '2023-02-21', 'Delivered',  'Credit Card',  'Chennai'),
(6,  '2023-03-01', '2023-03-08', 'Returned',   'UPI',          'Pune'),
(7,  '2023-03-14', '2023-03-20', 'Delivered',  'Cash on Del',  'Jaipur'),
(8,  '2023-04-02', '2023-04-09', 'Delivered',  'Credit Card',  'Kolkata'),
(9,  '2023-04-18', NULL,         'Cancelled',  'UPI',          'Ahmedabad'),
(10, '2023-05-05', '2023-05-11', 'Delivered',  'Debit Card',   'Mumbai'),
(1,  '2023-05-20', '2023-05-26', 'Delivered',  'Credit Card',  'Mumbai'),
(11, '2023-06-03', '2023-06-09', 'Delivered',  'Net Banking',  'Delhi'),
(12, '2023-06-17', '2023-06-23', 'Returned',   'Credit Card',  'Bangalore'),
(13, '2023-07-01', '2023-07-07', 'Delivered',  'UPI',          'Hyderabad'),
(14, '2023-07-15', '2023-07-21', 'Delivered',  'Cash on Del',  'Chennai'),
(15, '2023-08-02', '2023-08-09', 'Delivered',  'Credit Card',  'Pune'),
(4,  '2023-08-19', NULL,         'Cancelled',  'Debit Card',   'Hyderabad'),
(16, '2023-09-06', '2023-09-12', 'Delivered',  'UPI',          'Jaipur'),
(17, '2023-09-20', '2023-09-27', 'Delivered',  'Net Banking',  'Kolkata'),
(18, '2023-10-04', '2023-10-11', 'Returned',   'Credit Card',  'Ahmedabad'),
(2,  '2023-10-18', '2023-10-24', 'Delivered',  'UPI',          'Delhi'),
(19, '2023-11-02', '2023-11-08', 'Delivered',  'Debit Card',   'Mumbai'),
(20, '2023-11-16', '2023-11-22', 'Delivered',  'Credit Card',  'Delhi'),
(8,  '2023-12-01', '2023-12-07', 'Delivered',  'Net Banking',  'Kolkata'),
(21, '2023-12-15', '2023-12-22', 'Delivered',  'UPI',          'Bangalore'),
(22, '2024-01-08', '2024-01-15', 'Delivered',  'Credit Card',  'Hyderabad'),
(23, '2024-01-22', '2024-01-28', 'Delivered',  'Cash on Del',  'Chennai'),
(10, '2024-02-05', NULL,         'Cancelled',  'UPI',          'Mumbai'),
(24, '2024-02-19', '2024-02-25', 'Delivered',  'Debit Card',   'Pune'),
(25, '2024-03-04', '2024-03-10', 'Returned',   'Credit Card',  'Jaipur'),
(1,  '2024-03-18', '2024-03-24', 'Delivered',  'UPI',          'Mumbai'),
(26, '2024-04-01', '2024-04-07', 'Delivered',  'Net Banking',  'Kolkata'),
(15, '2024-04-15', '2024-04-21', 'Delivered',  'Credit Card',  'Pune'),
(27, '2024-05-02', '2024-05-08', 'Delivered',  'Cash on Del',  'Ahmedabad'),
(11, '2024-05-16', '2024-05-22', 'Delivered',  'Debit Card',   'Delhi'),
(28, '2024-06-03', NULL,         'Pending',    'UPI',          'Mumbai'),
(5,  '2024-06-17', '2024-06-23', 'Delivered',  'Credit Card',  'Chennai'),
(29, '2024-07-01', '2024-07-07', 'Delivered',  'Net Banking',  'Delhi'),
(20, '2024-07-15', '2024-07-21', 'Delivered',  'UPI',          'Delhi'),
(30, '2024-08-02', '2024-08-08', 'Delivered',  'Credit Card',  'Bangalore'),
(3,  '2024-08-16', '2024-08-22', 'Returned',   'Debit Card',   'Bangalore'),
(12, '2024-09-03', '2024-09-09', 'Delivered',  'Cash on Del',  'Bangalore'),
(22, '2024-09-17', '2024-09-23', 'Delivered',  'Credit Card',  'Hyderabad'),
(7,  '2024-10-01', '2024-10-07', 'Delivered',  'UPI',          'Jaipur'),
(16, '2024-10-15', NULL,         'Cancelled',  'Net Banking',  'Jaipur'),
(19, '2024-11-02', '2024-11-08', 'Delivered',  'Credit Card',  'Mumbai'),
(23, '2024-11-16', '2024-11-22', 'Delivered',  'Debit Card',   'Chennai'),
(9,  '2024-12-01', '2024-12-07', 'Delivered',  'Cash on Del',  'Ahmedabad'),
(4,  '2024-12-14', '2024-12-20', 'Delivered',  'UPI',          'Hyderabad'),
(13, '2024-12-28', NULL,         'Pending',    'Credit Card',  'Hyderabad');
GO

-- ============================================================
-- INSERT SAMPLE DATA: Order Items
-- ============================================================
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice, Discount)
VALUES
(1,  1,  1, 79999, 5),
(1,  3,  1, 24999, 0),
(2,  5,  2, 7499,  10),
(3,  7,  1, 2999,  0),
(4,  4,  1, 99999, 8),
(5,  6,  1, 8999,  5),
(5,  13, 2, 1299,  0),
(6,  9,  1, 5999,  12),
(7,  11, 3, 399,   0),
(7,  12, 2, 499,   0),
(8,  2,  1, 69999, 7),
(9,  15, 2, 1999,  5),
(10, 8,  2, 1799,  10),
(10, 16, 1, 1499,  0),
(11, 1,  1, 79999, 0),
(11, 3,  1, 24999, 5),
(12, 10, 1, 9499,  0),
(12, 9,  1, 5999,  8),
(13, 14, 1, 2499,  0),
(13, 13, 1, 1299,  5),
(14, 5,  1, 7499,  10),
(14, 6,  1, 8999,  0),
(15, 4,  1, 99999, 10),
(16, 17, 2, 799,   0),
(16, 18, 3, 349,   5),
(17, 19, 1, 6999,  0),
(18, 7,  2, 2999,  10),
(18, 8,  2, 1799,  5),
(19, 2,  1, 69999, 5),
(19, 15, 1, 1999,  0),
(20, 11, 5, 399,   15),
(20, 12, 3, 499,   10),
(21, 5,  1, 7499,  0),
(21, 13, 2, 1299,  5),
(22, 1,  1, 79999, 8),
(23, 3,  1, 24999, 0),
(23, 15, 2, 1999,  5),
(24, 9,  1, 5999,  0),
(25, 20, 1, 8499,  10),
(26, 14, 2, 2499,  0),
(26, 16, 3, 1499,  5),
(27, 6,  2, 8999,  0),
(27, 13, 1, 1299,  10),
(28, 4,  1, 99999, 5),
(29, 10, 1, 9499,  8),
(30, 7,  3, 2999,  0),
(31, 1,  1, 79999, 10),
(32, 17, 3, 799,   0),
(32, 18, 2, 349,   5),
(33, 15, 2, 1999,  0),
(34, 5,  1, 7499,  5),
(35, 2,  1, 69999, 0),
(35, 3,  1, 24999, 8),
(36, 11, 4, 399,   0),
(37, 9,  1, 5999,  5),
(37, 16, 2, 1499,  10),
(38, 12, 3, 499,   0),
(38, 13, 1, 1299,  5),
(39, 4,  1, 99999, 12),
(40, 20, 1, 8499,  0),
(41, 7,  1, 2999,  5),
(41, 8,  2, 1799,  0),
(42, 6,  1, 8999,  8),
(42, 14, 1, 2499,  5),
(43, 1,  1, 79999, 0),
(44, 3,  2, 24999, 5),
(45, 5,  1, 7499,  0),
(46, 2,  1, 69999, 10),
(46, 15, 1, 1999,  0),
(47, 10, 1, 9499,  5),
(48, 17, 2, 799,   0),
(48, 18, 2, 349,   10),
(49, 13, 2, 1299,  0),
(49, 16, 1, 1499,  5),
(50, 4,  1, 99999, 7);
GO
