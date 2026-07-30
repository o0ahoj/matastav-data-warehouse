CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.fact_finance_actual AS
WITH unioned AS (

  -- INCOMES (actual): linked to contract sometimes
  SELECT
    CAST(iddoc AS INT)              AS finance_actual_id,
    day                             AS day_str,
    CAST(ammount AS DECIMAL(12,2))  AS actual_amount,
    TRIM(type)                      AS transaction_type,
    CAST(NULL AS INT)               AS employee_id,
    CAST(NULL AS INT)               AS branch_id,
    CAST(NULL AS INT)               AS resource_id,
    CAST(idcontr AS INT)            AS contract_id
  FROM workspace.bronze_example.t_incomes_actual_streaming

  UNION ALL

  -- WAGE (actual): linked to employee
  SELECT
    CAST(iddoc AS INT),
    day,
    CAST(ammount AS DECIMAL(12,2)),
    TRIM(type),
    CAST(idemp AS INT)              AS employee_id,
    CAST(NULL AS INT)               AS branch_id,
    CAST(NULL AS INT)               AS resource_id,
    CAST(NULL AS INT)               AS contract_id
  FROM workspace.bronze_example.t_expenses_wage_actual_streaming

  UNION ALL

  -- RENT (actual): linked to branch
  SELECT
    CAST(iddoc AS INT),
    day,
    CAST(ammount AS DECIMAL(12,2)),
    TRIM(type),
    CAST(NULL AS INT),
    CAST(idbranch AS INT)           AS branch_id,
    CAST(NULL AS INT),
    CAST(NULL AS INT)
  FROM workspace.bronze_example.t_expenses_rent_actual_streaming

  UNION ALL

  -- OVERHEAD (actual): linked to branch
  SELECT
    CAST(iddoc AS INT),
    day,
    CAST(ammount AS DECIMAL(12,2)),
    TRIM(type),
    CAST(NULL AS INT),
    CAST(idbranch AS INT),
    CAST(NULL AS INT),
    CAST(NULL AS INT)
  FROM workspace.bronze_example.t_expenses_overhead_actual_streaming

  UNION ALL

  -- RESOURCE EXPENSE (actual): linked to resource and/or contract
  SELECT
    CAST(iddoc AS INT),
    day,
    CAST(ammount AS DECIMAL(12,2)),
    TRIM(type),
    CAST(NULL AS INT),
    CAST(NULL AS INT),
    CAST(idresource AS INT)         AS resource_id,
    CAST(idcontr AS INT)            AS contract_id
  FROM workspace.bronze_example.t_expenses_resource_actual_streaming

  UNION ALL

  -- PERSONAL EXPENSE (actual): linked to employee
  SELECT
    CAST(iddoc AS INT),
    day,
    CAST(ammount AS DECIMAL(12,2)),
    TRIM(type),
    CAST(idemp AS INT),
    CAST(NULL AS INT),
    CAST(NULL AS INT),
    CAST(NULL AS INT)
  FROM workspace.bronze_example.t_expenses_personal_actual_streaming
),

enriched AS (
  SELECT
    u.finance_actual_id,
    CAST(date_format(to_date(to_timestamp(u.day_str)), 'yyyyMMdd') AS INT) AS time_id,

    -- optional keys directly from the record
    u.branch_id,
    u.employee_id,

    -- resource can be directly present OR derivable from contract
    COALESCE(u.resource_id, CAST(c.idresource AS INT)) AS resource_id,

    -- customer only if contract exists
    CASE WHEN u.contract_id IS NOT NULL THEN CAST(c.idcustomer AS INT) END AS customer_id,

    u.transaction_type,
    u.actual_amount
  FROM unioned u
  LEFT JOIN workspace.bronze_example.t_contract_streaming c
    ON u.contract_id = CAST(c.idcontr AS INT)
)

SELECT
  e.finance_actual_id,
  e.time_id,
  e.branch_id,
  e.employee_id,
  e.resource_id,
  tt.transaction_type_id,
  e.customer_id,
  e.actual_amount
FROM enriched e
LEFT JOIN workspace.silver_example.Dim_transaction_type tt
  ON e.transaction_type = tt.transaction_type;