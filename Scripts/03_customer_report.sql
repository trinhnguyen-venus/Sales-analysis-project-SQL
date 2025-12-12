/*
============================================================================================================
                                            CUSTOMER REPORT
============================================================================================================
 This report consolidates key customer metrics and behaviors.
 Hightlights: 
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age group.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order values
		- average month spend
============================================================================================================
*/

CREATE VIEW gold.report_customers AS

/*----------------------------------------------------------------------------------------------------------
1. Base query: Retrives core columns from tables
----------------------------------------------------------------------------------------------------------*/
WITH base_query AS(
SELECT order_number,
	order_date,
	product_key,
	sales_amount,
	c.customer_key,
	quantity,
	customer_number,
	CONCAT(first_name, ' ', last_name) AS customer_name,
	DATEDIFF(YEAR, birthdate, GETDATE()) AS age
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL),

customer_aggregation AS(
/*----------------------------------------------------------------------------------------------------------
2. Customer Aggregations: Summarizes key metrics at customer level
----------------------------------------------------------------------------------------------------------*/
SELECT customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age)

SELECT customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50+'
	END AS age_group,
	CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_products,
	total_quantity,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,
	lifespan,
	-- Average order value --
	CASE WHEN total_sales = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,
	-- Average month spend --
	CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_spend
FROM customer_aggregation