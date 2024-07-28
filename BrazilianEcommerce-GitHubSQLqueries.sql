USE [olist_brazilian_ecommerce]

--DATASETS
--[dbo].[olist_customers_dataset]
--[dbo].[olist_order_items_dataset]
--[dbo].[olist_orders_dataset]
--[dbo].[olist_order_payments_dataset]
--[dbo].[olist_products_dataset]
--[dbo].[olist_sellers_dataset]
--[dbo].[product_category_name_translation]

--CHECKING DATASETS
--1.CUSTOMER DATASET
SELECT	* 
FROM	[dbo].[olist_customers_dataset] --99,441 rows
SELECT	COUNT(customer_id) 
FROM	[dbo].[olist_customers_dataset] --99,441 rows
SELECT	COUNT(customer_unique_id) 
FROM	[dbo].[olist_customers_dataset] --99,441 rows
SELECT	COUNT(DISTINCT customer_id) 
FROM	[dbo].[olist_customers_dataset] --99,441 rows
SELECT	COUNT(DISTINCT customer_unique_id) 
FROM	[dbo].[olist_customers_dataset] --96,096 rows
SELECT	COUNT(DISTINCT customer_city) 
FROM	[dbo].[olist_customers_dataset] --4,119 rows
SELECT	COUNT(DISTINCT customer_state) 
FROM	[dbo].[olist_customers_dataset] --27 rows
SELECT	COUNT(DISTINCT customer_zip_code_prefix) 
FROM	[dbo].[olist_customers_dataset] --14,994 rows
GO

--the dataset explains that there are customers who made repurchases. so there will be duplicate unique ids.
--i should check for customer id which is different for every purchase made by the customer.
--when i check with customer id not customer unique id, there are no duplicates.
WITH duplicates AS
	(SELECT *,
			ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY (SELECT NULL)) AS number
		FROM
			olist_customers_dataset)
SELECT * 
FROM	duplicates WHERE number > 1;

--checking for null values in the columns
SELECT	* 
FROM	[dbo].[olist_customers_dataset] 
WHERE	customer_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_customers_dataset] 
WHERE		customer_unique_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_customers_dataset] 
WHERE	customer_city IS NULL --0 nulls
SELECT	*
FROM	[dbo].[olist_customers_dataset]
WHERE	customer_state IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_customers_dataset] 
WHERE	customer_zip_code_prefix IS NULL --0 nulls

--2.SELLERS DATASET
SELECT * 
FROM	[dbo].[olist_sellers_dataset] --3,095 rows
SELECT	COUNT(seller_id) 
FROM	[dbo].[olist_sellers_dataset] --3,095 rows
SELECT	COUNT(DISTINCT seller_id) 
FROM	[dbo].[olist_sellers_dataset] --3,095 rows
SELECT	COUNT(DISTINCT seller_city) 
FROM	[dbo].[olist_sellers_dataset] --608 rows
SELECT	COUNT(DISTINCT seller_state) 
FROM	[dbo].[olist_sellers_dataset] --23 rows
SELECT	COUNT(DISTINCT seller_zip_code_prefix) 
FROM	[dbo].[olist_sellers_dataset] --2,246 rows
GO

--check for duplicates. no duplicates
WITH duplicates AS
	(SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY seller_id ORDER BY (SELECT NULL)) AS number
		FROM 
			olist_sellers_dataset)
SELECT * 
FROM	duplicates WHERE number > 1;

--checking for null values in the columns
SELECT	* 
FROM	[dbo].[olist_sellers_dataset] 
WHERE	seller_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_sellers_dataset] 
WHERE	seller_city IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_sellers_dataset] 
WHERE	seller_state IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_sellers_dataset] 
WHERE	seller_zip_code_prefix IS NULL --0 nulls

--3.ORDER ITEMS DATASET
SELECT	* 
FROM	[dbo].[olist_order_items_dataset] --112,650 rows
SELECT	COUNT(order_item_id) 
FROM	[dbo].[olist_order_items_dataset] --112,650
SELECT	COUNT(order_id) 
FROM	[dbo].[olist_order_items_dataset] --112,650
SELECT	COUNT(DISTINCT order_item_id) 
FROM	[dbo].[olist_order_items_dataset] --21
SELECT	COUNT(DISTINCT order_id) 
FROM	[dbo].[olist_order_items_dataset] --98,666
SELECT	COUNT(DISTINCT seller_id) 
FROM	[dbo].[olist_order_items_dataset] --3,095
SELECT	COUNT(DISTINCT shipping_limit_date) 
FROM	[dbo].[olist_order_items_dataset] --54,615
SELECT	COUNT(DISTINCT price) 
FROM	[dbo].[olist_order_items_dataset] --5,968
SELECT	COUNT(DISTINCT freight_value) 
FROM	[dbo].[olist_order_items_dataset] --6,999
SELECT	COUNT(DISTINCT product_id) 
FROM	[dbo].[olist_order_items_dataset] --32,951
GO

--checking for duplicates. 10,225 rows. 
--these are same orders, same products, same sellers, more than once
WITH duplicates AS
	(SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY order_id, seller_id, product_id ORDER BY (SELECT NULL)) AS number
		FROM
			olist_order_items_dataset)
SELECT	* 
FROM	duplicates WHERE number > 1;

--checking for null values
SELECT	* 
FROM	[dbo].[olist_order_items_dataset] 
WHERE	order_item_id IS NULL --0 nulls
SELECT	* 
FROM [dbo].[olist_order_items_dataset] 
WHERE	order_id IS NULL --0 nulls
SELECT	 *
FROM	[dbo].[olist_order_items_dataset] 
WHERE	product_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_items_dataset] 
WHERE	seller_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_items_dataset] 
WHERE	shipping_limit_date IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_items_dataset]
WHERE	price IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_items_dataset] 
WHERE	freight_value IS NULL --0 nulls

--4.ORDERS DATASET
SELECT	* 
FROM	[dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(order_id) 
FROM [dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(DISTINCT order_id) 
FROM	[dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(customer_id) 
FROM	[dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(DISTINCT customer_id) 
FROM	[dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(order_status) 
FROM	[dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(DISTINCT order_status) 
FROM	[dbo].[olist_orders_dataset] --8
SELECT	COUNT(order_purchase_timestamp) 
FROM	[dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(DISTINCT order_purchase_timestamp) 
FROM	[dbo].[olist_orders_dataset] --88,789
SELECT	COUNT(order_approved_at) 
FROM	[dbo].[olist_orders_dataset] --99,281
SELECT	COUNT(DISTINCT order_approved_at) 
FROM	[dbo].[olist_orders_dataset] --50,462
SELECT	COUNT(order_estimated_delivery_date) 
FROM	[dbo].[olist_orders_dataset] --99,441
SELECT	COUNT(DISTINCT order_estimated_delivery_date) 
FROM	[dbo].[olist_orders_dataset] --459
SELECT	COUNT(order_delivered_carrier_date) 
FROM	[dbo].[olist_orders_dataset] --97,658
SELECT	COUNT(DISTINCT order_delivered_carrier_date) 
FROM	[dbo].[olist_orders_dataset] --61,544
SELECT	COUNT(order_delivered_customer_date) 
FROM	[dbo].[olist_orders_dataset] --96,476
SELECT	COUNT(DISTINCT order_delivered_customer_date) 
FROM	[dbo].[olist_orders_dataset] --75,649
GO

--checking for duplicates
WITH duplicates AS
	(SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY (SELECT NULL)) AS number
		FROM 
			olist_orders_dataset)
SELECT	* 
FROM	duplicates WHERE number > 1;

--checking for nulls in columns
SELECT	* 
FROM	[dbo].[olist_orders_dataset] 
WHERE	order_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_orders_dataset]
WHERE	customer_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_orders_dataset] 
WHERE	order_status IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_orders_dataset] 
WHERE	order_purchase_timestamp IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_orders_dataset] 
WHERE	order_approved_at IS NULL --160 rows
SELECT	* 
FROM	[dbo].[olist_orders_dataset] 
WHERE	order_estimated_delivery_date IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_orders_dataset] 
WHERE	order_delivered_carrier_date IS NULL --1,783 rows
SELECT	* 
FROM	[dbo].[olist_orders_dataset] 
WHERE	order_delivered_customer_date IS NULL --2,965 rows

--5.ORDERS PAYMENTS DATASET
SELECT	* 
FROM	olist_order_payments_dataset --103,886 rows
SELECT	COUNT(order_id) 
FROM	[dbo].[olist_order_payments_dataset] --103,886
SELECT	COUNT(DISTINCT order_id) 
FROM	[dbo].[olist_order_payments_dataset] --99,440
SELECT	COUNT(payment_sequential) 
FROM	[dbo].[olist_order_payments_dataset] --103,886
SELECT	COUNT(DISTINCT payment_sequential) 
FROM	[dbo].[olist_order_payments_dataset] --29
SELECT	COUNT(payment_type) 
FROM	[dbo].[olist_order_payments_dataset] --103,886
SELECT	COUNT(DISTINCT payment_type) 
FROM	[dbo].[olist_order_payments_dataset] --5
SELECT	COUNT(payment_installments) 
FROM	[dbo].[olist_order_payments_dataset] --103,886
SELECT	COUNT(DISTINCT payment_installments) 
FROM	[dbo].[olist_order_payments_dataset] --24
SELECT	COUNT(payment_value) 
FROM	[dbo].[olist_order_payments_dataset] --103,886
SELECT	COUNT(DISTINCT payment_value) 
FROM	[dbo].[olist_order_payments_dataset] --29
GO

--checking for duplicates. 4,446 rows. 
--it is possible to have more than one order id bcoz many orders were placed
--there could be more than one item in one order. need a query for this.
--i do not know what this query means because the payment sequential it shows different payment methods if more than one
--the row number more than one does not reflect more than one payment installment
--yet there are duplicate order ids with different payment values.
WITH duplicates AS
	(SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY (SELECT NULL)) AS number
		FROM 
			olist_order_payments_dataset)
SELECT	* 
FROM	duplicates WHERE number > 1;

--checking for nulls
SELECT	* 
FROM	[dbo].[olist_order_payments_dataset] 
WHERE	order_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_payments_dataset] 
WHERE	payment_sequential IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_payments_dataset] 
WHERE	payment_installments IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_payments_dataset] 
WHERE	payment_type IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_order_payments_dataset] 
WHERE	payment_value IS NULL --0 nulls

--6.ORDER PRODUCTS DATASET
SELECT	* 
FROM	[dbo].[olist_products_dataset] --32,951 rows
SELECT	COUNT(product_id) 
FROM	[dbo].[olist_products_dataset] --32,951
SELECT	COUNT(DISTINCT product_id) 
FROM	[dbo].[olist_products_dataset] --32,951
SELECT	COUNT(product_category_name) 
FROM	[dbo].[olist_products_dataset] --32,951
SELECT	COUNT(DISTINCT product_category_name) 
FROM	[dbo].[olist_products_dataset] --74
SELECT	COUNT(product_description_length) 
FROM	[dbo].[olist_products_dataset] --32,341
SELECT	COUNT(DISTINCT product_description_length) 
FROM	[dbo].[olist_products_dataset] --2,960
SELECT	COUNT(product_height_cm) 
FROM	[dbo].[olist_products_dataset] --32,949
SELECT	COUNT(DISTINCT product_height_cm) 
FROM	[dbo].[olist_products_dataset] --102
SELECT	COUNT(product_length_cm) 
FROM	[dbo].[olist_products_dataset] --32,949
SELECT	COUNT(DISTINCT product_length_cm) 
FROM	[dbo].[olist_products_dataset] --99
SELECT	COUNT(product_width_cm) 
FROM	[dbo].[olist_products_dataset] --32,949
SELECT	COUNT(DISTINCT product_width_cm) 
FROM	[dbo].[olist_products_dataset] --95
SELECT	COUNT(product_name_length) 
FROM	[dbo].[olist_products_dataset] --32,341
SELECT	COUNT(DISTINCT product_name_length) 
FROM	[dbo].[olist_products_dataset] --66
SELECT	COUNT(product_photos_qty) 
FROM	[dbo].[olist_products_dataset] --32,341
SELECT	COUNT(DISTINCT product_photos_qty) 
FROM	[dbo].[olist_products_dataset] --19
SELECT	COUNT(product_weight_g) 
FROM	[dbo].[olist_products_dataset] --32,949
SELECT	COUNT(DISTINCT product_weight_g) 
FROM	[dbo].[olist_products_dataset] --2,204
GO

--checking for duplicates. none
WITH duplicates AS
	(SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY (SELECT NULL)) AS number
		FROM 
			olist_products_dataset)
SELECT	* 
FROM	duplicates WHERE number > 1;

--checking for nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_id IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_category_name IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_description_length IS NULL --610 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_length_cm IS NULL --2 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_height_cm IS NULL --2 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_width_cm IS NULL --2 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_weight_g IS NULL --2 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_name_length IS NULL --610 nulls
SELECT	* 
FROM	[dbo].[olist_products_dataset] 
WHERE	product_photos_qty IS NULL --610 nulls

--7.PRODUCT CATEGORY NAME TRANSLATION DATASET
SELECT	* 
FROM	[dbo].[product_category_name_translation] --71 rows
SELECT	COUNT(product_category_name) 
FROM	[dbo].[product_category_name_translation] --71
SELECT	COUNT(DISTINCT product_category_name) 
FROM	[dbo].[product_category_name_translation] --71
SELECT	COUNT(product_category_name_english) 
FROM	[dbo].[product_category_name_translation] --71
SELECT	COUNT(DISTINCT product_category_name_english) 
FROM	[dbo].[product_category_name_translation] --71
GO
--checking for duplicates. none
WITH duplicates AS
	(SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY product_category_name ORDER BY (SELECT NULL)) AS number
		FROM
			product_category_name_translation)
SELECT	* 
FROM	duplicates WHERE number > 1;

--checking for nulls
SELECT	* 
FROM	[dbo].[product_category_name_translation] 
WHERE	product_category_name IS NULL --0 nulls
SELECT	* 
FROM	[dbo].[product_category_name_translation] 
WHERE	product_category_name_english IS NULL --0 nulls

--ADDING COLUMNS
--adding 3 columns. order value, total freight value, and total order value i.e total order items + total freight
ALTER TABLE 
	[dbo].[olist_order_items_dataset]
ADD 
	total_order_items float,
	total_freight float,
	total_order_value float;

SELECT TOP 10 * FROM [dbo].[olist_order_items_dataset]; --to check if columns are added

--removing the column and adding the correct name to column
ALTER TABLE 
	[dbo].[olist_order_items_dataset]
DROP COLUMN 
	total_order_items; 
ALTER TABLE 
	[dbo].[olist_order_items_dataset]
ADD 
	order_value float;

--adding values to the 3 columns
UPDATE 
	[dbo].[olist_order_items_dataset]
SET		
	order_value = order_item_id * price,
	total_freight = order_item_id * freight_value;
UPDATE 
	[dbo].[olist_order_items_dataset]
SET	
	total_order_value = total_freight + order_value;

SELECT TOP 10 * FROM [dbo].[olist_order_items_dataset] ; --to check if columns

--ANALYSIS
--CUSTOMER ANALYSIS
--1. top customers in terms of
--i) sales
--ii) quantities of items
--iii) number of purchases
--iv) frequency of purchase
--v) recency of purchase
--vi) rank customers in terms of total payments made
--vii) percentage of customers who had repurchases
--viii) customers who bought more than one distinct product

--2.sales
--i) top 3 customers with highest order sales
--ii) top 3 customers with lowest order sales
--iii) maximum and minimum spent by each customer
--iv) customers with repurchases  
--v) average purchase per customer

--3. location of customers
--i) city/state with most and least customer count
--ii) city/state with top customers in terms of number of orders, order value, and quantity of orders
--iii) city/state with customers and sellers

--PRODUCTS ANALYSIS
--1.  most popular product in terms of:
--i) quantity
--ii) sales
--iii) location
--iv) finding orders which had more than one product item in one order
--v) number of orders that had more than one item per order

--2.price of products

--3. most popular category

--4. products with complete description and photos with effect to sales
--i) comparing product sales with complete product description and those without product description
--ii) comparing product sales with complete photos and those without complete photos

--5. freight and delivery
--i) most costly product by freight
--ii) delivery
--cancelled orders
--orders where purchase time is not the same as approved time
--orders where approval time is greater than one hour after purchase 
--orders where estimated delivery not the same as delivery to customer
--products that were delivered on time within two days
--where these customers with delivery withing two days are located
--time between order approved, estimated delivery, to delivery to carrier, and delivery to customer
--iv) product category showing number of orders with missing order delivery info
--v) products with number of orders missing delivery info
--vi) time difference between placing order and order delivery

--TIME, DAYS, MONTHS, ANALYSIS
--1. most popular order purchase time, day, month, year
--2. date with the highest order value
--3. most popular delivery date, time, day, month
--4. most popular delivery date, time, day, month, to customer
--5. if estimated delivery date is the same as customer delivery date
--6. count of deliveries where the estimated delivery date is the same as the customer delivery

--PAYMENT ANALYSIS
--1. types of payment methods

--2. most popular methods of payment
--i) by order count
--ii) by total payment value

--3. payment installments
--i) unique number of installments
--ii) most common number of installments
--iii) number of customers showing payment installments
--iv) comparing payment values of customers who made one complete payment and more than one payment installment
--v) if customers who had repurchases had payment installments
--vi) number of product categories with payment installments

--LOCATION
--1. order values by customer city/state
--i) by customer city
--ii) by customer state
--2. sellers in city/state
--i) number of sellers by city
--ii) number of sellers by state
--iii) cities with one seller
--3. customers in city/state
--i) number of customers by city
--ii) number of customers by state
--iii) cities with one customer

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CUSTOMER ANALYSIS
--1. top customers in terms of
--i) sales
--to find if total order value is the same as the total payment value. it is not! 95,419 rows
SELECT 
	customers.customer_unique_id, 
	ROUND(SUM(items.total_order_value),0) AS total_order_value, 
	ROUND(SUM(payments.payment_value),0) AS total_payments
FROM 
	olist_customers_dataset AS customers
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	olist_order_items_dataset AS items
ON
	orders.order_id = items.order_id
INNER JOIN 
	olist_order_payments_dataset AS payments
ON 
	items.order_id = payments.order_id
GROUP BY 
	customers.customer_unique_id
ORDER BY
	total_order_value DESC;

--cases where the total order value is not the same as the total payments
--78,010 rows
SELECT 
	customers.customer_unique_id, 
	ROUND(SUM(items.total_order_value),1) AS order_value_total, 
	ROUND(SUM(payments.payment_value),1) AS total_payments
FROM 
	olist_customers_dataset AS customers
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
INNER JOIN 
	olist_order_payments_dataset AS payments
ON 
	items.order_id = payments.order_id
GROUP BY 
	customers.customer_unique_id
HAVING 
	SUM(items.total_order_value) != SUM(payments.payment_value)
ORDER BY 
	order_value_total DESC, total_payments DESC;

--cases where the total payments are greater than the total order value
--49,394 rows
SELECT 
	customers.customer_unique_id, ROUND(SUM(items.total_order_value),1) AS order_value_total, ROUND(SUM(payments.payment_value),1) AS total_payments
FROM
	[dbo].[olist_customers_dataset] AS customers
INNER JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	[dbo].[olist_order_items_dataset] AS items
ON 
	orders.order_id = items.order_id
INNER JOIN 
	[dbo].[olist_order_payments_dataset] AS payments
ON 
	items.order_id = payments.order_id
GROUP BY 
	customers.customer_unique_id
HAVING 
	SUM(items.total_order_value) < SUM(payments.payment_value)
ORDER BY 
	order_value_total DESC, total_payments DESC;

--cases where the total order value is greater than the total payments
--39,394 rows
SELECT 
	customers.customer_id, 
	SUM(items.total_order_value) AS order_value_total, 
	SUM(payments.payment_value) AS total_payments
FROM 
	[dbo].[olist_customers_dataset] AS customers
INNER JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	[dbo].[olist_order_items_dataset] AS items
ON 
	orders.order_id = items.order_id
INNER JOIN 
	[dbo].[olist_order_payments_dataset] AS payments
ON 
	items.order_id = payments.order_id
GROUP BY 
	customers.customer_id
HAVING 
	SUM(items.total_order_value) > SUM(payments.payment_value)
ORDER BY 
	order_value_total DESC, total_payments DESC;

--i will use the payments dataset for sale values because payment installments affect total paid by customers
--interest rates may make the payments higher. 96,095 rows
SELECT 
	customers.customer_unique_id, 
	ROUND(SUM(payments.payment_value),1) AS total_transaction
FROM 
	[dbo].[olist_customers_dataset] AS customers
INNER JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	[dbo].[olist_order_payments_dataset] AS payments
ON 
	orders.order_id = payments.order_id
GROUP BY 
	customers.customer_unique_id
ORDER BY 
	total_transaction DESC;

--ii) quantities of items. 95,420 rows
SELECT 
	customers.customer_unique_id, 
	SUM(items.order_item_id) AS total_order_quantity
FROM 
	[dbo].[olist_customers_dataset] AS customers
INNER JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON	
	customers.customer_id = orders.customer_id
INNER JOIN 
	[dbo].[olist_order_items_dataset] AS items
ON
	orders.order_id = items.order_id
GROUP BY 
	customers.customer_unique_id
ORDER BY 
	total_order_quantity DESC;

--iii) number of purchases
SELECT 
	customer_unique_id, 
	COUNT(customer_id) AS customer_orders
FROM 
	[dbo].[olist_customers_dataset]
GROUP BY 
	customer_unique_id
ORDER BY 
	customer_orders DESC;

--iv) frequency of purchase. number of purchases per month. 98,001 rows.
--with HAVING the number of purchases for customers who had more than one in a month. 1,362 rows
SELECT 
	customers.customer_unique_id, 
	DATENAME(MONTH, orders.order_purchase_timestamp) AS month, 
	COUNT(customers.customer_id) AS purchase_count
FROM	 
	[dbo].[olist_customers_dataset] AS customers
LEFT JOIN	
	[dbo].[olist_orders_dataset] AS orders
ON		
	customers.customer_id = orders.customer_id
GROUP BY	
	customers.customer_unique_id, DATENAME(MONTH, orders.order_purchase_timestamp)
--HAVING 
	--COUNT(customers.customer_id) > 1
ORDER BY	
	month;

--v) recency of purchase
--minimum and maximum dates of the dataset. the description says data is from 2016 to 2018.
--September 4th 2016 and October 17th 2018
SELECT 
	MIN(order_purchase_timestamp) AS earliest_date, 
	MAX(order_purchase_timestamp) AS latest_date
FROM 
	[dbo].[olist_orders_dataset];

--since the data reaches until October 17th 2018, the recency shall be the last two months
--1,878 rows
SELECT 
	customers.customer_unique_id, orders.order_purchase_timestamp, 
	DATEDIFF(DAY, '2018-08-17', MAX(orders.order_purchase_timestamp)) AS days_elapsed
FROM 
	[dbo].[olist_customers_dataset] AS customers
INNER JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
GROUP BY 
	customers.customer_unique_id, orders.order_purchase_timestamp
HAVING 
	MAX(orders.order_purchase_timestamp) >= '2018-08-17' 
ORDER BY 
	days_elapsed;
	
--vi) rank customers in terms of total payments made
SELECT 
	customers.customer_unique_id, 
	ROUND(SUM(payments.payment_value),0) AS total_payments, 
	DENSE_RANK() OVER(ORDER BY SUM(payments.payment_value) DESC) AS ranked_customers
FROM 
	[dbo].[olist_customers_dataset] AS customers
INNER JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	[dbo].[olist_order_payments_dataset] AS payments
ON	
	orders.order_id = payments.order_id
GROUP BY 
	customers.customer_unique_id;


--vii) percentage of customers who had repurchases. 6.6%
SELECT 
	ROUND(CAST(COUNT(multiple_transactions.customer_unique_id) AS float)/ --counts the number of customers with multiple transactions
	COUNT(DISTINCT customers.customer_unique_id) * 100,2) AS customers_with_multiple_transactions_percentage --counts total number of unique customers
FROM 
	olist_customers_dataset AS customers
LEFT JOIN 
	(SELECT 
		customer_unique_id, 
		COUNT(customer_id) AS customer_rep --left join makes sure all customers are shown even those without multiple transactions
	FROM 
		olist_customers_dataset 
	GROUP BY 
		customer_unique_id
	HAVING 
		COUNT(customer_id) > 1) AS multiple_transactions --filters to those with more than one transaction
ON 
	customers.customer_unique_id = multiple_transactions.customer_unique_id;

--viii) customers who bought more than one distinct product. 5,456 rows
SELECT 
	customers.customer_unique_id, 
	COUNT(DISTINCT items.product_id) AS unique_product_count
FROM 
	[dbo].[olist_customers_dataset] AS customers
INNER JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	[dbo].[olist_order_items_dataset] AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	customers.customer_unique_id
HAVING 
	COUNT(DISTINCT items.product_id) > 1
ORDER BY 
	unique_product_count DESC;

--SALES
--i) top 3 customers with highest order sales
WITH customer_transactions AS (
		SELECT
			customers.customer_unique_id, 
			ROUND(SUM(total_order_value),0) AS total_value
		FROM 
			[dbo].[olist_customers_dataset] AS customers
		INNER JOIN 
			[dbo].[olist_orders_dataset] AS orders
		ON 
			customers.customer_id = orders.customer_id
		INNER JOIN	
			[dbo].[olist_order_items_dataset] AS items
		ON 
			orders.order_id = items.order_id
		GROUP BY 
			customers.customer_unique_id)
SELECT 
	TOP 3 *
FROM 
	customer_transactions
ORDER BY 
	total_value DESC;

--ii) top 3 customers with lowest order sales
WITH customer_transactions AS (
		SELECT 
			customers.customer_unique_id, 
			ROUND(SUM(total_order_value),0) AS total_value
		FROM 
			[dbo].[olist_customers_dataset] AS customers
		INNER JOIN 
			[dbo].[olist_orders_dataset] AS orders
		ON 
			customers.customer_id = orders.customer_id
		INNER JOIN 
			[dbo].[olist_order_items_dataset] AS items
		ON 
			orders.order_id = items.order_id
		GROUP BY 
			customers.customer_unique_id)
SELECT TOP 3 *
FROM 
	customer_transactions
ORDER BY 
	total_value ASC;

--iii) maximum and minimum spent by each customer
--these customers have different maximum and minimum order values. 11,600 rows
SELECT 
	customers.customer_unique_id,
	ROUND(MAX(total_order_value),0) AS highest_order_value, 
	ROUND(MIN(total_order_value),0) AS least_order_value
FROM 
	[dbo].[olist_customers_dataset] AS customers
LEFT JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
LEFT JOIN 
	[dbo].[olist_order_items_dataset] AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	customers.customer_unique_id
HAVING 
	ROUND(MAX(total_order_value),0) != ROUND(MIN(total_order_value),0)
ORDER BY
	highest_order_value DESC;

--iv) customers with repurchases. 11,945 rows
SELECT 
	customers.customer_unique_id, 
	COUNT(customers.customer_id) AS order_count 
FROM 
	[dbo].[olist_customers_dataset] AS customers
LEFT JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
LEFT JOIN 
	[dbo].[olist_order_items_dataset] AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	customers.customer_unique_id
HAVING 
	COUNT(customers.customer_id) > 1
ORDER BY 
	order_count DESC;

--v) average purchase per customer. 
--95,420 rows with inner join. 96,096 rows with left join which is all the customers
SELECT 
	customers.customer_unique_id, 
	ROUND(AVG(total_order_value),0) AS average_order_value
FROM 
	[dbo].[olist_customers_dataset] AS customers
LEFT JOIN 
	[dbo].[olist_orders_dataset] AS orders
ON 
	customers.customer_id = orders.customer_id
LEFT JOIN 
	[dbo].[olist_order_items_dataset] AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	customer_unique_id
ORDER BY 
	average_order_value DESC;

--3. location of customers
--i) city/state with most and least customer count
--distinct cities. shows list of cities in the dataset. 4,119 rows
SELECT 
	DISTINCT customer_city
FROM 
	olist_customers_dataset;

--number of distinct cities. 4,119 cities
SELECT 
	COUNT(DISTINCT customer_city) AS city_count
FROM 
	olist_customers_dataset;

--cities with most customers. 4,119 rows
SELECT 
	customer_city, 
	COUNT(customer_unique_id) AS customers_in_cities
FROM 
	olist_customers_dataset
GROUP BY
	customer_city
ORDER BY 
	customers_in_cities DESC;

--distinct states. shows list of states in dataset. 27 rows
SELECT 
	DISTINCT customer_state
FROM 
	olist_customers_dataset;

--number of distinct states. 27 states
SELECT 
	COUNT(DISTINCT customer_state) AS state_count
FROM 
	olist_customers_dataset;

--states with the most customers.27 rows
SELECT 
	customer_state, 
	COUNT(customer_unique_id) AS customers_in_states
FROM 
	olist_customers_dataset
GROUP BY 
	customer_state
ORDER BY 
	customers_in_states DESC;

--ii) city/state with top customers in terms of number of orders, total value of orders, quantity of orders
--city. 4,110 rows with inner join. 4,119 rows with left join. left join shows all the cities.
SELECT 
	customers.customer_city, 
	COUNT(items.order_id) AS order_count, 
	ROUND(SUM(items.order_item_id),0) AS quantity_count,
	ROUND(SUM(items.total_order_value),0) AS total_order_value
FROM 
	olist_customers_dataset AS customers
LEFT JOIN 
	olist_orders_dataset AS orders
ON 
	customers.customer_id = orders.customer_id
LEFT JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	customers.customer_city
ORDER BY 
	total_order_value DESC;

--state. 27 rows with inner join and left join.
SELECT 
	customers.customer_state, 
	COUNT(items.order_id) AS order_count, 
	ROUND(SUM(items.order_item_id),0) AS quantity_count,
	ROUND(SUM(items.total_order_value),0) AS total_order_value
FROM 
	olist_customers_dataset AS customers
LEFT JOIN 
	olist_orders_dataset AS orders
ON 
	customers.customer_id = orders.customer_id
LEFT JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	customers.customer_state
ORDER BY 
	total_order_value DESC;

--iii) city/state with customers and sellers. 
--city. 74 rows
SELECT 
	DISTINCT customers.customer_city 
FROM 
	olist_customers_dataset AS customers
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
INNER JOIN 
	olist_sellers_dataset AS sellers
ON 
	items.seller_id = sellers.seller_id
WHERE 
	customers.customer_city = sellers.seller_city;

--state. 17 rows
SELECT 
	DISTINCT customers.customer_state 
FROM 
	olist_customers_dataset AS customers
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	customers.customer_id = orders.customer_id
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
INNER JOIN 
	olist_sellers_dataset AS sellers
ON 
	items.seller_id = sellers.seller_id
WHERE 
	customers.customer_state = sellers.seller_state;

--PRODUCTS ANALYSIS
--1.  most popular product in terms of:
--i) quantity. 15,793 rows 
SELECT 
	products.product_id, 
	SUM(items.order_item_id) AS product_quantity
FROM 
	olist_products_dataset AS products
LEFT JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
GROUP BY 
	products.product_id
HAVING 
	SUM(items.order_item_id) > 1
ORDER BY 
	product_quantity DESC;

--ii) sales. 32,951 rows
SELECT 
	products.product_id, 
	ROUND(SUM(items.total_order_value),0) AS total_product_value
FROM 
	olist_products_dataset AS products
LEFT JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
GROUP BY 
	products.product_id
ORDER BY 
	total_product_value DESC;

--iii) location
--by sellers city. 34,145 rows
SELECT 
	products.product_id, 
	sellers.seller_city, 
	ROUND(SUM(items.total_order_value),0) AS total_product_value,
	SUM(items.order_item_id) AS total_order_quantity,
	COUNT(products.product_id) AS product_count
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_sellers_dataset AS sellers
ON 
	items.seller_id = sellers.seller_id
GROUP BY 
	products.product_id, sellers.seller_city
ORDER BY 
	total_product_value DESC;

--by customers city. 89,391 rows
SELECT 
	products.product_id, 
	customers.customer_city, 
	ROUND(SUM(items.total_order_value),0) AS total_product_value,
	SUM(items.order_item_id) AS total_order_quantity,
	COUNT(products.product_id) AS product_count
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_orders_dataset AS orders
ON items.order_id = orders.order_id
INNER JOIN	
	olist_customers_dataset AS customers
ON 
	orders.customer_id = customers.customer_id
GROUP BY 
	products.product_id, customers.customer_city
ORDER BY 
	total_product_value DESC;

--by sellers state. 33,577 rows
SELECT 
	products.product_id, 
	sellers.seller_state, 
	ROUND(SUM(items.total_order_value),0) AS total_product_value,
	SUM(items.order_item_id) AS total_order_quantity,
	COUNT(products.product_id) AS product_count
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_sellers_dataset AS sellers
ON 
	items.seller_id = sellers.seller_id
GROUP BY 
	products.product_id, sellers.seller_state
ORDER BY 
	total_product_value DESC;

--by customers state. 61,224 rows
SELECT 
	products.product_id, 
	customers.customer_state, 
	ROUND(SUM(items.total_order_value),0) AS total_product_value,
	SUM(items.order_item_id) AS total_order_quantity,
	COUNT(products.product_id) AS product_count
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_orders_dataset AS orders
ON items.order_id = orders.order_id
INNER JOIN	
	olist_customers_dataset AS customers
ON 
	orders.customer_id = customers.customer_id
GROUP BY 
	products.product_id, customers.customer_state
ORDER BY 
	total_product_value DESC;

--iv) finding orders which had more than one product item in one order. 3,236 rows
SELECT 
	order_id, 
	COUNT(DISTINCT product_id) AS total_products 
FROM 
	olist_order_items_dataset 
GROUP BY 
	order_id
HAVING 
	COUNT(DISTINCT product_id) > 1
ORDER BY 
	total_products DESC;

--v) number of orders that had more than one item per order. 9,803 rows
SELECT 
	order_id, 
	SUM(order_item_id) AS total_items
FROM 
	olist_order_items_dataset
GROUP BY 
	order_id
HAVING 
	SUM(order_item_id) > 1
ORDER BY 
	total_items DESC;

--2. price. 3 columns, 1 row
SELECT 
	ROUND(AVG(price),2) AS average_price, 
	ROUND(MAX(price),2) AS highest_price, 
	ROUND(MIN(price),2) AS lowest_price
FROM 
	olist_order_items_dataset;

--3. most popular category in terms of product count. 71 rows
SELECT 
	category.product_category_name_english, 
	COUNT(products.product_id) AS product_count
FROM 
	olist_products_dataset AS products
INNER JOIN 
	product_category_name_translation AS category
ON 
	products.product_category_name = category.product_category_name
GROUP BY 
	category.product_category_name_english
ORDER BY 
	product_count DESC;

--4. products with complete description and photos with effect to sales
--i) comparing product sales with complete product description and those without product description
SELECT 
	ROUND(SUM(CASE WHEN products.product_height_cm IS NOT NULL AND
		products.product_width_cm IS NOT NULL AND
		products.product_length_cm IS NOT NULL AND
		products.product_weight_g IS NOT NULL THEN items.total_order_value 
		END),0) AS complete_description_sum,
	ROUND(SUM(CASE WHEN products.product_height_cm IS NULL OR
		products.product_width_cm IS NULL OR
		products.product_length_cm IS NULL OR
		products.product_weight_g IS NULL THEN items.total_order_value END),0) AS lacking_description_sum
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id;

--ii) comparing product sales with complete photos and those without complete photos
SELECT 
	ROUND(SUM(CASE WHEN products.product_photos_qty IS NOT NULL THEN items.total_order_value 
		END),0) AS product_photos_sum,
	ROUND(SUM(CASE WHEN products.product_photos_qty IS NULL THEN items.total_order_value
		END),0) AS lacking_photos_sum
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id;

--5. freight and delivery
--i) most costly product by freight
--most costly product by freight. 112,267 rows without distinct. 64,495 rows with distinct.
SELECT 
	DISTINCT product_id, 
	ROUND(freight_value,0) AS freight_value
FROM 
	olist_order_items_dataset
WHERE 
	freight_value > 0
ORDER BY 
	freight_value DESC;

--most costly product by freight by city. 93,478 rows
SELECT 
	DISTINCT customers.customer_city, items.product_id, 
	ROUND(freight_value,0) AS freight_value
FROM 
	olist_order_items_dataset AS items
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	items.order_id = orders.order_id
INNER JOIN 
	olist_customers_dataset AS customers
ON 
	orders.customer_id = customers.customer_id
WHERE 
	freight_value > 0
ORDER BY 
	freight_value DESC;

--ii) delivery
--number of cancelled orders. 542 orders
SELECT 
	products.product_id, 
	orders.order_status
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	items.order_id = orders.order_id
WHERE 
	orders.order_status LIKE '%cancel%';

--orders where that approval time is not the same as purchase time. 97,519 rows
SELECT
	order_id,
	order_purchase_timestamp, 
	order_approved_at, 
	order_status
FROM 
	olist_orders_dataset
WHERE 
	order_status NOT LIKE '%cancel%' AND
		order_approved_at != order_purchase_timestamp;

--where an order is approved greater than one hour after purchase. 35,757 rows
SELECT
	order_id,
	order_purchase_timestamp, 
	order_approved_at, 
	order_status
FROM 
	olist_orders_dataset
WHERE 
	order_status NOT LIKE '%cancel%' AND
		order_approved_at >= DATEADD(HOUR, 1, order_purchase_timestamp);

--orders where estimated delivery not same as delivery to customer 96,470 rows
SELECT 
	order_id, 
	order_purchase_timestamp, 
	order_estimated_delivery_date,
	order_delivered_customer_date,
	order_status
FROM 
	olist_orders_dataset
WHERE 
	order_estimated_delivery_date != order_delivered_customer_date AND
		order_estimated_delivery_date IS NOT NULL AND
		order_delivered_customer_date IS NOT NULL AND
		order_purchase_timestamp IS NOT NULL AND 
		order_status NOT LIKE '%cancel%'
ORDER BY 
	order_estimated_delivery_date;

--products that were delivered on time. within two days. 4,084 rows
WITH delivery AS
	(SELECT 
		products.product_id AS product_id, 
		orders.order_purchase_timestamp AS purchase_time, 
		orders.order_delivered_customer_date AS customer_delivery_time,
		DATEDIFF(DAY, orders.order_purchase_timestamp, orders.order_delivered_customer_date) AS day_diff
	FROM 
		olist_products_dataset AS products
	INNER JOIN 
		olist_order_items_dataset AS items
	ON 
		products.product_id = items.product_id
	INNER JOIN 
		olist_orders_dataset AS orders
	ON 
		items.order_id = orders.order_id)
SELECT 
	product_id, 
	purchase_time, 
	customer_delivery_time, 
	day_diff
FROM 
	delivery
WHERE 
	day_diff <= 2
ORDER BY 
	day_diff;
	
--where these customers with delivery within two days are located. 4,084 rows
WITH delivery AS
	(SELECT 
		products.product_id AS product_id, 
		customer_city AS customer_city, 
		orders.order_purchase_timestamp AS purchase_time, 
		orders.order_delivered_customer_date AS customer_delivery_time,
		orders.order_status AS status,
		DATEDIFF(DAY, orders.order_purchase_timestamp, orders.order_delivered_customer_date) AS day_diff
	FROM 
		olist_products_dataset AS products
	INNER JOIN 
		olist_order_items_dataset AS items
	ON 
		products.product_id = items.product_id
	INNER JOIN 
		olist_orders_dataset AS orders
	ON 
		items.order_id = orders.order_id
	INNER JOIN 
		olist_customers_dataset AS customers
	ON 
		orders.customer_id = customers.customer_id
	WHERE 
		orders.order_status NOT LIKE '%cancel%')
SELECT 
	product_id, 
	customer_city, 
	purchase_time, 
	customer_delivery_time,
	status,
	day_diff
FROM 
	delivery
WHERE 
	day_diff <= 2
ORDER BY 
	day_diff;

--time between order approved, estimated delivery, to delivery to carrier, and delivery to customer
SELECT 
	order_id, 
	order_status, 
	order_purchase_timestamp,
	CASE WHEN order_approved_at IS NOT NULL THEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) END AS approval_time,
	CASE WHEN order_estimated_delivery_date IS NOT NULL THEN DATEDIFF(DAY, order_purchase_timestamp, order_estimated_delivery_date) END AS estimated_time,
	CASE WHEN order_delivered_carrier_date IS NOT NULL THEN DATEDIFF(DAY, order_purchase_timestamp, order_delivered_carrier_date) END AS carrier_time,
	CASE WHEN order_delivered_customer_date IS NOT NULL THEN DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) END AS customer_time
FROM 
	olist_orders_dataset
WHERE 
	order_status NOT LIKE '%cancel%' AND 
		order_purchase_timestamp IS NOT NULL AND
		order_approved_at IS NOT NULL AND
		order_estimated_delivery_date IS NOT NULL AND
		order_delivered_carrier_date IS NOT NULL AND
		order_delivered_customer_date IS NOT NULL;

--iv) product category showing number of orders with missing order delivery info. 62 rows
SELECT 
	category.product_category_name_english, 
	COUNT(orders.order_id) AS order_count
FROM 
	product_category_name_translation AS category
INNER JOIN 
	olist_products_dataset AS products
ON 
	category.product_category_name = products.product_category_name
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	items.order_id = orders.order_id
WHERE 
	orders.order_status NOT LIKE '%cancel%' AND
	orders.order_estimated_delivery_date IS NULL OR
	orders.order_delivered_carrier_date IS NULL OR
	orders.order_delivered_customer_date IS NULL
GROUP BY
	category.product_category_name_english
ORDER BY 
	order_count DESC;

--v) products with missing order delivery info. 1,872 rows
SELECT 
	products.product_id, 
	COUNT(orders.order_id) AS order_count
FROM 
	olist_products_dataset AS products
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	items.order_id = orders.order_id
WHERE 
	orders.order_status NOT LIKE '%cancel%' AND
	orders.order_estimated_delivery_date IS NULL OR
	orders.order_delivered_carrier_date IS NULL OR
	orders.order_delivered_customer_date IS NULL
GROUP BY
	products.product_id
ORDER BY 
	order_count DESC;

--vi) time difference between placing order and order delivery. 96,470 rows
SELECT
	order_id,
	order_purchase_timestamp,
	order_delivered_customer_date,
	DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) AS delivery_days
FROM 
	olist_orders_dataset
WHERE
	order_status NOT LIKE '%cancel%' AND
	order_purchase_timestamp IS NOT NULL AND
	order_delivered_customer_date IS NOT NULL
ORDER BY
	delivery_days;


--TIME, DAYS, MONTHS, ANALYSIS
--1. most popular order purchase time, day, month, year
--i) most popular purchase order time
SELECT 
	COUNT(order_id) AS order_count, 
	DATEPART(HOUR, order_purchase_timestamp) AS purchase_hour
FROM 
	olist_orders_dataset
GROUP BY 
	DATEPART(HOUR, order_purchase_timestamp)
ORDER BY 
	order_count DESC;

--ii) most popular order purchase day
SELECT 
	COUNT(orders.order_id) AS order_count, 
	ROUND(SUM(items.total_order_value),0) AS total_order_value,  
	ROUND(AVG(items.total_order_value),0) AS average_order_value, 
	DATENAME(WEEKDAY, order_purchase_timestamp) AS purchase_day
FROM 
	olist_orders_dataset AS orders
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	DATENAME(WEEKDAY, order_purchase_timestamp)
ORDER BY 
	order_count DESC;

--iii) most popular purchase order month
SELECT 
	COUNT(orders.order_id) AS order_count, 
	ROUND(SUM(items.total_order_value),0) AS total_order_value, 
	ROUND(AVG(items.total_order_value),0) AS average_order_value, 
	DATENAME(MONTH, order_purchase_timestamp) AS purchase_month
FROM 
	olist_orders_dataset AS orders
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	DATENAME(MONTH, order_purchase_timestamp)
ORDER BY 
	total_order_value DESC;

--iv) most popular purchase order year
SELECT 
	COUNT(orders.order_id) AS order_count, 
	ROUND(SUM(items.total_order_value),0) AS total_order_value, 
	ROUND(AVG(items.total_order_value),0) AS average_order_value, 
	DATEPART(YEAR, order_purchase_timestamp) AS purchase_year
FROM 
	olist_orders_dataset AS orders
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	DATEPART(YEAR, order_purchase_timestamp)
ORDER BY 
	order_count DESC;

--2. date with highest order value
SELECT 
	orders.order_purchase_timestamp, 
	ROUND(SUM(total_order_value),0) AS total_order_value
FROM 
	olist_orders_dataset AS orders
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
WHERE 
	items.total_order_value = (SELECT MAX(total_order_value) FROM olist_order_items_dataset)
GROUP BY 
	orders.order_purchase_timestamp;

--3. most popular delivery date, time, day, month to carrier
--i)most popular delivery date. 548 rows with null. 547 rows without null. null has the highest order count
SELECT 
	COUNT(order_id) AS order_count, 
	CAST(order_delivered_carrier_date AS date) AS carrier_date
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_carrier_date IS NOT NULL
GROUP BY 
	CAST(order_delivered_carrier_date AS date)
ORDER BY 
	order_count DESC;

--ii) most popular delivery time. 25 rows with null
SELECT 
	COUNT(order_id) AS order_count, 
	DATEPART(HOUR, order_delivered_carrier_date) AS carrier_hour
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_carrier_date IS NOT NULL
GROUP BY 
	DATEPART(HOUR, order_delivered_carrier_date)
ORDER BY 
	order_count DESC;

--iii) most popular delivery day. 8 rows with null
SELECT 
	COUNT(order_id) AS order_count, 
	DATENAME(WEEKDAY, order_delivered_carrier_date) AS carrier_day
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_carrier_date IS NOT NULL
GROUP BY 
	DATENAME(WEEKDAY, order_delivered_carrier_date) 
ORDER BY 
	order_count DESC;

--iv) most popular delivery month. 13 rows with null
SELECT 
	COUNT(order_id) AS order_count, 
	DATENAME(MONTH, order_delivered_carrier_date) AS carrier_month
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_carrier_date IS NOT NULL
GROUP BY 
	DATENAME(MONTH, order_delivered_carrier_date) 
ORDER BY 
	order_count DESC;

--4. most popular delivery date, time, day, month, to customer
--i) most popular delivery date. 646 rows with null
SELECT 
	COUNT(order_id) AS order_count, 
	CAST(order_delivered_customer_date AS date) AS customer_date
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_customer_date IS NOT NULL
GROUP BY 
	CAST(order_delivered_customer_date AS date)
ORDER BY 
	order_count DESC;

--ii) most popular delivery time. 25 rows with null
SELECT 
	COUNT(order_id) AS order_count, 
	DATEPART(HOUR, order_delivered_customer_date) AS customer_hour
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_customer_date IS NOT NULL
GROUP BY 
	DATEPART(HOUR, order_delivered_customer_date)
ORDER BY 
	order_count DESC;

--iii) most popular delivery day. 8 rows with null
SELECT 
	COUNT(order_id) AS order_count, 
	DATENAME(WEEKDAY, order_delivered_carrier_date) AS carrier_day
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_carrier_date IS NOT NULL
GROUP BY 
	DATENAME(WEEKDAY, order_delivered_carrier_date) 
ORDER BY 
	order_count DESC;

--iv) most popular delivery month. 13 rows with null
SELECT 
	COUNT(order_id) AS order_count, 
	DATENAME(MONTH, order_delivered_carrier_date) AS carrier_month
FROM 
	olist_orders_dataset
--WHERE 
	--order_delivered_carrier_date IS NOT NULL
GROUP BY 
	DATENAME(MONTH, order_delivered_carrier_date) 
ORDER BY 
	order_count DESC;

--5. if estimated delivery date is the same as customer delivery date. 1,292 rows
SELECT 
	CAST(order_estimated_delivery_date AS date) AS estimated_delivery_date, 
	CAST(order_delivered_customer_date AS date) AS customer_delivery_date
FROM 
	olist_orders_dataset
WHERE 
	order_status NOT LIKE '%cancel%' AND
	order_estimated_delivery_date IS NOT NULL AND 
	order_delivered_customer_date IS NOT NULL AND
	CAST(order_estimated_delivery_date AS date) = CAST(order_delivered_customer_date AS date)
ORDER BY 
	order_delivered_customer_date;

--6. count of deliveries where the estimated delivery date is the same as the customer delivery. 285 rows
SELECT 
	COUNT(order_id) AS count_order, 
	CAST(order_estimated_delivery_date AS date) AS estimated_delivery_date, 
	CAST(order_delivered_customer_date AS date) AS delivery_to_customer
FROM 
	olist_orders_dataset
WHERE 
	order_status NOT LIKE '%cancel%' AND
	order_estimated_delivery_date IS NOT NULL AND 
	order_delivered_customer_date IS NOT NULL AND
	CAST(order_estimated_delivery_date AS date) = CAST(order_delivered_customer_date AS date)
GROUP BY 
	CAST(order_estimated_delivery_date AS date), 
	CAST(order_delivered_customer_date AS date)
ORDER BY 
	count_order DESC;

--PAYMENT ANALYSIS
--1. types of payment methods. 5 rows
SELECT 
	DISTINCT payment_type
FROM 
	olist_order_payments_dataset;

--2. most popular methods of payment
--i)by order count. 5 rows
SELECT payment_type, COUNT(order_id) AS order_count
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY order_count DESC;

--ii) by total payment value. 5 rows
SELECT payment_type, ROUND(SUM(payment_value),0) AS total_payments
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_payments DESC;

--3. payment installments
--i) unique number of installments. 1 row. 24 unique payment installments
SELECT 
	COUNT(DISTINCT payment_installments) AS unique_payments_installments
FROM 
	olist_order_payments_dataset;

--ii) order count showing number of installments. 24 rows
SELECT 
	payment_installments, 
	COUNT(order_id) AS order_count 
FROM 
	olist_order_payments_dataset 
GROUP BY 
	payment_installments 
ORDER BY 
	order_count DESC;

--iii) number of customers showing payment installments. 24 rows
SELECT 
	COUNT(DISTINCT customers.customer_unique_id) AS customer_count, 
	payments.payment_installments
FROM 
	olist_order_payments_dataset AS payments
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	payments.order_id = orders.order_id
INNER JOIN 
	olist_customers_dataset AS customers
ON 
	orders.customer_id = customers.customer_id
GROUP BY 
	payments.payment_installments
ORDER BY 
	customer_count DESC;

--iv) comparing sales of those who made one complete payment and those who made more than one payment installment
SELECT 
	ROUND(SUM(CASE WHEN payment_installments = 0 THEN payment_value END),0) AS one_complete_payment_value,
	ROUND(SUM(CASE WHEN payment_installments > 1 THEN payment_value END),0) AS more_than_one_payment_installment_value
FROM 
	olist_order_payments_dataset;

--v) if customers who had repurchases had payment installments. 21 rows
SELECT 
	COUNT(customers.customer_id) AS customer_count, 
	payments.payment_installments
FROM 
	olist_order_payments_dataset AS payments
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	payments.order_id = orders.order_id
INNER JOIN 
	olist_customers_dataset AS customers
ON 
	orders.customer_id = customers.customer_id
WHERE 
	payments.payment_installments >= 1 --these are more than one installment
GROUP BY 
	payments.payment_installments
HAVING 
	COUNT(customers.customer_id) > 1 --these are customers with more than one purchase
ORDER BY 
	customer_count DESC;

--vi) number of product categories and installments
SELECT 
	payments.payment_installments, 
	COUNT(DISTINCT category.product_category_name) AS category_count, 
	ROUND(SUM(items.total_order_value),0) AS total_order_value
FROM 
	product_category_name_translation AS category
INNER JOIN 
	olist_products_dataset AS products
ON 
	category.product_category_name = products.product_category_name
INNER JOIN olist_order_items_dataset AS items
ON 
	products.product_id = items.product_id
INNER JOIN 
	olist_order_payments_dataset AS payments
ON 
	items.order_id = payments.order_id
GROUP BY 
	payments.payment_installments
ORDER BY 
	category_count DESC; 

--LOCATION
--1. order values by customer city/state
--i) order values by customer city. 112,650 rows
SELECT 
	customers.customer_city, 
	orders.order_purchase_timestamp,
	SUM(items.total_order_value) OVER(PARTITION BY customers.customer_city ORDER BY orders.order_purchase_timestamp) AS cumulative_order_value_by_city,
	COUNT(items.total_order_value) OVER(PARTITION BY customers.customer_city ORDER BY orders.order_purchase_timestamp) AS cumulative_order_count_by_city,
	AVG(items.total_order_value) OVER(PARTITION BY customers.customer_city ORDER BY orders.order_purchase_timestamp) AS cumulative_average_order_by_city
FROM 
	olist_order_items_dataset AS items
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	items.order_id = orders.order_id
INNER JOIN 
	olist_customers_dataset AS customers
ON 
	orders.customer_id = customers.customer_id
ORDER BY 
	customers.customer_city;


--ii) order values by customer state. 112,650 rows
SELECT 
	customers.customer_state, 
	orders.order_purchase_timestamp,
	SUM(items.total_order_value) OVER(PARTITION BY customers.customer_state ORDER BY orders.order_purchase_timestamp) AS cumulative_order_value_by_state,
	COUNT(items.total_order_value) OVER(PARTITION BY customers.customer_state ORDER BY orders.order_purchase_timestamp) AS cumulative_order_count_by_state,
	AVG(items.total_order_value) OVER(PARTITION BY customers.customer_state ORDER BY orders.order_purchase_timestamp) AS cumulative_average_order_by_state
FROM olist_order_items_dataset AS items
INNER JOIN olist_orders_dataset AS orders
ON items.order_id = orders.order_id
INNER JOIN olist_customers_dataset AS customers
ON orders.customer_id = customers.customer_id
ORDER BY customers.customer_state;

--2. sellers in city/state
--i) number of sellers by city. 608 rows
SELECT 
	sellers.seller_city, 
	COUNT(sellers.seller_id) AS number_of_sellers
FROM 
	olist_sellers_dataset AS sellers
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	sellers.seller_id = items.seller_id
GROUP BY 
	sellers.seller_city
ORDER BY number_of_sellers DESC;

--ii) number of sellers by state. 23 rows
SELECT 
	sellers.seller_state, 
	COUNT(sellers.seller_id) AS number_of_sellers
FROM 
	olist_sellers_dataset AS sellers
INNER JOIN 
	olist_order_items_dataset AS items
ON 
	sellers.seller_id = items.seller_id
GROUP BY 
	sellers.seller_state
ORDER BY number_of_sellers DESC;

--iii) are there cities that have sellers who have not made any sales?
--these cities have one seller. 68 rows
SELECT 
	sellers.seller_city, 
	COUNT(sellers.seller_id) AS number_of_sellers
FROM 
	olist_sellers_dataset AS sellers
LEFT JOIN 
	olist_order_items_dataset AS items
ON  
	sellers.seller_id = items.seller_id
GROUP BY 
	sellers.seller_city
HAVING 
	COUNT(sellers.seller_id) <= 1
ORDER BY 
	number_of_sellers DESC;


--3. customers in city/state
--i) number of customers in city. 4,119 rows
SELECT 
	customer_city, 
	COUNT(customer_unique_id) AS number_of_customers
FROM 
	olist_customers_dataset AS customers
GROUP BY 
	customer_city
ORDER BY 
	number_of_customers DESC;

--ii) number of customers in state. 27 rows
SELECT 
	customer_state, 
	COUNT(customer_unique_id) AS number_of_customers
FROM 
	olist_customers_dataset AS customers
GROUP BY 
	customer_state
ORDER BY 
	number_of_customers DESC;

--iii) are there cities which have customers who did not make an order?
--these cities have one customer. 1,060 rows
SELECT 
	customer_city, 
	COUNT(customers.customer_unique_id) AS number_of_customers
FROM 
	olist_customers_dataset AS customers
INNER JOIN 
	olist_orders_dataset AS orders
ON 
	customers.customer_id = orders.customer_id
LEFT JOIN 
	olist_order_items_dataset AS items
ON 
	orders.order_id = items.order_id
GROUP BY 
	customer_city
HAVING 
	COUNT(customers.customer_unique_id) <= 1
ORDER BY 
	number_of_customers DESC;

---END---

