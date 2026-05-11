# 🛒 E-Commerce Sales Analytics — SQL Project

> **Resume Project | Data Analytics | MS SQL Server**

---

## 📌 Project Overview

This project simulates a real-world **e-commerce sales database** and uses SQL to answer key business questions across revenue, customer behaviour, product performance, and operational efficiency. It is built entirely in **Microsoft SQL Server** and demonstrates skills directly relevant to a Data Analyst role.

---

## 🗂️ Project Structure

```
ecommerce_sql_project/
│
├── 01_schema_and_data.sql     # Database creation, table schema & sample data
├── 02_analysis_queries.sql    # 10 business analysis queries
├── 03_advanced_sql.sql        # Views, Stored Procedures & Window Functions
└── README.md                  # Project documentation (this file)
```

---

## 🗃️ Database Schema

The database contains **4 related tables**:

```
Customers ──< Orders ──< OrderItems >── Products
```

| Table        | Description                                           | Rows |
|--------------|-------------------------------------------------------|------|
| `Customers`  | Customer profile, city, segment (Premium/Regular/New) | 30   |
| `Products`   | Product catalogue with cost, selling price, stock     | 20   |
| `Orders`     | Order header — date, status, payment method           | 50   |
| `OrderItems` | Line items — quantity, price, discount per order      | 75   |

### Key Relationships
- One **Customer** → Many **Orders**
- One **Order** → Many **OrderItems**
- One **Product** → Many **OrderItems**

---

## 🔍 Business Questions Answered

### `02_analysis_queries.sql` — 10 Analysis Queries

| # | Business Question | SQL Concepts Used |
|---|-------------------|-------------------|
| 1 | Overall revenue, orders & profit | Aggregation, JOINs |
| 2 | Monthly revenue trend | GROUP BY, FORMAT |
| 3 | Top 5 best-selling products | TOP N, ORDER BY |
| 4 | Revenue share by product category | Window Function (SUM OVER) |
| 5 | Customer segmentation by spend | CTE, CASE, RANK() |
| 6 | Order status breakdown & cancel rate | CASE, % calculation |
| 7 | City-wise sales performance | GROUP BY, AVG |
| 8 | Payment method preference | GROUP BY, Window Function |
| 9 | Month-over-month revenue growth % | CTE, LAG() |
| 10 | Product profit margin analysis | RANK() OVER PARTITION |

---

### `03_advanced_sql.sql` — Views, Stored Procedures & Window Functions

#### Views Created
| View | Purpose |
|------|---------|
| `vw_SalesSummary` | Unified sales view joining all 4 tables |
| `vw_CustomerLifetimeValue` | Each customer's LTV, order count, recency |

#### Stored Procedures
| Procedure | Parameters | Purpose |
|-----------|-----------|---------|
| `usp_GetCategoryReport` | `@Category` | Full P&L for any product category |
| `usp_GetMonthlyReport` | `@Year, @Month` | KPI snapshot for any month |

#### Window Functions Demonstrated
- `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()` — customer & product rankings
- `NTILE(4)` — quartile segmentation
- `LAG()` — month-over-month growth
- `SUM() OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)` — cumulative revenue
- `AVG() OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)` — 3-month rolling average
- `PARTITION BY` — rankings within category/segment


## 💡 Key SQL Skills Demonstrated

| Skill | Usage |
|-------|-------|
| DDL (CREATE, ALTER) | Table creation with constraints, FK references |
| DML (INSERT) | Bulk data population |
| JOINs | INNER JOIN across 4 tables |
| Aggregations | SUM, COUNT, AVG with GROUP BY |
| CTEs | `WITH` clause for readable multi-step queries |
| Window Functions | RANK, LAG, NTILE, running totals |
| Views | Reusable query abstraction |
| Stored Procedures | Parameterised, reusable business logic |
| CASE Statements | Conditional logic for segmentation |
| Date Functions | FORMAT, YEAR, MONTH, DATEDIFF |
| NULL Handling | NULLIF to prevent divide-by-zero |

---

## 📊 Sample Insights from the Data

- **Electronics** is the top revenue category, driven by iPhones and laptops
- **Credit Card** and **UPI** are the dominant payment methods
- **Mumbai** and **Delhi** lead in city-wise revenue
- **Premium** customers have significantly higher lifetime value vs Regular/New
- Revenue shows a clear **upward trend** through 2023–2024
- Product margins vary from ~15% (Electronics) to ~55% (Books)

---

## 🧑‍💻 Author

**[Your Name]**
Aspiring Data Analyst | SQL | Excel | Power BI
📧 [your.email@example.com]
🔗 [LinkedIn Profile URL]
💻 [GitHub Profile URL]

---

## 📝 Resume Line (copy-paste ready)

> **E-Commerce Sales Analytics SQL Project** *(Personal Project | 2024)*
> Designed a normalized MS SQL Server database for e-commerce data (4 tables, 175+ rows).
> Performed 10+ business analyses including revenue trends, customer LTV segmentation, and
> product margin analysis using JOINs, CTEs, Window Functions, Views, and Stored Procedures.
