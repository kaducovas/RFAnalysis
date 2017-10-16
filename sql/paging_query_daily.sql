SELECT * FROM 
(
select u.cellname as node, 'cell'::text as type, c.date,
round(100*COALESCE(vs_rrc_paging1_loss_pchcong_cell/NULLIF(vs_utran_attpaging1,0),0)::numeric,4) as paging
from umts_counter.fss_67109509_daily c inner join umts_configuration.ucellsetup u on c.rnc = u.rncname where c.cellid = u.cellid

union
select rnc as node, 'rnc'::text as type, date,
round(100*COALESCE((vs_ranap_cspaging_loss+ vs_ranap_pspaging_loss)/NULLIF((vs_ranap_cspaging_att+vs_ranap_pspaging_att),0),0)::numeric,4) as paging
from umts_counter.fss_67109438_daily

union
select enodeb as node, 'enodeb'::text as type, date,
round(100*COALESCE(l_paging_dis_num/NULLIF(l_paging_s1_rx,0),0)::numeric,4) as paging
from lte_counter.fss_1526726666_daily
) t 
where date > '2017-09-18' --dia que todos os contadores foram habilitados
order by type, node, date, paging desc