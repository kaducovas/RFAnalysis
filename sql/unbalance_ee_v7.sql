
copy(

select year,week,regional as region,c.rnc,c.nodebname as nodeb,c.cellid,cellname as node,carrier as carrier, azimuth as azimuth, ee,
avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth) as avg_ee,
case 
when (ee < 0.7*avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth) or 
ee > 1.3*avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth)) then 'NOK'::text
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
where datetime BETWEEN '2017-04-30' and '2017-05-07'
and datetime::time between '06:00:00' and '23:30:00'
group by date_part('year'::text, datetime::date), 
date_part('week'::text, datetime::date + '1 day'::interval), 
datetime::date, rnc, cellid) daily ) weekly
where weekly.rn < 4
group by year, week,rnc,cellid
) load inner join (select distinct regional,rnc,cellid,cellname,nodebname,carrier,azimuth from umts_control.cells_db) c
on load.rnc = c.rnc and load.cellid = c.cellid
ORDER BY regional,rnc,nodeb,azimuth,carrier
) to '/home/postgres/dump/w6ee_unbalancev2.csv' delimiter ';' csv header 

