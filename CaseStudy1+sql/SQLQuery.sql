-- 1. What is the total amount each customer spent in the restaurant?
select s.customer_id, SUM(m.price) As total_spent
from sales s
join menu m
on s.product_id = m.product_id
Group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT s.customer_id, COUNT(DISTINCT s.order_date) AS days_visited
FROM dbo.sales s
GROUP BY s.customer_id;

-- 3. What was the first item from the menu purchased by each customer?

WITH customer_first_purchase AS(
	SELECT s.customer_id, MIN(s.order_date) AS first_purchase_date
	FROM dbo.sales s
	GROUP BY s.customer_id
)
SELECT cfp.customer_id, cfp.first_purchase_date, m.product_name
FROM customer_first_purchase cfp
INNER JOIN dbo.sales s ON s.customer_id = cfp.customer_id
AND cfp.first_purchase_date = s.order_date
INNER JOIN dbo.menu m on m.product_id = s.product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT TOP 3 m.product_name, COUNT(s.product_id) AS total_purchased
FROM sales s
INNER JOIN menu m on s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchased DESC;

-- 5. Which item was the most popular for each customer?
WITH customer_popularity AS (
    SELECT s.customer_id, m.product_name, COUNT(*) AS purchase_count,
        DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rank
    FROM sales s
    INNER JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
)
SELECT customer_id, product_name, purchase_count
FROM customer_popularity
WHERE rank = 1;

--6. Recreate the table output using the available data

SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE WHEN s.order_date >= mb.join_date THEN 'Y'
ELSE 'N' END AS member
FROM sales s
JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members mb ON s.customer_id = mb.customer_id
ORDER BY s.customer_id, s.order_date;
