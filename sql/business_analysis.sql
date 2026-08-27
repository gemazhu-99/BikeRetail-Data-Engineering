-- ============================================================
-- Bike Retail Data Engineering & Analytics Pipeline
-- Business Analysis Queries
-- ============================================================


-- 1. Top Products by Revenue
-- Identify the highest-performing products based on units sold
-- and revenue after discounts.

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


-- 2. Store Performance
-- Compare store-level performance using total orders,
-- units sold, and revenue.

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


-- 3. Customer Analysis
-- Identify the highest-value customers based on total spending,
-- order frequency, and units purchased.

SELECT TOP 10
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS units_purchased,
    ROUND(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)),
        2
    ) AS total_spent
FROM dbo.customers c
JOIN dbo.orders o
    ON c.customer_id = o.customer_id
JOIN dbo.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;
