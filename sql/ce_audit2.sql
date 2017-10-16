--copy(
--create table umts_capacity.ulce_audit_3sigma_monthly as 
insert into umts_capacity.ulce_audit_3sigma_monthly
SELECT year,month,
NODEB,
SUM(CEUL/RETAINED_DAYS) CEUL
--SUM(CEDL/RETAINED_DAYS) CEDL
FROM
(
SELECT
date_part('year'::text, datetime::date) AS year,
date_part('month'::text, datetime::date) AS month,
RNC,
NODEB,
SUM(CASE WHEN ceul <= AVG_CE_CONSUPTION+3*STDDEV_CE_CONSUPTION THEN CEUL ELSE 0 END) CEUL,
SUM(CASE WHEN ceul <= AVG_CE_CONSUPTION+3*STDDEV_CE_CONSUPTION THEN 1 ELSE 0 END) RETAINED_DAYS
from
(
SELECT rnc, nodeb, datetime, vs_nodeb_ulcreditused_mean as ceul,
AVG(vs_nodeb_ulcreditused_mean) OVER (PARTITION BY RNC,NODEB) AVG_CE_CONSUPTION,
STDDEV(vs_nodeb_ulcreditused_mean) OVER (PARTITION BY RNC,NODEB) STDDEV_CE_CONSUPTION
  FROM umts_capacity.ulce_utilization_nodeb_ceoverb_daily
  where datetime::date between '2016-09-01' and '2016-09-30') t
GROUP BY
date_part('year'::text, datetime::date),
date_part('month'::text, datetime::date),
RNC,
NODEB
HAVING SUM(CASE WHEN ceul <= AVG_CE_CONSUPTION+3*STDDEV_CE_CONSUPTION THEN 1 ELSE 0 END) > 22
) t2
GROUP BY
NODEB,year,month

--) to '/home/postgres/dump/201705_ulce_audit.csv' delimiter ',' csv header

-------------------------------------------------------------------------------------------------------------------------------------



create table umts_capacity.dlce_audit_monthly as 
--insert into umts_capacity.dlce_audit_monthly
SELECT 
year,month,
NODEB,
--SUM(CEUL/RETAINED_DAYS) CEUL,
SUM(CEDL/RETAINED_DAYS) CEDL
FROM
(
SELECT
date_part('year'::text, datetime::date) AS year,
date_part('month'::text, datetime::date) AS month,
RNC,
NODEB,
SUM(CASE WHEN cedl <= AVG_CE_CONSUPTION+STDDEV_CE_CONSUPTION THEN CEDL ELSE 0 END) CEDL,
SUM(CASE WHEN cedl <= AVG_CE_CONSUPTION+STDDEV_CE_CONSUPTION THEN 1 ELSE 0 END) RETAINED_DAYS
from
(
SELECT rnc, nodeb, datetime, vs_lc_dlcreditused_mean as cedl,
AVG(vs_lc_dlcreditused_mean) OVER (PARTITION BY RNC,NODEB) AVG_CE_CONSUPTION,
STDDEV(vs_lc_dlcreditused_mean) OVER (PARTITION BY RNC,NODEB) STDDEV_CE_CONSUPTION
  FROM umts_capacity.dlce_utilization_nodeb_daily
  where datetime::date between '2017-04-01' and '2017-04-30') t
GROUP BY
date_part('year'::text, datetime::date),
date_part('month'::text, datetime::date),
RNC,
NODEB
HAVING SUM(CASE WHEN cedl <= AVG_CE_CONSUPTION+STDDEV_CE_CONSUPTION THEN 1 ELSE 0 END) > 22
) t2
GROUP BY
NODEB,year,month

--) to '/home/postgres/dump/dlce_audit.csv' delimiter ',' csv header