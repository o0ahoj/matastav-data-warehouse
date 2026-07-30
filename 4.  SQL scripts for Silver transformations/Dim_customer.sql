CREATE OR REPLACE MATERIALIZED VIEW workspace.silver_example.Dim_customer AS

SELECT DISTINCT
    CAST(c.idcustomer AS INT)      AS customer_id,
    CAST(c.idemp AS INT)           AS employee_id,        -- ADD THIS
    TRIM(c.customer_name)          AS customer_name,
    TRIM(c.street)                 AS street,
    TRIM(c.city)                   AS city,
    TRIM(c.zip_code)               AS zip_code,
    CAST(c.idcategory AS INT)      AS customer_category_id,
    CAST(c.credit_ammount AS FLOAT) AS credit_amount       -- NICE TO HAVE
FROM workspace.bronze_example.t_customers_streaming c
LEFT JOIN workspace.silver_example.Dim_customer_category cc
    ON CAST(c.idcategory AS INT) = cc.customer_category_id
WHERE c.idcustomer IS NOT NULL;