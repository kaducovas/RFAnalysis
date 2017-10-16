SELECT n.year, n.week, n.region, n.rnc, n.nodeb,n.nodebname, n.node, n.cellid,n.node, qda_cs, qda_ps, 
       qda_ps_f2h, qdr_cs, qdr_ps, throughput, n.availability, retention_cs, 
       retention_ps, hsdpa_users_ratio, nqi_cs, nqi_ps, nqi_ps_f2h,m.rtwp, 

CASE when qda_ps_f2h >= 92 then 'OK' ELSE 'NOK' end as status_qda_ps_f2h,
CASE when qdr_ps >=95 then 'OK' ELSE 'NOK' end as status_qdr_ps,
CASE when retention_ps = 100 then 'OK' ELSE 'NOK' end as status_retention_ps,
CASE when n.availability>=99.5 then 'OK' ELSE 'NOK' end as status_availability,
CASE when throughput>=92 then 'OK' ELSE 'NOK' end as status_throughput,
CASE when hsdpa_users>=99.5 then 'OK' ELSE 'NOK' end as status_hsdpa_users,
CASE when nqi_ps_f2h>=85 then 'OK' ELSE 'NOK' end as status_nqi_ps_f2h,
CASE when qda_cs >=90 then 'OK' ELSE 'NOK' end as status_qda_cs,
CASE when qdr_cs>=90 then 'OK' ELSE 'NOK' end as status_qdr_cs,
CASE when nqi_cs>=85 then 'OK' ELSE 'NOK' end as status_nqi_cs,
case when (qda_ps_f2h >= 92 and qdr_ps >=95  and retention_ps = 100 and n.availability>=99.5 and throughput>=92 and hsdpa_users>=99.5 and nqi_ps_f2h>=85 and qda_cs >=90 and qdr_cs>=90 and nqi_cs>=85) then 'OK' else 'NOK' end as nqi,  
case when m.rtwp > -90 then 'NOK' else 'OK' end as status_rtwp,
i.wbbp_total,
i.status as status_board,
 u.code_utilization, 
 u.dlpower_utilization,
 u.user_fach_utilization,
 u.rach_utilization,
 u.pch_utilization,
 u.cnbap_utilization,
 u.dlce_utilization,
 u.ulce_utilization,
 case when u.code_utilization >= 70::real then 'NOK' else 'OK' END status_code_utilization,
 case when u.dlpower_utilization >= 70::real then 'NOK' else 'OK' END status_dlpower_utilization,
 case when u.user_fach_utilization >= 70::real then 'NOK' else 'OK' END status_fach_utilization,  
 case when u.rach_utilization >= 70::real then 'NOK' else 'OK' END status_rach_utilization,
 case WHEN u.pch_utilization >= 60::real then 'NOK' else 'OK' END status_pch_utilization,
 case when u.cnbap_utilization >= 60::real then 'NOK' else 'OK' END status_cnbap_utilization,
 case when u.dlce_utilization >= 70::real then 'NOK' else 'OK' END status_dlce_utilization,                     
 case when u.ulce_utilization >= 70::real then 'NOK' else 'OK' END status_ulce_utilization,
case when (e.ee > 22 and e.balanced = 'NOK') then 'NOK' else 'OK' end as ee_balanced,
o.count as covered_sites_count, 
o.covered_sites, 
case when (o.count > 0 and o.count is not null) then 'NOK' else 'OK' end as overshooter,
t.comentario as tx_comment,
t.status as status_tx,
case when (u.code_utilization >= 70::real or u.dlpower_utilization >= 70::real or u.user_fach_utilization >= 70::real or u.rach_utilization >= 70::real or u.pch_utilization >= 60::real or u.cnbap_utilization >= 60::real or u.dlce_utilization >= 70::real or u.ulce_utilization >= 70::real or i.status = 'NOK') then 'NOK' else 'OK' end as capacity,
case when ((e.ee > 22 and e.balanced = 'NOK') or (o.count > 0 and o.count is not null) or m.rtwp > -90) then 'NOK' else 'OK' end otm,
case when (n.availability<99.5 or t.status = 'OMR') then 'NOK' else 'OK' end omr
FROM umts_kpi.vw_nqi_weekly_cell_2 n 
left join umts_capacity.vw_utilization_weekly u on n.rnc=u.rnc and n.cellid = u.cellid and n.year = u.year and n.week = u.week
left join ee_unbalance e on n.rnc = e.rnc and n.cellid = e.cellid
left join w6weekly_overshooters o on n.rnc = o.rnc and n.cellid = o.cellid
left join umts_kpi.vw_main_kpis_cell_rate_weekly m on n.rnc = m.rnc and n.cellid = m.cellid and n.year = m.year and n.week = m.week
left join tx_co t on n.nodebname = t.node
left join umts_inventory.insufficient_bbps i on n.nodeb = i.nodebname_normalized
  where n.year = 2017 and n.week = 6
and n.region = 'CO'