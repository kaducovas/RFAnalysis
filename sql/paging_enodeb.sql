select * from

(select
date_part('year'::text, date) AS year,
date_part('week'::text, date + '1 day'::interval) AS week,
c.enodeb,
u.region,
round(avg(100*COALESCE(l_paging_dis_num/NULLIF(l_paging_s1_rx,0),0))::numeric,8) as paging
from lte_counter.fss_1526726666_daily c inner join lte_control.cells u on u.enodeb=c.enodeb
where u.cellid = c.locellid
and date > '2017-09-18' --dia que todos os contadores foram habilitados
group by (date_part('year'::text, date),
date_part('week'::text, date + '1 day'::interval),
c.enodeb,
u.region)
) e

where week = 39 and year = 2017