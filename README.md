# 📊 SQL Sales Analysis Project

## Skills Demonstrated

SQL Fundamentals – database creation, schema design
Data Warehouse Concepts – fact & dimension tables
Data Loading – BULK INSERT
Analytical SQL – window functions, CTEs, segmentation
Reporting Views – customer and product analytical models

## Project Overview
This project analyzes sales, customer behavior, and product performance using SQL Server.
The dataset follows a simple Data Warehouse model with fact and dimension tables.
The analysis includes time-based trends, customer segmentation, product evaluation, and performance metrics.

The project includes:

- Database and schema setup
- Data loading using BULK INSERT
- Sales performance analysis queries
- Customer report view (behavior, segments, KPIs)
- Product report view (performance tiers, metrics, KPIs)

##  How It Works
This project is executed entirely inside Microsoft SQL Server.
To run the analysis from start to finish, follow these steps:

#### 1. Prepare the Dataset

All CSV files are stored in the /dataset folder:
gold.dim_customers.csv – customer attributes
gold.dim_products.csv – product details
gold.fact_sales.csv – transaction-level sales data
Download the repository. You may need to update the file paths in the script depending on your directory.

#### 2. Create Schema and Tables

##### ➡️ Option A – Use the provided setup script (recommended)

Run the script: Scripts/01_setup_and_load.sql

⚠️ You may need to update the CSV file paths to match the location of the datasets/ folder on your machine.

##### ➡️ Option B – Create the database manually

If preferred, you may:

1. Create a new database in SSMS

2. Import each CSV using Flat File Import

This method is slower but helpful for users unfamiliar with BULK INSERT.

#### 3. Run the Analysis Scripts

Execute: **Scripts/02_sales_analysis.sql**

This script includes:

- Monthly and yearly sales trends
- Customer behavior segmentation
- Product-level performance
- Category contribution analysis
- Cost-range product grouping
- Window function–based KPIs
The queries are modular and can be run independently.

##### 4. Generate Reporting Views

Run:

- **03_customer_report.sql** → creates gold.report_customers

- **04_product_report.sql** → creates gold.report_products

These views consolidate the entire dataset into clean, ready-to-use outputs for BI dashboards or further

## 📂 Files Included

- **01_setup_and_load.sql** – Creates database, schema, tables, and loads CSV files using BULK INSERT
- **02_sales_analysis.sql** – Time analysis, category contribution, product cost segmentation, customer segmentation
- **03_customer_report.sql** – Full customer analytical report (orders, spending, recency, segments)
- **04_product_report.sql** – Full product analytical report (sales, customers, profitability, performance tiers)
- **Datasets (.csv)** – Source data for dim_customers, dim_products, and fact_sales
- **README.md** – Project explanation


## 📌 Notes

Paths in BULK INSERT may need to be updated depending on your local folder structure
This project runs on Microsoft SQL Server
Views can be queried directly after executing all scripts

## Author

Trinh Nguyen
📧 Contact: ng.trinh3023@gmail.com

📍 GitHub: https://trinhnguyen-venus.github.io/