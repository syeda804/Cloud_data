-- Q1: List all brand names
SELECT brand_name
FROM production.brands;
-- Q2: Products from most expensive to cheapest
SELECT product_name, list_price
FROM production.products
ORDER BY list_price DESC;
-- Q3: Customers living in New York
SELECT *
FROM sales.customers
WHERE state = 'NY';
-- Q4: Top 5 most expensive products
SELECT TOP 5 product_name, list_price
FROM production.products
ORDER BY list_price DESC;
-- Q5: Products priced between $200 and $500
SELECT product_name, list_price
FROM production.products
WHERE list_price >= 200 AND list_price <= 500
ORDER BY list_price ASC;
-- Q6: Customers whose last name starts with S
SELECT *
FROM sales.customers
WHERE last_name >= 'S' AND last_name < 'T';
-- Q7: Mountain Bikes OR Road Bikes
SELECT product_name, category_id
FROM production.products
WHERE category_id IN (6, 7);
-- Q8: Orders not shipped yet
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;
-- Q9: Product name, brand ID, and 15% discount price
SELECT
    product_name,
    brand_id,
    list_price * 0.85 AS [Sale Price]
FROM production.products;
-- Q10: Unique customer cities in alphabetical order
SELECT DISTINCT city
FROM sales.customers
ORDER BY city ASC;
-- Q11: Active staff members with full name and email
SELECT
    first_name + ' ' + last_name AS full_name,
    email
FROM sales.staffs
WHERE active = 1;
-- Q12: Combined cities from customers and stores
SELECT city
FROM sales.customers

UNION

SELECT city
FROM sales.stores
ORDER BY city ASC;
-- Q13: Product IDs in order_items but not in products
SELECT DISTINCT oi.product_id
FROM sales.order_items AS oi
LEFT JOIN production.products AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
-- Q14: Products from 2016 costing more than $1,500
SELECT product_name, model_year, list_price
FROM production.products
WHERE model_year = 2016
  AND list_price > 1500
ORDER BY list_price DESC;
-- Q15 BONUS: Trek 2016 and Surly 2017 products
SELECT
    p.product_name,
    b.brand_name,
    p.model_year,
    p.list_price
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
WHERE p.brand_id = 9
  AND p.model_year = 2016

UNION ALL

SELECT
    p.product_name,
    b.brand_name,
    p.model_year,
    p.list_price
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
WHERE p.brand_id = 8
  AND p.model_year = 2017
ORDER BY model_year ASC, list_price DESC;