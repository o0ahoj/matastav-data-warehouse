CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.Dim_resource_category AS

SELECT DISTINCT

  CAST(idtype AS INT)    AS resource_category_id,

  TRIM(resource_type)    AS resource_category_name

FROM workspace.bronze_example.t_resource_type_streaming

WHERE idtype IS NOT NULL;
 