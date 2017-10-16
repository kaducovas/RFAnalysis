copy(SELECT 
NODEB,
SUM(CEUL/RETAINED_DAYS) CEUL
--SUM(CEDL/RETAINED_DAYS) CEDL
FROM
(
SELECT
RNC,
NODEB,
SUM(CASE WHEN ceul <= AVG_CE_CONSUPTION+STDDEV_CE_CONSUPTION THEN CEUL ELSE 0 END) CEUL,
SUM(CASE WHEN ceul <= AVG_CE_CONSUPTION+STDDEV_CE_CONSUPTION THEN 1 ELSE 0 END) RETAINED_DAYS
from
(
SELECT rnc, nodeb, datetime, vs_nodeb_ulcreditused_mean as ceul,
AVG(vs_nodeb_ulcreditused_mean) OVER (PARTITION BY RNC,NODEB) AVG_CE_CONSUPTION,
STDDEV(vs_nodeb_ulcreditused_mean) OVER (PARTITION BY RNC,NODEB) STDDEV_CE_CONSUPTION
  FROM umts_capacity.ulce_utilization_nodeb_ceoverb_daily
  where datetime::date between '2016-09-01' and '2016-09-30') t
GROUP BY
RNC,
NODEB
HAVING SUM(CASE WHEN cedl <= AVG_CE_CONSUPTION+STDDEV_CE_CONSUPTION THEN 1 ELSE 0 END) > 22
) t2
GROUP BY
NODEB) to '/home/postgres/dump/201609_ulce_audit.csv' delimiter ',' csv header