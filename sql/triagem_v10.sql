COPY	(SELECT DISTINCT ON (node) * ,

-- -- Area/Status
	CASE	WHEN kpi = 'OK' AND omr = 'OK' AND "TX/OMR" = 'OK' AND otm = 'OK' AND capacity = 'OK' AND "PLAN/ENG RF" = 'OK' THEN 'NORMAL'
		WHEN omr = 'NOK' THEN 'OMR'
		WHEN "TX/OMR" = 'NOK' THEN 'TX/OMR'
		WHEN otm = 'NOK' THEN 'OTM'
		WHEN capacity = 'NOK' AND "NP Action Found?" = 'No' THEN 'CAP'
		WHEN status_board = 'NOK' AND "NP Action Found?" = 'No' THEN 'PLAN/ENG RF'
		WHEN capacity = 'NOK' AND "NP Action Found?" = 'Yes' THEN 'IMP'
		ELSE 'ANALYSIS'
	END AS area

-- -- Cell Info
	FROM (SELECT	n.year, n.week, n.region, n.rnc, n.nodebname, n.node,

-- -- KPI
	qda_cs,
	qda_ps_f2h AS qda_hs,
	qdr_cs,
	qdr_ps qdr_ps,
	throughput,
	n.availability,
	retention_cs,
	retention_ps,
	hsdpa_users_ratio,
	m.rtwp,
	nqi_cs,
	nqi_ps_f2h nqi_hs,
	CASE 	WHEN	(qda_ps_f2h >= 90 AND qdr_ps >= 95  AND retention_ps = 100 AND n.availability >= 99.5 AND qda_cs >= 92
			AND qdr_cs >= 92 AND m.rtwp <= -90 AND retention_cs >= 99.5 AND hsdpa_users_ratio >= 99.5 AND throughput >= 92)
			THEN 'OK' ELSE 'NOK'
	END AS kpi,

-- -- wbbp_total
	i.wbbp_total,

-- -- OMR
	CASE WHEN n.availability >= 99.5 THEN 'OK' ELSE 'NOK' END AS status_availability,
	alarm.alarmname AS "Uncleared Alarms",
	alarm.tipo AS Note,
	CASE WHEN (n.availability < 99.5) OR alarm.nodeb IS NOT NULL THEN 'NOK' ELSE 'OK' END omr,

-- -- TX/OMR
	t.transt AS tx_type,
	t.ping_meandelay,
	t.ping_meanjitter,
	t.ping_meanlost,
	t.vs_iub_flowctrol_dl_dropnum_lgcport1,
	t.vs_iub_flowctrol_ul_dropnum_lgcport1,
	t.vs_iub_flowctrol_dl_congtime_lgcport1,
	t.vs_iub_flowctrol_ul_congtime_lgcport1,
	t.atm_dl_utilization,t.atm_ul_utilization,
	t.tx_integrity,
	NULL AS note,
	CASE WHEN (t.tx_integrity < 92) THEN 'NOK' ELSE 'OK' end "TX/OMR",

-- -- OTM
	CASE WHEN m.rtwp <= -90 THEN 'OK' ELSE 'NOK' END AS rtwp_check,
	CASE WHEN (e.ee > 15 AND e.balanced = 'NOK') THEN 'NOK' ELSE 'OK' END AS ee_balanced, -- was e.ee > 22
	CASE WHEN (o.count > 0 AND o.count is not null) THEN 'NOK' ELSE 'OK' END AS no_overshooter,
	o.count AS covered_sites_count,
	o.covered_sites,
	COALESCE (b.status,'OK') AS parameter_check,
	b.mo_out AS mo_out,	
	CASE 	WHEN	((e.ee > 15 AND e.balanced = 'NOK') OR (o.count > 0 AND o.count IS NOT NULL) -- was e.ee > 22
			OR m.rtwp > -90
			OR (b.status = 'NOK')) THEN 'NOK' ELSE 'OK'
	END otm,
	
-- -- CAPACITY
	load_ee.ee AS ee,
	load_ee.load AS load,
	u.code_utilization, 
	u.dlpower_utilization,
	u.user_fach_utilization,
	u.rach_utilization,
	u.pch_utilization,
	u.cnbap_utilization,
	u.dlce_utilization,
	u.ulce_utilization,
	CASE 	WHEN	(u.code_utilization >= 70::REAL OR u.dlpower_utilization >= 70::REAL OR u.user_fach_utilization >= 70::REAL
			OR u.rach_utilization >= 70::REAL OR u.pch_utilization >= 60::REAL OR u.cnbap_utilization >= 60::REAL
			OR u.dlce_utilization >= 70::REAL OR u.ulce_utilization >= 70::REAL or load_ee.highly_loaded_cell=1) THEN 'NOK' ELSE 'OK'
	END AS capacity,

-- -- PLAN/ENG RF
	i.board_found,
	i.status AS status_board,
	CASE WHEN pn.site is null THEN 'No' ELSE 'Yes' END AS "NP Action Found?",
	pn.atividade AS "NP Solution",
	pn.solucao AS "Nota",
	CASE 	WHEN	(u.code_utilization >= 70::REAL OR u.dlpower_utilization >= 70::REAL OR u.user_fach_utilization >= 70::REAL
			OR u.rach_utilization >= 70::REAL OR u.pch_utilization >= 60::REAL OR u.cnbap_utilization >= 60::REAL
			OR u.dlce_utilization >= 70::REAL OR u.ulce_utilization >= 70::real) AND pn.site is null THEN 'NOK'
		WHEN	i.status = 'NOK' AND pn.site is null THEN 'NOK'
		ELSE 'OK'
	END AS "PLAN/ENG RF"

-- FROM TABLES:
-- -- n
	FROM umts_kpi.vw_nqi_weekly_cell_2 n
-- -- u
	LEFT JOIN umts_capacity.vw_utilization_weekly u ON n.rnc=u.rnc AND n.cellid = u.cellid AND n.year = u.year AND n.week = u.week
-- -- e
-- -- -- -- W__
	LEFT JOIN w36_ee e on n.rnc = e.rnc AND n.cellid = e.cellid
	LEFT JOIN w36_load_ee_v4 load_ee on n.rnc = load_ee.rnc AND n.cellid = load_ee.cellid
-- -- o
	LEFT JOIN common_gis.cell_overshooters_v2 o ON n.rnc = o.rnc AND n.cellid = o.cellid AND n.year = o.year AND n.week = o.week
-- -- m
	LEFT JOIN umts_kpi.vw_main_kpis_cell_rate_weekly m ON n.rnc = m.rnc AND n.cellid = m.cellid AND n.year = m.year AND n.week = m.week
-- -- t
-- -- -- -- W__
	LEFT JOIN (SELECT *,get_nodeb_name(node, 'nodeb') AS nodeb_norm  FROM w36_tx) t ON n.nodeb = t.nodeb_norm AND n.year = t.year AND n.week = t.week
-- -- i
	LEFT JOIN (SELECT DISTINCT ON (nodebname_normalized) * FROM umts_inventory.board_status_m2k) i ON n.nodeb = i.nodebname_normalized
-- -- alarm
	LEFT JOIN (SELECT nodeb, STRING_AGG(alarmname::TEXT, ',' ORDER BY occurrencetime) AS alarmname, STRING_AGG(netype::TEXT, ',' ORDER BY occurrencetime)
	netype, STRING_AGG(type::TEXT, ',' ORDER BY occurrencetime) tipo, STRING_AGG(severity::TEXT, ',' ORDER BY occurrencetime) severity,
	STRING_AGG(occurrencetime::TEXT, ',' ORDER BY occurrencetime) occurrencetime FROM (SELECT DISTINCT on (nodeb,alarmname)
	get_nodeb_name(alarm_source, 'nodeb'::TEXT) AS nodeb,* FROM alarm.alarm_log WHERE severity IN ('Major','Critical') AND locationinformation
	NOT LIKE '%eNodeB%' AND locationinformation NOT LIKE 'X2%' AND locationinformation NOT LIKE 'S1%') alarm GROUP BY nodeb) alarm on n.nodeb = alarm.nodeb
-- -- pn
	LEFT JOIN (SELECT site,STRING_AGG(semana_publicacao::TEXT, ',' ORDER BY semana_publicacao) AS semana_publicacao, STRING_AGG(tipo_solucao::TEXT, ','
	ORDER BY semana_publicacao) AS tipo_solucao, STRING_AGG(atividade::TEXT, ',' ORDER BY semana_publicacao) AS atividade, STRING_AGG(objetivo::TEXT, ','
	ORDER BY semana_publicacao) AS objetivo, STRING_AGG(comentario_solucao::TEXT, ',' ORDER BY semana_publicacao) AS solucao  FROM pn INNER JOIN pn_umts
	ON pn.atividade = pn_umts.solucao  WHERE tecnologia = '3G' GROUP BY site) pn ON RIGHT(n.nodeb,7) = pn.site
-- -- t
	LEFT JOIN (SELECT node,element_id,status, STRING_AGG(mo::TEXT, ',' ORDER BY mo) AS mo_out
	FROM (SELECT DISTINCT node,element_id,mo,status
	FROM umts_baseline.consistency_check_hist WHERE status = 'NOK' AND mo NOT IN ('UCELLLICENSE')) t -- AND baseline_date = '2017-07-21') t
-- -- t1
-- -- -- -- W__
	GROUP BY node,element_id,status) b ON n.rnc=b.node AND n.cellid::TEXT = b.element_id WHERE n.year = 2017 AND n.week = 36) t1

-- SAVE AT/SAVE AS:
-- -- -- -- W__
)	TO '/home/postgres/dump/w36_triage.csv' DELIMITER ';' CSV header