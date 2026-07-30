CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.fact_finance_plan AS

WITH unioned AS (

-- INCOME PLAN
SELECT
    CAST(iddoc AS INT) AS finance_plan_id,
    CAST(date_format(to_date(day),'yyyyMMdd') AS INT) AS time_id,
    NULL AS branch_id,
    NULL AS employee_id,
    NULL AS resource_id,
    CAST(idcontr AS INT) AS contract_id,
    TRIM(type) AS transaction_type,
    CAST(ammount AS DECIMAL(12,2)) AS planned_amount
FROM workspace.bronze_example.t_incomes_plan_streaming

UNION ALL

-- WAGE PLAN (employee)
SELECT
    CAST(iddoc AS INT),
    CAST(date_format(to_date(day),'yyyyMMdd') AS INT),
    NULL,
    CAST(idemp AS INT),
    NULL,
    NULL,
    TRIM(type),
    CAST(ammount AS DECIMAL(12,2))
FROM workspace.bronze_example.t_expenses_wage_plan_streaming

UNION ALL

-- PERSONAL PLAN (employee)
SELECT
    CAST(iddoc AS INT),
    CAST(date_format(to_date(day),'yyyyMMdd') AS INT),
    NULL,
    CAST(idemp AS INT),
    NULL,
    NULL,
    TRIM(type),
    CAST(ammount AS DECIMAL(12,2))
FROM workspace.bronze_example.t_expenses_personal_plan_streaming

UNION ALL

-- RENT PLAN (branch)
SELECT
    CAST(iddoc AS INT),
    CAST(date_format(to_date(day),'yyyyMMdd') AS INT),
    CAST(idbranch AS INT),
    NULL,
    NULL,
    NULL,
    TRIM(type),
    CAST(ammount AS DECIMAL(12,2))
FROM workspace.bronze_example.t_expenses_rent_plan_streaming

UNION ALL

-- OVERHEAD PLAN (branch)
SELECT
    CAST(iddoc AS INT),
    CAST(date_format(to_date(day),'yyyyMMdd') AS INT),
    CAST(idbranch AS INT),
    NULL,
    NULL,
    NULL,
    TRIM(type),
    CAST(ammount AS DECIMAL(12,2))
FROM workspace.bronze_example.t_expenses_overhead_plan_streaming

UNION ALL

-- RESOURCE PLAN (resource + contract)
SELECT
    CAST(iddoc AS INT),
    CAST(date_format(to_date(day),'yyyyMMdd') AS INT),
    NULL,
    NULL,
    CAST(idresource AS INT),
    CAST(idcontr AS INT),
    TRIM(type),
    CAST(ammount AS DECIMAL(12,2))
FROM workspace.bronze_example.t_expenses_resource_plan_streaming
),

enriched AS (
  SELECT
    u.finance_plan_id,
    u.time_id,
    u.branch_id,
    u.employee_id,
    COALESCE(u.resource_id, c.idresource) AS resource_id,
    c.idcustomer AS customer_id,
    u.transaction_type,
    u.planned_amount
  FROM unioned u
  LEFT JOIN workspace.bronze_example.t_contract_streaming c
    ON u.contract_id = c.idcontr
)

SELECT
  e.finance_plan_id,
  e.time_id,
  e.branch_id,
  e.employee_id,
  e.resource_id,
  tt.transaction_type_id,
  e.customer_id,
  e.planned_amount
FROM enriched e
LEFT JOIN workspace.silver_example.Dim_transaction_type tt
  ON e.transaction_type = tt.transaction_type;