    --1-- create table with the specified perior
    create table thp_20161006 as 
    SELECT nodeb, locell, datetime, vs_hsdpa_all_schedulednum, vs_hsdpa_dataoutput_traffic, 
           vs_hsupa_traffic_trb, vs_hsupa_2mstti_traffic, vs_hsupa_10mstti_traffic, 
           vs_hsupa_2mspdu_tti_num, vs_hsupa_10mspdu_tti_num, vs_hsdpa_datattinum_user
      FROM npm_reports.vw_thp_tti2ms_locell
    where datetime = '2016-10-06 18:00:00';

copy (SELECT regional,nodeb,date_part('week'::text, datetime::date + '1 day'::interval) AS week,    
      case when SUM(vs_hsdpa_datattinum_user) IS NULL then 0 else 1 end as vs_hsdpa_datattinum_user, 
      case WHEN SUM(vs_hsdpa_dataoutput_traffic) IS NULL then 0 else 1 end as vs_hsdpa_dataoutput_traffic
  FROM public.thp_20161006 inner join (select distinct "NODEB","REGIONAL" AS REGIONAL,"RNC","LOCELL" from common_gis.cell_database) t on right(nodeb,7) = "NODEB" and locell = "LOCELL" 
  --where DATETIME = '2016/07/22 18:00:00'
  group by regional,nodeb,date_part('week'::text, datetime::date + '1 day'::interval)
  order by regional,nodeb) to '/home/postgres/dump/20161006thp_nodeb_counter_enable.csv' delimiter ',' csv header;
  
  drop table thp_20161006;