-- View: umts_kpi.vw_main_kpis_cell_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_cell_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cell_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week,
    main_kpis_daily.date,
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
    u.nodebname,
    main_kpis_daily.cellid,
    u.cellname AS node,
    round((100::real * COALESCE(main_kpis_daily.acc_rrc_num / NULLIF(main_kpis_daily.acc_rrc_den, 0::real), 1::real))::numeric, 2) AS acc_rrc,
    main_kpis_daily.acc_rrc_den - main_kpis_daily.acc_rrc_num AS fails_acc_rrc,
    round((100::real * COALESCE(main_kpis_daily.acc_cs_rab_num / NULLIF(main_kpis_daily.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS eff_cs,
    main_kpis_daily.acc_cs_rab_den - main_kpis_daily.acc_cs_rab_num AS fails_acc_cs,
    round((100::real * COALESCE(main_kpis_daily.acc_rrc_num / NULLIF(main_kpis_daily.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_daily.acc_cs_rab_num / NULLIF(main_kpis_daily.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(main_kpis_daily.acc_ps_rab_num / NULLIF(main_kpis_daily.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS eff_ps,
    main_kpis_daily.acc_ps_rab_den - main_kpis_daily.acc_ps_rab_num AS fails_acc_ps,
    round((100::real * COALESCE(main_kpis_daily.acc_rrc_num / NULLIF(main_kpis_daily.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_daily.acc_ps_rab_num / NULLIF(main_kpis_daily.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(main_kpis_daily.acc_hs_num / NULLIF(main_kpis_daily.acc_hs_den, 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    main_kpis_daily.acc_hs_den - main_kpis_daily.acc_hs_num AS fails_acc_hsdpa,
    round((100::real * COALESCE(main_kpis_daily.acc_hs_f2h_num / NULLIF(main_kpis_daily.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS eff_f2h,
    main_kpis_daily.acc_hs_f2h_den - main_kpis_daily.acc_hs_f2h_num AS fails_f2h,
    round((100::real * COALESCE(main_kpis_daily.acc_rrc_num / NULLIF(main_kpis_daily.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_daily.acc_hs_num / NULLIF(main_kpis_daily.acc_hs_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(main_kpis_daily.acc_rrc_num / NULLIF(main_kpis_daily.acc_rrc_den, 0::real), 1::real) * COALESCE((main_kpis_daily.acc_hs_num + main_kpis_daily.acc_hs_f2h_num) / NULLIF(main_kpis_daily.acc_hs_den + main_kpis_daily.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(main_kpis_daily.drop_cs_num / NULLIF(main_kpis_daily.drop_cs_den, 0::real), 1::real)))::numeric, 2) AS drop_cs,
    main_kpis_daily.drop_cs_den AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(main_kpis_daily.drop_ps_num / NULLIF(main_kpis_daily.drop_ps_den, 0::real), 1::real)))::numeric, 2) AS drop_ps,
    main_kpis_daily.drop_ps_den AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(main_kpis_daily.drop_hsdpa_num / NULLIF(main_kpis_daily.drop_hsdpa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    main_kpis_daily.drop_hsdpa_den AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(main_kpis_daily.drop_hsupa_num / NULLIF(main_kpis_daily.drop_hsupa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    main_kpis_daily.drop_hsupa_den AS fails_drop_hsupa,
    round((100::real * COALESCE(main_kpis_daily.sho_succ_rate_num / NULLIF(main_kpis_daily.sho_succ_rate_den, 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(main_kpis_daily.soft_hand_succ_rate_num / NULLIF(main_kpis_daily.soft_hand_succ_rate_den, 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(main_kpis_daily.hho_intra_freq_succ_num / NULLIF(main_kpis_daily.hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_daily.cs_hho_intra_freq_succ_num / NULLIF(main_kpis_daily.cs_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(main_kpis_daily.ps_hho_intra_freq_succ_num / NULLIF(main_kpis_daily.ps_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_daily.hho_inter_freq_succ_num / NULLIF(main_kpis_daily.hho_inter_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_daily.iratho_cs_succ_num / NULLIF(main_kpis_daily.iratho_cs_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(main_kpis_daily.iratho_ps_succ_num / NULLIF(main_kpis_daily.iratho_ps_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_daily.retention_cs_num / NULLIF(main_kpis_daily.retention_cs_den, 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_daily.retention_ps_num / NULLIF(main_kpis_daily.retention_ps_den, 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(main_kpis_daily.sho_over_num / NULLIF(main_kpis_daily.sho_over_den, 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    main_kpis_daily.rtwp,
    round((100::real * (1::double precision - (main_kpis_daily.unavailtime / (main_kpis_daily.gp * 60)::double precision)::real))::numeric, 2) AS availability,
    main_kpis_daily.data_hsdpa,
    main_kpis_daily.data_hsupa,
    main_kpis_daily.ps_r99_ul,
    main_kpis_daily.ps_r99_dl,
    main_kpis_daily.voice_traffic_dl,
    main_kpis_daily.voice_traffic_ul,
    main_kpis_daily.voice_erlangs_num,
    main_kpis_daily.voice_erlangs_den,
    main_kpis_daily.hsdpa_users,
    main_kpis_daily.hsupa_users,
    main_kpis_daily.dch_users,
    main_kpis_daily.pch_users,
    main_kpis_daily.fach_users,
    main_kpis_daily.ps_nonhs_users,
    round((main_kpis_daily.thp_hsdpa / (main_kpis_daily.gp::real / 30::double precision))::numeric, 2)::real AS thp_hsdpa,
    round((main_kpis_daily.thp_hsupa / (main_kpis_daily.gp::real / 30::double precision))::numeric, 2)::real AS thp_hsupa
   FROM umts_kpi.main_kpis_daily
     JOIN umts_configuration.ucellsetup u ON main_kpis_daily.rnc = u.rncname AND main_kpis_daily.cellid = u.cellid;

ALTER TABLE umts_kpi.vw_main_kpis_cell_rate_daily
  OWNER TO postgres;

  ------------------------------------------------
  -- View: umts_kpi.vw_main_kpis_cell_rate_daily_2

-- DROP VIEW umts_kpi.vw_main_kpis_cell_rate_daily_2;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cell_rate_daily_2 AS 
 SELECT date_part('week'::text, main_kpis.datetime::date + '1 day'::interval) AS week,
    main_kpis.datetime::date AS date,
        CASE
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis.rnc,
    "left"(main_kpis.cellname, 8) AS nodeb,
    main_kpis.cellid,
    main_kpis.cellname AS node,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis.acc_rrc_den) - sum(main_kpis.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis.acc_cs_rab_num) / NULLIF(sum(main_kpis.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis.acc_cs_rab_den) - sum(main_kpis.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_cs_rab_num) / NULLIF(sum(main_kpis.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis.acc_ps_rab_num) / NULLIF(sum(main_kpis.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis.acc_ps_rab_den) - sum(main_kpis.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_ps_rab_num) / NULLIF(sum(main_kpis.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis.acc_hs_num) / NULLIF(sum(main_kpis.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis.acc_hs_den) - sum(main_kpis.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis.acc_hs_f2h_num) / NULLIF(sum(main_kpis.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis.acc_hs_f2h_den) - sum(main_kpis.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_hs_num) / NULLIF(sum(main_kpis.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis.acc_hs_num) + sum(main_kpis.acc_hs_f2h_num)) / NULLIF(sum(main_kpis.acc_hs_den) + sum(main_kpis.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_cs_num) / NULLIF(sum(main_kpis.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_ps_num) / NULLIF(sum(main_kpis.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_hsdpa_num) / NULLIF(sum(main_kpis.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_hsupa_num) / NULLIF(sum(main_kpis.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis.sho_succ_rate_num) / NULLIF(sum(main_kpis.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.iratho_cs_succ_num) / NULLIF(sum(main_kpis.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.iratho_ps_succ_num) / NULLIF(sum(main_kpis.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis.retention_cs_num) / NULLIF(sum(main_kpis.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis.retention_ps_num) / NULLIF(sum(main_kpis.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis.sho_over_num) / NULLIF(sum(main_kpis.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis.unavailtime) / (sum(main_kpis.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis
  GROUP BY date_part('week'::text, main_kpis.datetime::date + '1 day'::interval), main_kpis.datetime::date,
        CASE
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis.rnc, "left"(main_kpis.cellname, 8), main_kpis.cellname, main_kpis.cellid;

ALTER TABLE umts_kpi.vw_main_kpis_cell_rate_daily_2
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cell_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_cell_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cell_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis.datetime::date + '1 day'::interval) AS week,
    main_kpis.datetime AS date,
        CASE
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis.rnc,
    main_kpis.cellid,
    main_kpis.cellname AS node,
    round((100::real * COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real))::numeric, 2) AS acc_rrc,
    main_kpis.acc_rrc_den - main_kpis.acc_rrc_num AS fails_acc_rrc,
    round((100::real * COALESCE(main_kpis.acc_cs_rab_num / NULLIF(main_kpis.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS eff_cs,
    main_kpis.acc_cs_rab_den - main_kpis.acc_cs_rab_num AS fails_acc_cs,
    round((100::real * COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_cs_rab_num / NULLIF(main_kpis.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(main_kpis.acc_ps_rab_num / NULLIF(main_kpis.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS eff_ps,
    main_kpis.acc_ps_rab_den - main_kpis.acc_ps_rab_num AS fails_acc_ps,
    round((100::real * COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_ps_rab_num / NULLIF(main_kpis.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(main_kpis.acc_hs_num / NULLIF(main_kpis.acc_hs_den, 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    main_kpis.acc_hs_den - main_kpis.acc_hs_num AS fails_acc_hsdpa,
    round((100::real * COALESCE(main_kpis.acc_hs_f2h_num / NULLIF(main_kpis.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS eff_f2h,
    main_kpis.acc_hs_f2h_den - main_kpis.acc_hs_f2h_num AS fails_f2h,
    round((100::real * COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_hs_num / NULLIF(main_kpis.acc_hs_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE((main_kpis.acc_hs_num + main_kpis.acc_hs_f2h_num) / NULLIF(main_kpis.acc_hs_den + main_kpis.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(main_kpis.drop_cs_num / NULLIF(main_kpis.drop_cs_den, 0::real), 0::real)))::numeric, 2) AS drop_cs,
    main_kpis.drop_cs_den AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(main_kpis.drop_ps_num / NULLIF(main_kpis.drop_ps_den, 0::real), 0::real)))::numeric, 2) AS drop_ps,
    main_kpis.drop_ps_den AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(main_kpis.drop_hsdpa_num / NULLIF(main_kpis.drop_hsdpa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    main_kpis.drop_hsdpa_den AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(main_kpis.drop_hsupa_num / NULLIF(main_kpis.drop_hsupa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    main_kpis.drop_hsupa_den AS fails_drop_hsupa,
    round((100::real * COALESCE(main_kpis.sho_succ_rate_num / NULLIF(main_kpis.sho_succ_rate_den, 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(main_kpis.soft_hand_succ_rate_num / NULLIF(main_kpis.soft_hand_succ_rate_den, 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(main_kpis.hho_intra_freq_succ_num / NULLIF(main_kpis.hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis.cs_hho_intra_freq_succ_num / NULLIF(main_kpis.cs_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(main_kpis.ps_hho_intra_freq_succ_num / NULLIF(main_kpis.ps_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis.hho_inter_freq_succ_num / NULLIF(main_kpis.hho_inter_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(main_kpis.iratho_cs_succ_num / NULLIF(main_kpis.iratho_cs_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(main_kpis.iratho_ps_succ_num / NULLIF(main_kpis.iratho_ps_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis.retention_cs_num / NULLIF(main_kpis.retention_cs_den, 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis.retention_ps_num / NULLIF(main_kpis.retention_ps_den, 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(main_kpis.sho_over_num / NULLIF(main_kpis.sho_over_den, 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    main_kpis.rtwp,
    round((100::real * (1::double precision - (main_kpis.unavailtime / (main_kpis.gp * 60)::double precision)::real))::numeric, 2) AS availability,
    main_kpis.data_hsdpa,
    main_kpis.data_hsupa,
    main_kpis.ps_r99_ul,
    main_kpis.ps_r99_dl,
    main_kpis.voice_traffic_dl,
    main_kpis.voice_traffic_ul,
    main_kpis.voice_erlangs_num,
    main_kpis.voice_erlangs_den,
    main_kpis.hsdpa_users,
    main_kpis.hsupa_users,
    main_kpis.dch_users,
    main_kpis.pch_users,
    main_kpis.fach_users,
    main_kpis.ps_nonhs_users,
    main_kpis.thp_hsdpa,
    main_kpis.thp_hsupa
   FROM umts_kpi.main_kpis;

ALTER TABLE umts_kpi.vw_main_kpis_cell_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cell_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_cell_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cell_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_daily.date) AS month,
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
    u.nodebname,
    main_kpis_daily.cellid,
    u.cellname AS node,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_daily.acc_rrc_den) - sum(main_kpis_daily.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_daily.acc_cs_rab_den) - sum(main_kpis_daily.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_daily.acc_ps_rab_den) - sum(main_kpis_daily.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_daily.acc_hs_den) - sum(main_kpis_daily.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_f2h_num) / NULLIF(sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_daily.acc_hs_f2h_den) - sum(main_kpis_daily.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_daily.acc_hs_num) + sum(main_kpis_daily.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_daily.acc_hs_den) + sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_cs_num) / NULLIF(sum(main_kpis_daily.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_daily.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_ps_num) / NULLIF(sum(main_kpis_daily.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_daily.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsdpa_num) / NULLIF(sum(main_kpis_daily.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_daily.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsupa_num) / NULLIF(sum(main_kpis_daily.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_daily.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_daily.sho_succ_rate_num) / NULLIF(sum(main_kpis_daily.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_daily.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_cs_succ_num) / NULLIF(sum(main_kpis_daily.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_ps_succ_num) / NULLIF(sum(main_kpis_daily.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_cs_num) / NULLIF(sum(main_kpis_daily.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_ps_num) / NULLIF(sum(main_kpis_daily.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_daily.sho_over_num) / NULLIF(sum(main_kpis_daily.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_daily.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_daily.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_daily.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_daily.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_daily.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_daily.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_daily.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_daily.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_daily.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_daily.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_daily.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_daily.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_daily.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_daily.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_daily.fach_users)::numeric, 2) AS fach_users,
    round((sum(main_kpis_daily.thp_hsdpa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsdpa,
    round((sum(main_kpis_daily.thp_hsupa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_daily
     JOIN umts_configuration.ucellsetup u ON main_kpis_daily.rnc = u.rncname AND main_kpis_daily.cellid = u.cellid
  GROUP BY date_part('month'::text, main_kpis_daily.date),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_daily.rnc, u.nodebname, main_kpis_daily.cellid, u.cellname;

ALTER TABLE umts_kpi.vw_main_kpis_cell_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cell_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_cell_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cell_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week,
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
    u.nodebname,
    main_kpis_daily.cellid,
    u.cellname AS node,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_daily.acc_rrc_den) - sum(main_kpis_daily.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_daily.acc_cs_rab_den) - sum(main_kpis_daily.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_daily.acc_ps_rab_den) - sum(main_kpis_daily.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_daily.acc_hs_den) - sum(main_kpis_daily.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_f2h_num) / NULLIF(sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_daily.acc_hs_f2h_den) - sum(main_kpis_daily.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_daily.acc_hs_num) + sum(main_kpis_daily.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_daily.acc_hs_den) + sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_cs_num) / NULLIF(sum(main_kpis_daily.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_daily.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_ps_num) / NULLIF(sum(main_kpis_daily.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_daily.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsdpa_num) / NULLIF(sum(main_kpis_daily.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_daily.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsupa_num) / NULLIF(sum(main_kpis_daily.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_daily.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_daily.sho_succ_rate_num) / NULLIF(sum(main_kpis_daily.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_daily.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_cs_succ_num) / NULLIF(sum(main_kpis_daily.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_ps_succ_num) / NULLIF(sum(main_kpis_daily.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_cs_num) / NULLIF(sum(main_kpis_daily.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_ps_num) / NULLIF(sum(main_kpis_daily.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_daily.sho_over_num) / NULLIF(sum(main_kpis_daily.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_daily.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_daily.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_daily.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_daily.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_daily.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_daily.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_daily.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_daily.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_daily.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_daily.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_daily.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_daily.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_daily.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_daily.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_daily.fach_users)::numeric, 2) AS fach_users,
    round((sum(main_kpis_daily.thp_hsdpa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsdpa,
    round((sum(main_kpis_daily.thp_hsupa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_daily
     JOIN umts_configuration.ucellsetup u ON main_kpis_daily.rnc = u.rncname AND main_kpis_daily.cellid = u.cellid
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_daily.rnc, u.nodebname, main_kpis_daily.cellid, u.cellname;

ALTER TABLE umts_kpi.vw_main_kpis_cell_rate_weekly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cidade_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_cidade_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cidade_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval) AS week,
    main_kpis_cidade.datetime::date AS date,
    main_kpis_cidade.uf,
    main_kpis_cidade.ibge,
    main_kpis_cidade.cidade AS node,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cidade.acc_rrc_den) - sum(main_kpis_cidade.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cidade.acc_cs_rab_den) - sum(main_kpis_cidade.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cidade.acc_ps_rab_den) - sum(main_kpis_cidade.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cidade.acc_hs_den) - sum(main_kpis_cidade.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cidade.acc_hs_f2h_den) - sum(main_kpis_cidade.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cidade.acc_hs_num) + sum(main_kpis_cidade.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cidade.acc_hs_den) + sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_cs_num) / NULLIF(sum(main_kpis_cidade.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cidade.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_ps_num) / NULLIF(sum(main_kpis_cidade.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cidade.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsdpa_num) / NULLIF(sum(main_kpis_cidade.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cidade.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsupa_num) / NULLIF(sum(main_kpis_cidade.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cidade.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cidade.sho_succ_rate_num) / NULLIF(sum(main_kpis_cidade.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cidade.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_cs_num) / NULLIF(sum(main_kpis_cidade.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_ps_num) / NULLIF(sum(main_kpis_cidade.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cidade.sho_over_num) / NULLIF(sum(main_kpis_cidade.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cidade.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cidade.unavailtime) / (sum(main_kpis_cidade.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cidade.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cidade.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cidade.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cidade.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cidade.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cidade.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cidade.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cidade.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cidade.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cidade.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cidade.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cidade.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cidade.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cidade.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cidade.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cidade.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cidade
  GROUP BY date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval), main_kpis_cidade.datetime::date, main_kpis_cidade.ibge, main_kpis_cidade.cidade, main_kpis_cidade.uf;

ALTER TABLE umts_kpi.vw_main_kpis_cidade_rate_daily
  OWNER TO postgres;


  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cidade_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_cidade_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cidade_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval) AS week,
    main_kpis_cidade.datetime AS date,
    main_kpis_cidade.uf,
    main_kpis_cidade.ibge,
    main_kpis_cidade.cidade AS node,
    round((100::real * COALESCE(main_kpis_cidade.acc_rrc_num / NULLIF(main_kpis_cidade.acc_rrc_den, 0::real), 1::real))::numeric, 2) AS acc_rrc,
    main_kpis_cidade.acc_rrc_den - main_kpis_cidade.acc_rrc_num AS fails_acc_rrc,
    round((100::real * COALESCE(main_kpis_cidade.acc_cs_rab_num / NULLIF(main_kpis_cidade.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS eff_cs,
    main_kpis_cidade.acc_cs_rab_den - main_kpis_cidade.acc_cs_rab_num AS fails_acc_cs,
    round((100::real * COALESCE(main_kpis_cidade.acc_rrc_num / NULLIF(main_kpis_cidade.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_cidade.acc_cs_rab_num / NULLIF(main_kpis_cidade.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(main_kpis_cidade.acc_ps_rab_num / NULLIF(main_kpis_cidade.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS eff_ps,
    main_kpis_cidade.acc_ps_rab_den - main_kpis_cidade.acc_ps_rab_num AS fails_acc_ps,
    round((100::real * COALESCE(main_kpis_cidade.acc_rrc_num / NULLIF(main_kpis_cidade.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_cidade.acc_ps_rab_num / NULLIF(main_kpis_cidade.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(main_kpis_cidade.acc_hs_num / NULLIF(main_kpis_cidade.acc_hs_den, 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    main_kpis_cidade.acc_hs_den - main_kpis_cidade.acc_hs_num AS fails_acc_hsdpa,
    round((100::real * COALESCE(main_kpis_cidade.acc_hs_f2h_num / NULLIF(main_kpis_cidade.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS eff_f2h,
    main_kpis_cidade.acc_hs_f2h_den - main_kpis_cidade.acc_hs_f2h_num AS fails_f2h,
    round((100::real * COALESCE(main_kpis_cidade.acc_rrc_num / NULLIF(main_kpis_cidade.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_cidade.acc_hs_num / NULLIF(main_kpis_cidade.acc_hs_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(main_kpis_cidade.acc_rrc_num / NULLIF(main_kpis_cidade.acc_rrc_den, 0::real), 1::real) * COALESCE((main_kpis_cidade.acc_hs_num + main_kpis_cidade.acc_hs_f2h_num) / NULLIF(main_kpis_cidade.acc_hs_den + main_kpis_cidade.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(main_kpis_cidade.drop_cs_num / NULLIF(main_kpis_cidade.drop_cs_den, 0::real), 0::real)))::numeric, 2) AS drop_cs,
    main_kpis_cidade.drop_cs_den AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(main_kpis_cidade.drop_ps_num / NULLIF(main_kpis_cidade.drop_ps_den, 0::real), 0::real)))::numeric, 2) AS drop_ps,
    main_kpis_cidade.drop_ps_den AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(main_kpis_cidade.drop_hsdpa_num / NULLIF(main_kpis_cidade.drop_hsdpa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    main_kpis_cidade.drop_hsdpa_den AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(main_kpis_cidade.drop_hsupa_num / NULLIF(main_kpis_cidade.drop_hsupa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    main_kpis_cidade.drop_hsupa_den AS fails_drop_hsupa,
    round((100::real * COALESCE(main_kpis_cidade.sho_succ_rate_num / NULLIF(main_kpis_cidade.sho_succ_rate_den, 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(main_kpis_cidade.soft_hand_succ_rate_num / NULLIF(main_kpis_cidade.soft_hand_succ_rate_den, 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(main_kpis_cidade.hho_intra_freq_succ_num / NULLIF(main_kpis_cidade.hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_cidade.cs_hho_intra_freq_succ_num / NULLIF(main_kpis_cidade.cs_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(main_kpis_cidade.ps_hho_intra_freq_succ_num / NULLIF(main_kpis_cidade.ps_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_cidade.hho_inter_freq_succ_num / NULLIF(main_kpis_cidade.hho_inter_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_cidade.iratho_cs_succ_num / NULLIF(main_kpis_cidade.iratho_cs_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(main_kpis_cidade.iratho_ps_succ_num / NULLIF(main_kpis_cidade.iratho_ps_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_cidade.retention_cs_num / NULLIF(main_kpis_cidade.retention_cs_den, 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_cidade.retention_ps_num / NULLIF(main_kpis_cidade.retention_ps_den, 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(main_kpis_cidade.sho_over_num / NULLIF(main_kpis_cidade.sho_over_den, 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    main_kpis_cidade.rtwp,
    round((100::real * (1::double precision - (main_kpis_cidade.unavailtime / (main_kpis_cidade.gp * 60)::double precision)::real))::numeric, 2) AS availability,
    main_kpis_cidade.data_hsdpa,
    main_kpis_cidade.data_hsupa,
    main_kpis_cidade.ps_r99_ul,
    main_kpis_cidade.ps_r99_dl,
    main_kpis_cidade.voice_traffic_dl,
    main_kpis_cidade.voice_traffic_ul,
    main_kpis_cidade.voice_erlangs_num,
    main_kpis_cidade.voice_erlangs_den,
    main_kpis_cidade.hsdpa_users,
    main_kpis_cidade.hsupa_users,
    main_kpis_cidade.dch_users,
    main_kpis_cidade.pch_users,
    main_kpis_cidade.fach_users,
    main_kpis_cidade.ps_nonhs_users,
    main_kpis_cidade.thp_hsdpa,
    main_kpis_cidade.thp_hsupa
   FROM umts_kpi.main_kpis_cidade;

ALTER TABLE umts_kpi.vw_main_kpis_cidade_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cidade_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_cidade_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cidade_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_cidade.datetime::date) AS month,
    main_kpis_cidade.uf,
    main_kpis_cidade.ibge,
    main_kpis_cidade.cidade AS node,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cidade.acc_rrc_den) - sum(main_kpis_cidade.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cidade.acc_cs_rab_den) - sum(main_kpis_cidade.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cidade.acc_ps_rab_den) - sum(main_kpis_cidade.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cidade.acc_hs_den) - sum(main_kpis_cidade.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cidade.acc_hs_f2h_den) - sum(main_kpis_cidade.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cidade.acc_hs_num) + sum(main_kpis_cidade.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cidade.acc_hs_den) + sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_cs_num) / NULLIF(sum(main_kpis_cidade.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cidade.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_ps_num) / NULLIF(sum(main_kpis_cidade.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cidade.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsdpa_num) / NULLIF(sum(main_kpis_cidade.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cidade.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsupa_num) / NULLIF(sum(main_kpis_cidade.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cidade.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cidade.sho_succ_rate_num) / NULLIF(sum(main_kpis_cidade.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cidade.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_cs_num) / NULLIF(sum(main_kpis_cidade.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_ps_num) / NULLIF(sum(main_kpis_cidade.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cidade.sho_over_num) / NULLIF(sum(main_kpis_cidade.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cidade.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cidade.unavailtime) / (sum(main_kpis_cidade.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cidade.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cidade.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cidade.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cidade.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cidade.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cidade.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cidade.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cidade.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cidade.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cidade.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cidade.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cidade.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cidade.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cidade.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cidade.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cidade.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cidade
  GROUP BY date_part('month'::text, main_kpis_cidade.datetime::date), main_kpis_cidade.ibge, main_kpis_cidade.cidade, main_kpis_cidade.uf;

ALTER TABLE umts_kpi.vw_main_kpis_cidade_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cidade_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_cidade_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cidade_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval) AS week,
    main_kpis_cidade.uf,
    main_kpis_cidade.ibge,
    main_kpis_cidade.cidade AS node,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cidade.acc_rrc_den) - sum(main_kpis_cidade.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cidade.acc_cs_rab_den) - sum(main_kpis_cidade.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cidade.acc_ps_rab_den) - sum(main_kpis_cidade.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cidade.acc_hs_den) - sum(main_kpis_cidade.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cidade.acc_hs_f2h_den) - sum(main_kpis_cidade.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cidade.acc_hs_num) + sum(main_kpis_cidade.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cidade.acc_hs_den) + sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_cs_num) / NULLIF(sum(main_kpis_cidade.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cidade.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_ps_num) / NULLIF(sum(main_kpis_cidade.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cidade.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsdpa_num) / NULLIF(sum(main_kpis_cidade.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cidade.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsupa_num) / NULLIF(sum(main_kpis_cidade.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cidade.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cidade.sho_succ_rate_num) / NULLIF(sum(main_kpis_cidade.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cidade.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_cs_num) / NULLIF(sum(main_kpis_cidade.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_ps_num) / NULLIF(sum(main_kpis_cidade.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cidade.sho_over_num) / NULLIF(sum(main_kpis_cidade.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cidade.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cidade.unavailtime) / (sum(main_kpis_cidade.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cidade.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cidade.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cidade.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cidade.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cidade.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cidade.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cidade.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cidade.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cidade.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cidade.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cidade.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cidade.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cidade.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cidade.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cidade.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cidade.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cidade
  GROUP BY date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval), main_kpis_cidade.ibge, main_kpis_cidade.cidade, main_kpis_cidade.uf;

ALTER TABLE umts_kpi.vw_main_kpis_cidade_rate_weekly
  OWNER TO postgres;


  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cluster_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_cluster_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cluster_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_cluster.datetime::date + '1 day'::interval) AS week,
    main_kpis_cluster.datetime::date AS date,
    main_kpis_cluster.uf,
    main_kpis_cluster.cluster_id,
    main_kpis_cluster.cluster AS node,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cluster.acc_rrc_den) - sum(main_kpis_cluster.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cluster.acc_cs_rab_den) - sum(main_kpis_cluster.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cluster.acc_ps_rab_den) - sum(main_kpis_cluster.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_hs_num) / NULLIF(sum(main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cluster.acc_hs_den) - sum(main_kpis_cluster.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cluster.acc_hs_f2h_den) - sum(main_kpis_cluster.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_hs_num) / NULLIF(sum(main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cluster.acc_hs_num) + sum(main_kpis_cluster.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cluster.acc_hs_den) + sum(main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_cs_num) / NULLIF(sum(main_kpis_cluster.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cluster.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_ps_num) / NULLIF(sum(main_kpis_cluster.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cluster.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_hsdpa_num) / NULLIF(sum(main_kpis_cluster.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cluster.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_hsupa_num) / NULLIF(sum(main_kpis_cluster.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cluster.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cluster.sho_succ_rate_num) / NULLIF(sum(main_kpis_cluster.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cluster.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cluster.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cluster.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cluster.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cluster.retention_cs_num) / NULLIF(sum(main_kpis_cluster.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cluster.retention_ps_num) / NULLIF(sum(main_kpis_cluster.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cluster.sho_over_num) / NULLIF(sum(main_kpis_cluster.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cluster.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cluster.unavailtime) / (sum(main_kpis_cluster.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cluster.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cluster.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cluster.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cluster.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cluster.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cluster.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cluster.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cluster.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cluster.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cluster.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cluster.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cluster.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cluster.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cluster.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cluster.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cluster.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cluster
  GROUP BY date_part('week'::text, main_kpis_cluster.datetime::date + '1 day'::interval), main_kpis_cluster.datetime::date, main_kpis_cluster.cluster_id, main_kpis_cluster.cluster, main_kpis_cluster.uf;

ALTER TABLE umts_kpi.vw_main_kpis_cluster_rate_daily
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cluster_rate_daily_2

-- DROP VIEW umts_kpi.vw_main_kpis_cluster_rate_daily_2;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cluster_rate_daily_2 AS 
 SELECT date_part('week'::text, vw_main_kpis_cluster.datetime::date + '1 day'::interval) AS week,
    vw_main_kpis_cluster.datetime::date AS date,
    vw_main_kpis_cluster.uf,
    vw_main_kpis_cluster.cluster_id,
    vw_main_kpis_cluster.cluster AS node,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_rrc_num) / NULLIF(sum(vw_main_kpis_cluster.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(vw_main_kpis_cluster.acc_rrc_den) - sum(vw_main_kpis_cluster.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(vw_main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(vw_main_kpis_cluster.acc_cs_rab_den) - sum(vw_main_kpis_cluster.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_rrc_num) / NULLIF(sum(vw_main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(vw_main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(vw_main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(vw_main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(vw_main_kpis_cluster.acc_ps_rab_den) - sum(vw_main_kpis_cluster.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_rrc_num) / NULLIF(sum(vw_main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(vw_main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(vw_main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_hs_num) / NULLIF(sum(vw_main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(vw_main_kpis_cluster.acc_hs_den) - sum(vw_main_kpis_cluster.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_hs_f2h_num) / NULLIF(sum(vw_main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(vw_main_kpis_cluster.acc_hs_f2h_den) - sum(vw_main_kpis_cluster.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_rrc_num) / NULLIF(sum(vw_main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(vw_main_kpis_cluster.acc_hs_num) / NULLIF(sum(vw_main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.acc_rrc_num) / NULLIF(sum(vw_main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(vw_main_kpis_cluster.acc_hs_num) + sum(vw_main_kpis_cluster.acc_hs_f2h_num)) / NULLIF(sum(vw_main_kpis_cluster.acc_hs_den) + sum(vw_main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(vw_main_kpis_cluster.drop_cs_num) / NULLIF(sum(vw_main_kpis_cluster.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(vw_main_kpis_cluster.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(vw_main_kpis_cluster.drop_ps_num) / NULLIF(sum(vw_main_kpis_cluster.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(vw_main_kpis_cluster.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(vw_main_kpis_cluster.drop_hsdpa_num) / NULLIF(sum(vw_main_kpis_cluster.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(vw_main_kpis_cluster.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(vw_main_kpis_cluster.drop_hsupa_num) / NULLIF(sum(vw_main_kpis_cluster.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(vw_main_kpis_cluster.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.sho_succ_rate_num) / NULLIF(sum(vw_main_kpis_cluster.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.soft_hand_succ_rate_num) / NULLIF(sum(vw_main_kpis_cluster.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.hho_intra_freq_succ_num) / NULLIF(sum(vw_main_kpis_cluster.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.cs_hho_intra_freq_succ_num) / NULLIF(sum(vw_main_kpis_cluster.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.ps_hho_intra_freq_succ_num) / NULLIF(sum(vw_main_kpis_cluster.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.hho_inter_freq_succ_num) / NULLIF(sum(vw_main_kpis_cluster.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.iratho_cs_succ_num) / NULLIF(sum(vw_main_kpis_cluster.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(vw_main_kpis_cluster.iratho_ps_succ_num) / NULLIF(sum(vw_main_kpis_cluster.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(vw_main_kpis_cluster.retention_cs_num) / NULLIF(sum(vw_main_kpis_cluster.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(vw_main_kpis_cluster.retention_ps_num) / NULLIF(sum(vw_main_kpis_cluster.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(vw_main_kpis_cluster.sho_over_num) / NULLIF(sum(vw_main_kpis_cluster.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, vw_main_kpis_cluster.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(vw_main_kpis_cluster.unavailtime) / (sum(vw_main_kpis_cluster.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(vw_main_kpis_cluster.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(vw_main_kpis_cluster.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(vw_main_kpis_cluster.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(vw_main_kpis_cluster.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(vw_main_kpis_cluster.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(vw_main_kpis_cluster.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(vw_main_kpis_cluster.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(vw_main_kpis_cluster.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(vw_main_kpis_cluster.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(vw_main_kpis_cluster.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(vw_main_kpis_cluster.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(vw_main_kpis_cluster.dch_users)::numeric, 2) AS dch_users,
    round(avg(vw_main_kpis_cluster.pch_users)::numeric, 2) AS pch_users,
    round(avg(vw_main_kpis_cluster.fach_users)::numeric, 2) AS fach_users,
    round(avg(vw_main_kpis_cluster.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(vw_main_kpis_cluster.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.vw_main_kpis_cluster
  GROUP BY date_part('week'::text, vw_main_kpis_cluster.datetime::date + '1 day'::interval), vw_main_kpis_cluster.datetime::date, vw_main_kpis_cluster.cluster_id, vw_main_kpis_cluster.cluster, vw_main_kpis_cluster.uf;

ALTER TABLE umts_kpi.vw_main_kpis_cluster_rate_daily_2
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cluster_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_cluster_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cluster_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis_cluster.datetime::date + '1 day'::interval) AS week,
    main_kpis_cluster.datetime AS date,
    main_kpis_cluster.uf,
    main_kpis_cluster.cluster_id,
    main_kpis_cluster.cluster AS node,
    round((100::real * COALESCE(main_kpis_cluster.acc_rrc_num / NULLIF(main_kpis_cluster.acc_rrc_den, 0::real), 1::real))::numeric, 2) AS acc_rrc,
    main_kpis_cluster.acc_rrc_den - main_kpis_cluster.acc_rrc_num AS fails_acc_rrc,
    round((100::real * COALESCE(main_kpis_cluster.acc_cs_rab_num / NULLIF(main_kpis_cluster.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS eff_cs,
    main_kpis_cluster.acc_cs_rab_den - main_kpis_cluster.acc_cs_rab_num AS fails_acc_cs,
    round((100::real * COALESCE(main_kpis_cluster.acc_rrc_num / NULLIF(main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_cluster.acc_cs_rab_num / NULLIF(main_kpis_cluster.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(main_kpis_cluster.acc_ps_rab_num / NULLIF(main_kpis_cluster.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS eff_ps,
    main_kpis_cluster.acc_ps_rab_den - main_kpis_cluster.acc_ps_rab_num AS fails_acc_ps,
    round((100::real * COALESCE(main_kpis_cluster.acc_rrc_num / NULLIF(main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_cluster.acc_ps_rab_num / NULLIF(main_kpis_cluster.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(main_kpis_cluster.acc_hs_num / NULLIF(main_kpis_cluster.acc_hs_den, 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    main_kpis_cluster.acc_hs_den - main_kpis_cluster.acc_hs_num AS fails_acc_hsdpa,
    round((100::real * COALESCE(main_kpis_cluster.acc_hs_f2h_num / NULLIF(main_kpis_cluster.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS eff_f2h,
    main_kpis_cluster.acc_hs_f2h_den - main_kpis_cluster.acc_hs_f2h_num AS fails_f2h,
    round((100::real * COALESCE(main_kpis_cluster.acc_rrc_num / NULLIF(main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_cluster.acc_hs_num / NULLIF(main_kpis_cluster.acc_hs_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(main_kpis_cluster.acc_rrc_num / NULLIF(main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE((main_kpis_cluster.acc_hs_num + main_kpis_cluster.acc_hs_f2h_num) / NULLIF(main_kpis_cluster.acc_hs_den + main_kpis_cluster.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(main_kpis_cluster.drop_cs_num / NULLIF(main_kpis_cluster.drop_cs_den, 0::real), 0::real)))::numeric, 2) AS drop_cs,
    main_kpis_cluster.drop_cs_den AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(main_kpis_cluster.drop_ps_num / NULLIF(main_kpis_cluster.drop_ps_den, 0::real), 0::real)))::numeric, 2) AS drop_ps,
    main_kpis_cluster.drop_ps_den AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(main_kpis_cluster.drop_hsdpa_num / NULLIF(main_kpis_cluster.drop_hsdpa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    main_kpis_cluster.drop_hsdpa_den AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(main_kpis_cluster.drop_hsupa_num / NULLIF(main_kpis_cluster.drop_hsupa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    main_kpis_cluster.drop_hsupa_den AS fails_drop_hsupa,
    round((100::real * COALESCE(main_kpis_cluster.sho_succ_rate_num / NULLIF(main_kpis_cluster.sho_succ_rate_den, 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(main_kpis_cluster.soft_hand_succ_rate_num / NULLIF(main_kpis_cluster.soft_hand_succ_rate_den, 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(main_kpis_cluster.hho_intra_freq_succ_num / NULLIF(main_kpis_cluster.hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_cluster.cs_hho_intra_freq_succ_num / NULLIF(main_kpis_cluster.cs_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(main_kpis_cluster.ps_hho_intra_freq_succ_num / NULLIF(main_kpis_cluster.ps_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_cluster.hho_inter_freq_succ_num / NULLIF(main_kpis_cluster.hho_inter_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_cluster.iratho_cs_succ_num / NULLIF(main_kpis_cluster.iratho_cs_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(main_kpis_cluster.iratho_ps_succ_num / NULLIF(main_kpis_cluster.iratho_ps_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_cluster.retention_cs_num / NULLIF(main_kpis_cluster.retention_cs_den, 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_cluster.retention_ps_num / NULLIF(main_kpis_cluster.retention_ps_den, 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(main_kpis_cluster.sho_over_num / NULLIF(main_kpis_cluster.sho_over_den, 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    main_kpis_cluster.rtwp,
    round((100::real * (1::double precision - (main_kpis_cluster.unavailtime / (main_kpis_cluster.gp * 60)::double precision)::real))::numeric, 2) AS availability,
    round((main_kpis_cluster.data_hsdpa / 1024::real)::numeric, 2)::real AS data_hsdpa,
    round((main_kpis_cluster.data_hsupa / 1024::real)::numeric, 2)::real AS data_hsupa,
    round((main_kpis_cluster.ps_r99_ul / (1024 * 1024)::real)::numeric, 2)::real AS ps_r99_ul,
    round((main_kpis_cluster.ps_r99_dl / (1024 * 1024)::real)::numeric, 2)::real AS ps_r99_dl,
    main_kpis_cluster.voice_traffic_dl,
    main_kpis_cluster.voice_traffic_ul,
    main_kpis_cluster.voice_erlangs_num,
    main_kpis_cluster.voice_erlangs_den,
    main_kpis_cluster.hsdpa_users,
    main_kpis_cluster.hsupa_users,
    main_kpis_cluster.dch_users,
    main_kpis_cluster.pch_users,
    main_kpis_cluster.fach_users,
    main_kpis_cluster.ps_nonhs_users,
    main_kpis_cluster.thp_hsdpa,
    main_kpis_cluster.thp_hsupa
   FROM umts_kpi.main_kpis_cluster;

ALTER TABLE umts_kpi.vw_main_kpis_cluster_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cluster_rate_hourly_2

-- DROP VIEW umts_kpi.vw_main_kpis_cluster_rate_hourly_2;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cluster_rate_hourly_2 AS 
 SELECT date_part('week'::text, vw_main_kpis_cluster.datetime::date + '1 day'::interval) AS week,
    vw_main_kpis_cluster.datetime AS date,
    vw_main_kpis_cluster.uf,
    vw_main_kpis_cluster.cluster_id,
    vw_main_kpis_cluster.cluster AS node,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_rrc_num / NULLIF(vw_main_kpis_cluster.acc_rrc_den, 0::real), 1::real))::numeric, 2) AS acc_rrc,
    vw_main_kpis_cluster.acc_rrc_den - vw_main_kpis_cluster.acc_rrc_num AS fails_acc_rrc,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_cs_rab_num / NULLIF(vw_main_kpis_cluster.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS eff_cs,
    vw_main_kpis_cluster.acc_cs_rab_den - vw_main_kpis_cluster.acc_cs_rab_num AS fails_acc_cs,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_rrc_num / NULLIF(vw_main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE(vw_main_kpis_cluster.acc_cs_rab_num / NULLIF(vw_main_kpis_cluster.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_ps_rab_num / NULLIF(vw_main_kpis_cluster.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS eff_ps,
    vw_main_kpis_cluster.acc_ps_rab_den - vw_main_kpis_cluster.acc_ps_rab_num AS fails_acc_ps,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_rrc_num / NULLIF(vw_main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE(vw_main_kpis_cluster.acc_ps_rab_num / NULLIF(vw_main_kpis_cluster.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_hs_num / NULLIF(vw_main_kpis_cluster.acc_hs_den, 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    vw_main_kpis_cluster.acc_hs_den - vw_main_kpis_cluster.acc_hs_num AS fails_acc_hsdpa,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_hs_f2h_num / NULLIF(vw_main_kpis_cluster.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS eff_f2h,
    vw_main_kpis_cluster.acc_hs_f2h_den - vw_main_kpis_cluster.acc_hs_f2h_num AS fails_f2h,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_rrc_num / NULLIF(vw_main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE(vw_main_kpis_cluster.acc_hs_num / NULLIF(vw_main_kpis_cluster.acc_hs_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(vw_main_kpis_cluster.acc_rrc_num / NULLIF(vw_main_kpis_cluster.acc_rrc_den, 0::real), 1::real) * COALESCE((vw_main_kpis_cluster.acc_hs_num + vw_main_kpis_cluster.acc_hs_f2h_num) / NULLIF(vw_main_kpis_cluster.acc_hs_den + vw_main_kpis_cluster.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(vw_main_kpis_cluster.drop_cs_num / NULLIF(vw_main_kpis_cluster.drop_cs_den, 0::real), 0::real)))::numeric, 2) AS drop_cs,
    vw_main_kpis_cluster.drop_cs_den AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(vw_main_kpis_cluster.drop_ps_num / NULLIF(vw_main_kpis_cluster.drop_ps_den, 0::real), 0::real)))::numeric, 2) AS drop_ps,
    vw_main_kpis_cluster.drop_ps_den AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(vw_main_kpis_cluster.drop_hsdpa_num / NULLIF(vw_main_kpis_cluster.drop_hsdpa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    vw_main_kpis_cluster.drop_hsdpa_den AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(vw_main_kpis_cluster.drop_hsupa_num / NULLIF(vw_main_kpis_cluster.drop_hsupa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    vw_main_kpis_cluster.drop_hsupa_den AS fails_drop_hsupa,
    round((100::real * COALESCE(vw_main_kpis_cluster.sho_succ_rate_num / NULLIF(vw_main_kpis_cluster.sho_succ_rate_den, 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(vw_main_kpis_cluster.soft_hand_succ_rate_num / NULLIF(vw_main_kpis_cluster.soft_hand_succ_rate_den, 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(vw_main_kpis_cluster.hho_intra_freq_succ_num / NULLIF(vw_main_kpis_cluster.hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(vw_main_kpis_cluster.cs_hho_intra_freq_succ_num / NULLIF(vw_main_kpis_cluster.cs_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(vw_main_kpis_cluster.ps_hho_intra_freq_succ_num / NULLIF(vw_main_kpis_cluster.ps_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(vw_main_kpis_cluster.hho_inter_freq_succ_num / NULLIF(vw_main_kpis_cluster.hho_inter_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(vw_main_kpis_cluster.iratho_cs_succ_num / NULLIF(vw_main_kpis_cluster.iratho_cs_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(vw_main_kpis_cluster.iratho_ps_succ_num / NULLIF(vw_main_kpis_cluster.iratho_ps_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(vw_main_kpis_cluster.retention_cs_num / NULLIF(vw_main_kpis_cluster.retention_cs_den, 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(vw_main_kpis_cluster.retention_ps_num / NULLIF(vw_main_kpis_cluster.retention_ps_den, 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(vw_main_kpis_cluster.sho_over_num / NULLIF(vw_main_kpis_cluster.sho_over_den, 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    vw_main_kpis_cluster.rtwp,
    round((100::real * (1::double precision - (vw_main_kpis_cluster.unavailtime / (vw_main_kpis_cluster.gp * 60)::double precision)::real))::numeric, 2) AS availability,
    round((vw_main_kpis_cluster.data_hsdpa / 1024::real)::numeric, 2)::real AS data_hsdpa,
    round((vw_main_kpis_cluster.data_hsupa / 1024::real)::numeric, 2)::real AS data_hsupa,
    round((vw_main_kpis_cluster.ps_r99_ul / (1024 * 1024)::real)::numeric, 2)::real AS ps_r99_ul,
    round((vw_main_kpis_cluster.ps_r99_dl / (1024 * 1024)::real)::numeric, 2)::real AS ps_r99_dl,
    vw_main_kpis_cluster.voice_traffic_dl,
    vw_main_kpis_cluster.voice_traffic_ul,
    vw_main_kpis_cluster.voice_erlangs_num,
    vw_main_kpis_cluster.voice_erlangs_den,
    vw_main_kpis_cluster.hsdpa_users,
    vw_main_kpis_cluster.hsupa_users,
    vw_main_kpis_cluster.dch_users,
    vw_main_kpis_cluster.pch_users,
    vw_main_kpis_cluster.fach_users,
    vw_main_kpis_cluster.ps_nonhs_users,
    vw_main_kpis_cluster.thp_hsdpa,
    vw_main_kpis_cluster.thp_hsupa
   FROM umts_kpi.vw_main_kpis_cluster;

ALTER TABLE umts_kpi.vw_main_kpis_cluster_rate_hourly_2
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cluster_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_cluster_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cluster_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_cluster.datetime::date) AS month,
    main_kpis_cluster.uf,
    main_kpis_cluster.cluster_id,
    main_kpis_cluster.cluster AS node,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cluster.acc_rrc_den) - sum(main_kpis_cluster.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cluster.acc_cs_rab_den) - sum(main_kpis_cluster.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cluster.acc_ps_rab_den) - sum(main_kpis_cluster.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_hs_num) / NULLIF(sum(main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cluster.acc_hs_den) - sum(main_kpis_cluster.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cluster.acc_hs_f2h_den) - sum(main_kpis_cluster.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_hs_num) / NULLIF(sum(main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cluster.acc_hs_num) + sum(main_kpis_cluster.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cluster.acc_hs_den) + sum(main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_cs_num) / NULLIF(sum(main_kpis_cluster.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cluster.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_ps_num) / NULLIF(sum(main_kpis_cluster.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cluster.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_hsdpa_num) / NULLIF(sum(main_kpis_cluster.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cluster.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_hsupa_num) / NULLIF(sum(main_kpis_cluster.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cluster.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cluster.sho_succ_rate_num) / NULLIF(sum(main_kpis_cluster.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cluster.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cluster.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cluster.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cluster.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cluster.retention_cs_num) / NULLIF(sum(main_kpis_cluster.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cluster.retention_ps_num) / NULLIF(sum(main_kpis_cluster.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cluster.sho_over_num) / NULLIF(sum(main_kpis_cluster.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cluster.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cluster.unavailtime) / (sum(main_kpis_cluster.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cluster.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cluster.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cluster.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cluster.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cluster.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cluster.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cluster.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cluster.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cluster.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cluster.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cluster.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cluster.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cluster.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cluster.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cluster.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cluster.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cluster
  GROUP BY date_part('month'::text, main_kpis_cluster.datetime::date), main_kpis_cluster.cluster_id, main_kpis_cluster.cluster, main_kpis_cluster.uf;

ALTER TABLE umts_kpi.vw_main_kpis_cluster_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_cluster_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_cluster_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_cluster_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_cluster.datetime::date + '1 day'::interval) AS week,
    main_kpis_cluster.uf,
    main_kpis_cluster.cluster_id,
    main_kpis_cluster.cluster AS node,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cluster.acc_rrc_den) - sum(main_kpis_cluster.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cluster.acc_cs_rab_den) - sum(main_kpis_cluster.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_cs_rab_num) / NULLIF(sum(main_kpis_cluster.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cluster.acc_ps_rab_den) - sum(main_kpis_cluster.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_ps_rab_num) / NULLIF(sum(main_kpis_cluster.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_hs_num) / NULLIF(sum(main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cluster.acc_hs_den) - sum(main_kpis_cluster.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cluster.acc_hs_f2h_den) - sum(main_kpis_cluster.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cluster.acc_hs_num) / NULLIF(sum(main_kpis_cluster.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cluster.acc_rrc_num) / NULLIF(sum(main_kpis_cluster.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cluster.acc_hs_num) + sum(main_kpis_cluster.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cluster.acc_hs_den) + sum(main_kpis_cluster.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_cs_num) / NULLIF(sum(main_kpis_cluster.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cluster.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_ps_num) / NULLIF(sum(main_kpis_cluster.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cluster.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_hsdpa_num) / NULLIF(sum(main_kpis_cluster.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cluster.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cluster.drop_hsupa_num) / NULLIF(sum(main_kpis_cluster.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cluster.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cluster.sho_succ_rate_num) / NULLIF(sum(main_kpis_cluster.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cluster.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cluster.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cluster.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cluster.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cluster.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cluster.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cluster.retention_cs_num) / NULLIF(sum(main_kpis_cluster.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cluster.retention_ps_num) / NULLIF(sum(main_kpis_cluster.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cluster.sho_over_num) / NULLIF(sum(main_kpis_cluster.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cluster.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cluster.unavailtime) / (sum(main_kpis_cluster.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cluster.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cluster.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cluster.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cluster.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cluster.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cluster.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cluster.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cluster.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cluster.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cluster.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cluster.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cluster.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cluster.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cluster.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cluster.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cluster.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cluster
  GROUP BY date_part('week'::text, main_kpis_cluster.datetime::date + '1 day'::interval), main_kpis_cluster.cluster_id, main_kpis_cluster.cluster, main_kpis_cluster.uf;

ALTER TABLE umts_kpi.vw_main_kpis_cluster_rate_weekly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_network_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_network_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_network_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
    main_kpis_rnc.datetime::date AS date,
    'NETWORK'::text AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval), main_kpis_rnc.datetime::date;

ALTER TABLE umts_kpi.vw_main_kpis_network_rate_daily
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_network_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_network_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_network_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
    main_kpis_rnc.datetime AS date,
    'NETWORK'::text AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval), main_kpis_rnc.datetime;

ALTER TABLE umts_kpi.vw_main_kpis_network_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_network_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_network_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_network_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_rnc.datetime::date) AS month,
    'NETWORK'::text AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('month'::text, main_kpis_rnc.datetime::date);

ALTER TABLE umts_kpi.vw_main_kpis_network_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_network_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_network_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_network_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
    'NETWORK'::text AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval);

ALTER TABLE umts_kpi.vw_main_kpis_network_rate_weekly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_nodeb_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_nodeb_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_nodeb_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week,
    main_kpis_daily.date,
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
    u.nodebname AS node,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_daily.acc_rrc_den) - sum(main_kpis_daily.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_daily.acc_cs_rab_den) - sum(main_kpis_daily.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_daily.acc_ps_rab_den) - sum(main_kpis_daily.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_daily.acc_hs_den) - sum(main_kpis_daily.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_f2h_num) / NULLIF(sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_daily.acc_hs_f2h_den) - sum(main_kpis_daily.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_daily.acc_hs_num) + sum(main_kpis_daily.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_daily.acc_hs_den) + sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_cs_num) / NULLIF(sum(main_kpis_daily.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_daily.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_ps_num) / NULLIF(sum(main_kpis_daily.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_daily.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsdpa_num) / NULLIF(sum(main_kpis_daily.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_daily.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsupa_num) / NULLIF(sum(main_kpis_daily.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_daily.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_daily.sho_succ_rate_num) / NULLIF(sum(main_kpis_daily.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_daily.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_cs_succ_num) / NULLIF(sum(main_kpis_daily.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_ps_succ_num) / NULLIF(sum(main_kpis_daily.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_cs_num) / NULLIF(sum(main_kpis_daily.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_ps_num) / NULLIF(sum(main_kpis_daily.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_daily.sho_over_num) / NULLIF(sum(main_kpis_daily.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_daily.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_daily.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_daily.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_daily.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_daily.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_daily.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_daily.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_daily.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_daily.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_daily.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_daily.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_daily.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_daily.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_daily.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_daily.fach_users)::numeric, 2) AS fach_users,
    round((sum(main_kpis_daily.thp_hsdpa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsdpa,
    round((sum(main_kpis_daily.thp_hsupa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_daily
     JOIN umts_configuration.ucellsetup u ON main_kpis_daily.rnc = u.rncname AND main_kpis_daily.cellid = u.cellid
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval), main_kpis_daily.date,
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_daily.rnc, u.nodebname;

ALTER TABLE umts_kpi.vw_main_kpis_nodeb_rate_daily
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_nodeb_rate_daily_2

-- DROP VIEW umts_kpi.vw_main_kpis_nodeb_rate_daily_2;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_nodeb_rate_daily_2 AS 
 SELECT date_part('week'::text, main_kpis.datetime::date + '1 day'::interval) AS week,
    main_kpis.datetime::date AS date,
        CASE
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis.rnc,
    "left"(main_kpis.cellname, 8) AS node,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis.acc_rrc_den) - sum(main_kpis.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis.acc_cs_rab_num) / NULLIF(sum(main_kpis.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis.acc_cs_rab_den) - sum(main_kpis.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_cs_rab_num) / NULLIF(sum(main_kpis.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis.acc_ps_rab_num) / NULLIF(sum(main_kpis.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis.acc_ps_rab_den) - sum(main_kpis.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_ps_rab_num) / NULLIF(sum(main_kpis.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis.acc_hs_num) / NULLIF(sum(main_kpis.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis.acc_hs_den) - sum(main_kpis.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis.acc_hs_f2h_num) / NULLIF(sum(main_kpis.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis.acc_hs_f2h_den) - sum(main_kpis.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_hs_num) / NULLIF(sum(main_kpis.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis.acc_hs_num) + sum(main_kpis.acc_hs_f2h_num)) / NULLIF(sum(main_kpis.acc_hs_den) + sum(main_kpis.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_cs_num) / NULLIF(sum(main_kpis.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_ps_num) / NULLIF(sum(main_kpis.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_hsdpa_num) / NULLIF(sum(main_kpis.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_hsupa_num) / NULLIF(sum(main_kpis.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis.sho_succ_rate_num) / NULLIF(sum(main_kpis.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.iratho_cs_succ_num) / NULLIF(sum(main_kpis.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.iratho_ps_succ_num) / NULLIF(sum(main_kpis.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis.retention_cs_num) / NULLIF(sum(main_kpis.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis.retention_ps_num) / NULLIF(sum(main_kpis.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis.sho_over_num) / NULLIF(sum(main_kpis.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis.unavailtime) / (sum(main_kpis.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis
  GROUP BY date_part('week'::text, main_kpis.datetime::date + '1 day'::interval), main_kpis.datetime::date,
        CASE
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis.rnc, "left"(main_kpis.cellname, 8);

ALTER TABLE umts_kpi.vw_main_kpis_nodeb_rate_daily_2
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_nodeb_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_nodeb_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_nodeb_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis.datetime::date + '1 day'::interval) AS week,
    main_kpis.datetime AS date,
        CASE
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis.rnc,
    "left"(main_kpis.cellname, 8) AS node,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis.acc_rrc_den) - sum(main_kpis.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis.acc_cs_rab_num) / NULLIF(sum(main_kpis.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis.acc_cs_rab_den) - sum(main_kpis.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_cs_rab_num) / NULLIF(sum(main_kpis.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis.acc_ps_rab_num) / NULLIF(sum(main_kpis.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis.acc_ps_rab_den) - sum(main_kpis.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_ps_rab_num) / NULLIF(sum(main_kpis.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis.acc_hs_num) / NULLIF(sum(main_kpis.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis.acc_hs_den) - sum(main_kpis.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis.acc_hs_f2h_num) / NULLIF(sum(main_kpis.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis.acc_hs_f2h_den) - sum(main_kpis.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis.acc_hs_num) / NULLIF(sum(main_kpis.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis.acc_rrc_num) / NULLIF(sum(main_kpis.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis.acc_hs_num) + sum(main_kpis.acc_hs_f2h_num)) / NULLIF(sum(main_kpis.acc_hs_den) + sum(main_kpis.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_cs_num) / NULLIF(sum(main_kpis.drop_cs_den), 0::real), 0::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_ps_num) / NULLIF(sum(main_kpis.drop_ps_den), 0::real), 0::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_hsdpa_num) / NULLIF(sum(main_kpis.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis.drop_hsupa_num) / NULLIF(sum(main_kpis.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis.sho_succ_rate_num) / NULLIF(sum(main_kpis.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.iratho_cs_succ_num) / NULLIF(sum(main_kpis.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis.iratho_ps_succ_num) / NULLIF(sum(main_kpis.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis.retention_cs_num) / NULLIF(sum(main_kpis.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis.retention_ps_num) / NULLIF(sum(main_kpis.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis.sho_over_num) / NULLIF(sum(main_kpis.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis.unavailtime) / (sum(main_kpis.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis
  GROUP BY date_part('week'::text, main_kpis.datetime::date + '1 day'::interval), main_kpis.datetime,
        CASE
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis.rnc, "left"(main_kpis.cellname, 8);

ALTER TABLE umts_kpi.vw_main_kpis_nodeb_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_nodeb_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_nodeb_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_nodeb_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_daily.date) AS month,
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
    u.nodebname AS node,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_daily.acc_rrc_den) - sum(main_kpis_daily.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_daily.acc_cs_rab_den) - sum(main_kpis_daily.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_daily.acc_ps_rab_den) - sum(main_kpis_daily.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_daily.acc_hs_den) - sum(main_kpis_daily.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_f2h_num) / NULLIF(sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_daily.acc_hs_f2h_den) - sum(main_kpis_daily.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_daily.acc_hs_num) + sum(main_kpis_daily.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_daily.acc_hs_den) + sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_cs_num) / NULLIF(sum(main_kpis_daily.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_daily.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_ps_num) / NULLIF(sum(main_kpis_daily.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_daily.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsdpa_num) / NULLIF(sum(main_kpis_daily.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_daily.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsupa_num) / NULLIF(sum(main_kpis_daily.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_daily.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_daily.sho_succ_rate_num) / NULLIF(sum(main_kpis_daily.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_daily.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_cs_succ_num) / NULLIF(sum(main_kpis_daily.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_ps_succ_num) / NULLIF(sum(main_kpis_daily.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_cs_num) / NULLIF(sum(main_kpis_daily.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_ps_num) / NULLIF(sum(main_kpis_daily.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_daily.sho_over_num) / NULLIF(sum(main_kpis_daily.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_daily.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_daily.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_daily.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_daily.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_daily.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_daily.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_daily.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_daily.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_daily.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_daily.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_daily.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_daily.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_daily.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_daily.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_daily.fach_users)::numeric, 2) AS fach_users,
    round((sum(main_kpis_daily.thp_hsdpa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsdpa,
    round((sum(main_kpis_daily.thp_hsupa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_daily
     JOIN umts_configuration.ucellsetup u ON main_kpis_daily.rnc = u.rncname AND main_kpis_daily.cellid = u.cellid
  GROUP BY date_part('month'::text, main_kpis_daily.date),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_daily.rnc, u.nodebname;

ALTER TABLE umts_kpi.vw_main_kpis_nodeb_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_nodeb_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_nodeb_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_nodeb_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week,
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
    u.nodebname AS node,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_daily.acc_rrc_den) - sum(main_kpis_daily.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_daily.acc_cs_rab_den) - sum(main_kpis_daily.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_cs_rab_num) / NULLIF(sum(main_kpis_daily.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_daily.acc_ps_rab_den) - sum(main_kpis_daily.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_ps_rab_num) / NULLIF(sum(main_kpis_daily.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_daily.acc_hs_den) - sum(main_kpis_daily.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_hs_f2h_num) / NULLIF(sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_daily.acc_hs_f2h_den) - sum(main_kpis_daily.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_daily.acc_hs_num) / NULLIF(sum(main_kpis_daily.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_daily.acc_rrc_num) / NULLIF(sum(main_kpis_daily.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_daily.acc_hs_num) + sum(main_kpis_daily.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_daily.acc_hs_den) + sum(main_kpis_daily.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_cs_num) / NULLIF(sum(main_kpis_daily.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_daily.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_ps_num) / NULLIF(sum(main_kpis_daily.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_daily.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsdpa_num) / NULLIF(sum(main_kpis_daily.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_daily.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_daily.drop_hsupa_num) / NULLIF(sum(main_kpis_daily.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_daily.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_daily.sho_succ_rate_num) / NULLIF(sum(main_kpis_daily.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_daily.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_daily.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_daily.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_cs_succ_num) / NULLIF(sum(main_kpis_daily.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_daily.iratho_ps_succ_num) / NULLIF(sum(main_kpis_daily.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_cs_num) / NULLIF(sum(main_kpis_daily.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_daily.retention_ps_num) / NULLIF(sum(main_kpis_daily.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_daily.sho_over_num) / NULLIF(sum(main_kpis_daily.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_daily.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_daily.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_daily.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_daily.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_daily.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_daily.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_daily.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_daily.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_daily.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_daily.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_daily.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_daily.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_daily.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_daily.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_daily.fach_users)::numeric, 2) AS fach_users,
    round((sum(main_kpis_daily.thp_hsdpa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsdpa,
    round((sum(main_kpis_daily.thp_hsupa) / (sum(main_kpis_daily.gp)::real / 30::double precision))::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_daily
     JOIN umts_configuration.ucellsetup u ON main_kpis_daily.rnc = u.rncname AND main_kpis_daily.cellid = u.cellid
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_daily.rnc, u.nodebname;

ALTER TABLE umts_kpi.vw_main_kpis_nodeb_rate_weekly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_region_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_region_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_region_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
    main_kpis_rnc.datetime::date AS date,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval), main_kpis_rnc.datetime::date,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END;

ALTER TABLE umts_kpi.vw_main_kpis_region_rate_daily
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_region_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_region_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_region_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
    main_kpis_rnc.datetime AS date,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval), main_kpis_rnc.datetime,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END;

ALTER TABLE umts_kpi.vw_main_kpis_region_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_region_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_region_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_region_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_rnc.datetime::date) AS month,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('month'::text, main_kpis_rnc.datetime::date),
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END;

ALTER TABLE umts_kpi.vw_main_kpis_region_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_region_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_region_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_region_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval),
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END;

ALTER TABLE umts_kpi.vw_main_kpis_region_rate_weekly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_rnc_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_rnc_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_rnc_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
    main_kpis_rnc.datetime::date AS date,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis_rnc.rnc AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval), main_kpis_rnc.datetime::date,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_rnc.rnc;

ALTER TABLE umts_kpi.vw_main_kpis_rnc_rate_daily
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_rnc_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_rnc_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_rnc_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
    main_kpis_rnc.datetime AS date,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis_rnc.rnc AS node,
    round((100::real * COALESCE(main_kpis_rnc.acc_rrc_num / NULLIF(main_kpis_rnc.acc_rrc_den, 0::real), 1::real))::numeric, 2) AS acc_rrc,
    main_kpis_rnc.acc_rrc_den - main_kpis_rnc.acc_rrc_num AS fails_acc_rrc,
    round((100::real * COALESCE(main_kpis_rnc.acc_cs_rab_num / NULLIF(main_kpis_rnc.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS eff_cs,
    main_kpis_rnc.acc_cs_rab_den - main_kpis_rnc.acc_cs_rab_num AS fails_acc_cs,
    round((100::real * COALESCE(main_kpis_rnc.acc_rrc_num / NULLIF(main_kpis_rnc.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_rnc.acc_cs_rab_num / NULLIF(main_kpis_rnc.acc_cs_rab_den, 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(main_kpis_rnc.acc_ps_rab_num / NULLIF(main_kpis_rnc.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS eff_ps,
    main_kpis_rnc.acc_ps_rab_den - main_kpis_rnc.acc_ps_rab_num AS fails_acc_ps,
    round((100::real * COALESCE(main_kpis_rnc.acc_rrc_num / NULLIF(main_kpis_rnc.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_rnc.acc_ps_rab_num / NULLIF(main_kpis_rnc.acc_ps_rab_den, 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(main_kpis_rnc.acc_hs_num / NULLIF(main_kpis_rnc.acc_hs_den, 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    main_kpis_rnc.acc_hs_den - main_kpis_rnc.acc_hs_num AS fails_acc_hsdpa,
    round((100::real * COALESCE(main_kpis_rnc.acc_hs_f2h_num / NULLIF(main_kpis_rnc.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS eff_f2h,
    main_kpis_rnc.acc_hs_f2h_den - main_kpis_rnc.acc_hs_f2h_num AS fails_f2h,
    round((100::real * COALESCE(main_kpis_rnc.acc_rrc_num / NULLIF(main_kpis_rnc.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis_rnc.acc_hs_num / NULLIF(main_kpis_rnc.acc_hs_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(main_kpis_rnc.acc_rrc_num / NULLIF(main_kpis_rnc.acc_rrc_den, 0::real), 1::real) * COALESCE((main_kpis_rnc.acc_hs_num + main_kpis_rnc.acc_hs_f2h_num) / NULLIF(main_kpis_rnc.acc_hs_den + main_kpis_rnc.acc_hs_f2h_den, 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(main_kpis_rnc.drop_cs_num / NULLIF(main_kpis_rnc.drop_cs_den, 0::real), 1::real)))::numeric, 2) AS drop_cs,
    main_kpis_rnc.drop_cs_den AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(main_kpis_rnc.drop_ps_num / NULLIF(main_kpis_rnc.drop_ps_den, 0::real), 1::real)))::numeric, 2) AS drop_ps,
    main_kpis_rnc.drop_ps_den AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(main_kpis_rnc.drop_hsdpa_num / NULLIF(main_kpis_rnc.drop_hsdpa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    main_kpis_rnc.drop_hsdpa_den AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(main_kpis_rnc.drop_hsupa_num / NULLIF(main_kpis_rnc.drop_hsupa_den, 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    main_kpis_rnc.drop_hsupa_den AS fails_drop_hsupa,
    round((100::real * COALESCE(main_kpis_rnc.sho_succ_rate_num / NULLIF(main_kpis_rnc.sho_succ_rate_den, 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(main_kpis_rnc.soft_hand_succ_rate_num / NULLIF(main_kpis_rnc.soft_hand_succ_rate_den, 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(main_kpis_rnc.hho_intra_freq_succ_num / NULLIF(main_kpis_rnc.hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_rnc.cs_hho_intra_freq_succ_num / NULLIF(main_kpis_rnc.cs_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(main_kpis_rnc.ps_hho_intra_freq_succ_num / NULLIF(main_kpis_rnc.ps_hho_intra_freq_succ_den, 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_rnc.hho_inter_freq_succ_num / NULLIF(main_kpis_rnc.hho_inter_freq_succ_den, 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(main_kpis_rnc.iratho_cs_succ_num / NULLIF(main_kpis_rnc.iratho_cs_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(main_kpis_rnc.iratho_ps_succ_num / NULLIF(main_kpis_rnc.iratho_ps_succ_den, 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_rnc.retention_cs_num / NULLIF(main_kpis_rnc.retention_cs_den, 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(main_kpis_rnc.retention_ps_num / NULLIF(main_kpis_rnc.retention_ps_den, 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(main_kpis_rnc.sho_over_num / NULLIF(main_kpis_rnc.sho_over_den, 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    main_kpis_rnc.rtwp,
    round((100::real * (1::double precision - (main_kpis_rnc.unavailtime / (main_kpis_rnc.gp * 60)::double precision)::real))::numeric, 2) AS availability,
    main_kpis_rnc.data_hsdpa,
    main_kpis_rnc.data_hsupa,
    main_kpis_rnc.ps_r99_ul,
    main_kpis_rnc.ps_r99_dl,
    main_kpis_rnc.voice_traffic_dl,
    main_kpis_rnc.voice_traffic_ul,
    main_kpis_rnc.voice_erlangs_num,
    main_kpis_rnc.voice_erlangs_den,
    main_kpis_rnc.hsdpa_users,
    main_kpis_rnc.hsupa_users,
    main_kpis_rnc.dch_users,
    main_kpis_rnc.pch_users,
    main_kpis_rnc.fach_users,
    main_kpis_rnc.ps_nonhs_users,
    main_kpis_rnc.thp_hsdpa,
    main_kpis_rnc.thp_hsupa
   FROM umts_kpi.main_kpis_rnc;

ALTER TABLE umts_kpi.vw_main_kpis_rnc_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_rnc_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_rnc_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_rnc_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_rnc.datetime::date) AS month,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis_rnc.rnc AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('month'::text, main_kpis_rnc.datetime::date),
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_rnc.rnc;

ALTER TABLE umts_kpi.vw_main_kpis_rnc_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_rnc_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_rnc_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_rnc_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval) AS week,
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
    main_kpis_rnc.rnc AS node,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_rnc.acc_rrc_den) - sum(main_kpis_rnc.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_rnc.acc_cs_rab_den) - sum(main_kpis_rnc.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_cs_rab_num) / NULLIF(sum(main_kpis_rnc.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_rnc.acc_ps_rab_den) - sum(main_kpis_rnc.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_ps_rab_num) / NULLIF(sum(main_kpis_rnc.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_rnc.acc_hs_den) - sum(main_kpis_rnc.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_hs_f2h_num) / NULLIF(sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_rnc.acc_hs_f2h_den) - sum(main_kpis_rnc.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_rnc.acc_hs_num) / NULLIF(sum(main_kpis_rnc.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_rnc.acc_rrc_num) / NULLIF(sum(main_kpis_rnc.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_rnc.acc_hs_num) + sum(main_kpis_rnc.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_rnc.acc_hs_den) + sum(main_kpis_rnc.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_cs_num) / NULLIF(sum(main_kpis_rnc.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_rnc.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_ps_num) / NULLIF(sum(main_kpis_rnc.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_rnc.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsdpa_num) / NULLIF(sum(main_kpis_rnc.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_rnc.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_rnc.drop_hsupa_num) / NULLIF(sum(main_kpis_rnc.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_rnc.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_rnc.sho_succ_rate_num) / NULLIF(sum(main_kpis_rnc.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_rnc.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_rnc.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_rnc.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_cs_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_rnc.iratho_ps_succ_num) / NULLIF(sum(main_kpis_rnc.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_cs_num) / NULLIF(sum(main_kpis_rnc.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_rnc.retention_ps_num) / NULLIF(sum(main_kpis_rnc.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_rnc.sho_over_num) / NULLIF(sum(main_kpis_rnc.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_rnc.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_rnc.unavailtime) / (sum(main_kpis_rnc.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_rnc.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_rnc.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_rnc.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_rnc.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_rnc.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_rnc.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_rnc.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_rnc.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(sum(main_kpis_rnc.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(sum(main_kpis_rnc.hsupa_users)::numeric, 2) AS hsupa_users,
    round(sum(main_kpis_rnc.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(sum(main_kpis_rnc.dch_users)::numeric, 2) AS dch_users,
    round(sum(main_kpis_rnc.pch_users)::numeric, 2) AS pch_users,
    round(sum(main_kpis_rnc.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_rnc.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_rnc.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_rnc
  GROUP BY date_part('week'::text, main_kpis_rnc.datetime::date + '1 day'::interval),
        CASE
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_rnc.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END, main_kpis_rnc.rnc;

ALTER TABLE umts_kpi.vw_main_kpis_rnc_rate_weekly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_uf_rate_daily

-- DROP VIEW umts_kpi.vw_main_kpis_uf_rate_daily;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_uf_rate_daily AS 
 SELECT date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval) AS week,
    main_kpis_cidade.datetime::date AS date,
    main_kpis_cidade.uf AS node,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cidade.acc_rrc_den) - sum(main_kpis_cidade.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cidade.acc_cs_rab_den) - sum(main_kpis_cidade.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cidade.acc_ps_rab_den) - sum(main_kpis_cidade.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cidade.acc_hs_den) - sum(main_kpis_cidade.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cidade.acc_hs_f2h_den) - sum(main_kpis_cidade.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cidade.acc_hs_num) + sum(main_kpis_cidade.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cidade.acc_hs_den) + sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_cs_num) / NULLIF(sum(main_kpis_cidade.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cidade.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_ps_num) / NULLIF(sum(main_kpis_cidade.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cidade.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsdpa_num) / NULLIF(sum(main_kpis_cidade.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cidade.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsupa_num) / NULLIF(sum(main_kpis_cidade.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cidade.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cidade.sho_succ_rate_num) / NULLIF(sum(main_kpis_cidade.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cidade.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_cs_num) / NULLIF(sum(main_kpis_cidade.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_ps_num) / NULLIF(sum(main_kpis_cidade.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cidade.sho_over_num) / NULLIF(sum(main_kpis_cidade.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cidade.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cidade.unavailtime) / (sum(main_kpis_cidade.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cidade.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cidade.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cidade.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cidade.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cidade.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cidade.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cidade.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cidade.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cidade.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cidade.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cidade.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cidade.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cidade.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cidade.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cidade.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cidade.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cidade
  GROUP BY date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval), main_kpis_cidade.datetime::date, main_kpis_cidade.uf;

ALTER TABLE umts_kpi.vw_main_kpis_uf_rate_daily
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_uf_rate_hourly

-- DROP VIEW umts_kpi.vw_main_kpis_uf_rate_hourly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_uf_rate_hourly AS 
 SELECT date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval) AS week,
    main_kpis_cidade.datetime AS date,
    main_kpis_cidade.uf AS node,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cidade.acc_rrc_den) - sum(main_kpis_cidade.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cidade.acc_cs_rab_den) - sum(main_kpis_cidade.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cidade.acc_ps_rab_den) - sum(main_kpis_cidade.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cidade.acc_hs_den) - sum(main_kpis_cidade.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cidade.acc_hs_f2h_den) - sum(main_kpis_cidade.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cidade.acc_hs_num) + sum(main_kpis_cidade.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cidade.acc_hs_den) + sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_cs_num) / NULLIF(sum(main_kpis_cidade.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cidade.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_ps_num) / NULLIF(sum(main_kpis_cidade.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cidade.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsdpa_num) / NULLIF(sum(main_kpis_cidade.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cidade.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsupa_num) / NULLIF(sum(main_kpis_cidade.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cidade.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cidade.sho_succ_rate_num) / NULLIF(sum(main_kpis_cidade.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cidade.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_cs_num) / NULLIF(sum(main_kpis_cidade.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_ps_num) / NULLIF(sum(main_kpis_cidade.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cidade.sho_over_num) / NULLIF(sum(main_kpis_cidade.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cidade.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cidade.unavailtime) / (sum(main_kpis_cidade.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cidade.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cidade.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cidade.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cidade.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cidade.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cidade.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cidade.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cidade.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cidade.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cidade.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cidade.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cidade.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cidade.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cidade.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cidade.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cidade.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cidade
  GROUP BY date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval), main_kpis_cidade.datetime, main_kpis_cidade.uf;

ALTER TABLE umts_kpi.vw_main_kpis_uf_rate_hourly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_uf_rate_monthly

-- DROP VIEW umts_kpi.vw_main_kpis_uf_rate_monthly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_uf_rate_monthly AS 
 SELECT date_part('month'::text, main_kpis_cidade.datetime::date) AS month,
    main_kpis_cidade.uf AS node,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cidade.acc_rrc_den) - sum(main_kpis_cidade.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cidade.acc_cs_rab_den) - sum(main_kpis_cidade.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cidade.acc_ps_rab_den) - sum(main_kpis_cidade.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cidade.acc_hs_den) - sum(main_kpis_cidade.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cidade.acc_hs_f2h_den) - sum(main_kpis_cidade.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cidade.acc_hs_num) + sum(main_kpis_cidade.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cidade.acc_hs_den) + sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_cs_num) / NULLIF(sum(main_kpis_cidade.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cidade.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_ps_num) / NULLIF(sum(main_kpis_cidade.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cidade.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsdpa_num) / NULLIF(sum(main_kpis_cidade.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cidade.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsupa_num) / NULLIF(sum(main_kpis_cidade.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cidade.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cidade.sho_succ_rate_num) / NULLIF(sum(main_kpis_cidade.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cidade.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_cs_num) / NULLIF(sum(main_kpis_cidade.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_ps_num) / NULLIF(sum(main_kpis_cidade.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cidade.sho_over_num) / NULLIF(sum(main_kpis_cidade.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cidade.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cidade.unavailtime) / (sum(main_kpis_cidade.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cidade.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cidade.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cidade.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cidade.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cidade.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cidade.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cidade.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cidade.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cidade.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cidade.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cidade.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cidade.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cidade.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cidade.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cidade.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cidade.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cidade
  GROUP BY date_part('month'::text, main_kpis_cidade.datetime::date), main_kpis_cidade.uf;

ALTER TABLE umts_kpi.vw_main_kpis_uf_rate_monthly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_uf_rate_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_uf_rate_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_uf_rate_weekly AS 
 SELECT date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval) AS week,
    main_kpis_cidade.uf AS node,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real))::numeric, 2) AS acc_rrc,
    sum(main_kpis_cidade.acc_rrc_den) - sum(main_kpis_cidade.acc_rrc_num) AS fails_acc_rrc,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS eff_cs,
    sum(main_kpis_cidade.acc_cs_rab_den) - sum(main_kpis_cidade.acc_cs_rab_num) AS fails_acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_cs_rab_num) / NULLIF(sum(main_kpis_cidade.acc_cs_rab_den), 0::real), 1::real))::numeric, 2) AS acc_cs,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS eff_ps,
    sum(main_kpis_cidade.acc_ps_rab_den) - sum(main_kpis_cidade.acc_ps_rab_num) AS fails_acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_ps_rab_num) / NULLIF(sum(main_kpis_cidade.acc_ps_rab_den), 0::real), 1::real))::numeric, 2) AS acc_ps,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS eff_hsdpa,
    sum(main_kpis_cidade.acc_hs_den) - sum(main_kpis_cidade.acc_hs_num) AS fails_acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_hs_f2h_num) / NULLIF(sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS eff_f2h,
    sum(main_kpis_cidade.acc_hs_f2h_den) - sum(main_kpis_cidade.acc_hs_f2h_num) AS fails_f2h,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE(sum(main_kpis_cidade.acc_hs_num) / NULLIF(sum(main_kpis_cidade.acc_hs_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa,
    round((100::real * COALESCE(sum(main_kpis_cidade.acc_rrc_num) / NULLIF(sum(main_kpis_cidade.acc_rrc_den), 0::real), 1::real) * COALESCE((sum(main_kpis_cidade.acc_hs_num) + sum(main_kpis_cidade.acc_hs_f2h_num)) / NULLIF(sum(main_kpis_cidade.acc_hs_den) + sum(main_kpis_cidade.acc_hs_f2h_den), 0::real), 1::real))::numeric, 2) AS acc_hsdpa_f2h,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_cs_num) / NULLIF(sum(main_kpis_cidade.drop_cs_den), 0::real), 1::real)))::numeric, 2) AS drop_cs,
    sum(main_kpis_cidade.drop_cs_den) AS fails_drop_cs,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_ps_num) / NULLIF(sum(main_kpis_cidade.drop_ps_den), 0::real), 1::real)))::numeric, 2) AS drop_ps,
    sum(main_kpis_cidade.drop_ps_den) AS fails_drop_ps,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsdpa_num) / NULLIF(sum(main_kpis_cidade.drop_hsdpa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsdpa,
    sum(main_kpis_cidade.drop_hsdpa_den) AS fails_drop_hsdpa,
    round((100::real * (1::real - COALESCE(sum(main_kpis_cidade.drop_hsupa_num) / NULLIF(sum(main_kpis_cidade.drop_hsupa_den), 0::real), 1::real)))::numeric, 2) AS drop_hsupa,
    sum(main_kpis_cidade.drop_hsupa_den) AS fails_drop_hsupa,
    round((100::real * COALESCE(sum(main_kpis_cidade.sho_succ_rate_num) / NULLIF(sum(main_kpis_cidade.sho_succ_rate_den), 0::real), 1::real))::numeric, 2) AS sho_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.soft_hand_succ_rate_num) / NULLIF(sum(main_kpis_cidade.soft_hand_succ_rate_den), 0::real), 1::real))::numeric, 2) AS soft_hand_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.cs_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.cs_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS cs_hho_intra_freq_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.ps_hho_intra_freq_succ_num) / NULLIF(sum(main_kpis_cidade.ps_hho_intra_freq_succ_den), 0::real), 1::real))::numeric, 2) AS ps_hho_intra_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.hho_inter_freq_succ_num) / NULLIF(sum(main_kpis_cidade.hho_inter_freq_succ_den), 0::real), 1::real))::numeric, 2) AS hho_inter_freq_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_cs_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_cs_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_cs_succ_rate,
    round((100::real * COALESCE(sum(main_kpis_cidade.iratho_ps_succ_num) / NULLIF(sum(main_kpis_cidade.iratho_ps_succ_den), 0::real), 1::real))::numeric, 2) AS iratho_ps_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_cs_num) / NULLIF(sum(main_kpis_cidade.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs_succ_rate,
    round(100::numeric * (1::real - COALESCE(sum(main_kpis_cidade.retention_ps_num) / NULLIF(sum(main_kpis_cidade.retention_ps_den), 0::real), 0::real))::numeric, 2) AS retention_ps_succ_rate,
    round((100::real * (COALESCE(sum(main_kpis_cidade.sho_over_num) / NULLIF(sum(main_kpis_cidade.sho_over_den), 0::real), 1::real) - 1::double precision))::numeric, 2) AS sho_over,
    round(10::numeric * log(avg(power(10::double precision, main_kpis_cidade.rtwp / 10::double precision)))::numeric, 2) AS rtwp,
    round((100::real * (1::double precision - (sum(main_kpis_cidade.unavailtime) / (sum(main_kpis_cidade.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    round((sum(main_kpis_cidade.data_hsdpa) / 1024::real)::numeric, 2) AS data_hsdpa,
    round((sum(main_kpis_cidade.data_hsupa) / 1024::real)::numeric, 2) AS data_hsupa,
    round((sum(main_kpis_cidade.ps_r99_ul) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_ul,
    round((sum(main_kpis_cidade.ps_r99_dl) / (1024 * 1024)::real)::numeric, 2) AS ps_r99_dl,
    round(sum(main_kpis_cidade.voice_traffic_dl)::numeric, 2) AS voice_traffic_dl,
    round(sum(main_kpis_cidade.voice_traffic_ul)::numeric, 2) AS voice_traffic_ul,
    round(sum(main_kpis_cidade.voice_erlangs_num)::numeric, 2) AS voice_erlangs_num,
    round(sum(main_kpis_cidade.voice_erlangs_den)::numeric, 2) AS voice_erlangs_den,
    round(avg(main_kpis_cidade.hsdpa_users)::numeric, 2) AS hsdpa_users,
    round(avg(main_kpis_cidade.hsupa_users)::numeric, 2) AS hsupa_users,
    round(avg(main_kpis_cidade.ps_nonhs_users)::numeric, 2) AS ps_nonhs_users,
    round(avg(main_kpis_cidade.dch_users)::numeric, 2) AS dch_users,
    round(avg(main_kpis_cidade.pch_users)::numeric, 2) AS pch_users,
    round(avg(main_kpis_cidade.fach_users)::numeric, 2) AS fach_users,
    round(avg(main_kpis_cidade.thp_hsdpa)::numeric, 2) AS thp_hsdpa,
    round(avg(main_kpis_cidade.thp_hsupa)::numeric, 2) AS thp_hsupa
   FROM umts_kpi.main_kpis_cidade
  GROUP BY date_part('week'::text, main_kpis_cidade.datetime::date + '1 day'::interval), main_kpis_cidade.uf;

ALTER TABLE umts_kpi.vw_main_kpis_uf_rate_weekly
  OWNER TO postgres;

  ------------------------------------------------
-- View: umts_kpi.vw_main_kpis_weekly

-- DROP VIEW umts_kpi.vw_main_kpis_weekly;

CREATE OR REPLACE VIEW umts_kpi.vw_main_kpis_weekly AS 
 SELECT date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week,
    main_kpis_daily.rnc,
    main_kpis_daily.cellname,
    main_kpis_daily.cellid,
    sum(main_kpis_daily.gp) AS gp,
    sum(main_kpis_daily.acc_rrc_num) AS acc_rrc_num,
    sum(main_kpis_daily.acc_rrc_den) AS acc_rrc_den,
    sum(main_kpis_daily.acc_cs_rab_num) AS acc_cs_rab_num,
    sum(main_kpis_daily.acc_cs_rab_den) AS acc_cs_rab_den,
    sum(main_kpis_daily.acc_ps_rab_num) AS acc_ps_rab_num,
    sum(main_kpis_daily.acc_ps_rab_den) AS acc_ps_rab_den,
    sum(main_kpis_daily.acc_hs_num) AS acc_hs_num,
    sum(main_kpis_daily.acc_hs_den) AS acc_hs_den,
    sum(main_kpis_daily.acc_hs_f2h_num) AS acc_hs_f2h_num,
    sum(main_kpis_daily.acc_hs_f2h_den) AS acc_hs_f2h_den,
    sum(main_kpis_daily.drop_cs_num) AS drop_cs_num,
    sum(main_kpis_daily.drop_cs_den) AS drop_cs_den,
    sum(main_kpis_daily.drop_ps_num) AS drop_ps_num,
    sum(main_kpis_daily.drop_ps_den) AS drop_ps_den,
    sum(main_kpis_daily.drop_hsdpa_num) AS drop_hsdpa_num,
    sum(main_kpis_daily.drop_hsdpa_den) AS drop_hsdpa_den,
    sum(main_kpis_daily.drop_hsupa_num) AS drop_hsupa_num,
    sum(main_kpis_daily.drop_hsupa_den) AS drop_hsupa_den,
    sum(main_kpis_daily.unavailability) AS unavailability,
    sum(main_kpis_daily.unavailtime) AS unavailtime,
    sum(main_kpis_daily.sho_over_num) AS sho_over_num,
    sum(main_kpis_daily.sho_over_den) AS sho_over_den,
    avg(main_kpis_daily.rtwp) AS rtwp,
    sum(main_kpis_daily.sho_succ_rate_num) AS sho_succ_rate_num,
    sum(main_kpis_daily.sho_succ_rate_den) AS sho_succ_rate_den,
    sum(main_kpis_daily.soft_hand_succ_rate_num) AS soft_hand_succ_rate_num,
    sum(main_kpis_daily.soft_hand_succ_rate_den) AS soft_hand_succ_rate_den,
    sum(main_kpis_daily.hho_intra_freq_succ_num) AS hho_intra_freq_succ_num,
    sum(main_kpis_daily.hho_intra_freq_succ_den) AS hho_intra_freq_succ_den,
    sum(main_kpis_daily.cs_hho_intra_freq_succ_num) AS cs_hho_intra_freq_succ_num,
    sum(main_kpis_daily.cs_hho_intra_freq_succ_den) AS cs_hho_intra_freq_succ_den,
    sum(main_kpis_daily.ps_hho_intra_freq_succ_num) AS ps_hho_intra_freq_succ_num,
    sum(main_kpis_daily.ps_hho_intra_freq_succ_den) AS ps_hho_intra_freq_succ_den,
    sum(main_kpis_daily.hho_inter_freq_succ_num) AS hho_inter_freq_succ_num,
    sum(main_kpis_daily.hho_inter_freq_succ_den) AS hho_inter_freq_succ_den,
    sum(main_kpis_daily.iratho_cs_succ_num) AS iratho_cs_succ_num,
    sum(main_kpis_daily.iratho_cs_succ_den) AS iratho_cs_succ_den,
    sum(main_kpis_daily.iratho_ps_succ_num) AS iratho_ps_succ_num,
    sum(main_kpis_daily.iratho_ps_succ_den) AS iratho_ps_succ_den,
    sum(main_kpis_daily.retention_cs_num) AS retention_cs_num,
    sum(main_kpis_daily.retention_cs_den) AS retention_cs_den,
    sum(main_kpis_daily.retention_ps_num) AS retention_ps_num,
    sum(main_kpis_daily.retention_ps_den) AS retention_ps_den,
    avg(main_kpis_daily.thp_hsdpa) AS thp_hsdpa,
    avg(main_kpis_daily.thp_hsupa) AS thp_hsupa,
    sum(main_kpis_daily.data_hsdpa) AS data_hsdpa,
    sum(main_kpis_daily.data_hsupa) AS data_hsupa,
    sum(main_kpis_daily.ps_r99_ul) AS ps_r99_ul,
    sum(main_kpis_daily.ps_r99_dl) AS ps_r99_dl,
    sum(main_kpis_daily.voice_traffic_dl) AS voice_traffic_dl,
    sum(main_kpis_daily.voice_traffic_ul) AS voice_traffic_ul,
    sum(main_kpis_daily.voice_erlangs_num) AS voice_erlangs_num,
    sum(main_kpis_daily.voice_erlangs_den) AS voice_erlangs_den,
    avg(main_kpis_daily.hsdpa_users) AS hsdpa_users,
    avg(main_kpis_daily.hsupa_users) AS hsupa_users,
    avg(main_kpis_daily.ps_nonhs_users) AS ps_nonhs_users,
    avg(main_kpis_daily.dch_users) AS dch_users,
    avg(main_kpis_daily.pch_users) AS pch_users,
    avg(main_kpis_daily.fach_users) AS fach_users
   FROM umts_kpi.main_kpis_daily
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval), main_kpis_daily.rnc, main_kpis_daily.cellname, main_kpis_daily.cellid;

ALTER TABLE umts_kpi.vw_main_kpis_weekly
  OWNER TO postgres;

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------
  
  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  ------------------------------------------------

  
  
  