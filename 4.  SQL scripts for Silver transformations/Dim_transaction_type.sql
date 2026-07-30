CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.Dim_transaction_type AS

WITH all_types AS (

  SELECT TRIM(`type`) AS transaction_type, 'incomes_actual' AS source_table

  FROM workspace.bronze_example.t_incomes_actual_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'incomes_plan'

  FROM workspace.bronze_example.t_incomes_plan_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_wage_actual'

  FROM workspace.bronze_example.t_expenses_wage_actual_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_wage_plan'

  FROM workspace.bronze_example.t_expenses_wage_plan_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_rent_actual'

  FROM workspace.bronze_example.t_expenses_rent_actual_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_rent_plan'

  FROM workspace.bronze_example.t_expenses_rent_plan_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_overhead_actual'

  FROM workspace.bronze_example.t_expenses_overhead_actual_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_overhead_plan'

  FROM workspace.bronze_example.t_expenses_overhead_plan_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_resource_actual'

  FROM workspace.bronze_example.t_expenses_resource_actual_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_resource_plan'

  FROM workspace.bronze_example.t_expenses_resource_plan_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_personal_actual'

  FROM workspace.bronze_example.t_expenses_personal_actual_streaming

  WHERE `type` IS NOT NULL

  UNION ALL

  SELECT TRIM(`type`), 'expenses_personal_plan'

  FROM workspace.bronze_example.t_expenses_personal_plan_streaming

  WHERE `type` IS NOT NULL

),

dedup AS (

  SELECT

    transaction_type,

    concat_ws(',', sort_array(collect_set(source_table))) AS sources

  FROM all_types

  WHERE transaction_type <> ''

  GROUP BY transaction_type

)

SELECT

  DENSE_RANK() OVER (ORDER BY transaction_type) AS transaction_type_id,

  transaction_type,

  sources

FROM dedup;
 