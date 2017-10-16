SELECT distinct date_part('year'::text, date) AS year,
    date_part('week'::text, date + '1 day'::interval) AS week,
    cidade,
	cluster,
	round(COALESCE(sum(cell_downlink_avg_thp_num) FILTER (WHERE bandwidth='20M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) / NULLIF(sum(cell_downlink_avg_thp_den) FILTER (WHERE bandwidth='20M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster), 0::real) /1000, 0::real)::numeric, 2) AS downlink_avg_thp_20M,
	round(COALESCE(sum(cell_downlink_avg_thp_num) FILTER (WHERE bandwidth='15M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) / NULLIF(sum(cell_downlink_avg_thp_den) FILTER (WHERE bandwidth='15M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster), 0::real) /1000, 0::real)::numeric, 2) AS downlink_avg_thp_15M,
	round(COALESCE(sum(cell_downlink_avg_thp_num) FILTER (WHERE bandwidth='10M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) / NULLIF(sum(cell_downlink_avg_thp_den) FILTER (WHERE bandwidth='10M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster), 0::real) /1000, 0::real)::numeric, 2) AS downlink_avg_thp_10M,
   round(COALESCE(sum(cell_downlink_avg_thp_num) FILTER (WHERE bandwidth='5M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) / NULLIF(sum(cell_downlink_avg_thp_den) FILTER (WHERE bandwidth='5M') over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster), 0::real) /1000, 0::real)::numeric, 2) AS downlink_avg_thp_5M
   FROM lte_kpi.main_kpis_lte_daily a
     JOIN lte_control.cells ON a.enodeb = cells.site AND a.locellid = cells.cellid

     where cidade = 'SALVADOR' and date >= '2017-03-12' order by cluster, week
	 
	