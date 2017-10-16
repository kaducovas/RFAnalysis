COPY(SELECT a.year, a.week, a.cidade, a.region, a.node, a.freq, nqi_cs, nqi_ps, cqi_umts_cs, cqi_umts_ps, thp_hsdpa, thp_hsupa, 
 hsdpa_users, hsupa_users, voice_traffic_dl/(1024*1024) "traffic_dl (GB)"
 
 FROM
 (SELECT date_part('year'::text, nqi_daily.date - '2 days'::interval) AS year,
    date_part('week'::text, nqi_daily.date + '1 day'::interval) AS week,cidade,
        CASE
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    split_part(carrier,'_',1)::integer freq,
    
    round((100::double precision * COALESCE(sum(nqi_daily.qda_cs_good_attempts) / NULLIF(sum(nqi_daily.qda_cs_good_attempts) + sum(nqi_daily.qda_cs_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_cs_good_attempts) / NULLIF(sum(nqi_daily.qdr_cs_good_attempts) + sum(nqi_daily.qdr_cs_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.retention_cs_num) / NULLIF(sum(nqi_daily.retention_cs_den), 0::real), 0::real)) * (1::double precision - sum(nqi_daily.unavailability) / sum(nqi_daily.gp::real / 30::real)))::numeric, 2) AS nqi_cs,
    round((100::double precision * COALESCE(sum(nqi_daily.qda_ps_good_attempts) / NULLIF(sum(nqi_daily.qda_ps_good_attempts) + sum(nqi_daily.qda_ps_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_ps_good_attempts) / NULLIF(sum(nqi_daily.qdr_ps_good_attempts) + sum(nqi_daily.qdr_ps_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.retention_ps_num) / NULLIF(sum(nqi_daily.retention_ps_den), 0::real), 0::real)) * (1::double precision - sum(nqi_daily.unavailability) / sum(nqi_daily.gp::real / 30::real)) * COALESCE(sum(nqi_daily.user_good_throughput) / NULLIF(sum(nqi_daily.user_good_throughput) + sum(nqi_daily.user_bad_throughput), 0::real), 1::real) * COALESCE(sum(nqi_daily.hsdpa_users) / NULLIF(sum(nqi_daily.hsdpa_users) + sum(nqi_daily.ps_nonhs_users), 0::real), 1::real))::numeric, 2) AS nqi_ps
   FROM umts_kpi.nqi_daily
     JOIN umts_control.cells_db u ON nqi_daily.rnc = u.rnc AND nqi_daily.cellid = u.cellid
	 where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR')  and date > '2017-07-01'
  GROUP BY date_part('week'::text, nqi_daily.date + '1 day'::interval),
        CASE
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, date_part('year'::text, nqi_daily.date - '2 days'::interval), cidade, split_part(carrier,'_',1)) a
	JOIN 
	(SELECT date_part('year'::text, main_kpis_daily.date - '2 days'::interval) AS year,
	date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week, cidade,split_part(carrier,'_',1)::integer freq,
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    split_part(carrier,'_',1)::integer,
	
	round((100 * COALESCE(SUM(acc_rrc_num) / NULLIF(SUM(acc_rrc_den), 0),1) *
    COALESCE(SUM(acc_cs_rab_num) / NULLIF(SUM(acc_cs_rab_den), 0), 1) *
    (1 - SUM(unavailtime) / (SUM(gp) * 60)::real) *
    (1 - COALESCE(SUM(drop_cs_num) / NULLIF(SUM(drop_cs_den), 0), 1)))::numeric, 2) cqi_umts_cs,

    round(((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real)) *
    (1 - SUM(unavailtime) / (SUM(gp) * 60)::real) *
    (1 - COALESCE(SUM(drop_ps_num) / NULLIF(SUM(drop_ps_den), 0), 1)))::numeric, 2) cqi_umts_ps,
	
	round((sum(main_kpis_daily.thp_hsdpa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsdpa,
    round((sum(main_kpis_daily.thp_hsupa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsupa,
	round(sum(main_kpis_daily.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_daily.hsupa_users)::numeric, 2) AS hsupa_users,
	round(sum(main_kpis_daily.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl
    
   FROM umts_kpi.main_kpis_daily
     JOIN umts_control.cells_db u ON main_kpis_daily.rnc = u.rnc AND main_kpis_daily.cellid = u.cellid
	where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR')  and date > '2017-07-01'
     
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval),date_part('year'::text, main_kpis_daily.date - '2 days'::interval),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END,cidade,split_part(carrier,'_',1) ) b
	
	ON a.year = b.year AND a.week =b.week and a.cidade = b.cidade and a.node = b.node and a.freq = b.freq) 
	TO '/home/postgres/dump/umts_cidade_kpis.csv' with csv
	header delimiter ';'
	
	
-----------------------------------------------------

COPY (SELECT a.year, b.week, a.region, a.cidade, a.frequency, a.node, a.nqi, b.cqi, b.downlink_avg_thp, b.uplink_avg_thp,b.downlink_traffic_volume, b.average_user_volume
FROM
 (SELECT date_part('year'::text, nqi_daily.date) AS year,
    date_part('week'::text, nqi_daily.date + '1 day'::interval) AS week,
    cells.region,
    uf,
    cidade,
    frequency,
    right(nqi_daily.enodeb,7) node,
    round((100::real * COALESCE(sum(nqi_daily.qda_good_attempts) / NULLIF(sum(nqi_daily.qda_good_attempts) + sum(nqi_daily.qda_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_good_attempts) / NULLIF(sum(nqi_daily.qdr_good_attempts) + sum(nqi_daily.qdr_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.availability_num) / NULLIF(sum(nqi_daily.availability_den), 0::real), 1::real)) * (1::double precision - COALESCE(sum(nqi_daily.retention_num) / NULLIF(sum(nqi_daily.retention_den), 0::real), 1::real)) * COALESCE(sum(nqi_daily.qde_dl_good_attempts) / NULLIF(sum(nqi_daily.qde_dl_good_attempts) + sum(nqi_daily.qde_dl_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qde_ul_good_attempts) / NULLIF(sum(nqi_daily.qde_ul_good_attempts) + sum(nqi_daily.qde_ul_bad_attempts), 0::real), 1::real))::numeric, 2) AS nqi
   FROM lte_kpi.nqi_daily
     JOIN lte_control.cells ON nqi_daily.enodeb = cells.site AND nqi_daily.locellid = cells.cellid

     where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR') and date > '2017-07-01'
  GROUP BY date_part('week'::text, nqi_daily.date + '1 day'::interval), date_part('year'::text, nqi_daily.date), right(nqi_daily.enodeb,7), cells.region,frequency,cidade,uf) a

  JOIN
  (SELECT date_part('year'::text, main_kpis_lte_daily.date) AS year,
    date_part('week'::text, main_kpis_lte_daily.date + '1 day'::interval) AS week,
    cells.region,
    uf,
    cidade,
    frequency,
    right(main_kpis_lte_daily.enodeb,7) node,
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
    sum(main_kpis_lte_daily.downlink_traffic_volume) AS downlink_traffic_volume,
    sum(main_kpis_lte_daily.uplink_traffic_volume) AS uplink_traffic_volume,
    sum(main_kpis_lte_daily.average_user_volume) AS average_user_volume
   FROM lte_kpi.main_kpis_lte_daily
     JOIN lte_control.cells ON main_kpis_lte_daily.enodeb = cells.site AND main_kpis_lte_daily.locellid = cells.cellid

     where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR') and date > '2017-07-01'
  GROUP BY date_part('week'::text, main_kpis_lte_daily.date + '1 day'::interval), date_part('year'::text, main_kpis_lte_daily.date), right(main_kpis_lte_daily.enodeb,7), cells.region,frequency,cidade,uf) b

ON a.year = b.year AND a.week = b.week AND a.frequency = b.frequency AND a.node = b.node)
TO '/home/postgres/dump/umts_node_kpis.csv' with csv
	header delimiter ';'
	
	
-----------------------------------------------------------------------------------------------------------

COPY(SELECT a.year, a.week, a.cidade, a.region, a, nqi_cs, nqi_ps, cqi_umts_cs, cqi_umts_ps, thp_hsdpa, thp_hsupa, 
 hsdpa_users, hsupa_users, voice_traffic_dl/(1024*1024) "traffic_dl (GB)"
 
 FROM
 (SELECT date_part('year'::text, nqi_daily.date - '2 days'::interval) AS year,
    date_part('week'::text, nqi_daily.date + '1 day'::interval) AS week,cidade,
        CASE
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    
    round((100::double precision * COALESCE(sum(nqi_daily.qda_cs_good_attempts) / NULLIF(sum(nqi_daily.qda_cs_good_attempts) + sum(nqi_daily.qda_cs_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_cs_good_attempts) / NULLIF(sum(nqi_daily.qdr_cs_good_attempts) + sum(nqi_daily.qdr_cs_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.retention_cs_num) / NULLIF(sum(nqi_daily.retention_cs_den), 0::real), 0::real)) * (1::double precision - sum(nqi_daily.unavailability) / sum(nqi_daily.gp::real / 30::real)))::numeric, 2) AS nqi_cs,
    round((100::double precision * COALESCE(sum(nqi_daily.qda_ps_good_attempts) / NULLIF(sum(nqi_daily.qda_ps_good_attempts) + sum(nqi_daily.qda_ps_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_ps_good_attempts) / NULLIF(sum(nqi_daily.qdr_ps_good_attempts) + sum(nqi_daily.qdr_ps_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.retention_ps_num) / NULLIF(sum(nqi_daily.retention_ps_den), 0::real), 0::real)) * (1::double precision - sum(nqi_daily.unavailability) / sum(nqi_daily.gp::real / 30::real)) * COALESCE(sum(nqi_daily.user_good_throughput) / NULLIF(sum(nqi_daily.user_good_throughput) + sum(nqi_daily.user_bad_throughput), 0::real), 1::real) * COALESCE(sum(nqi_daily.hsdpa_users) / NULLIF(sum(nqi_daily.hsdpa_users) + sum(nqi_daily.ps_nonhs_users), 0::real), 1::real))::numeric, 2) AS nqi_ps
   FROM umts_kpi.nqi_daily
     JOIN umts_control.cells_db u ON nqi_daily.rnc = u.rnc AND nqi_daily.cellid = u.cellid
	 where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR')  and date > '2016-07-01'
  GROUP BY date_part('week'::text, nqi_daily.date + '1 day'::interval),
        CASE
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(nqi_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, date_part('year'::text, nqi_daily.date - '2 days'::interval), cidade) a
	JOIN 
	(SELECT date_part('year'::text, main_kpis_daily.date - '2 days'::interval) AS year,
	date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week, cidade,
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
	
	round((100 * COALESCE(SUM(acc_rrc_num) / NULLIF(SUM(acc_rrc_den), 0),1) *
    COALESCE(SUM(acc_cs_rab_num) / NULLIF(SUM(acc_cs_rab_den), 0), 1) *
    (1 - SUM(unavailtime) / (SUM(gp) * 60)::real) *
    (1 - COALESCE(SUM(drop_cs_num) / NULLIF(SUM(drop_cs_den), 0), 1)))::numeric, 2) cqi_umts_cs,

    round(((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real)) *
    (1 - SUM(unavailtime) / (SUM(gp) * 60)::real) *
    (1 - COALESCE(SUM(drop_ps_num) / NULLIF(SUM(drop_ps_den), 0), 1)))::numeric, 2) cqi_umts_ps,
	
	round((sum(main_kpis_daily.thp_hsdpa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsdpa,
    round((sum(main_kpis_daily.thp_hsupa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsupa,
	round(sum(main_kpis_daily.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_daily.hsupa_users)::numeric, 2) AS hsupa_users,
	round(sum(main_kpis_daily.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl
    
   FROM umts_kpi.main_kpis_daily
     JOIN umts_control.cells_db u ON main_kpis_daily.rnc = u.rnc AND main_kpis_daily.cellid = u.cellid
	where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR')  and date > '2016-07-01'
     
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval),date_part('year'::text, main_kpis_daily.date - '2 days'::interval),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END,cidade) b
	
	ON a.year = b.year AND a.week =b.week and a.cidade = b.cidade) 
	TO '/home/postgres/dump/umts_cidade_kpis_consolidado.csv' with csv
	header delimiter ';'
	
---------------------------------------------------------------------------------------------------------

COPY (SELECT a.year, b.week, a.region, a.cidade, a.nqi, b.cqi, b.downlink_avg_thp, b.uplink_avg_thp,b.downlink_traffic_volume/ (1024*1024) "downlink_traffic_volume (T)", b.average_user_volume
FROM
 (SELECT date_part('year'::text, nqi_daily.date) AS year,
    date_part('week'::text, nqi_daily.date + '1 day'::interval) AS week,
    cells.region,
    cidade,
    round((100::real * COALESCE(sum(nqi_daily.qda_good_attempts) / NULLIF(sum(nqi_daily.qda_good_attempts) + sum(nqi_daily.qda_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_good_attempts) / NULLIF(sum(nqi_daily.qdr_good_attempts) + sum(nqi_daily.qdr_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.availability_num) / NULLIF(sum(nqi_daily.availability_den), 0::real), 1::real)) * (1::double precision - COALESCE(sum(nqi_daily.retention_num) / NULLIF(sum(nqi_daily.retention_den), 0::real), 1::real)) * COALESCE(sum(nqi_daily.qde_dl_good_attempts) / NULLIF(sum(nqi_daily.qde_dl_good_attempts) + sum(nqi_daily.qde_dl_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qde_ul_good_attempts) / NULLIF(sum(nqi_daily.qde_ul_good_attempts) + sum(nqi_daily.qde_ul_bad_attempts), 0::real), 1::real))::numeric, 2) AS nqi
   FROM lte_kpi.nqi_daily
     JOIN lte_control.cells ON nqi_daily.enodeb = cells.site AND nqi_daily.locellid = cells.cellid

     where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR') and date > '2016-07-01'
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
    sum(main_kpis_lte_daily.downlink_traffic_volume) AS downlink_traffic_volume,
    sum(main_kpis_lte_daily.uplink_traffic_volume) AS uplink_traffic_volume,
    sum(main_kpis_lte_daily.average_user_volume) AS average_user_volume
   FROM lte_kpi.main_kpis_lte_daily
     JOIN lte_control.cells ON main_kpis_lte_daily.enodeb = cells.site AND main_kpis_lte_daily.locellid = cells.cellid

     where cidade in ('RECIFE','CURITIBA','FLORIANÓPOLIS','BELO HORIZONTE','SALVADOR') and date > '2016-07-01'
  GROUP BY date_part('week'::text, main_kpis_lte_daily.date + '1 day'::interval), date_part('year'::text, main_kpis_lte_daily.date), cells.region,cidade) b

ON a.year = b.year AND a.week = b.week AND ,a.cidade = b.cidade)
TO '/home/postgres/dump/lte_cidade_kpis_consolidado.csv' with csv
	header delimiter ';'
