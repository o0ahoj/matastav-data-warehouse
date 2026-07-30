 
CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.dim_employee AS

SELECT DISTINCT

  CAST(e.idemp AS INT)            AS employee_id,

  TRIM(e.first_name)              AS first_name,

  TRIM(e.surname)                 AS surname,

  TRIM(e.title)                   AS title,

  CAST(e.wage AS DECIMAL(12,2))   AS wage,

  CAST(e.idsuperior AS INT)       AS supervisor_employee_id,

  CAST(e.idbranch AS INT)         AS branch_id,

  CAST(e.idrole AS INT)           AS role_id

FROM workspace.bronze_example.t_employee_streaming e

LEFT JOIN workspace.silver_example.Dim_branch b

  ON CAST(e.idbranch AS INT) = b.idbranch

WHERE e.idemp IS NOT NULL;
 