copy (SELECT n.year, n.week, n.region, n.rnc, n.nodebname, n.node, qda_cs, 
       qda_ps_f2h as qda_hs, qdr_cs, qdr_ps qdr_ps, throughput, n.availability, retention_cs, 
       retention_ps, hsdpa_users_ratio, m.rtwp, nqi_cs, nqi_ps_f2h nqi_hs,
case when (qda_ps_f2h >= 90 and qdr_ps >=95  and retention_ps = 100 and n.availability>=99.5 and qda_cs >=92 and qdr_cs>=92 and m.rtwp <=-90) then 'OK' else 'NOK' end as kpi,  
CASE when n.availability>=99.5 then 'OK' ELSE 'NOK' end as status_availability,
null as "Uncleared Alarms",
null as Note,
case when (n.availability<99.5) then 'NOK' else 'OK' end omr,
t.ping_meandelay,
t.ping_meanjitter,
t.ping_meanlost,
null as note,
case when (t.tx_integrity >= 80) then 'NOK' else 'OK' end "TX/OMR",
case when (e.ee > 22 and e.balanced = 'NOK') then 'NOK' else 'OK' end as ee_balanced,
case when (o.count > 0 and o.count is not null) then 'NOK' else 'OK' end as no_overshooter,
o.count as covered_sites_count, 
o.covered_sites, 
null as parameter_check,
case when ((e.ee > 22 and e.balanced = 'NOK') or (o.count > 0 and o.count is not null) or m.rtwp > -90) then 'NOK' else 'OK' end otm,
 u.code_utilization, 
 u.dlpower_utilization,
 u.user_fach_utilization,
 u.rach_utilization,
 u.pch_utilization,
 u.cnbap_utilization,
 u.dlce_utilization,
 u.ulce_utilization,
case when (u.code_utilization >= 70::real or u.dlpower_utilization >= 70::real or u.user_fach_utilization >= 70::real or u.rach_utilization >= 70::real or u.pch_utilization >= 60::real or u.cnbap_utilization >= 60::real or u.dlce_utilization >= 70::real or u.ulce_utilization >= 70::real or i.status = 'NOK') then 'NOK' else 'OK' end as capacity,
i.wbbp_total,
i.status as status_board
FROM umts_kpi.vw_nqi_weekly_cell_2 n 
left join umts_capacity.vw_utilization_weekly u on n.rnc=u.rnc and n.cellid = u.cellid and n.year = u.year and n.week = u.week
left join ee_unbalance e on n.rnc = e.rnc and n.cellid = e.cellid
left join common_gis.cell_overshooters o on n.rnc = o.rnc and n.cellid = o.cellid and n.year = o.year and n.week = o.week
left join umts_kpi.vw_main_kpis_cell_rate_weekly m on n.rnc = m.rnc and n.cellid = m.cellid and n.year = m.year and n.week = m.week
left join umts_kpi.vw_tx_integrity t on n.nodebname = t.node
left join umts_inventory.insufficient_bbps i on n.nodeb = i.nodebname_normalized
  where n.year = 2017 and n.week = 10
) to '/home/postgres/dump/w10_triagem.csv' delimiter ';' csv header		
