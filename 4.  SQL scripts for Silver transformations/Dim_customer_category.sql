CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.Dim_customer_category AS

SELECT DISTINCT

  CAST(idcategory AS INT)      AS customer_category_id,

  TRIM(category_name)          AS customer_category_name,

  CAST(discount AS DECIMAL(5,2)) AS discount

FROM workspace.bronze_example.t_customer_category_streaming

WHERE idcategory IS NOT NULL;