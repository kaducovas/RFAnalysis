create table w32_load_ee_v4 as	
select year,week,region,rnc,nodeb,cellid,node,carrier,azimuth, ee,load,avg_ee,
case 
when count(*) FILTER (where balanced = 'NOK') OVER (PARTITION BY year,week,region,rnc,nodeb,azimuth) >=1 then 'NOK'
else 'OK'
end as balanced,
highly_loaded_cell
FROM (
select year,week,regional as region,c.rnc,c.nodebname as nodeb,c.cellid,c.cellname as node,carrier as carrier, azimuth as azimuth, ee,

case when load > 100 then 100 else load end as load,
avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth) as avg_ee,
case 
when (ee < 0.7*avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth) or 
ee > 1.3*avg(ee) over (partition by year,week,regional,c.rnc,nodebname,azimuth)) AND avg(ee) >= 15 then 'NOK'::text
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
            round(avg(weekly.ee)::numeric, 3) AS ee,
            100*round(avg(weekly.load)::numeric, 3) AS load
           FROM 
		   (select *,row_number() OVER (PARTITION BY year, week, region,rnc, cellid ORDER BY load DESC) AS rn
		   from
		   ( SELECT year,
                    week,
                    date,
                    region,
                    rnc,
                    cellid,
            round(avg(ee)::numeric, 3) AS ee,
            round(avg(load)::numeric, 3) AS load
										
                   -- row_number() OVER (PARTITION BY year, week, region,rnc, cellid ORDER BY load DESC) AS rn
		   from
		   ( SELECT foo.year,
                    foo.week,
                    foo.date,
                    foo.region,
                    foo.rnc,
                    foo.cellid,
                    foo.ee,
                    foo.load,
										
                    row_number() OVER (PARTITION BY foo.year, foo.week, foo.date, foo.region, foo.rnc, foo.cellid ORDER BY foo.load DESC) AS rn
                   FROM ( SELECT date_part('year'::text, datetime::date) AS year,
                            date_part('week'::text, datetime::date + '1 day'::interval) AS week,
                            datetime::date AS date,
							 CASE
                            WHEN "substring"(rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
                            WHEN "substring"(rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
                            WHEN "substring"(rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
                            WHEN "substring"(rnc, 4, 2) = 'MG'::text THEN 'MG'::text
                            WHEN "substring"(rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
                            WHEN "substring"(rnc, 4, 2) = 'ES'::text THEN 'ES'::text
                            ELSE 'UNKNOWN'::text
                        END AS region,
                            rnc,
                            cellid,
                            ee,
                            ee / 55::double precision + ((data_output_traffic / (1000 * 1000)::double precision + cell_dl_data_volume_mb)::real/3600) / 5::double precision AS load
                           FROM load_hourly
							where datetime BETWEEN '2017-09-03' and '2017-09-10'
							and datetime::time between '06:00:00' and '23:30:00'							 
							 ) foo) daily 
							WHERE daily.rn < 4
			group by year,
                    week,
                    date,
                    region,
                    rnc,
                    cellid
			) weekly_byday 
				
			) weekly
			WHERE weekly.rn < 6 
			group by year, week,region,rnc,cellid
) load inner join (select distinct regional,rnc,cellid,cellname,nodebname,carrier,azimuth from umts_control.cells_db) c
on load.rnc = c.rnc and load.cellid = c.cellid group by year,week,regional,c.rnc,c.nodebname,c.cellid,c.cellname,carrier, azimuth, ee,load) UNBALANCE
ORDER BY region,rnc,nodeb,azimuth,carrier

