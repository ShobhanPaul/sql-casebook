create schema if not exists m03_funnel_sales;
set search_path to m03_funnel_sales,public;
DROP TABLE IF EXISTS app_events, web_events, orders, customers CASCADE;
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
first_name TEXT NOT NULL,
city TEXT,
segment TEXT,
signup_date DATE,
platform TEXT CHECK (platform IN ('web','app'))
);
CREATE TABLE web_events (
event_id INT PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
session_id INT,
event_time TIMESTAMP NOT NULL,
event_type TEXT CHECK (event_type IN ('landing','signup','view_product','add_to_cart','checkout','purchase'))
);
CREATE TABLE app_events (
event_id INT PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
session_id INT,
event_time TIMESTAMP NOT NULL,
event_type TEXT CHECK (event_type IN ('landing','signup','view_product','add_to_cart','checkout','purchase'))
);
CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
order_date DATE NOT NULL,
amount NUMERIC(10,2) NOT NULL
);
\echo '--- Loading CSVs from ./data'
\copy customers FROM 'data/customers.csv' WITH (FORMAT csv, HEADER true)
\copy web_events FROM 'data/web_events.csv' WITH (FORMAT csv, HEADER true)
\copy app_events FROM 'data/app_events.csv' WITH (FORMAT csv, HEADER true)
\copy orders FROM 'data/orders.csv' WITH (FORMAT csv, HEADER true)
\echo '--- Row counts'
SELECT 'customers' AS t, COUNT(*) FROM customers
UNION ALL SELECT 'web_events', COUNT(*) FROM web_events
UNION ALL SELECT 'app_events', COUNT(*) FROM app_events
UNION ALL SELECT 'orders', COUNT(*) FROM orders;








