# Finance Funnel Analysis — SQL Casebook (Module 3)

A compact, recruiter‑friendly SQL project that implements a **loan application funnel** for a finance use case. The goal is to demonstrate how to translate a business funnel into robust SQL: define stages, attribute first touch, compute conversion and timing KPIs, and export CSVs for BI/Power BI.

---

## Project Structure

```
03-funnel-basics/
└─ funnel_in_finance/
   ├─ data/
   │  ├─ customers.csv
   │  ├─ digital_events.csv
   │  └─ loans.csv
   ├─ setup.sql
   ├─ queries.sql
   └─ exports.sql
```

> Schema used: **m03_finance_funnel**

---

## Dataset (toy, illustrative)

- **customers.csv** — `customer_id`, `first_name`, `city`, `segment`, `signup_date`
- **digital_events.csv** — `event_id`, `customer_id`, `session_id`, `event_time`, `src` (`web|app|branch`), `event_type` (funnel stages)
- **loans.csv** — `loan_id`, `customer_id`, `product`, `funded_time`, `amount`

This tiny dataset is built to keep the focus on **SQL logic** rather than data wrangling volume. It includes enough columns to support attribution (first touch), segmentation (city/segment), and stage flags.

---

## How to Run

From Windows Command Prompt:

```bat
cd C:\Projects\sql_casebook\03-funnel-basics\funnel_in_finance

:: 1) Create schema + tables and load CSVs
psql -U postgres -d sql_casebook -f setup.sql

:: 2) Create views and run example queries
psql -U postgres -d sql_casebook -f queries.sql

:: 3) Export results (ensure a 'results' folder exists)
mkdir results
psql -U postgres -d sql_casebook -f exports.sql
```

**Tip:** Keep every `\copy (SELECT ...) TO 'results/xyz.csv' CSV HEADER` statement **on one line** to avoid psql parse errors.

---

## Funnel Definition

Stages are modeled as **yes/no flags** per customer using `EXISTS`:
- `landed`
- `started_application`
- `application_submitted`
- `doc_uploaded`
- `kyc_verified`
- `approved`
- `funded` (comes from `loans` table)

This approach avoids the “same-row trap” and handles multiple events per stage.

**First touch attribution** uses `DISTINCT ON (customer_id)` ordered by earliest `event_time` to assign `first_source` (`web`, `app`, or `branch`).

---

## Core Views & Queries

See full SQL in [`queries.sql`](./queries.sql). Key objects:

- **`v_first_touch`** — earliest event per customer → `first_source`, `first_time`  
- **`v_steps`** — stage flags per customer using `EXISTS`  
- **`v_funnel_totals`** — counts at each stage via conditional aggregation  
- **`v_funded_by_source`** — conversion to funded by `first_source`  
- **`v_time_to_approval_per_customer`** — submit → approved duration per customer  
- **`v_time_to_approval_summary`** — min / p50 / p90 / max for approval time  
- **`v_approved_not_funded`** — approved customers who never funded (leakage)  
- **`v_started_not_submitted`** — abandonment between start and submit  
- **`v_overall_funded_rate`** — single-row KPI with overall funded rate

---

## Exports

[`exports.sql`](./exports.sql) writes comma‑separated outputs to `/results/`:

- `first_touch.csv` — customer, `first_source`, `first_time`
- `steps.csv` — per‑customer stage flags
- `funnel_totals.csv` — total users at each stage
- `funded_by_source.csv` — funded conversion by channel
- `time_to_approval_per_customer.csv` — per‑customer durations
- `approved_not_funded.csv` — approved yet unfunded customers
- `overall_funded_rate.csv` — KPI row for dashboards

These are copy‑paste‑ready for BI tools or portfolio visuals.

---

## Sanity Checks (recommended)

- Monotonicity: counts should **not** rise deeper in the funnel.  
- No negative durations: `approved_at >= submitted_at`.  
- Uniqueness: `event_id` is unique; `loan_id` is unique.  
- Reasonable rates: `funded ≤ approved ≤ submitted ≤ landed`.  
- Duplicates: consider `MIN(event_time)` per stage to dedupe noisy logs.

---

## What This Demonstrates (Recruiter Notes)

- Translating business funnel language into SQL entities and stage logic
- `EXISTS` / `NOT EXISTS` patterns for robust yes/no questions
- `DISTINCT ON` for deterministic first-touch attribution (PostgreSQL)
- Conditional aggregation for stage totals and conversion rates
- Time‑to‑event KPIs (submit → approval) including p50/p90 via `percentile_cont`
- Clean separation of concerns: **views** for logic, **exports** for artifacts

---

## Possible Extensions

- Stage‑to‑stage conversion (% waterfall) with deltas
- SLA flags (e.g., approval > 24h) and exception lists
- Segmentation by `city` / `segment` with side‑by‑side conversion
- Event deduplication and out‑of‑order event handling
- Funding pairing policy (e.g., submit pairs to *first* later funding)

---

## File Pointers

- [`setup.sql`](./setup.sql) — schema, tables, indexes, `\copy` CSV loads  
- [`queries.sql`](./queries.sql) — views + example analysis queries  
- [`exports.sql`](./exports.sql) — `\copy (SELECT ...) TO 'results/*.csv'`

> This module is intentionally small to keep the reviewer’s focus on **SQL quality** and reproducible outputs.
