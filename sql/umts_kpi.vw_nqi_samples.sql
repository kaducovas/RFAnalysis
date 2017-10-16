-- View: umts_kpi.vw_nqi_sample

-- DROP VIEW umts_kpi.vw_nqi_sample;

CREATE OR REPLACE VIEW umts_kpi.vw_nqi_sample AS 
 SELECT main_kpis.rnc,
    main_kpis.cellid,
    main_kpis.datetime,
    main_kpis.gp,
    COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_cs_rab_num / NULLIF(main_kpis.acc_cs_rab_den, 0::real), 1::real) AS acc_cs,
        CASE
            WHEN (COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_cs_rab_num / NULLIF(main_kpis.acc_cs_rab_den, 0::real), 1::real)) < 0.985::real THEN 0::real
            ELSE main_kpis.acc_rrc_den + main_kpis.acc_cs_rab_den
        END AS qda_cs_good_attempts,
        CASE
            WHEN (COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_cs_rab_num / NULLIF(main_kpis.acc_cs_rab_den, 0::real), 1::real)) < 0.985::real THEN main_kpis.acc_rrc_den + main_kpis.acc_cs_rab_den
            ELSE 0::real
        END AS qda_cs_bad_attempts,
    COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_hs_num / NULLIF(main_kpis.acc_hs_den, 0::real), 1::real) AS acc_hsdpa,
        CASE
            WHEN (COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_hs_num / NULLIF(main_kpis.acc_hs_den, 0::real), 1::real)) < 0.985::real THEN 0::real
            ELSE main_kpis.acc_rrc_den + main_kpis.acc_hs_den
        END AS qda_ps_good_attempts,
        CASE
            WHEN (COALESCE(main_kpis.acc_rrc_num / NULLIF(main_kpis.acc_rrc_den, 0::real), 1::real) * COALESCE(main_kpis.acc_hs_num / NULLIF(main_kpis.acc_hs_den, 0::real), 1::real)) < 0.985::real THEN main_kpis.acc_rrc_den + main_kpis.acc_hs_den
            ELSE 0::real
        END AS qda_ps_bad_attempts,
    COALESCE((main_kpis.acc_hs_num + main_kpis.acc_hs_f2h_num) / NULLIF(main_kpis.acc_hs_den + main_kpis.acc_hs_f2h_den, 0::real), 1::real) AS acc_hsdpa_f2h,
        CASE
            WHEN COALESCE((main_kpis.acc_hs_num + main_kpis.acc_hs_f2h_num) / NULLIF(main_kpis.acc_hs_den + main_kpis.acc_hs_f2h_den, 0::real), 1::real) < 0.985::real THEN 0::real
            ELSE main_kpis.acc_hs_den + main_kpis.acc_hs_f2h_den
        END AS qda_ps_f2h_good_attempts,
        CASE
            WHEN COALESCE((main_kpis.acc_hs_num + main_kpis.acc_hs_f2h_num) / NULLIF(main_kpis.acc_hs_den + main_kpis.acc_hs_f2h_den, 0::real), 1::real) < 0.985::real THEN main_kpis.acc_hs_den + main_kpis.acc_hs_f2h_den
            ELSE 0::real
        END AS qda_ps_f2h_bad_attempts,
    1::real - COALESCE(main_kpis.drop_cs_num / NULLIF(main_kpis.drop_cs_den, 0::real), 0::real) AS drop_cs,
        CASE
            WHEN (1::real - COALESCE(main_kpis.drop_cs_num / NULLIF(main_kpis.drop_cs_den, 0::real), 0::real)) < 0.985::real THEN 0::real
            ELSE main_kpis.drop_cs_den
        END AS qdr_cs_good_attempts,
        CASE
            WHEN (1::real - COALESCE(main_kpis.drop_cs_num / NULLIF(main_kpis.drop_cs_den, 0::real), 0::real)) < 0.985::real THEN main_kpis.drop_cs_den
            ELSE 0::real
        END AS qdr_cs_bad_attempts,
    1::real - COALESCE(main_kpis.drop_ps_num / NULLIF(main_kpis.drop_ps_den, 0::real), 0::real) AS drop_ps,
        CASE
            WHEN (1::real - COALESCE(main_kpis.drop_ps_num / NULLIF(main_kpis.drop_ps_den, 0::real), 0::real)) < 0.985::real THEN 0::real
            ELSE main_kpis.drop_ps_den
        END AS qdr_ps_good_attempts,
        CASE
            WHEN (1::real - COALESCE(main_kpis.drop_ps_num / NULLIF(main_kpis.drop_ps_den, 0::real), 0::real)) < 0.985::real THEN main_kpis.drop_ps_den
            ELSE 0::real
        END AS qdr_ps_bad_attempts,
    main_kpis.thp_hsdpa,
        CASE
            WHEN main_kpis.thp_hsdpa IS NULL OR main_kpis.thp_hsdpa < 400::real OR main_kpis.hsdpa_users < 1::real THEN 0
            ELSE 1
        END AS user_good_throughput,
        CASE
            WHEN main_kpis.thp_hsdpa IS NULL OR main_kpis.thp_hsdpa > 400::real OR main_kpis.hsdpa_users < 1::real THEN 0
            ELSE 1
        END AS user_bad_throughput,
    main_kpis.unavailability,
    main_kpis.retention_cs_num,
    main_kpis.retention_cs_den,
    main_kpis.retention_ps_num,
    main_kpis.retention_ps_den,
    main_kpis.voice_erlangs_num,
    main_kpis.voice_erlangs_den,
    main_kpis.hsdpa_users,
    main_kpis.ps_nonhs_users
   FROM umts_kpi.main_kpis;

ALTER TABLE umts_kpi.vw_nqi_sample
  OWNER TO postgres;
