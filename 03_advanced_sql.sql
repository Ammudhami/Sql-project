-- ============================================================
-- E-COMMERCE SALES ANALYTICS PROJECT
-- File: 03_advanced_sql.sql
-- Description: Views, Stored Procedures & Window Functions
-- Database: MS SQL Server
-- ============================================================

USE EcommerceAnalytics;
GO

-- ============================================================
-- VIEW 1: vw_SalesSummary
-- A reusable view combining all key sales metrics
-- ============================================================
CREATE OR ALTER VIEW vw_SalesSummary AS
SELECT
    o.OrderID,
    o.OrderDate,
    FORMAT(o.OrderDate, 'yyyy-MM')                                       AS YearMonth,
    YEAR(o.OrderDate)                                                    AS OrderYear,
    MONTH(o.OrderDate)                                                   AS OrderMonth,
    c.CustomerID,
    c.FirstName + ' ' + c.LastName                                       AS CustomerName,
    c.CustomerSegment,
    c.City,
    c.State,
    p.ProductID,
    p.ProductName,
    p.Category,
    p.SubCategory,
    oi.Quantity,
    oi.UnitPrice,
    oi.Discount,
    o.OrderStatus,
    o.PaymentMethod,
    ROUND(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0), 2)    AS LineRevenue,
    ROUND(oi.Quantity * (oi.UnitPrice - p.CostPrice)
          * (1 - oi.Discount / 100.0), 2)                               AS LineProfit,
    DATEDIFF(DAY, o.OrderDate, o.DeliveryDate)                          AS DeliveryDays
FROM Orders o
JOIN Customers c   ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p    ON oi.ProductID = p.ProductID;
GO

-- Quick test of the view
SELECT TOP 5 * FROM vw_SalesSummary;
GO


-- ============================================================
-- VIEW 2: vw_CustomerLifetimeValue
-- Summarises each customer's total value to the business
-- ============================================================
CREATE OR ALTER VIEW vw_CustomerLifetimeValue AS
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName                                       AS CustomerName,
    c.CustomerSegment,
    c.City,
    c.JoinDate,
    COUNT(DISTINCT o.OrderID)                                            AS TotalOrders,
    SUM(oi.Quantity)                                                     AS TotalItemsBought,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS LifetimeValue,
    MAX(o.OrderDate)                                                     AS LastPurchaseDate,
    DATEDIFF(DAY, MAX(o.OrderDate), GETDATE())                           AS DaysSinceLastOrder
FROM Customers c
JOIN Orders o     ON c.CustomerID = o.CustomerID AND o.OrderStatus = 'Delivered'
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.CustomerSegment, c.City, c.JoinDate;
GO

SELECT * FROM vw_CustomerLifetimeValue ORDER BY LifetimeValue DESC;
GO


-- ============================================================
-- STORED PROCEDURE 1: usp_GetCategoryReport
-- Accepts a Category name, returns its full sales report
-- ============================================================
CREATE OR ALTER PROCEDURE usp_GetCategoryReport
    @Category VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.SubCategory,
        p.ProductName,
        SUM(oi.Quantity)                                                 AS UnitsSold,
        ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS Revenue,
        ROUND(SUM(oi.Quantity * (oi.UnitPrice - p.CostPrice)
              * (1 - oi.Discount / 100.0)), 2)                           AS Profit,
        ROUND(SUM(oi.Quantity * (oi.UnitPrice - p.CostPrice)
              * (1 - oi.Discount / 100.0)) * 100.0
              / NULLIF(SUM(oi.Quantity * oi.UnitPrice
              * (1 - oi.Discount / 100.0)), 0), 2)                       AS ProfitMarginPct
    FROM Products p
    JOIN OrderItems oi ON p.ProductID = oi.ProductID
    JOIN Orders o      ON oi.OrderID = o.OrderID
    WHERE p.Category = @Category
      AND o.OrderStatus = 'Delivered'
    GROUP BY p.SubCategory, p.ProductName
    ORDER BY Revenue DESC;
END;
GO

-- Execute the stored procedure
EXEC usp_GetCategoryReport @Category = 'Electronics';
EXEC usp_GetCategoryReport @Category = 'Clothing';
GO


-- ============================================================
-- STORED PROCEDURE 2: usp_GetMonthlyReport
-- Accepts Year and Month, returns that month's KPI snapshot
-- ============================================================
CREATE OR ALTER PROCEDURE usp_GetMonthlyReport
    @Year  INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(DISTINCT o.OrderID)                                        AS TotalOrders,
        SUM(CASE WHEN o.OrderStatus = 'Delivered'  THEN 1 ELSE 0 END)   AS DeliveredOrders,
        SUM(CASE WHEN o.OrderStatus = 'Cancelled'  THEN 1 ELSE 0 END)   AS CancelledOrders,
        SUM(CASE WHEN o.OrderStatus = 'Returned'   THEN 1 ELSE 0 END)   AS ReturnedOrders,
        ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS GrossRevenue,
        ROUND(SUM(CASE WHEN o.OrderStatus = 'Delivered'
                       THEN oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)
                       ELSE 0 END), 2)                                   AS NetRevenue,
        COUNT(DISTINCT o.CustomerID)                                     AS UniqueCustomers
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    WHERE YEAR(o.OrderDate) = @Year
      AND MONTH(o.OrderDate) = @Month;
END;
GO

-- Execute for different months
EXEC usp_GetMonthlyReport @Year = 2024, @Month = 3;
EXEC usp_GetMonthlyReport @Year = 2023, @Month = 12;
GO


-- ============================================================
-- WINDOW FUNCTIONS: Running Total & Cumulative Revenue
-- Business Question: What is the cumulative revenue over time?
-- ============================================================
WITH MonthlyRev AS (
    SELECT
        FORMAT(o.OrderDate, 'yyyy-MM')                                   AS YearMonth,
        ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS MonthlyRevenue
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
)
SELECT
    YearMonth,
    MonthlyRevenue,
    SUM(MonthlyRevenue) OVER (ORDER BY YearMonth ROWS UNBOUNDED PRECEDING) AS CumulativeRevenue,
    AVG(MonthlyRevenue) OVER (ORDER BY YearMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Rolling3MonthAvg
FROM MonthlyRev
ORDER BY YearMonth;
GO


-- ============================================================
-- WINDOW FUNCTIONS: Customer Rank Within Segment
-- Business Question: Who are the top spenders per customer segment?
-- ============================================================
WITH SegmentSpend AS (
    SELECT
        c.CustomerID,
        c.FirstName + ' ' + c.LastName                                   AS CustomerName,
        c.CustomerSegment,
        ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS TotalSpend
    FROM Customers c
    JOIN Orders o     ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY c.CustomerID, c.FirstName, c.LastName, c.CustomerSegment
)
SELECT
    CustomerName,
    CustomerSegment,
    TotalSpend,
    RANK()       OVER (PARTITION BY CustomerSegment ORDER BY TotalSpend DESC) AS RankInSegment,
    DENSE_RANK() OVER (ORDER BY TotalSpend DESC)                              AS OverallRank,
    NTILE(4)     OVER (ORDER BY TotalSpend DESC)                              AS SpendQuartile
FROM SegmentSpend
ORDER BY CustomerSegment, RankInSegment;
GO


-- ============================================================
-- WINDOW FUNCTIONS: Product Sales Running Rank per Category
-- ============================================================
SELECT
    p.Category,
    p.ProductName,
    SUM(oi.Quantity)                                                     AS UnitsSold,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS Revenue,
    ROW_NUMBER() OVER (PARTITION BY p.Category ORDER BY
        SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)) DESC) AS RankInCategory
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
JOIN Orders o      ON oi.OrderID = o.OrderID AND o.OrderStatus = 'Delivered'
GROUP BY p.Category, p.ProductName
ORDER BY p.Category, RankInCategory;
GO
