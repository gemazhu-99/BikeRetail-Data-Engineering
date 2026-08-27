-- ============================================================
-- Bike Retail Data Engineering & Analytics Pipeline
-- Data Quality & Validation
-- ============================================================


-- 1. Row Count Validation
-- Validate the number of records loaded into each destination table.

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


-- 2. NULL Validation
-- Confirm that unshipped orders are stored as true SQL NULL values.

SELECT *
FROM dbo.orders
WHERE shipped_date IS NULL;


-- 3. Referential Integrity Validation
-- Identify orders that reference nonexistent customers.
-- Expected result: 0 rows.

SELECT o.*
FROM dbo.orders o
LEFT JOIN dbo.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
