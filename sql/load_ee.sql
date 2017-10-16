
	
create table w32_load_ee as	
select year,week,regional as region,c.rnc,c.nodebname as nodeb,c.cellid,c.cellname as node,carrier as carrier, azimuth as azimuth, ee,load,
avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth) as avg_ee,
case 
when (ee < 0.7*avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth) or 
ee > 1.3*avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth)) then 'NOK'::text
else 'OK' end as Balanced,
CASE
            WHEN load > 80::numeric AND ee > 15::numeric THEN 1
            WHEN ee > 40::numeric THEN 1
            ELSE 0
        END AS highly_loaded_cell	
	
   FROM ( SELECT weekly.year,
            weekly.week,
            weekly.region,
            weekly.rnc,
            weekly.cellid,
            weekly.cellname,
            round(avg(weekly.ee)::numeric, 3) AS ee,
            round(avg(weekly.load)::numeric, 3) AS load
           FROM 
		   
		   ( SELECT year,
                    week,
                    date,
                    region,
                    rnc,
                    cellid,
                    cellname,
                    ee,
                    load,
										
                    row_number() OVER (PARTITION BY year, week, region,rnc, cellid, cellname ORDER BY load DESC) AS rn
		   from
		   ( SELECT foo.year,
                    foo.week,
                    foo.date,
                    foo.region,
                    foo.rnc,
                    foo.cellid,
                    foo.cellname,
                    foo.ee,
                    foo.load,
										
                    row_number() OVER (PARTITION BY foo.year, foo.week, foo.date, foo.region, foo.rnc, foo.cellid, foo.cellname ORDER BY foo.load DESC) AS rn
                   FROM ( SELECT date_part('year'::text, u.datetime::date) AS year,
                            date_part('week'::text, u.datetime::date + '1 day'::interval) AS week,
                            u.datetime::date AS date,
							 CASE
                            WHEN "substring"(u.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
                            WHEN "substring"(u.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
                            WHEN "substring"(u.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
                            WHEN "substring"(u.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
                            WHEN "substring"(u.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
                            WHEN "substring"(u.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
                            ELSE 'UNKNOWN'::text
                        END AS region,
                            u.rnc,
                            u.cellname,
                            u.cellid,
                            u.ee,
                            u.ee / 55::double precision + ((c.thp_hsdpa_nodeb_num / (1000 * 1000)::double precision + u.cell_dl_data_volume_mb)::real/3600) / 5::double precision AS load
                           FROM umts_kpi.amx_load u
                             JOIN umts_kpi.thp_tti2ms c ON c.rnc = u.rnc and c.cellid = u.cellid AND u.datetime = c.datetime
							where u.datetime BETWEEN '2017-08-06' and '2017-08-13'
							and u.datetime::time between '06:00:00' and '23:30:00'							 
							 ) foo) daily 
							WHERE daily.rn < 2
			) weekly
			WHERE weekly.rn < 4
			group by year, week,region,rnc,cellid,cellname
) load inner join (select distinct regional,rnc,cellid,cellname,nodebname,carrier,azimuth from umts_control.cells_db) c
on load.rnc = c.rnc and load.cellid = c.cellid
ORDER BY regional,rnc,nodeb,azimuth,carrier			


