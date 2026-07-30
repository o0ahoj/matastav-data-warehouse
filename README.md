# Matastav Data Warehouse & Analytics Project
**VSE Prague · Architecture of Business Analytics · March 2026**

## Business Problem
Matastav, a Czech service company, faced three critical issues:
- Cash flow margin gap of **31.62%** against targets
- Wage outliers responsible for **111% of overspending** ("Story of Four")
- **10-year decline** in customer NPS (score: 8.08) — risk to VIP revenue

## Solution
A complete data warehouse built on Databricks, transforming raw 
operational data into actionable management insights.

## Data Architecture
**Medallion pipeline:** Bronze → Silver → Gold

**Snowflake Schema** — 4 fact tables + 8 dimension tables:

| Fact Tables | Dimension Tables |
|-------------|-----------------|
| fact_contracts | dim_branch |
| fact_finance_actual | dim_customer |
| fact_finance_plan | dim_customer_category |
| fact_satisfaction | dim_employee |
| | dim_resources |
| | dim_resource_category |
| | dim_time |
| | dim_transaction_type |

![Snowflake Schema ERD](SnowFlacks%20.png)

## Tech Stack
- **Platform**: Databricks (Serverless Warehouse)
- **Data modelling**: Snowflake schema
- **Transformation**: SQL scripts (Bronze → Silver layer)
- **Visualisation**: Databricks dashboards + PowerPoint for management
- **Analysis**: Excel dimensional analysis

## Deliverables
1. Snowflake schema ERD (this repo)
2. SQL transformation scripts
3. Dimensional analysis — Excel
4. Dashboard mockups
5. Management presentation

## Key Findings
- Identified 4 employees driving 111% of wage budget overspend
- Cash flow margin at 31.62%, significantly below target
- NPS declining for 10 years — VIP customer retention at risk
