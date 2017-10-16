SELECT date_part('week'::text, nqi_daily.date + '1 day'::interval) AS week,
	CASE
		WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
		ELSE 'UNKNOWN'::text
	END AS region,
	"substring"(nqi_daily.rnc, 4, 2) as UF,
	nqi_daily.rnc,
	
	CASE
		WHEN "substring"(umts_configuration.ucellsetup.cellname, 3, 3) = 'S01'::text THEN "substring"(umts_configuration.ucellsetup.cellname, 6, 7)
		ELSE "substring"(umts_configuration.ucellsetup.cellname, 2, 7)
	END AS nodeb,
		
	SUM(qda_cs_bad_attempts) AS qda_cs_bad_attempts, 
	SUM(qdr_cs_bad_attempts) AS qdr_cs_bad_attempts,
	1::REAL AS Retention_bad_attempts,
	1::REAL AS availability_bad_attempts,
    SUM(qda_cs_bad_attempts) + SUM(qdr_cs_bad_attempts) AS total_bad_attempts,        
    round((COALESCE(sum(nqi_daily.qda_cs_good_attempts) / NULLIF(sum(nqi_daily.qda_cs_good_attempts) + sum(nqi_daily.qda_cs_bad_attempts), 0::real), 1::real))::numeric, 2) AS qda_cs,
    round((COALESCE(sum(nqi_daily.qdr_cs_good_attempts) / NULLIF(sum(nqi_daily.qdr_cs_good_attempts) + sum(nqi_daily.qdr_cs_bad_attempts), 0::real), 1::real))::numeric, 2) AS qdr_cs,
    round((1::double precision - COALESCE(sum(nqi_daily.retention_cs_num) / NULLIF(sum(nqi_daily.retention_cs_den), 0::real), 0::real))::numeric, 2) AS retention_cs,
    round((1::double precision - sum(nqi_daily.unavailability) / sum(32)::double precision)::numeric, 2) AS availability,
    round((COALESCE(sum(nqi_daily.qda_cs_good_attempts) / NULLIF(sum(nqi_daily.qda_cs_good_attempts) + sum(nqi_daily.qda_cs_bad_attempts), 0::real), 1::real) * COALESCE(sum(nqi_daily.qdr_cs_good_attempts) / NULLIF(sum(nqi_daily.qdr_cs_good_attempts) + sum(nqi_daily.qdr_cs_bad_attempts), 0::real), 1::real) * (1::double precision - COALESCE(sum(nqi_daily.retention_cs_num) / NULLIF(sum(nqi_daily.retention_cs_den), 0::real), 0::real)) * (1::double precision - sum(nqi_daily.unavailability) / sum(32)::double precision))::numeric, 2) AS NQI_CS
FROM 
	umts_kpi.nqi_daily inner join umts_configuration.ucellsetup on 
	umts_kpi.nqi_daily.rnc = umts_configuration.ucellsetup.rncname
	AND umts_kpi.nqi_daily.cellid = umts_configuration.ucellsetup.cellid
WHERE
	date_part('week'::text, nqi_daily.date + '1 day'::interval) = 40
GROUP BY date_part('week'::text, nqi_daily.date + '1 day'::interval), --nqi_daily.date,
	CASE
		WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'GO'::text, 'TO'::text]) THEN 'CO'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = 'BA'::text THEN 'BASE'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = 'MG'::text THEN 'MG'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
		WHEN "substring"(nqi_daily.rnc, 4, 2) = 'ES'::text THEN 'ES'::text
		ELSE 'UNKNOWN'::text
	END, nqi_daily.rnc, 

	CASE
		WHEN "substring"(umts_configuration.ucellsetup.cellname, 3, 3) = 'S01'::text THEN "substring"(umts_configuration.ucellsetup.cellname, 6, 7)
		ELSE "substring"(umts_configuration.ucellsetup.cellname, 2, 7)
	END

ORDER BY 
	week,
	region, 
	(SUM(qda_cs_bad_attempts) + SUM(qdr_cs_bad_attempts)) DESC