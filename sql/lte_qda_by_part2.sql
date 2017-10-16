copy(SELECT 
date_part('week'::text, datetime::date + '1 day'::interval) AS week,
    cells.region AS node,    
enodeb,
COALESCE(sum(l_rrc_connreq_succ) / NULLIF(sum(l_rrc_connreq_att), 0::real), 1::real) rrc,
COALESCE(sum(l_s1sig_connest_succ) / NULLIF(sum(l_s1sig_connest_att), 0::real), 1::real) s1sig,
COALESCE(sum(l_e_rab_succest) / NULLIF(sum(l_e_rab_attest), 0::real), 1::real) e_rab,
COALESCE(sum(l_rrc_connreq_succ) / NULLIF(sum(l_rrc_connreq_att), 0::real), 1::real) * COALESCE(sum(l_s1sig_connest_succ) / NULLIF(sum(l_s1sig_connest_att), 0::real), 1::real) * COALESCE(sum(l_e_rab_succest) / NULLIF(sum(l_e_rab_attest), 0::real), 1::real) accessibility,

round((coalesce(sum(rrc_qda_good_attempts)::real/nullif(sum(rrc_qda_good_attempts)+sum(rrc_qda_bad_attempts),0),1::real))::numeric,4) as qda_rrc,
round((coalesce(sum(l_s1sig_qda_good_attempts)::real/nullif(sum(l_s1sig_qda_good_attempts)+sum(l_s1sig_qda_bad_attempts),0),1::real))::numeric,4) qda_s1sig,
round((coalesce(sum(l_e_rab_qda_good_attempts)::real/nullif(sum(l_e_rab_qda_good_attempts)+sum(l_e_rab_qda_bad_attempts),0),1::real))::numeric,4) qda_e_rab,
round((coalesce(sum(qda_good_attempts)::real/nullif(sum(qda_good_attempts)+sum(qda_bad_attempts),0),1::real))::numeric,4) qda
from
(select 
datetime,enodeb,locellid,l_rrc_connreq_succ,l_rrc_connreq_att,l_s1sig_connest_succ,l_s1sig_connest_att,l_e_rab_succest,l_e_rab_attest,
        CASE
            WHEN (COALESCE(l_rrc_connreq_succ / NULLIF(l_rrc_connreq_att, 0::real), 1::real))  < 0.99::real THEN 0::real
            ELSE l_rrc_connreq_att
        END AS rrc_qda_good_attempts,
        CASE
            WHEN (COALESCE(l_rrc_connreq_succ / NULLIF(l_rrc_connreq_att, 0::real), 1::real))  < 0.99::real THEN l_rrc_connreq_att
            ELSE 0::real
        END AS rrc_qda_bad_attempts,
--------
        CASE
            WHEN COALESCE(l_s1sig_connest_succ / NULLIF(l_s1sig_connest_att, 0::real), 1::real) < 0.99::real THEN 0::real
            ELSE l_s1sig_connest_att 
        END AS l_s1sig_qda_good_attempts,
        CASE
            WHEN COALESCE(l_s1sig_connest_succ / NULLIF(l_s1sig_connest_att, 0::real), 1::real)  < 0.99::real THEN l_s1sig_connest_att 
            ELSE 0::real
        END AS l_s1sig_qda_bad_attempts,
--------
        CASE
           when COALESCE(l_e_rab_succest / NULLIF(l_e_rab_attest, 0::real), 1::real) < 0.99::real THEN 0::real
            ELSE l_e_rab_attest
        END AS l_e_rab_qda_good_attempts,
        CASE
            WHEN COALESCE(l_e_rab_succest / NULLIF(l_e_rab_attest, 0::real), 1::real) < 0.99::real THEN l_e_rab_attest
            ELSE 0::real
        END AS l_e_rab_qda_bad_attempts,

	CASE
            WHEN (COALESCE(l_rrc_connreq_succ / NULLIF(l_rrc_connreq_att, 0::real), 1::real) * COALESCE(l_s1sig_connest_succ / NULLIF(l_s1sig_connest_att, 0::real), 1::real) * COALESCE(l_e_rab_succest / NULLIF(l_e_rab_attest, 0::real), 1::real)) < 0.99::real THEN 0::real
            ELSE l_rrc_connreq_att + l_s1sig_connest_att + l_e_rab_attest
        END AS qda_good_attempts,
        CASE
            WHEN (COALESCE(l_rrc_connreq_succ / NULLIF(l_rrc_connreq_att, 0::real), 1::real) * COALESCE(l_s1sig_connest_succ / NULLIF(l_s1sig_connest_att, 0::real), 1::real) * COALESCE(l_e_rab_succest / NULLIF(l_e_rab_attest, 0::real), 1::real)) < 0.99::real THEN l_rrc_connreq_att + l_s1sig_connest_att + l_e_rab_attest
            ELSE 0::real
        END AS qda_bad_attempts
 from npm_reports.vw_nqi_lte
 WHERE datetime::time BETWEEN '07:00' AND '23:00'
 and datetime between '2017-04-23' and '2017-04-30') t 
  JOIN lte_control.cells ON t.enodeb = cells.site AND t.locellid = cells.cellid
  GROUP BY date_part('week'::text, datetime::date  + '1 day'::interval), cells.region

,ENODEB
  ) to '/home/postgres/dump/weekly_qda_enodeb_lte.csv' delimiter ',' csv header