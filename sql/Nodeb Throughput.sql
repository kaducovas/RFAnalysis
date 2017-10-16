Nodeb Throughput

--1-- Create table with the specified period
    
	CREATE TABLE thp_W42 as 
	SELECT 
		nodeb, locell, datetime, vs_hsdpa_all_schedulednum, vs_hsdpa_dataoutput_traffic, 
		vs_hsupa_traffic_trb, vs_hsupa_2mstti_traffic, vs_hsupa_10mstti_traffic, 
		vs_hsupa_2mspdu_tti_num, vs_hsupa_10mspdu_tti_num, vs_hsdpa_datattinum_user
	FROM 
		npm_reports.vw_thp_tti2ms_locell
    WHERE 
		datetime between '2016-10-16' and '2016-10-22'
		AND datetime::time between '07:00:00' and '22:30:00';

--2-- Exportando o número de HSUsers por locell para .csv

    COPY(
		SELECT
			nodebname as nodeb, locell,m.datetime, 
			null,null,null, null,null, null, null, null,hsdpa_users
		FROM
			umts_kpi.main_kpis m inner join umts_configuration.ucellsetup u on m.rnc = u.rncname and m.cellid = u.cellid
		WHERE
			m.datetime between '2016-10-16' and '2016-10-22'
			and m.datetime::time between '07:00:00' and '22:30:00'
		) 
		TO '/home/postgres/dump/thp_W42_hsusers.csv';

--3-- Adicionando a coluna HUsers na tabela na tabela Throughput da semana

    ALTER TABLE thp_W42 add column hsdpa_users real;

--4-- Importando o número de HSUsers para a tabela Throughput

    COPY thp_W42 FROM '/home/postgres/dump/thp_W42_hsusers.csv';

--5-- Criando uma nova tabela para agregar e eliminar valores Null

    CREATE TABLE thp_W42_users as 
    SELECT 
		nodeb, locell, datetime, 
		SUM(vs_hsdpa_all_schedulednum) AS vs_hsdpa_all_schedulednum, 
		SUM(vs_hsdpa_dataoutput_traffic) AS vs_hsdpa_dataoutput_traffic, 
		SUM(vs_hsupa_traffic_trb) AS vs_hsupa_traffic_trb, 
		SUM(vs_hsupa_2mstti_traffic) AS vs_hsupa_2mstti_traffic, 
		SUM(vs_hsupa_10mstti_traffic) AS vs_hsupa_10mstti_traffic, 
		SUM(vs_hsupa_2mspdu_tti_num) AS vs_hsupa_2mspdu_tti_num, 
		SUM(vs_hsupa_10mspdu_tti_num) AS vs_hsupa_10mspdu_tti_num, 
		SUM(vs_hsdpa_datattinum_user) AS vs_hsdpa_datattinum_user,
		SUM(hsdpa_users) AS hsdpa_users
    FROM 
		thp_W42
    GROUP BY nodeb,locell,datetime;

--6-- Regional Weekly
	
    COPY(
		SELECT 
			regional,
			date_part('week'::text, datetime::date + '1 day'::interval) AS week,
			SUM(user_good_throughput) + sum(user_bad_throughput) AS Count_ROP_Throughput,
			ROUND(AVG(hsdpa_users)::numeric,2) AS Hsdpa_Users,
			ROUND(AVG(thp_machs),2) AS Average_Throughput,
			ROUND(MIN(thp_machs),2) AS Min_Throughput,
			ROUND(MAX(thp_machs),2) AS Max_Throughput,
			
			SUM(user_good_throughput) AS user_good_throughput,
			SUM(user_bad_throughput) AS user_bad_throughput,
			ROUND((100::real * COALESCE(sum(user_good_throughput) / NULLIF(sum(user_good_throughput) + sum(user_bad_throughput), 0::real), 1::real))::numeric, 2) AS throughput
		FROM
			(SELECT 
				"REGIONAL" as regional,"RNC" AS rnc, nodeb,"CELL", locell,
				datetime,
				vs_hsdpa_dataoutput_traffic,
				vs_hsdpa_datattinum_user,
				ROUND((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) as thp_machs,
				hsdpa_users,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) < 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_good_throughput,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) > 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_bad_throughput
			FROM 
				public.thp_W42_users inner join (select distinct "NODEB","REGIONAL","RNC","LOCELL","CELL" from common_gis.cell_database) t on right(nodeb,7) = "NODEB" and locell = "LOCELL" 
			WHERE
				(vs_hsdpa_dataoutput_traffic is not null and vs_hsdpa_datattinum_user is not null)
			) t
		GROUP BY 
			regional,
			date_part('week'::text, datetime::date + '1 day'::interval)
		ORDER BY 
			regional
		) to '/home/postgres/dump/thp_W42_hsusers_region_weekly.csv' delimiter ',' CSV HEADER;
	  
--8- RNC Weekly
	
	COPY(
		SELECT
			regional,rnc, 
			date_part('week'::text, datetime::date + '1 day'::interval) AS week,
			SUM(user_good_throughput) + sum(user_bad_throughput) AS Count_ROP_Throughput,
			ROUND(AVG(hsdpa_users)::numeric,2) AS Hsdpa_Users,
			ROUND(AVG(thp_machs),2) AS Average_Throughput,
			ROUND(MIN(thp_machs),2) AS Min_Throughput,
			ROUND(MAX(thp_machs),2) AS Max_Throughput,
			
			sum(user_good_throughput) AS user_good_throughput,
			sum(user_bad_throughput) AS user_bad_throughput,
			round((100::real * COALESCE(sum(user_good_throughput) / NULLIF(sum(user_good_throughput) + sum(user_bad_throughput), 0::real), 1::real))::numeric, 2) AS throughput
		FROM
			(SELECT 
				"REGIONAL" as regional,"RNC" AS rnc, nodeb,"CELL" as cell,locell,
				datetime,
				vs_hsdpa_dataoutput_traffic,
				vs_hsdpa_datattinum_user,
				ROUND((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) as thp_machs,hsdpa_users,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) < 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_good_throughput,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) > 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_bad_throughput
			FROM 
				public.thp_W42_users inner join (select distinct "NODEB","REGIONAL","RNC","LOCELL","CELL" from common_gis.cell_database) t on right(nodeb,7) = "NODEB" and thp_W42_users.locell = "LOCELL" 
			WHERE 
				(vs_hsdpa_dataoutput_traffic is not null and vs_hsdpa_datattinum_user is not null)
			) t
		GROUP BY 
			regional, 
			rnc, 
			date_part('week'::text, datetime::date + '1 day'::interval)
		ORDER BY 
			rnc
		) to '/home/postgres/dump/thp_W42_hsusers_RNC_weekly.csv' delimiter ',' CSV HEADER;
	  
--9-- Cluster Weekly	  
	  
	COPY(
		SELECT 
			regional,
			cluster,
			date_part('week'::text, datetime::date + '1 day'::interval) AS week,
			SUM(user_good_throughput) + sum(user_bad_throughput) AS Count_ROP_Throughput,
			ROUND(AVG(hsdpa_users)::numeric,2) AS Hsdpa_Users,
			ROUND(AVG(thp_machs),2) AS Average_Throughput,
			ROUND(MIN(thp_machs),2) AS Min_Throughput,
			ROUND(MAX(thp_machs),2) AS Max_Throughput,

			sum(user_good_throughput) AS user_good_throughput,
			sum(user_bad_throughput) AS user_bad_throughput,
			round((100::real * COALESCE(sum(user_good_throughput) / NULLIF(sum(user_good_throughput) + sum(user_bad_throughput), 0::real), 1::real))::numeric, 2) AS throughput
		FROM
			(SELECT 
				"REGIONAL" as regional,"RNC" AS rnc, "CLUSTER" AS cluster, nodeb,"CELL" as cell,locell,
				datetime,
				vs_hsdpa_dataoutput_traffic,
				vs_hsdpa_datattinum_user,
				round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) as thp_machs,hsdpa_users,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) < 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_good_throughput,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) > 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_bad_throughput
			FROM 
				public.thp_W42_users inner join (select distinct "NODEB","REGIONAL","RNC","CLUSTER","LOCELL","CELL" from common_gis.cell_database) t on right(nodeb,7) = "NODEB" and thp_W42_users.locell = "LOCELL" 
			WHERE 
				(vs_hsdpa_dataoutput_traffic is not null and vs_hsdpa_datattinum_user is not null)
			) t
		GROUP BY
			regional,
			cluster, 
			date_part('week'::text, datetime::date + '1 day'::interval)
      
		ORDER BY
			cluster
		) to '/home/postgres/dump/thp_W42_hsusers_Cluster_weekly.csv' delimiter ',' CSV HEADER;
	  
--10-- NodeB Weekly

	COPY(
		select 
			regional,rnc, nodeb,
			date_part('week'::text, datetime::date + '1 day'::interval) AS week,
			SUM(user_good_throughput) + sum(user_bad_throughput) AS Count_ROP_Throughput,
			ROUND(AVG(hsdpa_users)::numeric,2) AS Hsdpa_Users,
			ROUND(AVG(thp_machs),2) AS Average_Throughput,
			ROUND(MIN(thp_machs),2) AS Min_Throughput,
			ROUND(MAX(thp_machs),2) AS Max_Throughput,

			sum(user_good_throughput) AS user_good_throughput,
			sum(user_bad_throughput) AS user_bad_throughput,
			round((100::real * COALESCE(sum(user_good_throughput) / NULLIF(sum(user_good_throughput) + sum(user_bad_throughput), 0::real), 1::real))::numeric, 2) AS throughput
		from
			(SELECT 
				"REGIONAL" as regional,"RNC" AS rnc, nodeb,"CELL" as cell,locell,
				datetime,
				vs_hsdpa_dataoutput_traffic,
				vs_hsdpa_datattinum_user,
				round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) as thp_machs,hsdpa_users,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) < 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_good_throughput,
				CASE
					WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) > 400::real OR hsdpa_users < 1::real THEN 0
					ELSE 1
				END AS user_bad_throughput
			FROM 
				public.thp_W42_users inner join (select distinct "NODEB","REGIONAL","RNC","LOCELL","CELL" from common_gis.cell_database) t on right(nodeb,7) = "NODEB" and thp_W42_users.locell = "LOCELL" 
			where 
				(vs_hsdpa_dataoutput_traffic is not null and vs_hsdpa_datattinum_user is not null)
			) t
		group by 
			regional,
			rnc, 
			nodeb,
			date_part('week'::text, datetime::date + '1 day'::interval)
       	order by 
			rnc
		) to '/home/postgres/dump/thp_W42_hsusers_NodeB_weekly.csv' delimiter ',' CSV HEADER;
	  
--11-- Cell Weekly
	
    COPY(select regional,rnc, nodeb,cell,
    date_part('week'::text, datetime::date + '1 day'::interval) AS week,
		SUM(user_good_throughput) + sum(user_bad_throughput) AS Count_ROP_Throughput,
		ROUND(AVG(hsdpa_users)::numeric,2) AS Hsdpa_Users,
			ROUND(AVG(thp_machs),2) AS Average_Throughput,
			ROUND(MIN(thp_machs),2) AS Min_Throughput,
			ROUND(MAX(thp_machs),2) AS Max_Throughput,

    sum(user_good_throughput) AS user_good_throughput,
    sum(user_bad_throughput) AS user_bad_throughput,
      round((100::real * COALESCE(sum(user_good_throughput) / NULLIF(sum(user_good_throughput) + sum(user_bad_throughput), 0::real), 1::real))::numeric, 2) AS throughput
    from
    (SELECT "REGIONAL" as regional,"RNC" AS rnc, nodeb,"CELL" as cell,locell,datetime,vs_hsdpa_dataoutput_traffic,vs_hsdpa_datattinum_user,
    round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) as thp_machs,hsdpa_users,
        CASE
                WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) < 400::real OR hsdpa_users < 1::real THEN 0
                ELSE 1
            END AS user_good_throughput,
            CASE
                WHEN round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) IS NULL OR round((COALESCE(vs_hsdpa_dataoutput_traffic/ NULLIF(2*vs_hsdpa_datattinum_user, 0::real), 0::real))::numeric, 2) > 400::real OR hsdpa_users < 1::real THEN 0
                ELSE 1
            END AS user_bad_throughput
      FROM public.thp_W42_users inner join (select distinct "NODEB","REGIONAL","RNC","LOCELL","CELL" from common_gis.cell_database) t on right(nodeb,7) = "NODEB" and thp_W42_users.locell = "LOCELL" 
      where (vs_hsdpa_dataoutput_traffic is not null and vs_hsdpa_datattinum_user is not null)
      ) t
      group by regional,rnc, nodeb,cell,date_part('week'::text, datetime::date + '1 day'::interval)
      --datetime  
      order by rnc) to '/home/postgres/dump/thp_W42_hsusers_cell_weekly.csv' delimiter ',' CSV HEADER;
	  
----- NodeB Counter Enable Check

copy (SELECT regional, nodeb,date_part('week'::text, datetime::date + '1 day'::interval) AS week,    
      case when SUM(vs_hsdpa_datattinum_user) IS NULL then 0 else 1 end as vs_hsdpa_datattinum_user, 
      case WHEN SUM(vs_hsdpa_dataoutput_traffic) IS NULL then 0 else 1 end as vs_hsdpa_dataoutput_traffic
  FROM public.thp_W42_users inner join (select distinct "NODEB","REGIONAL" AS REGIONAL,"RNC","LOCELL" from common_gis.cell_database) t on right(nodeb,7) = "NODEB" and locell = "LOCELL" 
  --where DATETIME = '2016/10/07 18:00:00'
  group by regional,nodeb,date_part('week'::text, datetime::date + '1 day'::interval)
  order by regional,nodeb) to '/home/postgres/dump/W42thp_nodeb_counter_enable.csv' delimiter ',' csv header