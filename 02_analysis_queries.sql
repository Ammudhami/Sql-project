-- ============================================================
-- E-COMMERCE SALES ANALYTICS PROJECT
-- File: 02_analysis_queries.sql
-- Database: MS SQL Server
-- ============================================================

USE EcommerceAnalytics;
GO

-- ============================================================
-- ANALYSIS 1: Total Revenue, Orders & Average Order Value
-- Business Question: What is our overall sales performance?
-- ============================================================
SELECT
    COUNT(DISTINCT o.OrderID)                                            AS TotalOrders,
    SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0))         AS TotalRevenue,
    AVG(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0))         AS AvgOrderItemValue,
    SUM(oi.Quantity * (oi.UnitPrice - p.CostPrice) * (1 - oi.Discount / 100.0)) AS TotalProfit
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p    ON oi.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered';
GO

-- ============================================================
-- ANALYSIS 2: Monthly Revenue Trend
-- Business Question: How is revenue trending month over month?
-- ============================================================
SELECT
    FORMAT(o.OrderDate, 'yyyy-MM')                                       AS YearMonth,
    COUNT(DISTINCT o.OrderID)                                            AS TotalOrders,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS MonthlyRevenue
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY YearMonth;
GO

-- ============================================================
-- ANALYSIS 3: Top 5 Best-Selling Products by Revenue
-- Business Question: Which products are driving the most revenue?
-- ============================================================
SELECT TOP 5
    p.ProductName,
    p.Category,
    SUM(oi.Quantity)                                                     AS UnitsSold,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS TotalRevenue,
    ROUND(SUM(oi.Quantity * (oi.UnitPrice - p.CostPrice) * (1 - oi.Discount / 100.0)), 2) AS TotalProfit
FROM OrderItems oi
JOIN Products p  ON oi.ProductID = p.ProductID
JOIN Orders o    ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY TotalRevenue DESC;
GO

-- ============================================================
-- ANALYSIS 4: Revenue by Product Category
-- Business Question: Which category contributes most to revenue?
-- ============================================================
SELECT
    p.Category,
    COUNT(DISTINCT o.OrderID)                                            AS TotalOrders,
    SUM(oi.Quantity)                                                     AS UnitsSold,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS Revenue,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)) * 100.0
          / SUM(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0))) OVER(), 2) AS RevenueSharePct
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
JOIN Orders o   ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY Revenue DESC;
GO

-- ============================================================
-- ANALYSIS 5: Customer Segmentation by Spend (RFM-style)
-- Business Question: Who are our high-value customers?
-- ============================================================
WITH CustomerSpend AS (
    SELECT
        c.CustomerID,
        c.FirstName + ' ' + c.LastName                                   AS CustomerName,
        c.CustomerSegment,
        c.City,
        COUNT(DISTINCT o.OrderID)                                        AS TotalOrders,
        ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS TotalSpend,
        MAX(o.OrderDate)                                                 AS LastOrderDate
    FROM Customers c
    JOIN Orders o     ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY c.CustomerID, c.FirstName, c.LastName, c.CustomerSegment, c.City
)
SELECT
    CustomerName,
    CustomerSegment,
    City,
    TotalOrders,
    TotalSpend,
    LastOrderDate,
    CASE
        WHEN TotalSpend >= 100000 THEN 'Platinum'
        WHEN TotalSpend >= 50000  THEN 'Gold'
        WHEN TotalSpend >= 20000  THEN 'Silver'
        ELSE 'Bronze'
    END AS SpendTier,
    RANK() OVER (ORDER BY TotalSpend DESC) AS SpendRank
FROM CustomerSpend
ORDER BY TotalSpend DESC;
GO

-- ============================================================
-- ANALYSIS 6: Order Status Breakdown & Cancellation Rate
-- Business Question: How healthy is our fulfilment pipeline?
-- ============================================================
SELECT
    OrderStatus,
    COUNT(*)                                                             AS OrderCount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)                   AS StatusPct
FROM Orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC;
GO

-- ============================================================
-- ANALYSIS 7: City-Wise Sales Performance
-- Business Question: Which cities generate the most revenue?
-- ============================================================
SELECT
    o.ShippingCity,
    COUNT(DISTINCT o.OrderID)                                            AS TotalOrders,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS TotalRevenue,
    ROUND(AVG(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS AvgOrderValue
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY o.ShippingCity
ORDER BY TotalRevenue DESC;
GO

-- ============================================================
-- ANALYSIS 8: Payment Method Preference
-- Business Question: What payment methods do customers prefer?
-- ============================================================
SELECT
    PaymentMethod,
    COUNT(*)                                                             AS UsageCount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)                   AS UsagePct,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS RevenueGenerated
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY PaymentMethod
ORDER BY UsageCount DESC;
GO

-- ============================================================
-- ANALYSIS 9: Month-over-Month Revenue Growth %
-- Business Question: Is the business growing month on month?
-- ============================================================
WITH MonthlyRev AS (
    SELECT
        FORMAT(o.OrderDate, 'yyyy-MM')                                   AS YearMonth,
        ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.Discount / 100.0)), 2) AS Revenue
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
)
SELECT
    YearMonth,
    Revenue,
    LAG(Revenue) OVER (ORDER BY YearMonth)                               AS PrevMonthRevenue,
    ROUND((Revenue - LAG(Revenue) OVER (ORDER BY YearMonth)) * 100.0
          / NULLIF(LAG(Revenue) OVER (ORDER BY YearMonth), 0), 2)        AS GrowthPct
FROM MonthlyRev
ORDER BY YearMonth;
GO

-- ============================================================
-- ANALYSIS 10: Product Profit Margin Analysis
-- Business Question: Which products have the best profit margins?
-- ============================================================
SELECT
    p.ProductName,
    p.Category,
    p.CostPrice,
    p.SellingPrice,
    ROUND((p.SellingPrice - p.CostPrice) * 100.0 / p.SellingPrice, 2)   AS MarginPct,
    SUM(oi.Quantity)                                                     AS UnitsSold,
    ROUND(SUM(oi.Quantity * (oi.UnitPrice - p.CostPrice) * (1 - oi.Discount / 100.0)), 2) AS ActualProfit,
    RANK() OVER (PARTITION BY p.Category ORDER BY
        (p.SellingPrice - p.CostPrice) * 100.0 / p.SellingPrice DESC)   AS MarginRankInCategory
FROM Products p
LEFT JOIN OrderItems oi ON p.ProductID = oi.ProductID
LEFT JOIN Orders o      ON oi.OrderID = o.OrderID AND o.OrderStatus = 'Delivered'
GROUP BY p.ProductID, p.ProductName, p.Category, p.CostPrice, p.SellingPrice
ORDER BY MarginPct DESC;
GO
