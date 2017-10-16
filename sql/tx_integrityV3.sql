--CREATE OR REPLACE VIEW umts_kpi.vw_tx_integrity_ani AS
create table w29_tx as 
SELECT t.rnc,
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
	(SELECT tx_ip.rnc,tx_ip.ani,tx_ip.nodet,tx_ip.node,tx_atm.norm,tx_ip.transt,tx_ip.datetime,tx_ip.ping_meanlost,tx_ip.ping_meanjitter,tx_ip.ping_meandelay,
vs_iub_flowctrol_ul_dropnum_lgcport1,vs_iub_flowctrol_dl_dropnum_lgcport1,vs_iub_flowctrol_ul_congtime_lgcport1,vs_iub_flowctrol_dl_congtime_lgcport1,
atm_dl_utilization,atm_ul_utilization,			
                CASE
                    WHEN vs_iub_flowctrol_dl_dropnum_lgcport1 > 1000 or vs_iub_flowctrol_ul_dropnum_lgcport1 > 1000 or tx_ip.ping_meandelay > 80::double precision OR tx_ip.ping_meanjitter > 2::real OR tx_ip.ping_meanlost > 5::real or atm_dl_utilization >80 or atm_ul_utilization >80 THEN 0
                    ELSE 1
                END AS user_good_tx,
                CASE
                    WHEN vs_iub_flowctrol_dl_dropnum_lgcport1 > 1000 or vs_iub_flowctrol_ul_dropnum_lgcport1 > 1000 or tx_ip.ping_meandelay > 80::double precision OR tx_ip.ping_meanjitter > 2::real OR tx_ip.ping_meanlost > 5::real or atm_dl_utilization >80 or atm_ul_utilization >80 THEN 1
                    ELSE 0
                END AS user_bad_tx
                from
(select
rnc,nodeb,atm.norm,ani,transt,atm.datetime,vs_iub_flowctrol_ul_dropnum_lgcport1,vs_iub_flowctrol_dl_dropnum_lgcport1,vs_iub_flowctrol_ul_congtime_lgcport1,vs_iub_flowctrol_dl_congtime_lgcport1,
round((100::real * COALESCE(vs_atmdlmaxused_1 / NULLIF(vs_atmdltotal_1, 0::real), 0::real))::numeric, 2) AS atm_dl_utilization,
round((100::real * COALESCE(vs_atmulmaxused_1 / NULLIF(vs_atmultotal_1, 0::real), 0::real))::numeric, 2) AS atm_ul_utilization
from
(select *,get_nodeb_name(nodeb,'nodeb') as norm from umts_kpi.tx_atm
where datetime between '2017-07-16' and '2017-07-23' ----acelerar
) atm 
left join 
(select *,get_nodeb_name(name,'nodeb') norm from umts_configuration.adjnode) adj 
on atm.rnc=adj.rncname and adj.norm=atm.norm) tx_atm
inner join 
(select rnc,ip.ani,ip.nodet,node,transt,ip.datetime,ping_meanlost,ping_meanjitter,ping_meandelay
from umts_kpi.vw_tx_ip_hour ip 
left join umts_configuration.adjnode adj
on ip.rnc = adj.rncname and adj.ani = ip.ani
and ip.datetime between '2017-07-16' and '2017-07-23' ----acelerar
) tx_ip
on tx_atm.rnc = tx_ip.rnc and tx_atm.ani = tx_ip.ani
WHERE tx_ip.datetime::time without time zone >= '07:00:00'::time without time zone AND tx_ip.datetime::time without time zone <= '23:59:00'::time without time zone
and tx_ip.datetime between '2017-07-16' and '2017-07-23'
) t
GROUP BY t.rnc, t.ani, t.nodet, t.norm, date_part('year'::text, t.datetime::date), date_part('week'::text, t.datetime::date + '1 day'::interval),t.transt
