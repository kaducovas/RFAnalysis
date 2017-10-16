SELECT * FROM 
(
select cellname as node, 'cell'::text as type, datetime,
round(100*COALESCE(vs_rrc_paging1_loss_pchcong_cell/NULLIF(vs_utran_attpaging1,0),0)::numeric,4) as paging
from umts_counter.fss_67109509

union
select rnc as node, 'rnc'::text as type, datetime,
round(100*COALESCE((vs_ranap_cspaging_loss+ vs_ranap_pspaging_loss)/NULLIF((vs_ranap_cspaging_att+vs_ranap_pspaging_att),0),0)::numeric,4) as paging
from umts_counter.fss_67109438

union
select enodeb as node, 'enodeb'::text as type, datetime,
round(100*COALESCE(l_paging_dis_num/NULLIF(l_paging_s1_rx,0),0)::numeric,4) as paging
from lte_counter.fss_1526726666
) t order by type, node, datetime, paging desc