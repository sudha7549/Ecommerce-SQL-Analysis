-----TABLE CREATION------


create table customers(
    customer_id VARCHAR(100),
customer_unique_id VARCHAR(100),
customer_zip_code_prefix VARCHAR(100),
customer_city VARCHAR(100),
customer_state VARCHAR(100)

);

SELECT * FROM CUSTOMERS;


SET DATESTYLE = 'ISO,DMY';


CREATE TABLE GEOLOCATION(
  geolocation_zip_code_prefix VARCHAR(100),
geolocation_lat  VARCHAR(100),
geolocation_lng  VARCHAR(100),
geolocation_city  VARCHAR(100),
geolocation_state  VARCHAR(100)

);


SELECT * FROM GEOLOCATION;

CREATE TABLE ORDER_ITEMS(
   order_id VARCHAR(50) NOT NULL,
order_item_id VARCHAR(50),
product_id VARCHAR(50),
seller_id VARCHAR(50),
shipping_limit_date VARCHAR(50),
price NUMERIC,
freight_value VARCHAR(100)

);

SELECT * FROM ORDER_ITEMS;




CREATE TABLE ORDERS(
   order_id VARCHAR(100),
customer_id VARCHAR(100),
order_status VARCHAR(100),
order_purchase_timestamp DATE,
order_approved_date  DATE,
order_delivered_carrier_date DATE,
order_delivered_customer_date DATE,
order_estimated_delivery_date DATE

);
 
SET DATESTYLE = 'ISO,DMY';


SELECT * FROM ORDERS;




CREATE TABLE PAYMENTS(
    order_id	VARCHAR(100),
payment_sequential	NUMERIC,
payment_type	VARCHAR(50),
payment_installments NUMERIC,
payment_value NUMERIC(10,2)

);


DROP TABLE PAYMENTS;

 SELECT * FROM PAYMENTS;



 CREATE TABLE PRODUCTS(
    product_id	VARCHAR(100),
product_category VARCHAR(200),
product_name_length	VARCHAR(100),
product_description_length	VARCHAR(100),
product_photos_qty	VARCHAR(100),
product_weight_g	VARCHAR(100),
product_length_cm	VARCHAR(100),
product_height_cm	VARCHAR(100),
product_width_cm	VARCHAR(100)

 );



  SELECT * FROM PRODUCTS;



  CREATE TABLE SELLERS(
       seller_id	VARCHAR(50),
    seller_zip_code_prefix	VARCHAR(50),
     seller_city	VARCHAR(50),
      seller_state	VARCHAR(50)

  );


  SELECT * FROM SELLERS;


--🔸Question: Which credit card payments are above 1000 and made in exactly 2 installments?

SELECT * FROM PAYMENTS 
WHERE PAYMENT_TYPE = 'credit_card'
AND payment_value >1000 AND payment_installments = 2;

--🔸Question: Which customers are from the states MG or SP?


SELECT * FROM CUSTOMERS 
WHERE CUSTOMER_STATE = 'MG' OR CUSTOMER_STATE = 'SP';

--🔸Question: Which customers are not from MG or SP?


SELECT * FROM CUSTOMERS 
WHERE NOT(CUSTOMER_STATE = 'MG' OR CUSTOMER_STATE = 'SP');

--🔸Question: Which payments have values in the range 150 to 200 (inclusive)?


SELECT * FROM PAYMENTS WHERE PAYMENT_VALUE BETWEEN 150 AND 200;

-- 🔸Question: Which customers are from any of the states SC, PR, SP, or MG ?

SELECT * FROM CUSTOMERS WHERE CUSTOMER_STATE IN ('SC', 'PR', 'SP', 'MG');


-- 🔸Question: Which customers are from states other than SC, PR, SP, or MG?


SELECT * FROM CUSTOMERS WHERE CUSTOMER_STATE NOT IN ('SC', 'PR', 'SP', 'MG');


--🔸Question: Which customers live in cities that start with the letter 'r'?


SELECT * FROM CUSTOMERS WHERE CUSTOMER_CITY LIKE 'r%';

-- 🔸Question: Which customers live in cities that end with the letter 'r'?


SELECT * FROM CUSTOMERS WHERE CUSTOMER_CITY LIKE '%r';

-- 🔸Question: Which customers live in cities that have 'de' in their names?

SELECT * FROM CUSTOMERS WHERE CUSTOMER_CITY LIKE '%de%';

--🔸Question: How can I sort payments first by value (ascending), and for same value, by type (descending)?

 
SELECT * FROM PAYMENTS ORDER BY PAYMENT_VALUE, PAYMENT_TYPE DESC;

--🔸Question: Which one-installment payments exist, and how do they rank by value?


SELECT * FROM PAYMENTS WHERE PAYMENT_INSTALLMENTS = 1
  ORDER BY PAYMENT_VALUE;

--🔸Question: What are the first 4 entries in the payments table?

SELECT * FROM PAYMENTS LIMIT 4;

--🔸Question: How can I fetch 3 payment records starting from the 3rd row (skip first 2)?

SELECT * FROM payments
OFFSET 2 LIMIT 3;


----------AGGREGATE FUNCTIONS-------

--🔸Question: What is the total revenue from all payments, rounded to two decimal places?


SELECT ROUND(SUM(payment_value),2) as total_revenue
FROM payments;

--🔸Question: What is the highest payment value in the dataset?

SELECT MAX(payment_value) FROM payments;

--🔸Question: What is the lowest payment value in the dataset?

SELECT MIN(payment_value) FROM payments;

--🔸Question: What is the average payment value, rounded to two decimal places?

SELECT ROUND(AVG(payment_value),2) FROM payments;

--🔸Question: How many customer records are there in total?

SELECT COUNT(customer_id) FROM customers;

--🔸Question: How many unique cities do the customers come from?

SELECT COUNT(DISTINCT customer_city) FROM customers;

-- 🔸Question: What is the character length of each seller city name (excluding trailing spaces)?

SELECT seller_city, LENGTH(TRIM(seller_city)) FROM sellers;

--🔸Question: What do the seller city names look like in uppercase and lowercase formats?

SELECT UPPER(seller_city), LOWER(seller_city) FROM sellers;

--🔸Question: What is the result of replacing the letter 'a' with 'i' in each seller city name?

SELECT seller_city, REPLACE(seller_city, 'a','i') FROM sellers;

--🔸Question: How do the seller city and state appear when combined as one string like "City -State"?

SELECT *, CONCAT(seller_city, ' -' , seller_state) as city_state FROM sellers;

--🔸Question: For each order, what are the day, numeric month, and full month name of the delivery date?

SELECT 
  order_delivered_customer_date,
  EXTRACT(DAY FROM order_delivered_customer_date::DATE) AS delivery_day,
  EXTRACT(MONTH FROM order_delivered_customer_date::DATE) AS delivery_month,
  TRIM(TO_CHAR(order_delivered_customer_date::DATE, 'Month')) AS delivery_month_name
FROM orders;

--🔹 Question: How many days early or late were the orders delivered compared to the estimated delivery date?

SELECT 
  order_estimated_delivery_date - order_delivered_customer_date AS delivery_gap_days
FROM orders;

--🔹 Question: What is the ceiling (rounded up value) of each payment?

SELECT payment_value, ceil(payment_value) from payments;

--🔹 Question: What are the floor and ceiling values of each payment?

SELECT payment_value, ceil(payment_value),
 floor(payment_value) from payments;

 
--🔹 Question: Which orders have not been delivered yet (missing delivery date)?

SELECT * FROM ORDERS
WHERE ORDER_DELIVERED_CUSTOMER_DATE IS  NULL;

--🔹 Question: How many orders fall under each order status?

SELECT order_status, COUNT(order_status) as order_count
FROM orders
GROUP BY order_status ORDER BY order_count desc;

--🔹 Question: What is the count of each type of payment method used?

SELECT payment_type, COUNT(payment_type) AS payment_type_count 
FROM payments
GROUP BY payment_type ORDER BY payment_type_count desc;

--🔹 Question: What is the average payment value for each payment method?

SELECT payment_type, ROUND(AVG(payment_value),2)  as payment_avg
FROM payments
GROUP BY payment_type ORDER BY payment_avg DESC;

--🔹 Question: What is the maximum payment value recorded for each payment type?

SELECT payment_type, ROUND(MAX(payment_value),2)  as payment_max
FROM payments
GROUP BY payment_type ORDER BY payment_max DESC;

--🔹 Question: Which payment types have an average value of at least 100?

SELECT payment_type, ROUND(AVG(payment_value),2)  as payment_avg
FROM payments
GROUP BY payment_type 
HAVING AVG(payment_value) >= 100;

--🔹 Question: Which customers had orders that were canceled?

SELECT customers.customer_id, orders.order_status
FROM customers
JOIN orders
ON customers.customer_id=orders.customer_id
WHERE order_status = 'canceled';

--🔹 Question: What is the total revenue generated each year?

SELECT 
  EXTRACT(YEAR FROM orders.order_purchase_timestamp)::INT AS years,
  SUM(payments.payment_value)
FROM orders 
JOIN payments ON orders.order_id = payments.order_id
GROUP BY years;

--🔹Question: Which orders share the same payment type? (Note: this creates a Cartesian product for matching payment types.)

SELECT T1.order_id, t2.order_id
FROM payments AS t1, payments AS t2
WHERE t1.payment_type = t2.payment_type;

--🔹 Question: What are the top 5 product categories by total sales?

SELECT category FROM
(SELECT (products.product_category) AS category,
SUM(payments.payment_value) AS  sales
FROM products JOIN order_items
ON products.product_id = order_items.product_id
JOIN payments
ON payments.order_id = order_items.order_id
GROUP BY CATEGORY ORDER BY sales DESC LIMIT 5);
 

--🔹 Question: What is the total sales per category,
--and how can we classify them into 'LOW', 'MEDIUM', or 'HIGH'?


WITH A AS (
  SELECT 
    products.product_category AS category,
    SUM(payments.payment_value) AS sales
  FROM products 
  JOIN order_items ON products.product_id = order_items.product_id
  JOIN payments ON payments.order_id = order_items.order_id
  GROUP BY products.product_category
)
SELECT *,
  CASE
    WHEN sales <= 5000 THEN 'LOW'
    WHEN sales >= 100000 THEN 'HIGH'
    ELSE 'MEDIUM'
  END AS sale_type
FROM A
ORDER BY sales DESC;

--🔹 Question: What is the running total of daily sales over time?

SELECT order_date,sales,
SUM(sales) over(order by order_date) FROM
(SELECT orders.order_purchase_timestamp as order_date,
SUM(payments.payment_value) as sales
FROM orders JOIN payments
ON orders.order_id = payments.order_id
GROUP BY order_date) AS A;

--🔹 Question: What are the top 3 product categories by total sales using ranking?

WITH A AS
(SELECT (products.product_category) AS category,
SUM(payments.payment_value) AS  sales
FROM products JOIN order_items
ON products.product_id = order_items.product_id
JOIN payments
ON payments.order_id = order_items.order_id
GROUP BY CATEGORY),

B AS (SELECT category, sales, rank() over(order by sales DESC) AS RK
FROM A)

SELECT CATEGORY,SALES FROM B WHERE RK <=3;

--🔹 Question: Can we create a reusable view to show total sales per product category?

CREATE VIEW prod_cate_sales as 
SELECT (products.product_category) AS category,
SUM(payments.payment_value) AS  sales
FROM products JOIN order_items
ON products.product_id = order_items.product_id
JOIN payments
ON payments.order_id = order_items.order_id
GROUP BY CATEGORY;

SELECT * FROM prod_cate_sales;

