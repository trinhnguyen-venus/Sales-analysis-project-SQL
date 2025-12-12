-- Changes overtime analysis
SELECT
	DATETRUNC(MONTH, order_date) AS order_month,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) AS total_customer,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)


-- Total sales per month and the running of sales over time
SELECT order_year,
	total_sales,
	SUM(total_sales) OVER(ORDER BY order_year) AS running_total_sales,
	AVG(avg_price) OVER(ORDER BY order_year) AS moving_avg_price
FROM(
SELECT 
	YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE sales_amount IS NOT NULL
GROUP BY YEAR(order_date)) AS t

-- Analyze the yearly performance of product by comparing their sales to both the average sales performance of product and the previous year's sales
WITH yearly_product_sales AS (
SELECT 
	YEAR(f.order_date) AS year,
	p.product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p ON p.product_key = f.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(f.order_date), p.product_name)
SELECT *,
	AVG(current_sales) OVER(PARTITION BY product_name) AS avg_product_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS difference_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Bellow Avg'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
		ELSE 'Equal Avg'
	END AS avg_change,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY year) AS py_sales,
	current_sales - COALESCE(LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year), 0) AS difference_py,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year) < 0 THEN 'Decrease'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year) > 0 THEN 'Increase'
		ELSE 'No Change'
	END AS py_change
FROM yearly_product_sales

-- Which categories contribute the most overal sales?
WITH category_sales AS
(SELECT category,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p ON p.product_key = f.product_key
GROUP BY category)
SELECT *,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND(CAST(total_sales AS FLOAT) / SUM(total_sales) OVER () *100, 2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC

-- Segment products into cost range and count how mnay products fall into each segment
WITH product_segment AS(
SELECT product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products)
SELECT cost_range,
	COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers into three segments based on their purchased behaviours:
	- VIP: with at least 12 months of history and spending more than $5.000.
	- Regular: with  at least 12 months of history and spending $5.000 or less.
	- New: customers with a lifespan less than 12 months.
	And calculate total number of customers for each group */
WITH customer_segment AS(
SELECT c.customer_key AS customer_key,
	CONCAT(c.first_name, c.last_name) AS customer_name,
	SUM(sales_amount) AS total_spending,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.dim_customers AS c
LEFT JOIN gold.fact_sales AS f ON f.customer_key = C.customer_key
GROUP BY c.customer_key, CONCAT(c.first_name, c.last_name)) 
SELECT 
	COUNT(customer_key) AS number_of_customers,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >=12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM customer_segment
GROUP BY CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >=12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New' END
ORDER BY number_of_customers DESC

