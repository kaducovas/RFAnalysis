
copy(

select year,week,"REGIONAL" as region,rnc,"NODEBNAME" as nodeb,cellid,"CELL" as node,"CARRIER" as carrier, "AZIMUTH" as azimuth, ee,
avg(ee) over (partition by year,week,"REGIONAL",rnc,"NODEBNAME","AZIMUTH") as avg_hs_users,
case 
when (ee < 0.7*avg(ee) over (partition by year,week,"REGIONAL",rnc,"NODEBNAME","AZIMUTH") or 
ee > 1.3*avg(ee) over (partition by year,week,"REGIONAL",rnc,"NODEBNAME","AZIMUTH")) then 'NOK'::text
else 'OK' end as Balanced


FROM (select year,week,rnc,cellid,round(avg(ee)::numeric,2) as ee from
--select * from
(SELECT year,week,date,rnc,cellid,ee,
          ROW_NUMBER() OVER (
          PARTITION BY year,week,rnc,cellid 
          ORDER BY 
		ee desc
       ) rn
from
(SELECT 
date_part('year'::text, datetime::date) as year, 
date_part('week'::text, datetime::date + '1 day'::interval) as week, 
datetime::date as date, rnc, cellid, max(ee) as ee
FROM umts_kpi.amx_load
where datetime BETWEEN '2017-02-05' and '2017-02-11'
and datetime::time between '06:00:00' and '23:30:00'
group by date_part('year'::text, datetime::date), 
date_part('week'::text, datetime::date + '1 day'::interval), 
datetime::date, rnc, cellid) daily ) weekly
where weekly.rn < 4
group by year, week,rnc,cellid
) load inner join (select distinct "REGIONAL","RNC","CELLID","CELL","NODEBNAME","CARRIER","AZIMUTH" from common_gis.cell_database_v5) c
on load.rnc = c."RNC" and load.cellid = c."CELLID"
ORDER BY "REGIONAL",rnc,nodeb,azimuth,carrier
) to '/home/postgres/dump/w6hee_unbalance.csv' delimiter ';' csv header 

