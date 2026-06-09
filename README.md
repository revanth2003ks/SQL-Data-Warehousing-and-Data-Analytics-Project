# Data Warehouse and Analytics Project

## Overview

This project demonstrates the design and implementation of a modern SQL Server Data Warehouse using the Medallion Architecture (Bronze, Silver, and Gold layers). The solution integrates data from CRM and ERP source systems, performs data cleansing and transformation, and delivers business-ready datasets for analytics and reporting.

The project follows industry-standard Data Engineering and Data Warehousing practices, including ETL pipeline development, dimensional modeling, data quality management, and analytical reporting.

---

## Project Objectives

* Consolidate data from multiple source systems (CRM and ERP).
* Build a scalable Data Warehouse using SQL Server.
* Implement ETL pipelines for data ingestion and transformation.
* Apply data cleansing and standardization techniques.
* Design a Star Schema for analytical workloads.
* Generate business-ready datasets for reporting and decision-making.

---

## Architecture

The project follows the Medallion Architecture pattern:

```text
Source Systems (CRM & ERP CSV Files)
                 │
                 ▼
        Bronze Layer (Raw Data)
                 │
                 ▼
      Silver Layer (Cleaned Data)
                 │
                 ▼
 Gold Layer (Business Ready Views)
                 │
                 ▼
      Analytics & Reporting
```

### Bronze Layer

Purpose:

* Store raw source data.
* Preserve original records.
* Enable data recovery and auditing.

Tables:

* crm_cust_info
* crm_prd_info
* crm_sales_details
* erp_loc_a101
* erp_cust_az12
* erp_px_cat_g1v2

### Silver Layer

Purpose:

* Data cleansing
* Data validation
* Standardization
* Deduplication

Transformations:

* Remove duplicate customers
* Standardize gender and marital status values
* Correct invalid sales amounts
* Handle missing values
* Convert integer dates to proper DATE format
* Normalize country codes

### Gold Layer

Purpose:

* Create business-ready datasets.
* Implement Star Schema design.

Views:

* dim_customers
* dim_products
* fact_sales

---

## Data Model

### Dimension Tables

#### dim_customers

Contains:

* Customer information
* Demographics
* Country
* Gender
* Birthdate

#### dim_products

Contains:

* Product information
* Categories
* Subcategories
* Product line
* Maintenance type

### Fact Table

#### fact_sales

Contains:

* Sales transactions
* Revenue
* Quantity
* Product references
* Customer references
* Order dates

---

## ETL Process

### Bronze Load

Stored Procedure:

```sql
EXEC bronze.load_bronze;
```

Activities:

* Truncate Bronze tables
* Load CSV files using BULK INSERT
* Track load duration
* Log ETL execution

### Silver Load

Stored Procedure:

```sql
EXEC silver.load_silver;
```

Activities:

* Clean source data
* Remove duplicates
* Standardize values
* Validate business rules
* Create trusted datasets

---

## Data Quality Improvements

### Customer Data

* Removed duplicate customer records
* Standardized gender values
* Standardized marital status values
* Trimmed unwanted spaces

### Product Data

* Extracted category identifiers
* Standardized product line descriptions
* Managed product history using LEAD()

### Sales Data

* Corrected invalid sales values
* Recalculated sales amounts
* Derived missing prices
* Validated transaction dates

### ERP Data

* Normalized country names
* Removed invalid customer prefixes
* Corrected future birth dates

---

## Technologies Used

* SQL Server
* SQL Server Management Studio (SSMS)
* T-SQL
* ETL Development
* Data Warehousing
* Star Schema Modeling
* Git
* GitHub

---

## Business Insights Supported

The Gold Layer enables analysis of:

### Customer Analytics

* Customer demographics
* Customer segmentation
* Geographic distribution

### Product Analytics

* Product performance
* Category analysis
* Product line analysis

### Sales Analytics

* Revenue analysis
* Sales trends
* Order volume analysis
* Customer purchasing behavior

---

## Key Skills Demonstrated

### Data Engineering

* ETL Pipeline Development
* Data Integration
* Data Cleansing
* Data Validation

### Data Warehousing

* Medallion Architecture
* Star Schema
* Fact and Dimension Modeling
* Surrogate Keys

### SQL Development

* Stored Procedures
* Window Functions
* Joins
* Data Transformation
* Error Handling
* Performance Optimization

---


## Repository Structure

```text
data-warehouse-project
│
├── datasets
│
├── scripts
│   ├── bronze
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   ├── silver
│   │   ├── ddl_silver.sql
│   │   └── proc_load_silver.sql
│   │
│   └── gold
│       └── gold_views.sql



