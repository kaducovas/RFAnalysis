
copy(SELECT o.year, o.week, 
"CLUSTER" as cluster,
"UF" as uf,
"CIDADE" cidade,
"IBGE" ibge,
rnc, cellname, cellid, count, covered_sites
             FROM common_gis.weekly_overshooters o
             JOIN cell_db_history u ON u."RNC" = o.rnc AND u."CELLID" = o.cellid AND u.year = o.year::double precision AND u.week = o.week::double precision
where o.year = 2017 and o.week = 18) to '/home/postgres/dump/w18_overshooter.csv' delimiter ';' csv header

--------------------------------------------

select * from umts_baseline.vw_consistency_check 
where year = 2017
and week = 14

-------------------------------------------

SELECT distinct date from umts_kpi.main_kpis_daily where extract('dow' from date) = 1
AND date_part('week', date + '1 day'::interval) = 12

SELECT EXTRACT(week FROM current_date)::smallint - 1

SELECT EXTRACT(week FROM current_date - '1 day'::interval)::integer

insert into common_gis.weekly_overshooters 
SELECT year, week, rnc, cellname, cellid, count, covered_sites
  FROM common_gis.cell_overshooters_v2 where year = 2017 and week = 13;

insert into common_gis.weekly_overshooters 
SELECT year, week, rnc, cellname, cellid, count, covered_sites
  FROM common_gis.cell_overshooters_v2 where year = 2017 and week = 12;

insert into common_gis.weekly_overshooters
SELECT year, week, rnc, cellname, cellid, count, covered_sites
  FROM common_gis.cell_overshooters_v2 where year = 2017 and week = 11;

 select distinct year,week from common_gis.weekly_overshooters

 SELECT regional as node, string_agg(week::text, ',' order by week) as weeks,
  string_agg(overshooters::text, ',' order by week) as overshooters,
   string_agg(cells::text, ',' order by week) as cells,
    string_agg(non_overshooters::text, ',' order by week) as non_overshooters,
     string_agg(overshooters_portion::text, ',' order by week) as overshooters_portion,
      string_agg(non_overshooters_portion::text, ',' order by week) as non_overshooters_portion,
       string_agg(score::text, ',' order by week) as score FROM common_gis.weekly_overshooters_count_by_region 
       where (year,week) in ((2017,11),(2017,12),(2017,13),(2017,14)) group by regional ;