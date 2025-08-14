-- Module 1: Sales Basics
-- Top 5 selling products by total revenue
select product_id,sum(price) as total_revenue,count(product_id) as 
total_orders from cleaning_behavior where event_type='purchase' group by product_id order by total_revenue desc limit 5;
-- DAILY TOTAL REVENUE:
select DATE_TRUNC('day',event_time::timestamp) as sale_date, sum(price) as daily_revenue from cleaning_behavior where event_type='purchase' 
group by sale_date order by sale_date;
-- Unique Buyers per day:
select date_trunc('day',event_time::timestamp) as day, count(distinct user_id) as unique_buyers from cleaning_behavior where event_type 
='purchase' group by day order by day asc;
-- Brand wise total sales:
select brand, count(*) as total_orders, sum(price) as revenue from cleaning_behavior where event_type='purchase'
group by brand order by revenue desc limit 5;
-- AOV (average order value) per day:
select date_trunc('day',event_time) as day, sum(price) as revenue, count(*) as total_orders, round(sum(price)/nullif(count(*),0),2) as AOV from cleaning_behavior where event_type='purchase' group by day order by day;
--% of total_revenue by brand:
with brand_rev as (
select brand, sum(price) as revenue from cleaning_behavior where event_type = 'purchase' group by brand),
tot as (select sum(revenue) as total_rev from brand_rev),
brand_pct as (select b.brand, b.revenue, t.total_rev, round(b.revenue/nullif(t.total_rev,0),2)*100 as pct_of_total from brand_rev b cross join tot t)
select * from brand_pct order by revenue desc LIMIT 10;
--sessions that purchased:
select count(distinct user_session) from cleaning_behavior where event_type = 'purchase';
--funnel size by event type:
select event_type, count(*) as events from cleaning_behavior where event_type in ('view','cart','purchase') group by event_type order by events desc;
--brands with revenue greater than 10000:
select brand, sum(price) as revenue from cleaning_behavior where event_type = 'purchase' group by brand having sum(price) > 10000 order by revenue desc;







