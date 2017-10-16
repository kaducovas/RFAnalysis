-- Function: umts_kpi.worst_cells_main_kpis_fails_daily(text, text, date, text)

-- DROP FUNCTION umts_kpi.worst_cells_main_kpis_fails_daily(text, text, date, text);

CREATE OR REPLACE FUNCTION umts_kpi.worst_cells_main_kpis_fails_daily(
    netype text,
    kpi_name text,
    data date,
    ne text)
  RETURNS SETOF worst_cells_node_daily_fails AS
$BODY$
declare
  cur_row record;
  r worst_cells_node_daily_fails;
    mean real := -1;
sql text;
kpi_aux text;
  
begin 

if kpi_name in ('acc_rrc','acc_ps_rab','acc_cs_rab','acc_hs','acc_hs_f2h','soft_hand_succ_rate','cs_hho_intra_freq_succ','ps_hho_intra_freq_succ','hho_inter_freq_succ','iratho_cs_succ','iratho_ps_succ') THEN

	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s_den-%2$s_num as cell_fails,
round((100*(%2$s_den-%2$s_num)::real/(sum(%2$s_den) over (partition by date,c.%1$s) - sum(%2$s_num) over (partition by date,c.%1$s))::real)::numeric,2)::real as impact
from umts_kpi.main_kpis_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date between (''%4$s''::date - interval ''6 days'')::date and ''%4$s''
order by date,%2$s_den-%2$s_num desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)
	loop  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

ELSIF kpi_name in ('drop_cs','drop_ps','retention_cs','retention_ps','nqi_retention_ps','nqi_retention_cs') THEN

		  if (kpi_name like 'nqi%') then
			kpi_aux := 'nqi_daily';
			sql := format('select substring(''%s'' from 5 for 12)',kpi_name);
			execute sql INTO kpi_name;
		  ELSe 
		    kpi_aux := 'main_kpis_daily';			
		  end if;

	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s_num as cell_fails,
round((100*(%2$s_num)::real/(sum(%2$s_num) over (partition by date,c.%1$s))::real)::numeric,2)::real as impact
from umts_kpi.%5$s m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date between (''%4$s''::date - interval ''6 days'')::date and ''%4$s''
order by date,%2$s_den-%2$s_num desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data,kpi_aux)
	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

 

ELSIF kpi_name in ('availability','nqi_availability') THEN

		  if (kpi_name = 'availability') then
		    kpi_aux := 'main_kpis_daily';
		  ELSIF (kpi_name = 'nqi_availability') then
			kpi_aux := 'nqi_daily';
		  end if;

for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,unavailtime as cell_fails,

round(100*COALESCE((unavailtime)::real/ NULLIF ((sum(unavailtime) over (partition by date,c.%1$s))::real, 0), 1)::numeric,2)::real as impact
	
from umts_kpi.%2$s m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date between (''%4$s''::date - interval ''6 days'')::date and ''%4$s''
order by date,unavailtime desc) t group by node,rncname,cell,cellid',netype,kpi_aux,ne,data)
	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

ELSIF kpi_name in ('thp_hsdpa','thp_hsupa','rtwp') THEN


for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(%2$s::text, '','' order by date) as kpis
	from
(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s from umts_kpi.main_kpis_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date between (''%4$s''::date - interval ''6 days'')::date and ''%4$s''
order by date) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)

	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.kpis := cur_row.kpis;
		
		  return next r;
		  end loop;

elsif kpi_name in ('qda_cs','qda_ps','qdr_ps','qdr_cs','qda_ps_f2h') THEN
	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s_bad_attempts as cell_fails,
	round(100*COALESCE((%2$s_bad_attempts)::real/NULLIF((sum(%2$s_bad_attempts) over (partition by date,c.%1$s) )::real,0),1)::numeric,2)::real as impact
from umts_kpi.nqi_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date between (''%4$s''::date - interval ''6 days'')::date and ''%4$s''
order by date,%2$s_bad_attempts desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)		  
		  	loop  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;
		  
elsif kpi_name in ('throughput') THEN
	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,user_bad_throughput as cell_fails,
	round(100*COALESCE((user_bad_throughput)::real/NULLIF((sum(user_bad_throughput) over (partition by date,c.%1$s) )::real,0),1)::numeric,2)::real as impact
from umts_kpi.nqi_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date between (''%4$s''::date - interval ''6 days'')::date and ''%4$s''
order by date,user_bad_throughput desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)		  
		  	loop  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;
		  
		  
   end if;  
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION umts_kpi.worst_cells_main_kpis_fails_daily(text, text, date, text)
  OWNER TO postgres;

  --------------------------------------------------------------------------------------
-- Function: umts_kpi.worst_cells_main_kpis_fails_hourly(text, text, date, text)

-- DROP FUNCTION umts_kpi.worst_cells_main_kpis_fails_hourly(text, text, date, text);

CREATE OR REPLACE FUNCTION umts_kpi.worst_cells_main_kpis_fails_hourly(
    netype text,
    kpi_name text,
    data date,
    ne text)
  RETURNS SETOF worst_cells_node_daily_fails AS
$BODY$
declare
  cur_row record;
  r worst_cells_node_daily_fails;
    mean real := -1;

  
begin 

if kpi_name in ('acc_rrc','acc_ps_rab','acc_cs_rab','acc_hs','acc_hs_f2h','soft_hand_succ_rate','cs_hho_intra_freq_succ','ps_hho_intra_freq_succ','hho_inter_freq_succ','iratho_cs_succ','iratho_ps_succ') THEN

	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.cell,m.rnc as rncname,m.cellid,datetime as date,%2$s_den-%2$s_num as cell_fails,
round(100*COALESCE((%2$s_den-%2$s_num)::real/ NULLIF ((sum(%2$s_den) over (partition by datetime,c.%1$s) - sum(%2$s_num) over (partition by datetime,c.%1$s))::real, 0), 1)::numeric,2)::real as impact
from umts_kpi.main_kpis m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime between (''%4$s''::timestamp - interval ''4 hours'')::timestamp and ''%4$s''
order by datetime,%2$s_den-%2$s_num desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)
	loop  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

ELSIF kpi_name in ('drop_cs','drop_ps','retention_cs','retention_ps') THEN
	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.cell,m.rnc as rncname,m.cellid,datetime as date,%2$s_num as cell_fails,
round(100*COALESCE((%2$s_num)::real/ NULLIF ((sum(%2$s_num) over (partition by datetime,c.%1$s))::real, 0), 0)::numeric,2)::real as impact
from umts_kpi.main_kpis m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime between (''%4$s''::timestamp - interval ''4 hours'')::timestamp and ''%4$s''
order by datetime,%2$s_den-%2$s_num desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)
	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

 

ELSIF kpi_name in ('availability') THEN

for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.cell,m.rnc as rncname,m.cellid,datetime as date,unavailtime as cell_fails,
	round(100*COALESCE((unavailtime)::real/ NULLIF ((sum(unavailtime) over (partition by datetime,c.%1$s))::real, 0), 1)::numeric,2)::real as impact
from umts_kpi.main_kpis m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime between (''%4$s''::timestamp - interval ''4 hours'')::timestamp and ''%4$s''
order by datetime,unavailtime desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)
	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

ELSIF kpi_name in ('thp_hsdpa','thp_hsupa','rtwp') THEN


for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(datetime::text, '','' order by datetime) as dates,	
STRING_AGG(%2$s::text, '','' order by datetime) as kpis
	from
(select c.%1$s as node,m.rnc as rncname,c.cell,m.cellid,datetime,%2$s from umts_kpi.main_kpis_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime between (''%4$s''::timestamp - interval ''4 hours'')::timestamp and ''%4$s''
order by and datetime between (''%4$s''::timestamp - interval ''4 hours'')::timestamp and ''%4$s'') t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)

	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.kpis := cur_row.kpis;
		
		  return next r;
		  end loop;

		  
   end if;  
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION umts_kpi.worst_cells_main_kpis_fails_hourly(text, text, date, text)
  OWNER TO postgres;

  --------------------------------------------------------------------------------------
-- Function: umts_kpi.worst_cells_main_kpis_fails_weekly(text, text, text, text)

-- DROP FUNCTION umts_kpi.worst_cells_main_kpis_fails_weekly(text, text, text, text);

CREATE OR REPLACE FUNCTION umts_kpi.worst_cells_main_kpis_fails_weekly(
    netype text,
    kpi_name text,
    data text,
    ne text)
  RETURNS SETOF worst_cells_node_daily_fails AS
$BODY$
declare
  cur_row record;
  r worst_cells_node_daily_fails;
    mean real := -1;
sql text;
kpi_aux text;
  
begin 

if kpi_name in ('acc_rrc','acc_ps_rab','acc_cs_rab','acc_hs','acc_hs_f2h','soft_hand_succ_rate','cs_hho_intra_freq_succ','ps_hho_intra_freq_succ','hho_inter_freq_succ','iratho_cs_succ','iratho_ps_succ') THEN

	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week as date,%2$s_den-%2$s_num as cell_fails,
round((100*(%2$s_den-%2$s_num)::real/(sum(%2$s_den) over (partition by week,c.%1$s) - sum(%2$s_num) over (partition by week,c.%1$s))::real)::numeric,2)::real as impact
from umts_kpi.vw_main_kpis_weekly m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week between (''%4$s''::integer - 3) and ''%4$s''
order by date,%2$s_den-%2$s_num desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)
	loop  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

ELSIF kpi_name in ('drop_cs','drop_ps','retention_cs','retention_ps','nqi_retention_ps','nqi_retention_cs') THEN

		  if (kpi_name like 'nqi%') then
			kpi_aux := 'vw_nqi_weekly';
			sql := format('select substring(''%s'' from 5 for 12)',kpi_name);
			execute sql INTO kpi_name;
		  ELSe 
		    kpi_aux := 'vw_main_kpis_weekly';			
		  end if;


	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week as date,%2$s_num as cell_fails,
round((100*(%2$s_num)::real/(sum(%2$s_num) over (partition by week,c.%1$s))::real)::numeric,2)::real as impact
from umts_kpi.%5$s m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week between (''%4$s''::integer - 3) and ''%4$s''
order by date,%2$s_den-%2$s_num desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data,kpi_aux)
	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

 

ELSIF kpi_name in ('availability','nqi_availability') THEN

		  if (kpi_name = 'availability') then
		    kpi_aux := 'vw_main_kpis_weekly';
		  ELSIF (kpi_name = 'nqi_availability') then
			kpi_aux := 'vw_nqi_weekly';
		  end if;

for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week as date,unavailtime as cell_fails,
round((100*(unavailtime)::real/(sum(unavailtime) over (partition by week,c.%1$s))::real)::numeric,2)::real as impact
from umts_kpi.%2$s m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week between (''%4$s''::integer - 3) and ''%4$s''
order by date,unavailtime desc) t group by node,rncname,cell,cellid',netype,kpi_aux,ne,data)
	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;

ELSIF kpi_name in ('thp_hsdpa','thp_hsupa','rtwp') THEN


for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(%2$s::text, '','' order by date) as kpis
	from
(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week as date,%2$s from umts_kpi.vw_main_kpis_weekly m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week between (''%4$s''::integer - 3) and ''%4$s''
order by date) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)

	loop
	  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;	  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.kpis := cur_row.kpis;
		
		  return next r;
		  end loop;
elsif kpi_name in ('qda_cs','qda_ps','qdr_ps','qdr_cs','qda_ps_f2h') THEN
	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week as date,%2$s_bad_attempts as cell_fails,
	round(100*COALESCE((%2$s_bad_attempts)::real/NULLIF((sum(%2$s_bad_attempts) over (partition by week,c.%1$s) )::real,0),1)::numeric,2)::real as impact
from umts_kpi.vw_nqi_weekly m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week between (''%4$s''::integer - 3) and ''%4$s''
order by date,%2$s_bad_attempts desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)		  
		  	loop  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;
		  
elsif kpi_name in ('throughput') THEN
	for cur_row in execute format('select node,rncname,cell,cellid,
STRING_AGG(date::text, '','' order by date) as dates,	
STRING_AGG(cell_fails::text, '','' order by date) as fails,	
STRING_AGG(impact::text, '','' order by date) as impacts	
	from
	(select c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week as date,user_bad_throughput as cell_fails,
	round(100*COALESCE((user_bad_throughput)::real/NULLIF((sum(user_bad_throughput) over (partition by week,c.%1$s) )::real,0),1)::numeric,2)::real as impact
from umts_kpi.vw_nqi_weekly m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week between (''%4$s''::integer - 3) and ''%4$s''
order by date,user_bad_throughput desc) t group by node,rncname,cell,cellid',netype,kpi_name,ne,data)		  
		  	loop  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.dates := cur_row.dates;
		  r.fails := cur_row.fails;
		  r.impacts := cur_row.impacts;

		  return next r;
		  end loop;
		  
   end if;  
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION umts_kpi.worst_cells_main_kpis_fails_weekly(text, text, text, text)
  OWNER TO postgres;

  --------------------------------------------------------------------------------------
-- Function: umts_kpi.worst_cells_main_kpis_rank_daily(text, text, date, text)

-- DROP FUNCTION umts_kpi.worst_cells_main_kpis_rank_daily(text, text, date, text);

CREATE OR REPLACE FUNCTION umts_kpi.worst_cells_main_kpis_rank_daily(
    netype text,
    kpi_name text,
    data date,
    ne text)
  RETURNS SETOF worst_cells_node_daily AS
$BODY$
declare
sql TEXT:= '';
  cur_row record;
  r worst_cells_node_daily;
    mean real := -1;
kpi_aux text;
  
begin 

if kpi_name in ('acc_rrc','acc_ps_rab','acc_cs_rab','acc_hs','acc_hs_f2h','soft_hand_succ_rate','cs_hho_intra_freq_succ','ps_hho_intra_freq_succ','hho_inter_freq_succ','iratho_cs_succ','iratho_ps_succ') THEN

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_den-%2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_den-%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_den) over (partition by c.%1$s) - sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.main_kpis_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by %2$s_den-%2$s_num desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi + COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('drop_cs','drop_ps','retention_cs','retention_ps') THEN

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.main_kpis_daily m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by %2$s_num desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi::double precision - COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('availability','nqi_availability') THEN		  

		  if (kpi_name = 'availability') then
		    kpi_aux := 'main_kpis_daily';
		  ELSIF (kpi_name = 'nqi_availability') then
			kpi_aux := 'nqi_daily';
		  end if;


	r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by unavailtime desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,gp,sum(gp) over (partition by c.%1$s) as node_gp,unavailtime,sum(unavailtime) over (partition by c.%1$s) as node_unavailtime
from umts_kpi.%2$s m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by unavailtime desc',netype,kpi_aux,ne,data)
loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := (1 - COALESCE(cur_row.node_unavailtime / NULLIF((cur_row.node_gp * 60), 0),0));
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		   r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := 'availability';
		  r.cell_kpi := (1 - COALESCE(cur_row.unavailtime / NULLIF((cur_row.gp * 60), 0),0));
		  r.cell_fails := cur_row.unavailtime;
		  r.impact := COALESCE(r.cell_fails / NULLIF (cur_row.node_unavailtime, 0), 0);
		  r.node_kpi := (1 - COALESCE(cur_row.node_unavailtime / NULLIF((cur_row.node_gp * 60), 0),0));
		  r.new_node_kpi := r.new_node_kpi + COALESCE(r.cell_fails / NULLIF((cur_row.node_gp * 60), 0),0);
		   r.rank := cur_row.rank;
		  return next r;
end loop;


ELSIF kpi_name in ('thp_hsdpa','thp_hsupa') THEN

r.new_node_kpi := -2;

	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,(%2$s)::real/48 as cell_kpi,sum((%2$s)::real/48) over (partition by c.%1$s) as node_kpi,count(m.cellid) over (partition by c.%1$s) as samples
from umts_kpi.main_kpis_daily m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by %2$s',netype,kpi_name,ne,data)

loop
	
		  if (mean = -1) then
		    mean := cur_row.node_kpi;
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi := cur_row.cell_kpi;
		  r.node_kpi := COALESCE(cur_row.node_kpi / NULLIF(cur_row.samples, 0::real), 0::real);
		  r.rank := cur_row.rank;
		  mean := mean - COALESCE(r.cell_kpi,0);

		  r.new_node_kpi :=  COALESCE(mean / NULLIF((cur_row.samples - r.rank), 0::real), 0::real);
		  
		  return next r;
		  end loop;
	        mean := -1;	  


ELSIF kpi_name in ('rtwp') THEN

r.new_node_kpi := -2;

	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s as cell_kpi,SUM(power(10, (%2$s) / 10)) over (partition by c.%1$s) as node_kpi,count(m.cellid) over (partition by c.%1$s) as samples
from umts_kpi.main_kpis_daily m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by %2$s',netype,kpi_name,ne,data)

loop
		
		  if (mean = -1) then
		    mean := cur_row.node_kpi;
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := 'rtwp';
		  r.cell_kpi := cur_row.cell_kpi;
		  r.node_kpi := 10*log(abs(COALESCE(cur_row.node_kpi / NULLIF(cur_row.samples, 0::real), 1::real)))::real;
			r.rank := cur_row.rank;
		  mean := mean - COALESCE(power(10, cur_row.cell_kpi / 10),0);

		  r.new_node_kpi :=  10*log(abs(COALESCE(mean / NULLIF((cur_row.samples - r.rank), 0::real), 1::real)));
  
		  return next r;
		  end loop;


elsif kpi_name in ('qda_cs','qda_ps','qdr_ps','qdr_cs','qda_ps_f2h') THEN

	 r.new_node_kpi := 2;
for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_bad_attempts desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s_good_attempts as cell_kpi_num,(%2$s_good_attempts + %2$s_bad_attempts) as cell_kpi_den,%2$s_bad_attempts as cell_fails,
sum(%2$s_good_attempts) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_good_attempts + %2$s_bad_attempts) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_bad_attempts) over (partition by c.%1$s))::real as node_fails
from umts_kpi.nqi_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by %2$s_bad_attempts desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi + COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

elsif kpi_name in ('throughput') THEN

	 r.new_node_kpi := 2;
for cur_row in execute format('select row_number() over(partition by c.%1$s order by user_bad_throughput desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,user_good_throughput as cell_kpi_num,(user_good_throughput + user_bad_throughput) as cell_kpi_den,user_bad_throughput as cell_fails,
sum(user_good_throughput) over (partition by c.%1$s) as node_kpi_num,sum(user_good_throughput + user_bad_throughput) over (partition by c.%1$s) as node_kpi_den,
(sum(user_bad_throughput) over (partition by c.%1$s))::real as node_fails
from umts_kpi.nqi_daily m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by user_bad_throughput desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi + COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('nqi_retention_ps','nqi_retention_cs') THEN
sql := format('select substring(''%s'' from 5 for 12)',kpi_name);
execute sql INTO kpi_aux;

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,DATE,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.nqi_daily m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and date= ''%4$s''
order by %2$s_num desc',netype,kpi_aux,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.date;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi::double precision - COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;
		  
  end if;  
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION umts_kpi.worst_cells_main_kpis_rank_daily(text, text, date, text)
  OWNER TO postgres;

  --------------------------------------------------------------------------------------
-- Function: umts_kpi.worst_cells_main_kpis_rank_hourly(text, text, timestamp without time zone, text)

-- DROP FUNCTION umts_kpi.worst_cells_main_kpis_rank_hourly(text, text, timestamp without time zone, text);

CREATE OR REPLACE FUNCTION umts_kpi.worst_cells_main_kpis_rank_hourly(
    netype text,
    kpi_name text,
    data timestamp without time zone,
    ne text)
  RETURNS SETOF worst_cells_node_hourly AS
$BODY$
declare
  cur_row record;
  r worst_cells_node_hourly;
    mean real := -1;

  
begin 

if kpi_name in ('acc_rrc','acc_ps_rab','acc_cs_rab','acc_hs','acc_hs_f2h','soft_hand_succ_rate','cs_hho_intra_freq_succ','ps_hho_intra_freq_succ','hho_inter_freq_succ','iratho_cs_succ','iratho_ps_succ') THEN

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_den-%2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,datetime,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_den-%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_den) over (partition by c.%1$s) - sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.main_kpis m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime= ''%4$s''
order by %2$s_den-%2$s_num desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.datetime;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi + COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('drop_cs','drop_ps','retention_cs','retention_ps') THEN

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,datetime,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.main_kpis m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime= ''%4$s''
order by %2$s_num desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.datetime;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi::double precision - COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('availability') THEN		  

	r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by unavailtime desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,datetime,gp,sum(gp) over (partition by c.%1$s) as node_gp,unavailtime,sum(unavailtime) over (partition by c.%1$s) as node_unavailtime
from umts_kpi.main_kpis m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime= ''%4$s''
order by unavailtime desc',netype,kpi_name,ne,data)
loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := (1 - COALESCE(cur_row.node_unavailtime / NULLIF((cur_row.node_gp * 60), 0),0));
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		   r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.datetime;
		  r.kpi := 'availability';
		  r.cell_kpi := (1 - COALESCE(cur_row.unavailtime / NULLIF((cur_row.gp * 60), 0),0));
		  r.cell_fails := cur_row.unavailtime;
		  r.impact := COALESCE(r.cell_fails / NULLIF (cur_row.node_unavailtime, 0), 0);
		  r.node_kpi := (1 - COALESCE(cur_row.node_unavailtime / NULLIF((cur_row.node_gp * 60), 0),0));
		  r.new_node_kpi := r.new_node_kpi + COALESCE(r.cell_fails / NULLIF((cur_row.node_gp * 60), 0),0);
		   r.rank := cur_row.rank;
		  return next r;
end loop;


ELSIF kpi_name in ('thp_hsdpa','thp_hsupa') THEN

r.new_node_kpi := -2;

	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,datetime,(%2$s)::real/48 as cell_kpi,sum((%2$s)::real/48) over (partition by c.%1$s) as node_kpi,count(m.cellid) over (partition by c.%1$s) as samples
from umts_kpi.main_kpis m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime= ''%4$s''
order by %2$s',netype,kpi_name,ne,data)

loop
	
		  if (mean = -1) then
		    mean := cur_row.node_kpi;
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.datetime;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi := cur_row.cell_kpi;
		  r.node_kpi := COALESCE(cur_row.node_kpi / NULLIF(cur_row.samples, 0::real), 0::real);
		  r.rank := cur_row.rank;
		  mean := mean - COALESCE(r.cell_kpi,0);

		  r.new_node_kpi :=  COALESCE(mean / NULLIF((cur_row.samples - r.rank), 0::real), 0::real);
		  
		  return next r;
		  end loop;
	        mean := -1;	  


ELSIF kpi_name in ('rtwp') THEN

r.new_node_kpi := -2;

	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,datetime,%2$s as cell_kpi,SUM(power(10, (%2$s) / 10)) over (partition by c.%1$s) as node_kpi,count(m.cellid) over (partition by c.%1$s) as samples
from umts_kpi.main_kpis m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and datetime= ''%4$s''
order by %2$s',netype,kpi_name,ne,data)

loop
		
		  if (mean = -1) then
		    mean := cur_row.node_kpi;
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.datetime;
		  r.kpi := 'rtwp';
		  r.cell_kpi := cur_row.cell_kpi;
		  r.node_kpi := 10*log(abs(COALESCE(cur_row.node_kpi / NULLIF(cur_row.samples, 0::real), 1::real)))::real;
			r.rank := cur_row.rank;
		  mean := mean - COALESCE(power(10, cur_row.cell_kpi / 10),0);

		  r.new_node_kpi :=  10*log(abs(COALESCE(mean / NULLIF((cur_row.samples - r.rank), 0::real), 1::real)));
  
		  return next r;
		  end loop;
		  
  end if;  
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION umts_kpi.worst_cells_main_kpis_rank_hourly(text, text, timestamp without time zone, text)
  OWNER TO postgres;

  --------------------------------------------------------------------------------------

-- Function: umts_kpi.worst_cells_main_kpis_rank_weekly(text, text, text, text)

-- DROP FUNCTION umts_kpi.worst_cells_main_kpis_rank_weekly(text, text, text, text);

CREATE OR REPLACE FUNCTION umts_kpi.worst_cells_main_kpis_rank_weekly(
    netype text,
    kpi_name text,
    data text,
    ne text)
  RETURNS SETOF worst_cells_node_weekly AS
$BODY$
declare
  cur_row record;
  r worst_cells_node_weekly;
    mean real := -1;
sql TEXT:= '';
kpi_aux text;
  
begin 

if kpi_name in ('acc_rrc','acc_ps_rab','acc_cs_rab','acc_hs','acc_hs_f2h','soft_hand_succ_rate','cs_hho_intra_freq_succ','ps_hho_intra_freq_succ','hho_inter_freq_succ','iratho_cs_succ','iratho_ps_succ') THEN

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_den-%2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_den-%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_den) over (partition by c.%1$s) - sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.vw_main_kpis_weekly m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by %2$s_den-%2$s_num desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi + COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('drop_cs','drop_ps','retention_cs','retention_ps') THEN

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.vw_main_kpis_weekly m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by %2$s_num desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi::double precision - COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('availability','nqi_availability') THEN		  

		  if (kpi_name = 'availability') then
		    kpi_aux := 'vw_main_kpis_weekly';
		  ELSIF (kpi_name = 'nqi_availability') then
			kpi_aux := 'vw_nqi_weekly';
		  end if;

	r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by unavailtime desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,gp,sum(gp) over (partition by c.%1$s) as node_gp,unavailtime,sum(unavailtime) over (partition by c.%1$s) as node_unavailtime
from umts_kpi.%2$s m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by unavailtime desc',netype,kpi_aux,ne,data)
loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := (1 - COALESCE(cur_row.node_unavailtime / NULLIF((cur_row.node_gp * 60), 0),0));
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		   r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := 'availability';
		  r.cell_kpi := (1 - COALESCE(cur_row.unavailtime / NULLIF((cur_row.gp * 60), 0),0));
		  r.cell_fails := cur_row.unavailtime;
		  r.impact := COALESCE(r.cell_fails / NULLIF (cur_row.node_unavailtime, 0), 0);
		  r.node_kpi := (1 - COALESCE(cur_row.node_unavailtime / NULLIF((cur_row.node_gp * 60), 0),0));
		  r.new_node_kpi := r.new_node_kpi + COALESCE(r.cell_fails / NULLIF((cur_row.node_gp * 60), 0),0);
		   r.rank := cur_row.rank;
		  return next r;
end loop;


ELSIF kpi_name in ('thp_hsdpa','thp_hsupa') THEN

r.new_node_kpi := -2;

	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,(%2$s)::real/48 as cell_kpi,sum((%2$s)::real/48) over (partition by c.%1$s) as node_kpi,count(m.cellid) over (partition by c.%1$s) as samples
from umts_kpi.vw_main_kpis_weekly m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by %2$s',netype,kpi_name,ne,data)

loop
	
		  if (mean = -1) then
		    mean := cur_row.node_kpi;
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi := cur_row.cell_kpi;
		  r.node_kpi := COALESCE(cur_row.node_kpi / NULLIF(cur_row.samples, 0::real), 0::real);
		  r.rank := cur_row.rank;
		  mean := mean - COALESCE(r.cell_kpi,0);

		  r.new_node_kpi :=  COALESCE(mean / NULLIF((cur_row.samples - r.rank), 0::real), 0::real);
		  
		  return next r;
		  end loop;
	        mean := -1;	  


ELSIF kpi_name in ('rtwp') THEN

r.new_node_kpi := -2;

	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,%2$s as cell_kpi,SUM(power(10, (%2$s) / 10)) over (partition by c.%1$s) as node_kpi,count(m.cellid) over (partition by c.%1$s) as samples
from umts_kpi.vw_main_kpis_weekly m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by %2$s',netype,kpi_name,ne,data)

loop
		
		  if (mean = -1) then
		    mean := cur_row.node_kpi;
		  end if;
		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := 'rtwp';
		  r.cell_kpi := cur_row.cell_kpi;
		  r.node_kpi := 10*log(abs(COALESCE(cur_row.node_kpi / NULLIF(cur_row.samples, 0::real), 1::real)))::real;
			r.rank := cur_row.rank;
		  mean := mean - COALESCE(power(10, cur_row.cell_kpi / 10),0);

		  r.new_node_kpi :=  10*log(abs(COALESCE(mean / NULLIF((cur_row.samples - r.rank), 0::real), 1::real)));
  
		  return next r;
		  end loop;
elsif kpi_name in ('qda_cs','qda_ps','qdr_ps','qdr_cs','qda_ps_f2h') THEN

	 r.new_node_kpi := 2;
for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_bad_attempts desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,%2$s_good_attempts as cell_kpi_num,(%2$s_good_attempts + %2$s_bad_attempts) as cell_kpi_den,%2$s_bad_attempts as cell_fails,
sum(%2$s_good_attempts) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_good_attempts + %2$s_bad_attempts) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_bad_attempts) over (partition by c.%1$s))::real as node_fails
from umts_kpi.vw_nqi_weekly m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by %2$s_bad_attempts desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi + COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

elsif kpi_name in ('throughput') THEN

	 r.new_node_kpi := 2;
for cur_row in execute format('select row_number() over(partition by c.%1$s order by user_bad_throughput desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,user_good_throughput as cell_kpi_num,(user_good_throughput + user_bad_throughput) as cell_kpi_den,user_bad_throughput as cell_fails,
sum(user_good_throughput) over (partition by c.%1$s) as node_kpi_num,sum(user_good_throughput + user_bad_throughput) over (partition by c.%1$s) as node_kpi_den,
(sum(user_bad_throughput) over (partition by c.%1$s))::real as node_fails
from umts_kpi.vw_nqi_weekly m JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by user_bad_throughput desc',netype,kpi_name,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi + COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;

ELSIF kpi_name in ('nqi_retention_ps','nqi_retention_cs') THEN
sql := format('select substring(''%s'' from 5 for 12)',kpi_name);
execute sql INTO kpi_aux;

	 r.new_node_kpi := 2;
	for cur_row in execute format('select row_number() over(partition by c.%1$s order by %2$s_num desc) as rank,c.%1$s as node,c.rnc as rncname,c.cell,m.cellid,week,%2$s_num as cell_kpi_num,%2$s_den as cell_kpi_den,%2$s_num as cell_fails,
sum(%2$s_num) over (partition by c.%1$s) as node_kpi_num,sum(%2$s_den) over (partition by c.%1$s) as node_kpi_den,
(sum(%2$s_num) over (partition by c.%1$s))::real as node_fails
from umts_kpi.vw_nqi_weekly m left JOIN umts_control.cells_database c on m.rnc = c.rnc and m.cellid = c.cellid
where c.%1$s = ''%3$s''
and week= ''%4$s''
order by %2$s_num desc',netype,kpi_aux,ne,data)


		loop
		
		  if (r.new_node_kpi = 2) then
		    r.new_node_kpi := COALESCE(cur_row.node_kpi_num::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 1);
		  end if;

		  
		  r.node := cur_row.node;
		  r.rncname := cur_row.rncname;		  
		  r.cellname := cur_row.cell;		  
		  r.cellid := cur_row.cellid;
		  r.date := cur_row.week;
		  r.kpi := format('%s',kpi_name);
		  r.cell_kpi_num := cur_row.cell_kpi_num;
		  r.cell_kpi_den := cur_row.cell_kpi_den;
		  r.cell_kpi := COALESCE(cur_row.cell_kpi_num / NULLIF (cur_row.cell_kpi_den, 0), 1);
		  r.cell_fails := cur_row.cell_fails;
		  r.node_kpi_num := cur_row.node_kpi_num;
		  r.node_kpi_den := cur_row.node_kpi_den;
		  r.impact := COALESCE(cur_row.cell_fails / NULLIF (cur_row.node_fails, 0), 0);
		  r.node_kpi := COALESCE(cur_row.node_kpi_num / NULLIF (cur_row.node_kpi_den, 0), 1);
		  r.new_node_kpi := r.new_node_kpi::double precision - COALESCE(cur_row.cell_fails::double precision / NULLIF (cur_row.node_kpi_den::double precision, 0), 0);
		  r.rank := cur_row.rank;

		  return next r;
		  end loop;		  
  end if;  
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION umts_kpi.worst_cells_main_kpis_rank_weekly(text, text, text, text)
  OWNER TO postgres;

  --------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------
  