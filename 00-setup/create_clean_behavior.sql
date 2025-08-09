drop table if exists cleaning_behavior;
create table cleaning_behavior as select
event_time,event_type,product_id,category_id,
case when category_code is null or trim(category_code)='' then 'unknown'
else category_code end as category_code,
case when brand is null or trim(brand) = '' then 'unknown' else brand end as brand,price,user_id,user_session from staging_behavior;