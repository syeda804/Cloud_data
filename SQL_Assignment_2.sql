-- Show all product names along with their brand name. Sort by brand name, then by product name alphabetically.
SELECT p.product_name, b.brand_name
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
ORDER BY b.brand_name ASC, p.product_name ASC;

-- List all products with their category name and list price. Sort by category name, then by price from cheapest to most expensive.
SELECT p.product_name, c.category_name, p.list_price
FROM production.products AS p
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
ORDER BY c.category_name ASC, p.list_price ASC;

-- Show all orders with the customer's full name and order date. Sort by order date from newest to oldest.
SELECT o.order_id,
       c.first_name + ' ' + c.last_name AS full_name,
       o.order_date
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

-- Display each order item with the product name, quantity, unit price, and a computed column called "Line Total" (quantity × list_price). Sort by order ID.
SELECT oi.order_id, p.product_name,
       oi.quantity, oi.list_price,
       oi.quantity * oi.list_price AS [Line Total]
FROM sales.order_items AS oi
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
ORDER BY oi.order_id;

-- Show each order along with the store name where it was placed and the order date. Sort by store name.
SELECT o.order_id, s.store_name, o.order_date
FROM sales.orders AS o
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
ORDER BY s.store_name ASC;

-- Show each order with: order ID, customer full name, store name, and the staff member's full name who handled it.
SELECT o.order_id,
       c.first_name + ' ' + c.last_name AS customer_name,
       s.store_name,
       st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
INNER JOIN sales.staffs AS st
    ON o.staff_id = st.staff_id;

-- List all products from the brand "Trek" along with their category name and price. Sort by price descending. (Use JOIN — do NOT filter by brand_id directly.)
SELECT p.product_name, c.category_name, p.list_price
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE b.brand_name = 'Trek'
ORDER BY p.list_price DESC;

-- Find all customers from the state of "NY" who have placed at least one order. Show customer full name, city, and order date. (Use JOIN — do not use a subquery.)
SELECT c.first_name + ' ' + c.last_name AS full_name,
       c.city, o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE c.state = 'NY';

-- Show all completed orders (order_status = 4) from the store "Rowlett Bikes". Display order ID, customer full name, and order date.
SELECT o.order_id,
       c.first_name + ' ' + c.last_name AS customer_name,
       o.order_date
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
WHERE o.order_status = 4
  AND s.store_name = 'Rowlett Bikes';

-- List ALL customers and any orders they have placed. Include customers who have never placed an order (show NULL for order columns). Sort by customer ID.
SELECT c.customer_id,
       c.first_name + ' ' + c.last_name AS customer_name,
       o.order_id, o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- Find all customers who have NEVER placed an order. Show their full name and email.
SELECT c.first_name + ' ' + c.last_name AS full_name,
       c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- List all products and their stock quantity at every store. Include products that have NO stock record at all. Show product name, store ID, and quantity.
SELECT p.product_name, st.store_id, st.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS st
    ON p.product_id = st.product_id;

-- Find all products that have NEVER been ordered (no record in order_items). Show product name and list price.
SELECT p.product_name, p.list_price
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- List each staff member along with the full name of their manager. Staff with no manager (top-level) should still appear — show NULL for manager name.
SELECT st.first_name + ' ' + st.last_name AS staff_name,
       m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS st
LEFT JOIN sales.staffs AS m
    ON st.manager_id = m.staff_id;

-- Create a view called vw_bike_catalog that shows product_name, brand_name, category_name, model_year, and list_price. Then query it to show only products priced over $2,000, sorted by price descending.
CREATE VIEW vw_bike_catalog AS
SELECT p.product_name, b.brand_name,
       c.category_name, p.model_year, p.list_price
FROM production.products p
JOIN production.brands b
ON p.brand_id = b.brand_id
JOIN production.categories c
ON p.category_id = c.category_id;

SELECT *
FROM vw_bike_catalog
WHERE list_price > 2000
ORDER BY list_price DESC;

-- BONUS: Create a view called vw_customer_orders showing: customer full name, order_id, order_date, store_name, and order_status. Then query it to show only orders where the customer city is "New York", sorted by order_date.
CREATE VIEW vw_customer_orders AS
SELECT c.first_name + ' ' + c.last_name AS customer_name,
       o.order_id, o.order_date, s.store_name,
       o.order_status, c.city
FROM sales.customers c
JOIN sales.orders o
ON c.customer_id = o.customer_id
JOIN sales.stores s
ON o.store_id = s.store_id;

SELECT customer_name, order_id, order_date,
       store_name, order_status
FROM vw_customer_orders
WHERE city = 'New York'
ORDER BY order_date;