set search_path to m03_funnel_sales,public;
-- Q1. First-touch source per customer using CTE + subquery
with all_events as (select 'web' as src,event_id,customer_id,session_id,event_time,event_type from web_events union all select 'app' as src,event_id,customer_id,session_id,event_time,event_type from app_events), first_touch as (select e.customer_id,min(event_time) as first_time from all_events e group by e.customer_id) select ft.customer_id,c.first_name,e.src as first_source,ft.first_time from first_touch ft left join customers c on c.customer_id=ft.customer_id left join all_events e on ft.customer_id = e.customer_id and ft.first_time=e.event_time order by ft.customer_id;
--Q2. Funnel flags per customer with EXISTS (yes/no questions)
with all_events as (select 'web' as src,event_id,customer_id,session_id,event_time,event_type from web_events union all select 'app' as src,event_id,customer_id,session_id,event_time,event_type from app_events),steps as
(select c.customer_id,c.first_name, exists(select 1 from all_events e where e.customer_id=c.customer_id and e.event_type='landing') as landed,
EXISTS (SELECT 1 FROM all_events e WHERE e.customer_id=c.customer_id AND e.event_type='signup') AS signed_up,
EXISTS (SELECT 1 FROM all_events e WHERE e.customer_id=c.customer_id AND e.event_type='view_product') AS viewed,
EXISTS (SELECT 1 FROM all_events e WHERE e.customer_id=c.customer_id AND e.event_type='add_to_cart') AS added,
(exists(select 1 from all_events e where e.customer_id=c.customer_id and e.event_type='purchase') or 
exists(select 1 from orders o where o.customer_id=c.customer_id)) as purchased from customers c)
select * from steps order by customer_id;
-- Q3. Funnel totals + purchase conversion rate
set search_path to m03_funnel_sales,public;
with all_events as (
	select 'web' as src,event_id,customer_id,session_id,event_time,event_type from web_events
	union all
	select 'app' as src,event_id,customer_id,session_id,event_time,event_type from app_events
), steps as (
	select c.customer_id,
	exists (select 1 from all_events e where e.customer_id=c.customer_id and 				e.event_type='landing') as landed,
	exists (select 1 from all_events e where e.customer_id=c.customer_id and 
		e.event_type='signup') as signed_up,
	exists (select 1 from all_events e where e.customer_id=c.customer_id and 
		e.event_type='view product') as viewed,
	exists (select 1 from all_events e where e.customer_id=c.customer_id and 
		e.event_type='add_to_cart') as added,
	(
	 exists (select 1 from all_events e where e.customer_id=c.customer_id and 
		e.event_type='purchase') 
	 or
	 exists (select 1 from orders o where o.customer_id=c.customer_id)
	) as purchased 
	from customers c
)
select 
	sum(case when landed then 1 else 0 end) as landed,
	sum(case when signed_up then 1 else 0 end) as signed_up,
	sum(case when viewed then 1 else 0 end) as viewed,
	sum(case when added then 1 else 0 end) as added,
	sum(case when purchased then 1 else 0 end) as purchased,
	round(100*sum(case when purchased then 1 else 0 end)::numeric
		/nullif(sum(case when landed then 1 else 0 end),0),1) as purchase_rate_pct
from steps;
	
--Q4: added not purchased
with all_events as (
	select 'web' as src,event_id,customer_id,session_id,event_time,event_type from web_events
	union all
	select 'app' as src,event_id,customer_id,session_id,event_time,event_type from app_events
),steps as (
	select c.customer_id,
	(exists(select 1 from all_events e where e.customer_id=c.customer_id and 			e.event_type='add_to_cart') and not exists(select 1 from all_events e where e.customer_id 	=c.customer_id and e.event_type='purchase') and not exists (select 1 from orders o where 	o.order_id=c.customer_id)) as added_not_purchased from customers c)
select * from steps order by customer_id;
-- Q5. Revenue by first-touch source (CTEs + subqueries)

with all_events as (
	select 'web' as src,event_id,customer_id,session_id,event_time,event_type from web_events
	union all
	select 'app' as src,event_id,customer_id,session_id,event_time,event_type from app_events
), step1 as (
	select e.customer_id,min(e.event_time) as first_time from all_events e group by 	e.customer_id
), step2 as (
	select s1.customer_id,s1.first_time,e.src as first_source from step1 s1 left join 	all_events e on e.customer_id=s1.customer_id and e.event_time=s1.first_time
), step3 as (
	select s2.customer_id,o.amount,s2.first_time,s2.first_source from step2 s2 inner join 	orders 	o on 	o.customer_id=s2.customer_id 
)
select first_source,sum(amount) as total_revenue_first_touch from step3 group by first_source order by sum(amount) desc; 
--Q6: customers who ordered atleast once
select c.customer_id,c.first_name from customers c where exists (select 1 from orders o where o.customer_id=c.customer_id);















