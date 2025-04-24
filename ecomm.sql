create database ecomm;
use ecomm;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Alice Smith', 'alice@example.com', 'USA'),
(2, 'Bob Johnson', 'bob@example.com', 'Canada'),
(3, 'Carol Lee', 'carol@example.com', 'USA'),
(4, 'David Kim', 'david@example.com', 'UK');

INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing');

INSERT INTO products VALUES
(1, 'Smartphone', 1, 699.99),
(2, 'Laptop', 1, 999.99),
(3, 'T-Shirt', 3, 19.99),
(4, 'Novel', 2, 14.99),
(5, 'Headphones', 1, 129.99);

INSERT INTO orders VALUES
(1001, 1, '2024-04-01'),
(1002, 2, '2024-04-02'),
(1003, 3, '2024-04-03'),
(1004, 1, '2024-04-04');

INSERT INTO order_items VALUES
(1, 1001, 1, 1, 699.99),   
(2, 1001, 3, 2, 19.99),   
(3, 1002, 4, 1, 14.99),    
(4, 1003, 2, 1, 999.99),  
(5, 1004, 5, 1, 129.99);   

SELECT * 
FROM customers 
WHERE country = 'USA';

SELECT product_name, price 
FROM products 
ORDER BY price DESC 
LIMIT 5;

SELECT c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;

SELECT o.order_id, cu.customer_name, p.product_name, oi.quantity
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

SELECT customer_id, COUNT(*) AS num_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS avg_orders
);


CREATE VIEW customer_order_totals AS
SELECT o.customer_id, cu.customer_name, SUM(oi.quantity * oi.unit_price) AS total_value
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, cu.customer_name;

SELECT * FROM customer_order_totals ORDER BY total_value DESC;

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
