---
--NOSSO NQI HS e CS por regional
--
select week,date,node,
STRING_AGG(source::text, ',' order by source,node) AS source,
STRING_AGG(qda_ps_f2h::text, ',' order by source,node) AS qda_ps_f2h,
STRING_AGG(qdr_ps::text, ',' order by source,node) AS qdr_ps,
STRING_AGG(retention_ps::text, ',' order by source,node) AS retention_ps,
STRING_AGG(ps_availability::text, ',' order by source,node) AS availability,
STRING_AGG(throughput::text, ',' order by source,node) AS throughput,
STRING_AGG(hsdpa_users_ratio::text, ',' order by source,node) AS hsdpa_users_ratio,
STRING_AGG(qda_cs::text, ',' order by source,node) AS qda_cs,
STRING_AGG(qdr_cs::text, ',' order by source,node) AS qdr_cs,
STRING_AGG(cs_availability::text, ',' order by source,node) AS availability,
STRING_AGG(retention_cs::text, ',' order by source,node) AS retention_cs
from
(select 'NQI-HUAWEI'::text as source,week,date,node,
qda_ps_f2h,qdr_ps,retention_ps,availability as ps_availability,throughput,hsdpa_users_ratio,qda_cs, qdr_cs,availability as cs_availability,retention_cs  
FROM umts_kpi.vw_nqi_daily_region
  where date = '2017-04-29'
union  
---
--CLARO NQI HS e CS
--
select 
'NQI-Claro'::text as source,
17::integer as week,
id_tempo::date as date, 
nm_regional as node,
--nm_celula,
--nm_tecnologia, 
--nm_fabricante, 

round((100::real * COALESCE(sum(qda_ps_good_attempts) / NULLIF(sum(qda_ps_good_attempts + qda_ps_bad_attempts), 0::real), 1::real))::numeric, 2) as qda_ps,
round((100::real * COALESCE(sum(qdr_ps_good_attempts) / NULLIF(sum(qdr_ps_good_attempts + qdr_ps_bad_attempts), 0::real), 1::real))::numeric, 2) as qdr_ps,
round((100::real * COALESCE(sum(umts_ps_retention_n) / NULLIF(sum(umts_ps_retention_d), 0::real), 1::real))::numeric, 2) as ps_retention,
round((100::real * COALESCE(sum(availability_n) / NULLIF(sum(availability_d), 0::real), 1::real))::numeric, 2) as availability,
--avg(user_macd_throughput_kbps_avg) as user_macd_throughput_kbps_avg,
round((100::real * COALESCE(sum(qt_throughput_n) / NULLIF(sum(qt_throughput_d), 0::real), 1::real))::numeric, 2) as throughput,
round((100::real * COALESCE(sum(hsdpa_user_ratio_n) / NULLIF(sum(hsdpa_user_ratio_d), 0::real), 1::real))::numeric, 2) as hsdpa_user_ratio,
round((100::real * COALESCE(sum(qda_cs_good_attempts) / NULLIF(sum(qda_cs_good_attempts + qda_cs_bad_attempts), 0::real), 1::real))::numeric, 2) as qda_cs,
round((100::real * COALESCE(sum(qdr_cs_good_attempts) / NULLIF(sum(qdr_cs_good_attempts + qdr_cs_bad_attempts), 0::real), 1::real))::numeric, 2) as qdr_cs,
round((100::real * COALESCE(sum(availability_n) / NULLIF(sum(availability_d), 0::real), 1::real))::numeric, 2) as availability,
round((100::real * COALESCE(sum(umts_retention_n) / NULLIF(sum(umts_retention_d), 0::real), 1::real))::numeric, 2) as retention
from temp_nqi_claro
group by nm_regional,id_tempo::date
order by source,node) t
where node not in ('UNKNOWN')
group by week,date,node
--
--tabela da claro no nosso banco, basta dar update quando pedirem para compararmos
--select * temp_nqi_claro
