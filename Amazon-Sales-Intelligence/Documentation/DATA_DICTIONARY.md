# Data Dictionary

This document inventories the worksheets and fields in `Dataset/Amazon_Sales_Analysis.xlsx`.
Descriptions are inferred from field names and worksheet context; confirm definitions with the data owner before operational use.

| Worksheet | Rows | Columns |
|---|---:|---:|
| `Sales_Data` | 300 | 27 |
| `Orders` | 4,000 | 13 |
| `Products` | 400 | 8 |
| `Customers` | 400 | 10 |
| `Retailers` | 400 | 9 |
| `Warehouses` | 400 | 7 |
| `Inventory` | 4,000 | 10 |
| `Shipments` | 4,000 | 9 |
| `Returns` | 1,000 | 7 |
| `Reviews` | 4,000 | 7 |
| `Categories` | 8 | 6 |
| `Monthly_Sales` | 19 | 6 |
| `Region_Sales` | 5 | 6 |
| `Payment_Sales` | 7 | 5 |
| `Retailer_Sales` | 30 | 6 |
| `Dashboard` | 0 | 0 |
| `Sheet2` | 182 | 6 |

## Fields by worksheet

### Sales_Data

`Line_ID`, `Order_ID`, `Order_Date`, `Customer_ID`, `Customer_Name`, `Product_ID`, `Product_Name`, `Brand`, `Category`, `Sub_Category`, `Retailer_ID`, `Retailer_Name`, `Warehouse_ID`, `City`, `State`, `Region`, `Quantity`, `List_Price`, `Discount`, `Unit_Sale_Price`, `Sales`, `Cost`, `Profit`, `Payment_Mode`, `Order_Status`, `Delivery_Date`, `Channel`

### Orders

`Order_ID`, `Order_Date`, `Customer_ID`, `Customer_Name`, `Retailer_ID`, `Retailer_Name`, `Total_Quantity`, `Order_Value`, `Payment_Mode`, `Order_Status`, `Delivery_Date`, `Channel`, `Warehouse_ID`

### Products

`Product_ID`, `Product_Name`, `Brand`, `Category`, `Sub_Category`, `List_Price`, `Unit_Cost`, `Product_Status`

### Customers

`Customer_ID`, `Customer_Name`, `Gender`, `Age`, `Age_Group`, `City`, `State`, `Region`, `Signup_Date`, `Membership`

### Retailers

`Retailer_ID`, `Retailer_Name`, `Primary_Category`, `City`, `State`, `Region`, `Seller_Type`, `Seller_Rating`, `Status`

### Warehouses

`Warehouse_ID`, `Warehouse_Name`, `City`, `State`, `Region`, `Capacity_SqFt`, `Warehouse_Type`

### Inventory

`Product_ID`, `Product_Name`, `Category`, `Warehouse_ID`, `Warehouse_City`, `Opening_Stock`, `Stock_Received`, `Units_Sold`, `Closing_Stock`, `Reorder_Level`

### Shipments

`Shipment_ID`, `Order_ID`, `Warehouse_ID`, `Ship_Date`, `Promised_Date`, `Actual_Delivery_Date`, `Delay_Days`, `Carrier`, `Shipment_Status`

### Returns

`Return_ID`, `Order_ID`, `Customer_ID`, `Return_Date`, `Return_Reason`, `Refund_Amount`, `Return_Status`

### Reviews

`Review_ID`, `Order_ID`, `Customer_ID`, `Product_ID`, `Rating`, `Review_Text`, `Review_Date`

### Categories

`Category`, `Line_Items`, `Sales`, `Profit`, `Quantity`, `Profit_Margin`

### Monthly_Sales

`Month`, `Line_Items`, `Sales`, `Profit`, `Quantity`, `Profit_Margin`

### Region_Sales

`Region`, `Line_Items`, `Sales`, `Profit`, `Quantity`, `Profit_Margin`

### Payment_Sales

`Payment_Mode`, `Line_Items`, `Sales`, `Profit`, `Profit_Margin`

### Retailer_Sales

`Retailer_ID`, `Retailer_Name`, `Line_Items`, `Sales`, `Profit`, `Profit_Margin`
