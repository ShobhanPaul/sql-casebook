\pset pager off
set search_path to m02_retail,public;
-- Q1 INNER JOIN: customers with orders
select c.customer_id,c.first_name,count(o.order_id) as orders from customers c inner join orders o on o.customer_id=c.customer_id group by c.customer_id,c.first_name order by orders desc;
-- Q2 LEFT JOIN: include customers with zero orders
select c.customer_id,c.first_name,count(o.order_id) as orders from customers c left join orders o on c.customer_id=o.customer_id group by c.customer_id,c.first_name order by orders desc;
-- Q3 Multi-table: revenue per customer
select c.customer_id,c.first_name,sum(oi.price*oi.qty) as revenue from customers c inner join orders o on o.customer_id=c.customer_id inner join order_items oi on oi.order_id=o.order_id group by c.customer_id,c.first_name order by revenue desc;
-- Q4 Bridge table: revenue by brand
select p.brand,sum(oi.qty*oi.price) as revenue from products p inner join order_items oi on oi.product_id = p.product_id group by p.brand order by revenue desc;
-- Q5 Anti join: products never bought
select p.product_id from products p left join order_items oi on oi.product_id=p.product_id where oi.product_id is null;
-- Q6 Semi join: customers who bought headphones
select c.customer_id,c.first_name,p.category from customers c inner join orders o on o.customer_id=c.customer_id inner join order_items oi on oi.order_id = o.order_id inner join products p on p.product_id =oi.product_id where category='Headphones';
\copy (select c.customer_id,c.first_name,count(o.order_id) as orders from customers c inner join orders o on o.customer_id=c.customer_id group by c.customer_id,c.first_name order by orders desc) TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/results/q1_customers_with_orders.csv' CSV HEADER;
\copy (select c.customer_id,c.first_name,count(o.order_id) as orders from customers c left join orders o on c.customer_id=o.customer_id group by c.customer_id,c.first_name order by orders desc) TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/results/q2_customers_left_join.csv' CSV HEADER;
\copy (select c.customer_id,c.first_name,sum(oi.price*oi.qty) as revenue from customers c inner join orders o on o.customer_id=c.customer_id inner join order_items oi on oi.order_id=o.order_id group by c.customer_id,c.first_name order by revenue desc) TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/results/q3_revenue_per_customer.csv' CSV HEADER;
\copy (select p.brand,sum(oi.qty*oi.price) as revenue from products p inner join order_items oi on oi.product_id = p.product_id group by p.brand order by revenue desc) TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/results/q4_brand_revenue.csv' CSV HEADER;
\copy (select p.product_id from products p left join order_items oi on oi.product_id=p.product_id where oi.product_id is null) TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/results/q5_products_never_bought.csv' CSV HEADER;
\copy (select c.customer_id,c.first_name,p.category from customers c inner join orders o on o.customer_id=c.customer_id inner join order_items oi on oi.order_id = o.order_id inner join products p on p.product_id =oi.product_id where category='Headphones') TO 'C:/Projects/sql_casebook/02-joins/retail_tiny/results/q6_customers_bought_headphones.csv' CSV HEADER;
\echo --- queries.sql done





