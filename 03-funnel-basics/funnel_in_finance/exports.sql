\pset format csv
\pset tuples_only off


set search_path to m03_finance_funnel,public;
SELECT DISTINCT ON (e.customer_id) e.customer_id,c.first_name,e.event_time AS first_time,e.src AS first_source FROM digital_events e LEFT JOIN customers c ON c.customer_id =e.customer_id ORDER BY e.customer_id, e.event_time, e.src;

\g 'results/first_touch.csv'

select 
	c.customer_id,c.first_name,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 	e.event_type='visit_landing') as landed,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 
	e.event_type='start_application') as started_application,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 
	e.event_type='submit_application') as application_submitted,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 
	e.event_type='upload_docs') as doc_uploaded,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and
	e.event_type='kyc_verified') as kyc_verified,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and
	e.event_type='approved') as approved,
	exists(select 1 from loans l where l.customer_id=c.customer_id) as funded
from customers c order by customer_id;
\g 'results/flags_per_customer.csv'

with step1 as (select 
	c.customer_id,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 	e.event_type='visit_landing') as landed,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 
	e.event_type='start_application') as started_application,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 
	e.event_type='submit_application') as application_submitted,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and 
	e.event_type='upload_docs') as doc_uploaded,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and
	e.event_type='kyc_verified') as kyc_verified,
	exists(select 1 from digital_events e where e.customer_id=c.customer_id and
	e.event_type='approved') as approved,
	exists(select 1 from loans l where l.customer_id=c.customer_id) as funded
from customers c order by customer_id),step2 as (select 
	sum(case when landed then 1 else 0 end) as landed,
	sum(case when started_application then 1 else 0 end) as started_application,
	sum(case when application_submitted then 1 else 0 end) as application_submitted,
	sum(case when doc_uploaded then 1 else 0 end) as doc_uploaded,
	sum(case when kyc_verified then 1 else 0 end) as kyc_verified,
	sum(case when approved then 1 else 0 end) as approved,
	sum(case when funded then 1 else 0 end) as funded
	from step1) 
select * from step2;
\g 'results/funnel_total.csv'

with first_touch as (select distinct on (e.customer_id) 
		e.customer_id,e.event_time,e.src as first_source from digital_events e order by 		e.customer_id,e.event_time,e.src),base as (select ft.customer_id,ft.first_source from first_touch ft), funded as (select distinct customer_id from loans)
select b.first_source,count(*)::int customers_first_touched,count(f.customer_id)::int as funded_customers,round(100*count(f.customer_id)/nullif(count(*),0),2) as funded_rate_pct from base b left join funded f on f.customer_id=b.customer_id group by b.first_source order by customers_first_touched desc;

\g 'results/funded_rate_by_first_touch_source.csv'

with submits as (select customer_id,event_time as submit_time from digital_events where event_type='submit_application'),approved as (select customer_id,event_time as approve_time from digital_events where event_type='approved'),paired as (select s.customer_id,s.submit_time,min(a.approve_time) as approve_time from submits s inner join approved a on a.customer_id=s.customer_id and a.approve_time>=s.submit_time group by s.customer_id,s.submit_time)
select customer_id,submit_time,approve_time,approve_time-submit_time as time_to_approve from paired where approve_time is not null;

\g 'results/time_from_submit_to_approved.csv'

select c.customer_id,c.first_name from customers c where (exists(select 1 from digital_events e where e.customer_id=c.customer_id and e.event_type = 'approved') and not exists(select 1 from loans l where l.customer_id=c.customer_id));

\g 'results/approved_but_not_funded.csv'

with flags as (select c.customer_id, exists(select 1 from digital_events e where e.customer_id=c.customer_id and e.event_type='visit_landing') as landed, exists(select 1 from loans l where l.customer_id=c.customer_id) as funded from customers c)
select sum(case when landed then 1 else 0 end) as total_landed,sum(case when funded then 1 else 0 end) as total_funded,round(100*sum(case when funded then 1 else 0 end)::numeric/nullif(sum(case when landed then 1 else 0 end),0),1) as funded_rate_pct from flags;

\g 'results/overall_funded_rate_pct.csv'

