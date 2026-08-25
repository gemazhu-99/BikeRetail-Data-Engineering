# Bike Retail ETL Pipeline

## Overview
This project implements an end-to-end ETL pipeline using SQL Server
Integration Services (SSIS) to load Bike Retail business data from
CSV files into a relational SQL Server database.

The pipeline processes 9 datasets and handles data type conversion,
NULL values, relational dependencies, and automated full-refresh loading.

## Tech Stack
- SQL Server
- SQL Server Integration Services (SSIS)
- Visual Studio
- SSMS
- SQL
- CSV / Flat Files
- ADO.NET

## Data Pipeline

CSV Files
   ↓
Flat File Sources
   ↓
SSIS Transformations
   ↓
ADO.NET Destinations
   ↓
SQL Server (BikeStoreDB)

## Tables

The ETL pipeline loads 9 relational tables:

- brands
- categories
- customers
- stores
- staffs
- products
- stocks
- orders
- order_items

## ETL Workflow

Reset BikeStore Tables
        ↓
Load Brands
        ↓
Load Categories
        ↓
Load Customers
        ↓
Load Stores
        ↓
Load Staffs
        ↓
Load Products
        ↓
Load Stocks
        ↓
Load Orders
        ↓
Load Order Items

## Data Transformations

The pipeline includes:

- CSV schema and metadata configuration
- Data type conversion
- NULL value handling
- Date conversion
- Foreign-key-aware load ordering
- Automated table reset
- Full-refresh ETL execution

### NULL Manager ID

The `staffs` dataset contains NULL manager IDs.
A Derived Column transformation converts source NULL representations
into SQL-compatible NULL values.

### NULL Shipped Date

Orders that have not yet shipped contain NULL `shipped_date` values.
A Derived Column transformation handles these values before loading
them into SQL Server.

## Validation

The final SQL Server tables contain:

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

Additional validation checks were performed for:
- NULL shipped dates
- Foreign key integrity
- Table row counts
- Revenue and product-level aggregations

## Example Business Analysis

The loaded database can be queried to analyze:

- Product revenue
- Units sold
- Customer purchasing behavior
- Store performance
- Product inventory
- Order fulfillment

## Key Engineering Challenges

During development, several ETL issues were identified and resolved:

1. Source/destination metadata mismatches
2. String-to-date conversion errors
3. NULL value handling
4. Primary-key duplicate errors during repeated executions
5. Database connection configuration
6. Foreign-key dependency ordering

The final package supports repeatable full-refresh execution through
an automated reset step followed by dependency-aware table loading.
