copy(
SELECT date_part('year'::text, main_kpis_daily.date) AS year,
date_part('week'::text, main_kpis_daily.date + '1 day'::interval) AS week,
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text,'TO']) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END AS region,
rnc,nodebname,     
    round((100::double precision * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) AS availability,
    sum(main_kpis_daily.unavailtime) AS unavailtime,
CASE
	WHEN round((100::double precision * (1::double precision - (sum(main_kpis_daily.unavailtime) / (sum(main_kpis_daily.gp) * 60)::double precision)::real))::numeric, 2) >= 99.5 THEN 'OK'
	ELSE 'NOK'
	END AS status
	   FROM umts_kpi.main_kpis_daily
	inner join umts_configuration.ucellsetup u on umts_kpi.main_kpis_daily.cellid = u.cellid and umts_kpi.main_kpis_daily.rnc =u.rncname

	where date between '2017-05-14' and '2017-05-20'
	and "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'
  GROUP BY date_part('week'::text, main_kpis_daily.date + '1 day'::interval),date_part('year'::text, main_kpis_daily.date),
        CASE
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text,'TO'::text]) THEN 'CO'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN "substring"(main_kpis_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
            ELSE 'UNKNOWN'::text
        END,rnc,nodebname) to '/home/postgres/dump/W20_mg_unavailability.csv' delimiter ',' csv header

