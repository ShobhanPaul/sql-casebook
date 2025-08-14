\# Module 2 — Joins (m02\_retail)



\*\*Goal:\*\* Practice real join patterns on a clean 4-table retail schema.



\*\*Tables:\*\* `customers(customer\_id, first\_name, last\_name, country)`,  

`products(product\_id, brand, category)`, `orders(order\_id, customer\_id, order\_date)`,  

`order\_items(order\_id, product\_id, qty, price)`.



\## Queries (join ladder)

\- Q1 INNER: customers with orders  

\- Q2 LEFT: customers incl. zero orders  

\- Q3 Aggregate→join: revenue per customer  

\- Q4 Bridge: revenue by brand  

\- Q5 ANTI: products never bought  

\- Q6 SEMI/EXISTS: customers who bought Headphones



\## Results (CSV)

\- `results/q1\_customers\_with\_orders.csv`  

\- `results/q2\_customers\_left\_join.csv`  

\- `results/q3\_revenue\_per\_customer.csv`  

\- `results/q4\_brand\_revenue.csv`  

\- `results/q5\_products\_never\_bought.csv`  

\- `results/q6\_customers\_bought\_headphones.csv`



\*\*So what:\*\* These patterns answer common business asks:

\- Participation (has/hasn’t), enrichment (lookup), bridge aggregation, and safe anti-joins.



