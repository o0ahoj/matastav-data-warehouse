CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.fact_satisfaction AS
SELECT
  -- Use contract id as a stable unique survey key (1 survey per contract in your data)
  CAST(idcontr AS INT) AS satisfaction_id,

  -- Time key in same format as dim_time (yyyyMMdd)
  CAST(date_format(to_date(to_timestamp(rental_start_date)), 'yyyyMMdd') AS INT) AS time_id,

  CAST(idcustomer AS INT) AS customer_id,


  CAST(NPS AS INT) AS nps
FROM workspace.bronze_example.t_satisfaction_streaming
WHERE idcontr IS NOT NULL
  AND idcustomer IS NOT NULL
  AND rental_start_date IS NOT NULL;