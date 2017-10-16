SELECT distinct date_part('year'::text, date) AS year,
    date_part('week'::text, date + '1 day'::interval) AS week,
    cidade,
	cluster,
	round(COALESCE(sum(cell_downlink_avg_thp_num) over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) / NULLIF(sum(cell_downlink_avg_thp_den) over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster), 0::real), 0::real)::numeric, 2) AS "SUM downlink_avg_thp (Kbps)",
	sum(average_user_volume) FILTER (WHERE frequency=2600) over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) AS average_user_volume_2600,
	sum(average_user_volume) FILTER (WHERE frequency=1800) over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) AS average_user_volume_1800,
	sum(average_user_volume) FILTER (WHERE frequency=700) over (partition by date_part('week'::text, date + '1 day'::interval), date_part('year'::text, date), cidade,cluster) AS average_user_volume_700
	FROM lte_kpi.main_kpis_lte_daily a
     JOIN lte_control.cells ON a.enodeb = site AND a.locellid = cellid

     where cidade = 'SALVADOR' and cluster is not null and date >= '2017-03-12' order by cluster, week