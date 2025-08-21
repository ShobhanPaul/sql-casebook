\# Module 3 — Funnel in Sales (CTEs, Subqueries, UNION ALL)



\## 🎯 Goal

Practice \*\*CTEs\*\*, \*\*UNION ALL\*\*, and \*\*subqueries (IN / EXISTS / NOT EXISTS)\*\* by building a simple \*\*sales funnel\*\* from web/app events joined to orders.



\## 📂 What’s here

funnel\_in\_sales/

│── data/ # tiny, clean CSVs

│── results/ # exported outputs (created by results.sql)

│── setup.sql # schema m03\_funnel\_sales + CSV loads

│── queries.sql # all practice queries

│── results.sql # \\copy exports to CSV

│── README.md # this file

\## 🗄️ Tables

\- \*\*customers\*\* — id, name, city, signup, platform

\- \*\*web\_events / app\_events\*\* — `event\_time`, `event\_type` (landing, signup, view\_product, add\_to\_cart, purchase)

\- \*\*orders\*\* — customer\_id, order\_date, amount



\## 🧠 Skills you’ll see

\- `WITH` \*\*CTEs\*\* to stage logic clearly  

\- \*\*UNION ALL\*\* to stack event streams (web + app)  

\- \*\*EXISTS / NOT EXISTS / IN\*\* for yes/no questions  

\- Conditional aggregation (`CASE WHEN`) for funnel stats  

\- Simple attribution: \*\*revenue by first-touch source\*\*



\## 🚀 How to run (Windows / PowerShell)

From the module folder:

```powershell

cd C:\\Projects\\sql\_casebook\\03-funnel-basics\\funnel\_in\_sales



\# 1) Create schema and load CSVs

psql -U postgres -d sql\_casebook -f setup.sql



\# 2) Run practice queries (prints to console)

psql -U postgres -d sql\_casebook -f queries.sql



\# 3) Export result CSVs into ./results

psql -U postgres -d sql\_casebook -f results.sql

