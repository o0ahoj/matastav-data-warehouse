CREATE OR REFRESH MATERIALIZED VIEW workspace.silver_example.Dim_time AS

WITH base AS (

  SELECT DISTINCT

    to_date(to_timestamp(day)) AS time_date

  FROM workspace.bronze_example.t_pomday_streaming

  WHERE day IS NOT NULL

)

SELECT

  CAST(date_format(time_date, 'yyyyMMdd') AS INT) AS time_id,

  time_date                                       AS time_day_date,

  day(time_date)                                  AS time_day,

  month(time_date)                                AS time_month,

  year(time_date)                                 AS time_year

FROM base;
 