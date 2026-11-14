-- Amazon Sales Intelligence | MySQL 8.0 analysis queries
-- Source workbook: amazon analysis project(2).xlsx
-- IMPORTANT:
-- 1) This script assumes Excel sheets were imported as tables with the same names.
-- 2) Change the database name below if your MySQL schema has a different name.
-- 3) Sales_Data contains line-item-level records. Use SUM(Sales) from this table
--    for sales analysis; do not join it to one-to-many tables without aggregation.
-- 4) Orders is order-level; Inventory, Shipments, Returns and Reviews have their
--    own grains. Queries below aggregate carefully to reduce double counting.
-- 5) Run one query section at a time in MySQL Workbench if preferred.

-- 01. Database selection and table check
USE amazon_sales_analysis;

SHOW TABLES;

-- Expected core table names (if imported using Excel sheet names):
-- Sales_Data, Orders, Products, Customers, Retailers, Warehouses,
-- Inventory, Shipments, Returns, Reviews

-- 02. Overall sales KPIs
SELECT
    COUNT(*) AS line_items,
    COUNT(DISTINCT Order_ID) AS distinct_orders,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Cost), 2) AS total_cost,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct
FROM Sales_Data;

-- 03. Monthly sales and profit trend
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS sales_month,
    COUNT(*) AS line_items,
    COUNT(DISTINCT Order_ID) AS orders,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct
FROM Sales_Data
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY sales_month;

-- 04. Year-wise performance
SELECT
    YEAR(Order_Date) AS sales_year,
    COUNT(DISTINCT Order_ID) AS orders,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY YEAR(Order_Date)
ORDER BY sales_year;

-- 05. Category-wise performance
SELECT
    Category,
    COUNT(*) AS line_items,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct
FROM Sales_Data
GROUP BY Category
ORDER BY sales DESC;

-- 06. Sub-category analysis
SELECT
    Category,
    Sub_Category,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY Category, Sub_Category
ORDER BY sales DESC;

-- 07. Region-wise sales and profit
SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS orders,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY Region
ORDER BY sales DESC;

-- 08. State-wise sales leaderboard
SELECT
    State,
    Region,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit,
    COUNT(DISTINCT Order_ID) AS orders
FROM Sales_Data
GROUP BY State, Region
ORDER BY sales DESC
LIMIT 15;

-- 09. City-wise sales
SELECT
    City,
    State,
    ROUND(SUM(Sales), 2) AS sales,
    SUM(Quantity) AS units_sold
FROM Sales_Data
GROUP BY City, State
ORDER BY sales DESC
LIMIT 15;

-- 10. Payment mode performance
SELECT
    Payment_Mode,
    COUNT(DISTINCT Order_ID) AS orders,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY Payment_Mode
ORDER BY sales DESC;

-- 11. Order status summary
SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS orders,
    ROUND(SUM(Sales), 2) AS sales,
    SUM(Quantity) AS units
FROM Sales_Data
GROUP BY Order_Status
ORDER BY orders DESC;

-- 12. Sales channel analysis
SELECT
    Channel,
    COUNT(DISTINCT Order_ID) AS orders,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(AVG(Sales), 2) AS avg_line_sales
FROM Sales_Data
GROUP BY Channel
ORDER BY sales DESC;

-- 13. Top 10 products by sales
SELECT
    Product_ID,
    Product_Name,
    Category,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY Product_ID, Product_Name, Category
ORDER BY sales DESC
LIMIT 10;

-- 14. Top 10 products by profit
SELECT
    Product_ID,
    Product_Name,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY Product_ID, Product_Name
ORDER BY profit DESC
LIMIT 10;

-- 15. Brand performance
SELECT
    Brand,
    COUNT(DISTINCT Product_ID) AS products_sold,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY Brand
ORDER BY sales DESC
LIMIT 15;

-- 16. Discount impact analysis
SELECT
    CASE
        WHEN Discount < 10 THEN '0-9.99%'
        WHEN Discount < 20 THEN '10-19.99%'
        WHEN Discount < 30 THEN '20-29.99%'
        ELSE '30% and above'
    END AS discount_band,
    COUNT(*) AS line_items,
    ROUND(AVG(Discount), 2) AS avg_discount_pct,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct
FROM Sales_Data
GROUP BY discount_band
ORDER BY MIN(Discount);

-- 17. Customer membership analysis
SELECT
    c.Membership,
    COUNT(DISTINCT s.Customer_ID) AS customers,
    COUNT(DISTINCT s.Order_ID) AS orders,
    ROUND(SUM(s.Sales), 2) AS sales,
    ROUND(AVG(s.Sales), 2) AS avg_line_sales
FROM Sales_Data s
LEFT JOIN Customers c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Membership
ORDER BY sales DESC;

-- 18. Customer age-group analysis
SELECT
    c.Age_Group,
    COUNT(DISTINCT s.Customer_ID) AS customers,
    COUNT(DISTINCT s.Order_ID) AS orders,
    ROUND(SUM(s.Sales), 2) AS sales,
    ROUND(SUM(s.Profit), 2) AS profit
FROM Sales_Data s
LEFT JOIN Customers c ON s.Customer_ID = c.Customer_ID
GROUP BY c.Age_Group
ORDER BY sales DESC;

-- 19. Top customers by sales
SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS orders,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit
FROM Sales_Data
GROUP BY Customer_ID, Customer_Name
ORDER BY sales DESC
LIMIT 10;

-- 20. Repeat customers
SELECT
    Customer_ID,
    MAX(Customer_Name) AS customer_name,
    COUNT(DISTINCT Order_ID) AS order_count,
    ROUND(SUM(Sales), 2) AS total_sales
FROM Sales_Data
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Order_ID) > 1
ORDER BY order_count DESC, total_sales DESC;

-- 21. Retailer performance
SELECT
    Retailer_ID,
    Retailer_Name,
    COUNT(DISTINCT Order_ID) AS orders,
    ROUND(SUM(Sales), 2) AS sales,
    ROUND(SUM(Profit), 2) AS profit,
    ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct
FROM Sales_Data
GROUP BY Retailer_ID, Retailer_Name
ORDER BY sales DESC
LIMIT 15;

-- 22. Retailer attributes and sales
SELECT
    r.Retailer_ID,
    r.Retailer_Name,
    r.Seller_Type,
    r.Seller_Rating,
    r.Status,
    ROUND(SUM(s.Sales), 2) AS sales
FROM Retailers r
LEFT JOIN Sales_Data s ON r.Retailer_ID = s.Retailer_ID
GROUP BY r.Retailer_ID, r.Retailer_Name, r.Seller_Type, r.Seller_Rating, r.Status
ORDER BY sales DESC;

-- 23. Warehouse sales contribution
SELECT
    w.Warehouse_ID,
    w.Warehouse_Name,
    w.City,
    w.Region,
    COUNT(DISTINCT s.Order_ID) AS orders,
    ROUND(SUM(s.Sales), 2) AS sales
FROM Warehouses w
LEFT JOIN Sales_Data s ON w.Warehouse_ID = s.Warehouse_ID
GROUP BY w.Warehouse_ID, w.Warehouse_Name, w.City, w.Region
ORDER BY sales DESC;

-- 24. Inventory below reorder level
SELECT
    Product_ID,
    Product_Name,
    Category,
    Warehouse_ID,
    Warehouse_City,
    Closing_Stock,
    Reorder_Level,
    Reorder_Level - Closing_Stock AS units_to_reorder
FROM Inventory
WHERE Closing_Stock <= Reorder_Level
ORDER BY units_to_reorder DESC;

-- 25. Inventory stock reconciliation
SELECT
    Product_ID,
    Product_Name,
    Warehouse_ID,
    Opening_Stock,
    Stock_Received,
    Units_Sold,
    Closing_Stock,
    (Opening_Stock + Stock_Received - Units_Sold) AS expected_closing_stock,
    Closing_Stock - (Opening_Stock + Stock_Received - Units_Sold) AS variance
FROM Inventory
WHERE Closing_Stock <> (Opening_Stock + Stock_Received - Units_Sold)
ORDER BY ABS(variance) DESC;

-- 26. Shipment status summary
SELECT
    Shipment_Status,
    COUNT(*) AS shipment_records,
    COUNT(DISTINCT Order_ID) AS distinct_orders
FROM Shipments
GROUP BY Shipment_Status
ORDER BY shipment_records DESC;

-- 27. Average delivery delay by carrier
SELECT
    Carrier,
    COUNT(*) AS shipment_records,
    ROUND(AVG(Delay_Days), 2) AS avg_delay_days,
    SUM(CASE WHEN Delay_Days > 0 THEN 1 ELSE 0 END) AS delayed_records
FROM Shipments
WHERE Delay_Days IS NOT NULL
GROUP BY Carrier
ORDER BY avg_delay_days DESC;

-- 28. Return reason analysis
SELECT
    Return_Reason,
    Return_Status,
    COUNT(*) AS return_records,
    ROUND(SUM(Refund_Amount), 2) AS refund_amount
FROM Returns
GROUP BY Return_Reason, Return_Status
ORDER BY return_records DESC;

-- 29. Return rate by order (using Orders as denominator)
SELECT
    COUNT(DISTINCT o.Order_ID) AS total_orders,
    COUNT(DISTINCT r.Order_ID) AS orders_with_returns,
    ROUND(
        100 * COUNT(DISTINCT r.Order_ID) / NULLIF(COUNT(DISTINCT o.Order_ID), 0),
        2
    ) AS order_return_rate_pct
FROM Orders o
LEFT JOIN Returns r ON o.Order_ID = r.Order_ID;

-- 30. Product review rating
SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    COUNT(rv.Review_ID) AS review_count,
    ROUND(AVG(rv.Rating), 2) AS avg_rating
FROM Products p
LEFT JOIN Reviews rv ON p.Product_ID = rv.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
HAVING COUNT(rv.Review_ID) > 0
ORDER BY avg_rating DESC, review_count DESC
LIMIT 20;

-- 31. Category-wise customer ratings
SELECT
    p.Category,
    COUNT(rv.Review_ID) AS review_count,
    ROUND(AVG(rv.Rating), 2) AS avg_rating
FROM Reviews rv
JOIN Products p ON rv.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY avg_rating DESC;

-- 32. Sales data quality: missing delivery dates
SELECT
    COUNT(*) AS total_line_items,
    SUM(CASE WHEN Delivery_Date IS NULL THEN 1 ELSE 0 END) AS missing_delivery_dates,
    ROUND(
        100 * SUM(CASE WHEN Delivery_Date IS NULL THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS missing_delivery_pct
FROM Sales_Data;

-- 33. Duplicate primary-key check
SELECT 'Sales_Data.Line_ID' AS key_name, COUNT(*) AS duplicate_count
FROM (SELECT Line_ID FROM Sales_Data GROUP BY Line_ID HAVING COUNT(*) > 1) d
UNION ALL
SELECT 'Orders.Order_ID', COUNT(*)
FROM (SELECT Order_ID FROM Orders GROUP BY Order_ID HAVING COUNT(*) > 1) d
UNION ALL
SELECT 'Products.Product_ID', COUNT(*)
FROM (SELECT Product_ID FROM Products GROUP BY Product_ID HAVING COUNT(*) > 1) d
UNION ALL
SELECT 'Customers.Customer_ID', COUNT(*)
FROM (SELECT Customer_ID FROM Customers GROUP BY Customer_ID HAVING COUNT(*) > 1) d;

-- 34. Check Sales_Data order IDs missing from Orders
SELECT DISTINCT s.Order_ID
FROM Sales_Data s
LEFT JOIN Orders o ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

-- 35. Order-level sales vs Orders sheet value
SELECT
    o.Order_ID,
    o.Order_Value AS orders_sheet_value,
    ROUND(SUM(s.Sales), 2) AS sales_data_value,
    ROUND(SUM(s.Sales) - o.Order_Value, 2) AS difference
FROM Orders o
JOIN Sales_Data s ON o.Order_ID = s.Order_ID
GROUP BY o.Order_ID, o.Order_Value
HAVING ABS(SUM(s.Sales) - o.Order_Value) > 0.01
ORDER BY ABS(difference) DESC;
