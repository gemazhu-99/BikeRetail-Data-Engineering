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

The final SQL Server database contains 9 relational tables:

`brands` · `categories` · `customers` · `stores` · `staffs` · `products` · `stocks` · `orders` · `order_items`

### Conceptual ER Diagram

The initial ERD was developed to model the major business entities and relationships across products, customers, stores, staff, inventory, and orders.

During implementation, the schema was aligned with the BikeStores source structure, resulting in nine final tables in SQL Server.


<img width="942" height="1182" alt="image" src="https://github.com/user-attachments/assets/157f979d-bc45-41ac-aeaf-331e1878d638" />



The schema preserves primary/foreign key relationships between customers, orders, products, stores, staff, and inventory.

## ETL Architecture

The ETL pipeline was developed in SSIS to extract raw CSV data, transform source fields when necessary, and load the data into SQL Server.

### SSIS Control Flow

The workflow follows a dependency-aware loading sequence to preserve foreign key relationships between tables.

**Load Sequence:**

`Reset Tables → Brands → Categories → Customers → Stores → Staffs → Products → Stocks → Orders → Order Items`

<img width="580" height="730" alt="image" src="https://github.com/user-attachments/assets/404938a6-cd0c-4862-a3d8-5f732a288db6" />

Green precedence constraints ensure that each downstream task executes only after the previous task completes successfully.

### Successful Pipeline Execution

The complete ETL workflow was executed successfully after resolving data type, NULL handling, connection, and dependency issues.

<img width="558" height="696" alt="image" src="https://github.com/user-attachments/assets/e36cd068-1651-48fe-ac15-bb63b08fdc08" />




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

<img width="280" height="300" alt="image" src="https://github.com/user-attachments/assets/105c2414-0028-4827-bae3-90cff81b58b5" />


Referential integrity checks confirmed that all orders reference valid customers.

## SQL Business Analysis

SQL queries were used to analyze product sales, revenue, store performance, and customer behavior.

### Top Products by Revenue

<img width="612" height="325" alt="image" src="https://github.com/user-attachments/assets/10d83d97-1b03-4c27-8d54-6e656d525bae" />


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
