# 🚲 Bike Retail Data Engineering & Analytics Pipeline

An end-to-end data engineering project that transforms raw BikeStores CSV datasets into a structured SQL Server database using SSIS, followed by data quality validation and SQL-based business analysis.

## Project Overview

This project demonstrates a complete ETL workflow from raw CSV files to an analytics-ready relational database.

**Pipeline:**

Raw CSV Files → SSIS ETL → Data Cleaning & Transformation → SQL Server → Data Validation → Business Analysis

## Tech Stack

- **SQL Server** — Relational database and analytics
- **SSIS** — ETL pipeline development
- **SSMS** — Database management and SQL querying
- **Visual Studio** — SSIS package development
- **Git / GitHub** — Version control and project documentation

## Database Design

The database contains 9 relational tables:

`brands` · `categories` · `customers` · `stores` · `staffs` · `products` · `stocks` · `orders` · `order_items`

### ER Diagram

<img width="1095" height="1261" alt="image" src="https://github.com/user-attachments/assets/98f07091-ebb1-47ca-bf3b-d7f77171f6d7" />


The schema preserves primary/foreign key relationships between customers, orders, products, stores, staff, and inventory.

## ETL Architecture

The SSIS package loads the source datasets into SQL Server while respecting table dependencies.

### Control Flow

<img width="580" height="730" alt="image" src="https://github.com/user-attachments/assets/404938a6-cd0c-4862-a3d8-5f732a288db6" />


**Load sequence:**

Reset Tables → Brands → Categories → Customers → Stores → Staffs → Products → Stocks → Orders → Order Items

Green precedence constraints ensure dependent tables are loaded only after their parent tables complete successfully.

## Data Transformation

The pipeline handles source data quality issues before loading data into SQL Server.

### NULL Handling

The `shipped_date` field contains NULL values for orders that have not yet shipped. A Derived Column transformation preserves these values as SQL NULL rather than treating them as invalid dates.

<img width="1474" height="1069" alt="image" src="https://github.com/user-attachments/assets/d81b860d-dac2-469e-a445-632384c34cdf" />


## Data Quality & Validation

After the ETL process completes, SQL validation queries verify row counts, NULL handling, and referential integrity.

### Row Count Validation

| Table | Rows |
|---|---:|
| brands | 9 |
| categories | 7 |
| customers | 1,445 |
| stores | 3 |
| staffs | 10 |
| products | 321 |
| stocks | 939 |
| orders | 1,615 |
| order_items | 4,722 |

[放你 Row Count SQL 截图]

Referential integrity checks confirmed that all orders reference valid customers.

## SQL Business Analysis

SQL queries were used to analyze product sales, revenue, store performance, and customer behavior.

### Top Products by Revenue

[放你 Top 10 Products SQL + Results 截图]

Revenue was calculated as:

`quantity × list_price × (1 - discount)`

## Challenges & Solutions

### Handling NULL Shipping Dates
**Challenge:** `NULL` values in `shipped_date` caused SSIS date conversion failures.

**Solution:** Added a Derived Column transformation to correctly preserve missing shipping dates as SQL NULL values.

### Duplicate Data During Re-runs
**Challenge:** Re-running the ETL package caused primary-key violations.

**Solution:** Added a Reset BikeStore Tables SQL task before the ETL workflow, making the pipeline safely re-runnable.

### Foreign Key Dependencies
**Challenge:** Tables must be loaded in the correct order because of relational dependencies.

**Solution:** Implemented SSIS precedence constraints to enforce the required load sequence.

## Project Structure

```text
BikeRetail_ETL/
├── data/
├── sql/
│   ├── create_tables.sql
│   ├── validation_queries.sql
│   └── business_analysis.sql
├── screenshots/
│   ├── database_design/
│   ├── etl_pipeline/
│   └── sql_analysis/
├── Package.dtsx
└── README.md
