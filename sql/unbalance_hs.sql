
copy(

select week,region,rnc,"NODEBNAME" as nodeb,cellid,node,"CARRIER" as carrier, "AZIMUTH" as azimuth, hsdpa_users,
avg(hsdpa_users) over (partition by week,region,rnc,"NODEBNAME","AZIMUTH") as avg_hs_users,
case 
when (hsdpa_users < 0.7*avg(hsdpa_users) over (partition by week,region,rnc,"NODEBNAME","AZIMUTH") or 
hsdpa_users > 1.3*avg(hsdpa_users) over (partition by week,region,rnc,"NODEBNAME","AZIMUTH")) then 'NOK'::text
else 'OK' end as Balanced


FROM (select week,region,rnc,cellid,node,round(avg(hsdpa_users)::numeric,2) as hsdpa_users from
--select * from
(SELECT week,date, region,rnc,cellid,node,hsdpa_users,
          ROW_NUMBER() OVER (
          PARTITION BY week,region,rnc,cellid,node 
          ORDER BY 
		hsdpa_users desc
       ) rn
from
(SELECT week, date::date, region, rnc, cellid, node, max(hsdpa_users) as hsdpa_users
FROM umts_kpi.vw_main_kpis_cell_rate_hourly
where date BETWEEN '2017-01-29' and '2017-02-04'
and date::time between '06:00:00' and '23:30:00'
group by week, date::date, region, rnc, cellid, node) daily ) weekly
where weekly.rn < 4
group by week,region,rnc,cellid,node
) hs_users inner join (select distinct "RNC","CELLID","NODEBNAME","CARRIER","AZIMUTH" from common_gis.cell_database_v5) c
on hs_users.rnc = c."RNC" and hs_users.cellid = c."CELLID"
ORDER BY region,rnc,nodeb,azimuth,carrier
) to '/home/postgres/dump/w5hsuser_unbalance.csv' delimiter ';' csv header 

