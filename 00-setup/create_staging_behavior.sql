DROP TABLE IF EXISTS staging_behavior;
CREATE TABLE staging_behavior (
  event_time TIMESTAMP,
  event_type TEXT,
  product_id BIGINT,
  category_id NUMERIC,
  category_code TEXT,
  brand TEXT,
  price NUMERIC,
  user_id BIGINT,
  user_session TEXT
);
