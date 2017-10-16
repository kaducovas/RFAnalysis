SELECT date_part('year'::text, main_kpis_daily.date + '1 day'::interval) AS year,
SELECT date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week,
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text,'TO']) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
        "CIDADE",
        "RNC",
        "NODEB",               
    round((100::double precision * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    sum(main_kpis_daily.unavailtime) AS unavailtime,
CASE
	WHEN round((100::double precision * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) >= 99.5 THEN 'OK'
	ELSE 'NOK'
	END AS status
	   FROM umts_kpi.main_kpis_daily
	inner join common_gis.cell_database on umts_kpi.main_kpis_daily.cellid = common_gis.cell_database."CELLID" and umts_kpi.main_kpis_daily.rnc = common_gis.cell_database."RNC"

	where
	
	date_part('year'::text, main_kpis_daily.date - '2 days'::interval) = 2017 AND
        date_part('week'::text, main_kpis_daily.date + '1 day'::interval) = 20
and "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text,'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END,"CIDADE",
        "RNC",
        "NODEB"

