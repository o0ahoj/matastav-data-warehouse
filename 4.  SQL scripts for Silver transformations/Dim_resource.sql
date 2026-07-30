CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.Dim_resources AS

SELECT DISTINCT

  CAST(r.idresource AS INT)              AS resource_id,

  TRIM(r.resource_abbreviation)          AS resource_abbreviation,

  TRIM(r.resource_name)                  AS resource_name,

  TRIM(r.description)                    AS description,

  CAST(r.idtype AS INT)                  AS resource_category_id,

  CAST(r.daily_costs AS DECIMAL(12,2))   AS daily_costs,

  CAST(r.daily_basic_price AS DECIMAL(12,2)) AS daily_basic_price

FROM workspace.bronze_example.t_resource_streaming r

LEFT JOIN workspace.silver_example.Dim_resource_category rc

  ON CAST(r.idtype AS INT) = rc.resource_category_id

WHERE r.idresource IS NOT NULL;
 