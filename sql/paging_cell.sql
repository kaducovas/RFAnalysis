select * from

(select 
date_part('year'::text, c.date) AS year,
date_part('week'::text, c.date + '1 day'::interval) AS week,
u.nodeb,
c.rnc,
CASE
WHEN "substring"(c.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
WHEN "substring"(c.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
WHEN "substring"(c.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
WHEN "substring"(c.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
WHEN "substring"(c.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
WHEN "substring"(c.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
ELSE 'UNKNOWN'::text
END AS region, 
round(avg(100*COALESCE(vs_rrc_paging1_loss_pchcong_cell/NULLIF(vs_utran_attpaging1,0),0))::numeric,4) as paging
from umts_counter.fss_67109509_daily c inner join umts_control.cells_database u on c.rnc = u.rnc
where c.cellid = u.cellid
group by (date_part('year'::text, c.date),
date_part('week'::text, c.date + '1 day'::interval),
u.nodeb,
c.rnc,
CASE
WHEN "substring"(c.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
WHEN "substring"(c.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
WHEN "substring"(c.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
WHEN "substring"(c.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
WHEN "substring"(c.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
WHEN "substring"(c.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
ELSE 'UNKNOWN'::text
END)) c

where week = 39 and year = 2017