SELECT distinct date_part('year'::text, main_kpis_lte_daily.date) AS year,
    date_part('week'::text, main_kpis_lte_daily.date + '1 day'::interval) AS week,
    cidade,
	cluster,
	round(COALESCE(sum(cell_downlink_avg_thp_num)  / NULLIF(sum(cell_downlink_avg_thp_den) , 0::real) / 1000, 0::real)::numeric, 2) AS "THP (MB)",
	(sum(downlink_traffic_volume) + sum(uplink_traffic_volume)) /(8*1000*1000) AS "volume total(GB)"
   FROM lte_kpi.main_kpis_lte_daily
     JOIN lte_control.cells ON main_kpis_lte_daily.enodeb = cells.site AND main_kpis_lte_daily.locellid = cells.cellid

     where cidade = 'SALVADOR' and cluster is not null and date >= '2017-03-12'
	 
	 GROUP BY date_part('year'::text, main_kpis_lte_daily.date), 
	 date_part('week'::text, main_kpis_lte_daily.date + '1 day'::interval),
	 cidade, cluster