COPY(SELECT a.year, a.week, a.cidade, a.region, a.node, a.freq, nqi_cs, nqi_ps, cqi_umts_cs, cqi_umts_ps, thp_hsdpa, thp_hsupa, 
 hsdpa_users, hsupa_users, voice_traffic_dl traffic_dl
 
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
    nqi_daily.rnc,
    right(u.nodeb,7) AS node,
    split_part(carrier,'_',1)::integer freq,
    
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
        END, nqi_daily.rnc, u.nodeb, date_part('year'::text, nqi_daily.date - '2 days'::interval), cidade, split_part(carrier,'_',1)) a
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
    main_kpis_daily.rnc,
    right(u.nodebname,7) AS node,
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
        END, main_kpis_daily.rnc, u.nodebname, cidade,split_part(carrier,'_',1) ) b
	
	ON a.year = b.year AND a.week =b.week and a.cidade = b.cidade and a.node = b.node and a.freq = b.freq) 
	TO '/home/postgres/dump/umts_node_kpis.csv' with csv
	header delimiter ';'