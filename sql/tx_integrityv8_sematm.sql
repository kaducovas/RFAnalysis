--CREATE OR REPLACE VIEW umts_kpi.vw_tx_integrity_ani AS
--create table w39_tx_sem_atm as 
copy(SELECT t.rnc,
    t.ani,
    t.nodet,
	t.transt,
    t.norm as node,
    date_part('year'::text, t.datetime::date) AS year,
    date_part('week'::text, t.datetime::date + '1 day'::interval) AS week,
    round(avg(t.ping_meanlost)::numeric, 2) AS ping_meanlost,
    round(avg(t.ping_meanjitter)::numeric, 2) AS ping_meanjitter,
    round(avg(t.ping_meandelay)::numeric, 2) AS ping_meandelay,
    round(avg(t.vs_iub_flowctrol_dl_dropnum_lgcport1)::numeric, 2) AS vs_iub_flowctrol_dl_dropnum_lgcport1,
	round(avg(t.vs_iub_flowctrol_ul_dropnum_lgcport1)::numeric, 2) AS vs_iub_flowctrol_ul_dropnum_lgcport1,
    round(avg(t.vs_iub_flowctrol_dl_congtime_lgcport1)::numeric, 2) AS vs_iub_flowctrol_dl_congtime_lgcport1,
    round(avg(t.vs_iub_flowctrol_ul_congtime_lgcport1)::numeric, 2) AS vs_iub_flowctrol_ul_congtime_lgcport1,
    round(avg(t.atm_dl_utilization)::numeric, 2) AS atm_dl_utilization,
    round(avg(t.atm_ul_utilization)::numeric, 2) AS atm_ul_utilization,	
    round((100::real * COALESCE(sum(t.user_good_tx)::double precision / NULLIF((sum(t.user_good_tx) + sum(t.user_bad_tx))::double precision, 0::real), 1::real::double precision))::numeric, 2) AS tx_integrity	
FROM
	(SELECT rnc,ani,nodet,tx_ip.node,norm,transt,datetime,tx_ip.ping_meanlost,tx_ip.ping_meanjitter,tx_ip.ping_meandelay,
null::real vs_iub_flowctrol_ul_dropnum_lgcport1,null::real vs_iub_flowctrol_dl_dropnum_lgcport1,null::real vs_iub_flowctrol_ul_congtime_lgcport1,null::real vs_iub_flowctrol_dl_congtime_lgcport1,
null::real atm_dl_utilization,null::real atm_ul_utilization,			
                CASE
                    WHEN tx_ip.ping_meandelay > 80::double precision OR tx_ip.ping_meanjitter > 2::real OR tx_ip.ping_meanlost > 5::real THEN 0
                    ELSE 1
                END AS user_good_tx,
                CASE
                    WHEN tx_ip.ping_meandelay > 80::double precision OR tx_ip.ping_meanjitter > 2::real OR tx_ip.ping_meanlost > 5::real THEN 1
                    ELSE 0
                END AS user_bad_tx
                from
(select rnc,ip.ani,ip.nodet,node,transt,ip.datetime,ping_meanlost,ping_meanjitter,ping_meandelay
from umts_kpi.vw_tx_ip_hour ip 
right join umts_configuration.adjnode adj
on ip.rnc = adj.rncname and adj.ani = ip.ani
where ip.datetime between '2017-09-24' and '2017-10-01' ----acelerar
and ip.datetime::time without time zone >= '07:00:00'::time without time zone AND ip.datetime::time without time zone <= '23:59:00'::time without time zone
) tx_ip
--WHERE tx_ip.datetime::time without time zone >= '07:00:00'::time without time zone AND tx_ip.datetime::time without time zone <= '23:59:00'::time without time zone
--and tx_ip.datetime between '2017-07-16' and '2017-07-23'
) t
GROUP BY t.rnc, t.ani, t.nodet, t.norm, date_part('year'::text, t.datetime::date), date_part('week'::text, t.datetime::date + '1 day'::interval),t.transt) to '/home/postgres/dump/w39_tx_sem_atm.txt'



--select * from w29_txv5 order by transt