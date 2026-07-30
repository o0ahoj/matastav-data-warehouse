CREATE OR REFRESH MATERIALIZED VIEW dim_branch AS
SELECT
  idbranch,
  branch_abbreviation,
  branch_name,
  street,
  city,
  zip_code,
  phone,
  fax,
  `e-mail`,
  monthly_rent
FROM workspace.bronze_example.t_branch_streaming
WHERE idbranch IS NOT NULL;