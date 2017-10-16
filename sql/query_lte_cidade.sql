COPY (SELECT a.year, b.week, a.region, a.cidade, a.nqi, b.cqi, b.downlink_avg_thp, b.uplink_avg_thp,"downlink_traffic_volume (GB)", b.average_user_volume, b.retention_4g
FROM
 (SELECT date_part('year'::text, nqi_daily.date) AS year,
    date_part('week'::text, nqi_daily.date + '1 day'::interval) AS week,
    cells.region,
    cidade,
    round((100::real * COALESCE(sum(nqi_daily.qda_good_attempts) / NULLIF(sum(nqi_daily.qda_good_attempts) + sum(nqi_daily.qda_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_good_attempts) / NULLIF(sum(nqi_daily.qdr_good_attempts) + sum(nqi_daily.qdr_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.availability_num) / NULLIF(sum(nqi_daily.availability_den), 0::real), 1::real)) * (1::double precision - COALESCE(sum(nqi_daily.retention_num) / NULLIF(sum(nqi_daily.retention_den), 0::real), 1::real)) * COALESCE(sum(nqi_daily.qde_dl_good_attempts) / NULLIF(sum(nqi_daily.qde_dl_good_attempts) + sum(nqi_daily.qde_dl_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qde_ul_good_attempts) / NULLIF(sum(nqi_daily.qde_ul_good_attempts) + sum(nqi_daily.qde_ul_bad_attempts), 0::real), 1::real))::numeric, 2) AS nqi
   FROM lte_kpi.nqi_daily
     JOIN lte_control.cells ON nqi_daily.enodeb = cells.site AND nqi_daily.locellid = cells.cellid

     where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR') and date > '2017-07-30'
  GROUP BY date_part('week'::text, nqi_daily.date + '1 day'::interval), date_part('year'::text, nqi_daily.date), cells.region,cidade) a

  JOIN
  (SELECT date_part('year'::text, main_kpis_lte_daily.date) AS year,
    date_part('week'::text, main_kpis_lte_daily.date + '1 day'::interval) AS week,
    cells.region,
    cidade,
    round((100::real * COALESCE (SUM(rrc_service_num) /
    NULLIF(SUM(rrc_service_den),0) ,1) *
    COALESCE (SUM(e_rab_num) /
    NULLIF(SUM(e_rab_den),0),1) *
    COALESCE(SUM(csfb_num) /
    NULLIF(SUM(csfb_den),0),1) *
    (1 -(COALESCE(SUM(service_drop_num) /
    NULLIF(SUM(service_drop_den),0),0))))::numeric, 2) AS cqi,
    round(COALESCE(sum(main_kpis_lte_daily.cell_downlink_avg_thp_num) / NULLIF(sum(main_kpis_lte_daily.cell_downlink_avg_thp_den), 0::real), 1::real)::numeric, 2) AS downlink_avg_thp,
    round(COALESCE(sum(main_kpis_lte_daily.cell_uplink_avg_thp_num) / NULLIF(sum(main_kpis_lte_daily.cell_uplink_avg_thp_den), 0::real), 1::real)::numeric, 2) AS uplink_avg_thp,
    sum(main_kpis_lte_daily.uplink_traffic_volume) AS uplink_traffic_volume,
    sum(main_kpis_lte_daily.average_user_volume) AS average_user_volume,
	sum(main_kpis_lte_daily.downlink_traffic_volume)/(8*1024*1024) AS "downlink_traffic_volume (GB)",
	round((100::real * (1::real - COALESCE(sum(retention_4g_num) / NULLIF(sum(retention_4g_den), 0::real), 1::real)))::numeric, 2) AS retention_4g
   
   FROM lte_kpi.main_kpis_lte_daily
     JOIN lte_control.cells ON main_kpis_lte_daily.enodeb = cells.site AND main_kpis_lte_daily.locellid = cells.cellid

     where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR') and date > '2017-07-30'
  GROUP BY date_part('week'::text, main_kpis_lte_daily.date + '1 day'::interval), date_part('year'::text, main_kpis_lte_daily.date), cells.region,cidade) b

ON a.year = b.year AND a.week = b.week AND a.cidade = b.cidade)
TO '/home/postgres/dump/lte_cidade_kpis_consolidado.csv' with csv
	header delimiter ';'