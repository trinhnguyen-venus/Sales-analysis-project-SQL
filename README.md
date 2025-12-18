# 📊 Sales Performance Analysis & Customer Insights (SQL)

## 1. Project Context

This project analyzes historical sales data to understand how the business grows over time, which products drive revenue, and how customer value is distributed.

The focus is on business performance, not technical complexity.
SQL is used as a tool to transform raw transactional data into clear insights that support decision-making.

## 2. Business Questions

The analysis is designed to answer practical questions:

1. How has sales performance evolved over time?
2. Is growth driven by more customers, higher purchase volume, or both?
3. Which products and categories contribute most to revenue?
4. How concentrated is the revenue base?
5. Which customer groups generate long-term value?

##  3. Analytical Approach

The analysis follows a clear and structured workflow:

- Build a clean fact–dimension data structure
- Analyze sales trends at monthly and yearly levels
- Evaluate product and category contribution
- Segment customers based on purchase history and spending
- Consolidate findings into reusable reporting views

The goal is to understand where growth comes from and where risks may exist.


## 4. Key Insights
### 4.1 Sales growth is driven by real demand

- Sales show a strong **upward trend from 2011 to 2013**, with **2013 as the peak year**.
- Monthly sales increased from around **$400K–$700K** in earlier years to over $1.5M in multiple months of 2013.
- Growth is supported by increases in both **active customers and total quantity sold**.

**Insight:**

Sales growth reflects genuine demand expansion rather than short-term price effects.


### 4.2 Revenue is heavily concentrated in one category

- **Bikes account for over 96% of total revenue.**
- Accessories and Clothing together contribute less than 4%.

**Insight:**

While Bikes are a strong core product line, the business shows **high dependency on a single category**, creating long-term risk if demand shifts.


### 4.3 Product cost does not fully explain performance

- Most products fall into low to mid cost ranges.
- Revenue is not evenly distributed across products within the same cost range.

**Insight:**

Demand and category relevance matter more than price alone in driving revenue.

### 4.4 Customer value is unevenly distributed

- The customer base is dominated by new customers.
- Regular and VIP customers form a smaller group but represent the core long-term value segment.

**Insight:**

Future growth depends more on **retention and conversion** than on continued acquisition alone.

## 5. Overall Observation

The business demonstrates strong growth driven by:

- A small set of high-performing products
- A limited group of loyal, high-value customers

At the same time, this creates concentration risks that should be actively managed.

## 6. Recommendations

Based on the analysis:

1. Reduce reliance on a single product category by expanding contribution from secondary categories.
2. Strengthen retention strategies for high-value customers.
3. Focus on converting new customers into regular and long-term buyers.
4. Monitor category concentration as a key business risk indicator.

## 6. How It Works

This project runs entirely in Microsoft SQL Server.

1. Raw CSV files are stored in the datasets/ folder
2. The setup script creates the database structure and loads all data (CSV paths in BULK INSERT may need adjustment based on local setup)
3. Analytical queries explore trends, segmentation, and performance
4. Reporting views consolidate insights into query-ready outputs

All scripts are modular and can be executed step by step.


## 📂 Files Included

Datasets/
    - `gold.dim_customers.csv` – customer attributes
    - `gold.dim_products.csv` – product information
    - `gold.fact_sales.csv` – transaction-level sales data

Scripts/
    - `01_setup_and_load.sql` – database setup and data loading
    - `02_sales_analysis.sql` – core analytical queries
    - `03_customer_report.sql` – customer reporting view
    - `04_product_report.sql` – product reporting view


- `README.md` – Project explanation

## Author

**Trinh Nguyen**

📧 Contact: ng.trinh3023@gmail.com

📍 GitHub: https://trinhnguyen-venus.github.io/
