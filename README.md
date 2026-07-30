# Matastav Data Warehouse & Analytics Project

**VSE Prague · Fundamental Analytics and Reporting · March 2026**  

---

## Business Problem

Matastav is a Czech construction services company that rents machines and work teams to customers. Despite generating **15.14B CZK in total income**, management had no visibility into why profitability was declining. Four problems were identified:

| Problem | Description |
|---------|-------------|
| Deteriorating cash flow | Income and expenses becoming unbalanced over time |
| Wage mismatch | Actual wages consistently diverging from planned wages |
| Customer dissatisfaction | Net Promoter Score declining steadily since 2019 |
| Unclear customer segmentation | VIP/Large/Normal/Small categories not optimally defined |

---

## Solution Architecture

We designed and implemented a complete data warehouse solution on Databricks, following the **Medallion Architecture** (Bronze → Silver → Gold).

```
Raw CSV sources
      ↓
  Bronze Layer     — raw data, no transformations, full traceability
      ↓
  Silver Layer     — cleaned, typed, modelled as Snowflake schema
      ↓
  Gold Layer       — aggregated metrics, ready for dashboards
      ↓
Databricks Dashboards — 3 interactive management dashboards
```

---

## Data Model — Snowflake Schema

Designed with **4 central fact tables** and **8 dimension tables** to reduce redundancy and enable drill-down analysis.

![Snowflake Schema ERD](SnowFlacks%20.png)

| Fact Tables | Purpose |
|-------------|---------|
| `fact_contracts` | Revenue, costs, margin per contract |
| `fact_finance_actual` | Actual financial transactions |
| `fact_finance_plan` | Planned financial targets |
| `fact_satisfaction` | Customer NPS scores |

**Key design decisions:**
- **Snowflake structure** on Customer and Employee dimensions enables hierarchical drill-down (Region → District → Customer)
- **Dim_Time** covers 2014–2024, allowing 10-year trend analysis
- **Relational integrity** between Employee → Branch → Wages was the technical bridge that unlocked the wage mismatch investigation

---

## Dashboards

Three interactive dashboards built on the Databricks Gold layer:

### 1. Cash Flow Performance
> *"Why is profitability shrinking despite high revenue?"*

**Key metrics:** Total Income 15.14B · Total Expense -10.35B · Net Profit 4.79B · **Margin 31.62%**

- Income vs Expense trend (2014–2024)
- Expenses breakdown by type and branch
- Planned vs Actual Income gap analysis by customer

### 2. Wage Control  
> *"Why do planned wages differ from actual wages?"*

**Key metrics:** Actual Wages 192.52M · Planned Wages 204.26M · **Variance -11.74M**

- Wage trends over time — 8 years of stability (2014–2021), then sudden divergence in 2022–2023
- Wage variance by employee — identifies the **"Story of Four"** outliers
- Wages by branch — MATASTAV-headquarters at 84.11M total wages

### 3. Customer Performance
> *"Are we at risk of losing our most valuable customers?"*

**Key metrics:** Total Planned Revenue 16.63B · Contract Profit 5.80B · **Average NPS 8.08**

- Average NPS trend — steady decline since 2019
- NPS by customer category — Normal customers lowest at 7.07
- Revenue vs Customer Satisfaction scatter plot

---

## Key Business Findings

### The Profitability Squeeze
Revenue is high (15.14B) but margin is shrinking — from 31.82% in 2020 to 28.62% in 2023. Expenses remain stubbornly high while actual income increasingly falls short of plan.

### The Story of Four
The +2.77M CZK wage overspend is **not a company-wide problem** — it is concentrated in 4 specific employees and the Borohrádek branch. These 4 individuals are responsible for **111% of total overspend**.

### The NPS Time Bomb
Average NPS has been declining since 2019. VIP and Large customers (who generate the bulk of 16.63B revenue) currently sit in the high-satisfaction zone — but the trend is moving toward the danger zone.

---

## Strategic Recommendations

1. **Automate Budget Syncing** — mandatory trigger: any salary increase in payroll automatically updates the Wage Plan
2. **Audit Branch Anomalies** — immediate review of Borohrádek branch and the 4 outlier employees
3. **Standardize Salary Bands** — eliminate the massive pay spread within single roles (e.g. Salesmen: 30K–48K range)
4. **Reverse NPS Decline** — investigate root cause specifically targeting the Normal customer segment

---

## Repository Contents

```
matastav-data-warehouse/
├── SnowFlacks .png                          # Snowflake schema ERD diagram
├── 4. SQL scripts for Silver transformations/
│   ├── fact_contracts.sql
│   ├── fact_finance_actual.sql
│   ├── fact_finance_plan.sql
│   ├── fact_satisfaction.sql
│   ├── Dim_branch.sql
│   ├── Dim_customer.sql
│   ├── Dim_customer_category.sql
│   ├── Dim_employee.sql
│   ├── Dim_resource.sql
│   ├── Dim_resource_category.sql
│   ├── Dim_time.sql
│   └── Dim_transaction_type.sql
├── Cash_Flow_Perfomance.png                 # Dashboard mockup
├── Customer_Perfomance.png                  # Dashboard mockup
├── Wage_Control.png                         # Dashboard mockup
├── Matastav_Cash_Flow_Perfomance.pdf        # Databricks dashboard export
├── Matastav_Customer_Perfomance.pdf         # Databricks dashboard export
├── Matastav_Wage_Control.pdf                # Databricks dashboard export
├── Matastav_Report_Presentation_.pdf        # Full management presentation
└── Analysis_dimensions_metrics_filled.xlsx  # Dimensional analysis & metric definitions
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Platform | Databricks (Serverless Warehouse) |
| Data modelling | Snowflake schema |
| Pipeline | Bronze → Silver → Gold Medallion Architecture |
| Transformation | SQL (Materialized Views, Streaming Tables) |
| Visualisation | Databricks Dashboards |
| Analysis | Excel dimensional analysis |
| Presentation | PowerPoint / PDF |
