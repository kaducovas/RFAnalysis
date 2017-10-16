SELECT
	date_part('week'::text, datetime::date + '1 day'::interval) AS week,
	CASE
		WHEN "substring"(rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
		WHEN "substring"(rnc, 4, 2) = ANY (ARRAY['BA'::text, 'SE'::text]) THEN 'BASE'::text
		WHEN "substring"(rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'GO'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'TO'::text]) THEN 'CO'::text
		WHEN "substring"(rnc, 4, 2) = 'ES'::text THEN 'ES'::text
		WHEN "substring"(rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
		WHEN "substring"(rnc, 4, 2) = 'MG'::text THEN 'MG'::text
		ELSE 'UNKNOWN'::text
	END AS region,
	rnc,  
	CASE
		WHEN "substring"(cellname, 3, 3) = 'S01'::text THEN "substring"(cellname, 6, 7)
		ELSE "substring"(cellname, 2, 7)
	END AS "NODEB",
	round(10::numeric * log(avg(power(10::double precision, rtwp / 10::double precision)))::numeric, 2) AS rtwp,
	SUM(good_rop + bad_rop) as total_rops,
	SUM(bad_rop) as bad_rops
FROM
	(SELECT datetime, rnc, cellname, rtwp,
		CASE
			WHEN rtwp IS NULL OR rtwp > (-90)::real THEN 0
			ELSE 1
		END AS good_rop,
		CASE
			WHEN rtwp IS NULL OR rtwp < (-90)::real THEN 0
			ELSE 1
		END AS bad_rop
	FROM
		(SELECT 
			date_trunc('hour', datetime) as datetime,
			rnc,
			cellname,
			round(10::numeric * log(avg(power(10::double precision, rtwp / 10::double precision)))::numeric, 2) AS rtwp
		FROM
			umts_kpi.main_kpis
		GROUP BY 
			date_trunc('hour', datetime),rnc,cellname) t
	WHERE 
		date_part('week'::text, datetime::date + '1 day'::interval) = 43
		AND date_part('dow', datetime::date) in (1,2,3,4,5)
		AND datetime::time between '07:00:00' and '22:00:00') t2
GROUP BY 
	date_part('week'::text, datetime::date + '1 day'::interval),
	CASE
		WHEN substr(rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
		WHEN substr(rnc, 4, 2) = ANY (ARRAY['BA'::text, 'SE'::text]) THEN 'BASE'::text
		WHEN substr(rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'GO'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'TO'::text]) THEN 'CO'::text
		WHEN substr(rnc, 4, 2) = 'ES'::text THEN 'ES'::text
		WHEN substr(rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
		WHEN substr(rnc, 4, 2) = 'MG'::text THEN 'MG'::text
		ELSE 'UNKNOWN'::text
	END,
	rnc,  
	CASE
		WHEN "substring"(cellname, 3, 3) = 'S01'::text THEN "substring"(cellname, 6, 7)
		ELSE "substring"(cellname, 2, 7)
	END
ORDER BY 
	REGION, 
	bad_rops DESC
    