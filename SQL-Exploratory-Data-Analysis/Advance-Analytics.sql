--Advanced Analytics 

--Changes over Time Analysis

--Analyze how a measure evolves over time. Helps track trends and identify seasonality in your data 

--Analyze sales performance over time
SELECT 
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_Month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS Total_customer,
SUM(quantity) AS Total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date) 
ORDER BY YEAR(order_date),MONTH(order_date)

--or

SELECT 
DATETRUNC(MONTH, order_date) as order_date,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS Total_customer,
SUM(quantity) AS Total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)

--Cumulative Analysis
--Cumulative Analysis means Aggregate the data progressively over time. 
--Helps to understand whether our business is growing or declining

--calculate the total sales per month and the running total of sales over time.

SELECT
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
DATETRUNC(MONTH,order_date) AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) t

--running total over month and partitioned by year
SELECT
order_date,
total_sales,
SUM(total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
DATETRUNC(MONTH,order_date) AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) t


--running total over year and partition by year
SELECT
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
AVG(avg_sales) OVER (ORDER BY order_date) AS Running_avg
FROM(
SELECT 
DATETRUNC(YEAR,order_date) AS order_date,
SUM(sales_amount) AS total_sales,
AVG(sales_amount) AS avg_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
) t

--Performance Analysis
--comparing the current value to a target value.
--it helps measure success and compare performance.
-- Formula= current[measure]-Target[measure]

/* Analyze the yearly performance of products by comparing their sales to both the average sales performance
of the product and the previous year's sales*/

WITH yearly_product_sales AS
(
	SELECT
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date),p.product_name
)
SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales -	AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg ,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change,
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) previous_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'NO Change'
END AS privous_changes 
FROM yearly_product_sales
ORDER BY product_name,order_year


--Part to whole

--which categories contribute the most  to overall sales?

WITH category_sales AS(
SELECT
category,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY category
)
SELECT
category,
total_sales,
SUM(total_sales) OVER () AS overall_sales,
CONCAT(ROUND((CAST(total_sales as FLOAT)/SUM(total_sales) OVER ())*100,2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

--Data segmentation
--Group the data based on a specific range
--Helps to understand the correlation between two measures.

/* segment products into cost ranges and count how many products fall into each segement*/
WITH product_segments AS(
SELECT 
product_key,
product_name,
cost,
CASE WHEN cost<100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END AS cost_range
FROM gold.dim_products
) 
SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products

--Group customers into three segments based on their spending behavior:
--VIP: at least 12 months of history but spending more than 5000.
--Regular : at least 12 months of history but spending 5000 or less.
--NEW : lifespan less than 12 months.
WITH customer_spending AS(
SELECT 
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_spending,
MIN(f.order_date) AS first_order,
MAX(f.order_date) AS last_order,
DATEDIFF(MONTH, MIN(f.order_date),MAX(f.order_date)) AS life_span
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
)

SELECT
customer_segement,
COUNT(customer_key) AS total_customers
FROM(
SELECT
customer_key,
life_span,
CASE WHEN total_spending>5000 AND life_span >= 12 THEN 'VIP'
	 WHEN total_spending<=5000 AND life_span >= 12 THEN 'Regular'
	 ELSE 'NEW'
END AS customer_segement
FROM customer_spending
) t
GROUP BY customer_segement
ORDER BY total_customers DESC

--Reporting

