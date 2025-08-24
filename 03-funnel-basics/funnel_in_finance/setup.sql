DROP SCHEMA IF EXISTS m03_finance_funnel CASCADE;
CREATE SCHEMA m03_finance_funnel;
SET search_path = m03_finance_funnel, public;
CREATE TABLE customers (
  customer_id   INT PRIMARY KEY,
  first_name    TEXT NOT NULL,
  city          TEXT,
  segment       TEXT,
  signup_date   DATE
);
CREATE TABLE digital_events (
  event_id     INT PRIMARY KEY,
  customer_id  INT NOT NULL REFERENCES customers(customer_id),
  session_id   TEXT,
  event_time   TIMESTAMP NOT NULL,
  src          TEXT NOT NULL CHECK (src IN ('web','app','branch')),
  event_type   TEXT NOT NULL CHECK (event_type IN (
    'visit_landing','start_application','submit_application',
    'upload_docs','kyc_verified','approved'
  ))
);
CREATE INDEX ix_events_customer_time ON digital_events(customer_id, event_time);
CREATE INDEX ix_events_type ON digital_events(event_type);
CREATE TABLE loans (
  loan_id      INT PRIMARY KEY,
  customer_id  INT NOT NULL REFERENCES customers(customer_id),
  product      TEXT NOT NULL CHECK (product IN ('personal_loan','credit_card','auto_loan')),
  funded_time  TIMESTAMP NOT NULL,
  amount       NUMERIC(12,2) NOT NULL CHECK (amount > 0)
);
\copy customers FROM 'data/customers.csv' CSV HEADER
\copy digital_events FROM 'data/digital_events.csv' CSV HEADER
\copy loans FROM 'data/loans.csv' CSV HEADER












