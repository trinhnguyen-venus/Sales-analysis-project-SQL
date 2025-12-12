/*
============================================================================================================
                                            PRODUCT REPORT
============================================================================================================
 This report consolidates key product metrics and behaviors.
 Hightlights: 
	1. Gathers essential fields such as product names, category, subcategory, and cost.
	2. Segments product by revenue to identify High-performers, Mid-range or Low-performers.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customer(unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order revenue
		- average monthly revenue
============================================================================================================
*/

CREATE VIEW gold.report_products AS

/*----------------------------------------------------------------------------------------------------------
1. Base query: Retrives core columns from tables
----------------------------------------------------------------------------------------------------------*/
WITH base_product_query AS(
SELECT p.product_key,
	product_name,
	product_number,
	category, 
	subcategory,
	product_line,
	order_date,
	order_number,
	quantity,
	cost,
	price,
	sales_amount,
	customer_key
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p ON P.product_key = f.product_key
WHERE order_date IS NOT NULL),

product_aggregation AS (
/*----------------------------------------------------------------------------------------------------------
2. Product Aggregations: Summarizes key metrics at the product level
----------------------------------------------------------------------------------------------------------*/
SELECT product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_order_date,
	COUNT(DISTINCT order_number) AS total_order,
	COUNT(DISTINCT customer_key) AS total_customer,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),2) AS avg_selling_price
FROM base_product_query
GROUP BY 
	product_key,
	product_name,
	category,
	subcategory,
	cost
)

/*----------------------------------------------------------------------------------------------------------
3. Combine all product results into one output
----------------------------------------------------------------------------------------------------------*/

SELECT product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,
	CASE WHEN total_sales > 50000 THEN 'High-performer'
		WHEN total_sales >= 10000 THEN 'Mid-range'
		ELSE 'Low-performer'
	END AS product_segment,
	lifespan,
	total_sales,
	total_order,
	total_quantity,
	total_customer,
	-- Average order revenue --
	CASE WHEN total_order = 0 THEN 0
		ELSE total_sales / total_order
	END AS avg_order_revenue,
	-- Average monthly revenue
	CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregation