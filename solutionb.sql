--1
SELECT users.user_id, users.user_name, orders.order_id
FROM users
JOIN orders ON users.user_id = orders.user_id;

--2
SELECT users.user_id, users.user_name, COUNT(orders.order_id) AS so_don_hang
FROM users
LEFT JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id, users.user_name;
--3
SELECT order_id, COUNT(*) AS so_san_pham
FROM order_details
GROUP BY order_id;
--4
SELECT users.user_id, users.user_name, orders.order_id, products.product_name
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
GROUP BY orders.order_id;
--5
SELECT users.user_id, users.user_name, COUNT(orders.order_id) AS so_luong_don_hang
FROM users
LEFT JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id, users.user_name
ORDER BY so_luong_don_hang DESC
LIMIT 7;
--6
SELECT users.user_id, users.user_name, orders.order_id, products.product_name
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
WHERE products.product_name LIKE '%Samsung%' OR products.product_name LIKE '%Apple%'
LIMIT 7;
--7
SELECT users.user_id, users.user_name, orders.order_id, SUM(products.product_price) AS tong_tien
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
GROUP BY orders.order_id;
--8
SELECT users.user_id, users.user_name, orders.order_id, MAX(tong_tien) AS tong_tien
FROM (
    SELECT orders.user_id, orders.order_id, SUM(products.product_price) AS tong_tien
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id
    JOIN products ON order_details.product_id = products.product_id
    GROUP BY orders.user_id, orders.order_id
) AS user_order_total
JOIN orders ON user_order_total.user_id = orders.user_id AND user_order_total.tong_tien = (SELECT MAX(tong_tien) FROM (SELECT SUM(products.product_price) AS tong_tien FROM orders JOIN order_details ON orders.order_id = order_details.order_id JOIN products ON order_details.product_id = products.product_id WHERE orders.user_id = user_order_total.user_id GROUP BY orders.order_id) AS max_total)
JOIN users ON orders.user_id = users.user_id
GROUP BY users.user_id, users.user_name;
--9
SELECT users.user_id, users.user_name, orders.order_id, SUM(products.product_price) AS tong_tien, COUNT(order_details.product_id) AS so_san_pham
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
GROUP BY users.user_id, users.user_name, orders.order_id
HAVING SUM(products.product_price) = (
    SELECT MIN(total_price)
    FROM (
        SELECT orders.user_id, orders.order_id, SUM(products.product_price) AS total_price
        FROM orders
        JOIN order_details ON orders.order_id = order_details.order_id
        JOIN products ON order_details.product_id = products.product_id
        GROUP BY orders.user_id, orders.order_id
    ) AS min_prices
    WHERE min_prices.user_id = users.user_id
)
--10
SELECT users.user_id, users.user_name, orders.order_id, SUM(products.product_price) AS tong_tien, MAX(total_products) AS so_san_pham
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN (
    SELECT order_id, COUNT(*) AS total_products
    FROM order_details
    GROUP BY order_id
) AS order_counts ON orders.order_id = order_counts.order_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
GROUP BY users.user_id, users.user_name, orders.order_id
