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

All nine target tables were loaded successfully while preserving dependency order and referential integrity.


## Data Transformation

During the ETL process, several source fields required transformation before they could be loaded safely into SQL Server.

### NULL Handling for `shipped_date`

The source `orders.csv` file contains `"NULL"` values in the `shipped_date` column for orders that have not yet been shipped.

Directly converting the entire column to a date type caused SSIS conversion errors. To resolve this, the source column was first treated as a string and then transformed using a Derived Column component.

```text
shipped_date == "NULL"
    ? NULL(DT_DBDATE)
    : (DT_DBDATE)shipped_date
```
<img width="1474" height="1069" alt="image" src="https://github.com/user-attachments/assets/d81b860d-dac2-469e-a445-632384c34cdf" />

This transformation preserves missing shipping dates as SQL `NULL` values while converting valid date strings into the `DT_DBDATE` data type.

### Additional Data Preparation

Other ETL preparation steps included:

- Configuring UTF-8 source encoding
- Increasing string column widths to prevent truncation
- Converting numeric price and discount fields to appropriate decimal data types
- Converting `manager_id` source `"NULL"` values into SQL `NULL`
- Aligning source and destination metadata before loading

### Row Count Validation

After the ETL pipeline completed, row counts were validated across all nine destination tables to confirm that the expected records were successfully loaded into SQL Server.

```sql
SELECT 'brands' AS table_name, COUNT(*) AS row_count FROM dbo.brands
UNION ALL
SELECT 'categories', COUNT(*) FROM dbo.categories
UNION ALL
SELECT 'customers', COUNT(*) FROM dbo.customers
UNION ALL
SELECT 'stores', COUNT(*) FROM dbo.stores
UNION ALL
SELECT 'staffs', COUNT(*) FROM dbo.staffs
UNION ALL
SELECT 'products', COUNT(*) FROM dbo.products
UNION ALL
SELECT 'stocks', COUNT(*) FROM dbo.stocks
UNION ALL
SELECT 'orders', COUNT(*) FROM dbo.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM dbo.order_items;
```

| Table | Row Count |
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

### NULL Validation

The `shipped_date` field was validated after loading to confirm that unshipped orders were stored as true SQL `NULL` values rather than the source string `"NULL"`.

```sql
SELECT *
FROM dbo.orders
WHERE shipped_date IS NULL;
```

The validation confirmed that missing shipping dates were successfully preserved as SQL `NULL` values after the SSIS transformation.

<img width="918" height="618" alt="image" src="https://github.com/user-attachments/assets/4b6a1c2d-f9ce-4f3e-bada-20348a5cfce1" />

### Referential Integrity Validation

Foreign key relationships were also validated to ensure that transactional records reference valid parent records.

For example, the following query checks for orders associated with nonexistent customers:

```sql
SELECT o.*
FROM dbo.orders o
LEFT JOIN dbo.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```

The query returned 0 rows, indicating that no orphaned order records were found and that all customer_id values in the orders table reference valid customer records.


## SQL Business Analysis

After validating the ETL pipeline, SQL queries were used to analyze sales performance and extract business insights from the integrated BikeStore database.

### Top Products by Revenue

Product-level sales performance was analyzed using total units sold and revenue after discounts.

```sql
SELECT TOP 10
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)),
        2
    ) AS revenue
FROM dbo.order_items oi
JOIN dbo.products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;
```
<img width="586" height="54" alt="image" src="https://github.com/user-attachments/assets/5b62665f-498c-43ee-98dd-b68991b9d64d" />

**Key Insight:** Trek Slash 8 27.5 - 2016 generated the highest revenue at approximately **$616K**, with **154 units sold**. Several other Trek models also ranked among the top-performing products.

### Store Performance

Store-level performance was analyzed by combining order and order item data to compare total orders, units sold, and revenue across locations.

```sql
SELECT
    s.store_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)),
        2
    ) AS revenue
FROM dbo.stores s
JOIN dbo.orders o
    ON s.store_id = o.store_id
JOIN dbo.order_items oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY revenue DESC;
```

<img width="546" height="151" alt="image" src="https://github.com/user-attachments/assets/9774a5b6-5b9d-42e1-94ed-5cc5f82890f0" />


**Key Insight:** Trek Slash 8 27.5 - 2016 generated the highest revenue at approximately **$616K**, with **154 units sold**. Several Trek models also ranked among the top-performing products by revenue.


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
