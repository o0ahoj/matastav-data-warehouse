CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.fact_contracts AS
SELECT
  CAST(idcontr AS INT)     AS contract_id,
  CAST(idcustomer AS INT)  AS customer_id,
  CAST(idresource AS INT)  AS resource_id,

  CAST(date_format(to_date(to_timestamp(rental_start)), 'yyyyMMdd') AS INT) AS contract_date_id,

  CAST(price AS DECIMAL(12,2)) AS planned_revenue,
  CAST(costs AS DECIMAL(12,2)) AS planned_cost,
  CAST((price - costs) AS DECIMAL(12,2)) AS margin,

  CAST(
    datediff(
      to_date(to_timestamp(rental_end)),
      to_date(to_timestamp(rental_start))
    ) + 1 AS INT
  ) AS rental_duration
FROM workspace.bronze_example.t_contract_streaming
WHERE idcontr IS NOT NULL;