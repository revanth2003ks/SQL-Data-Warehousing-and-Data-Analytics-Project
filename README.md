# Modern Data Warehouse & Analytics Solution

An end-to-end data warehousing and analytics pipeline built on **SQL Server**, transforming raw CRM and ERP data into business-ready insights using the **Medallion Architecture (Bronze → Silver → Gold)**.

---

## Overview

Organizations accumulate large volumes of operational data across CRM and ERP systems, but raw data alone rarely drives decisions. This project bridges that gap by building a centralized, layered data warehouse that integrates, cleans, models, and analyzes data — delivering actionable insights on customer behavior, product performance, and sales trends.

---

## Architecture

The solution follows the Medallion Architecture, progressing data through three quality tiers:

```
Source Systems (CRM + ERP CSV Files)
           │
           ▼
    ┌─────────────┐
    │ Bronze Layer│  Raw data ingestion — no transformations
    └─────────────┘
           │
           ▼
    ┌─────────────┐
    │ Silver Layer│  Data cleaning, standardization & validation
    └─────────────┘
           │
           ▼
    ┌─────────────┐
    │  Gold Layer │  Star schema model — business-ready analytics
    └─────────────┘
           │
           ▼
    Analytics & Reporting
```

---

## Data Sources

| Source | Contents |
|--------|----------|
| **CRM** | Customer information, product details, sales transactions |
| **ERP** | Customer demographics, location data, product category hierarchy |

---

## Layer Details

### Bronze — Raw Ingestion

Stores source data exactly as received, with no transformations applied. Data is loaded via SQL Server `BULK INSERT` through stored procedures.

**Tables created:**

| Schema | Table |
|--------|-------|
| `bronze` | `crm_cust_info` |
| `bronze` | `crm_prd_info` |
| `bronze` | `crm_sales_details` |
| `bronze` | `erp_cust_az12` |
| `bronze` | `erp_loc_a101` |
| `bronze` | `erp_px_cat_g1v2` |

---

### Silver — Cleansing & Transformation

Prepares data for reliable analytics by resolving quality issues across all source entities.

| Entity | Transformations Applied |
|--------|------------------------|
| **Customers** | Removed duplicates, handled NULLs, trimmed whitespace, standardized gender and marital status values |
| **Products** | Extracted category IDs, imputed missing costs, standardized categories, generated product date ranges |
| **Sales** | Converted integer date formats to proper `DATE` type, validated sales amounts, corrected invalid prices, enforced quantity-price consistency |
| **ERP Records** | Stripped unwanted prefixes, standardized country names, corrected invalid birth dates, normalized gender fields |

---

### Gold — Business Analytics Layer

Exposes a **Star Schema** model optimized for reporting and self-service analytics.

```
         dim_customers
               │
               │
dim_products ──┼── fact_sales
```

| Object | Description |
|--------|-------------|
| `gold.dim_customers` | Customer attributes — country, gender, birthdate, demographics |
| `gold.dim_products` | Product hierarchy — category, subcategory, product line, cost |
| `gold.fact_sales` | Transactional grain — orders, revenue, quantity, keys, dates |

---

## Analytics

### Exploratory Data Analysis

SQL-based EDA covering database structure exploration, dimension profiling (customer countries, product categories, hierarchy), date range analysis, and customer age distribution.

### Business KPIs

| Metric | Description |
|--------|-------------|
| Total Sales | Aggregate revenue |
| Total Orders | Order volume |
| Total Customers | Active customer base |
| Total Products | Product catalog size |
| Average Order Value | Revenue per order |

### Advanced Analytics

| Analysis | Technique |
|----------|-----------|
| **Trend Analysis** | Monthly and yearly sales trends, revenue growth patterns |
| **Cumulative Analysis** | Running totals, moving averages via window functions |
| **Performance Comparison** | Year-over-year and average benchmarking using `LAG()` |
| **Part-to-Whole** | Category revenue contribution and percentage share |
| **Segmentation** | Product tiers by cost range; customer segments (VIP, Regular, New) by spend and tenure |

---

## Reporting Views

### `gold.report_customers`

Provides a unified customer profile including segment (VIP / Regular / New), age group, order history, total revenue, quantity, lifespan, recency, average order value, and monthly spend.

### `gold.report_products`

Covers product performance metrics — revenue, sales quantity, customer reach, product segment, average selling price, and monthly revenue contribution.

---

## Repository Structure

```
Data-Warehouse-Analytics-Project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── scripts/
│   ├── bronze/
│   │   ├── create_tables.sql
│   │   └── load_bronze.sql
│   │
│   ├── silver/
│   │   ├── create_tables.sql
│   │   └── load_silver.sql
│   │
│   └── gold/
│       └── create_views.sql
│
├── analytics/
│   ├── exploratory_analysis.sql
│   └── advanced_analysis.sql
│
├── reports/
│   ├── customer_report.sql
│   └── product_report.sql
│
└── README.md
```

---

## Tech Stack

| Category | Tools |
|----------|-------|
| Database | SQL Server, T-SQL |
| IDE | SQL Server Management Studio (SSMS) |
| Paradigms | ETL, Data Warehousing, Star Schema, EDA |
| Version Control | Git & GitHub |

---

## Skills Demonstrated

- ETL pipeline development (ingestion → cleansing → modeling)
- Data warehouse design using Medallion Architecture
- Dimensional modeling with Star Schema
- Advanced SQL — window functions, `LAG()`, CTEs, running totals
- Customer and product segmentation logic
- Business KPI definition and reporting layer design

