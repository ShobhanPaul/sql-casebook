
CREATE SCHEMA IF NOT EXISTS m02_retail;
SET search_path TO m02_retail, public;
\pset pager off
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
  customer_id INT PRIMARY KEY,
  first_name  TEXT,
  last_name   TEXT,
  country     TEXT
);
CREATE TABLE products(
  product_id INT PRIMARY KEY,
  brand      TEXT,
  category   TEXT
);
create table orders(order_id int primary key,
customer_id int references customers(customer_id),
order_date date);
create table order_items(order_id int references orders(order_id),
product_id int references products(product_id),
qty int, price numeric(10,2));
INSERT INTO customers VALUES
  (1,'Asha','Roy','India'),
  (2,'Rahul','Sen','India'),
  (3,'Mia','Das','USA'),
  (4,'Ishan','Patel','India'),
  (5,'Liam','Khan','UK');
INSERT INTO products VALUES
  (10,'Apple','Phone'),
  (11,'Samsung','Phone'),
  (12,'Sony','Headphones'),
  (13,'HP','Laptop'),
  (14,'Boat','Headphones');
INSERT INTO orders VALUES
  (100,1,'2019-11-02'),
  (101,1,'2019-11-12'),
  (102,2,'2019-11-15'),
  (103,3,'2019-11-20');
INSERT INTO order_items VALUES
  (100,10,1,60000.00),
  (100,12,1, 5000.00),
  (101,11,1,45000.00),
  (102,14,2, 1500.00),
  (103,13,1,65000.00);
-- Export base tables to /data (good for GitHub preview)
\echo --- Exporting base tables to /data
\copy customers    TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/data/customers.csv'    CSV HEADER;
\copy products     TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/data/products.csv'     CSV HEADER;
\copy orders       TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/data/orders.csv'       CSV HEADER;
\copy order_items  TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/data/order_items.csv'  CSV HEADER;

\echo --- setup.sql done






















