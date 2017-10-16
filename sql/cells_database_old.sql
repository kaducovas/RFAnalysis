-- View: common_gis.cells_database

-- DROP VIEW common_gis.cells_database;

CREATE OR REPLACE VIEW common_gis.cells_database AS 
 SELECT c.cellid,
    c.locell,
    c.cellname AS cell,
    substr(c.cellname, 2, 7) AS nodeb,
        CASE
            WHEN substr(c.cellname, 2, 2) = ANY (ARRAY['AL'::text, 'CE'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text]) THEN 'NE'::text
            WHEN substr(c.cellname, 2, 2) = ANY (ARRAY['BA'::text, 'SE'::text]) THEN 'BASE'::text
            WHEN substr(c.cellname, 2, 2) = ANY (ARRAY['AC'::text, 'DF'::text, 'GO'::text, 'MS'::text, 'MT'::text, 'RO'::text, 'TO'::text]) THEN 'CO'::text
            WHEN substr(c.cellname, 2, 2) = 'ES'::text THEN 'ES'::text
            WHEN substr(c.cellname, 2, 2) = ANY (ARRAY['PR'::text, 'SC'::text]) THEN 'PRSC'::text
            WHEN substr(c.cellname, 2, 2) = 'MG'::text THEN 'MG'::text
            ELSE NULL::text
        END AS regional,
        CASE
            WHEN NOT l.cluster IS NULL THEN substr(l.cluster, 1, 2)
            ELSE substr(c.cellname, 2, 2)
        END AS uf,
    c.rncname AS rnc,
    l.cluster,
    l.city AS cidade,
    l.ibge,
    l.neighborhood AS bairro,
    l.latitude,
    l.longitude,
    c.rncid,
    (('x'::text || lpad("right"(c.lac, (-2)), 16, '0'::text)))::bit(64)::bigint AS "LAC",
    c.uarfcnuplink,
    c.uarfcndownlink,
    c.pscrambcode AS psc,
    c.bandind AS band,
        CASE
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['A'::text, 'B'::text, 'C'::text, 'D'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['AC'::text, 'AL'::text, 'CE'::text, 'DF'::text, 'GO'::text, 'MS'::text, 'MT'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text, 'RO'::text, 'TO'::text])) THEN '850 F1'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['E'::text, 'F'::text, 'G'::text, 'H'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['AC'::text, 'AL'::text, 'CE'::text, 'DF'::text, 'GO'::text, 'ES'::text, 'MS'::text, 'MT'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text, 'RO'::text, 'TO'::text])) THEN '850 F2'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['I'::text, 'J'::text, 'K'::text, 'L'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['AC'::text, 'AL'::text, 'CE'::text, 'DF'::text, 'GO'::text, 'ES'::text, 'MS'::text, 'MT'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text, 'RO'::text, 'TO'::text])) THEN '2100 F1'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['M'::text, 'N'::text, 'O'::text, 'P'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['AC'::text, 'AL'::text, 'CE'::text, 'DF'::text, 'GO'::text, 'ES'::text, 'MS'::text, 'MT'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text, 'RO'::text, 'TO'::text])) THEN '2100 F2'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['U'::text, 'V'::text, 'W'::text, 'X'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['AC'::text, 'AL'::text, 'CE'::text, 'DF'::text, 'GO'::text, 'ES'::text, 'MS'::text, 'MT'::text, 'PB'::text, 'PE'::text, 'PI'::text, 'RN'::text, 'RO'::text, 'TO'::text])) THEN '2100 F3'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['A'::text, 'B'::text, 'C'::text, 'D'::text, 'M'::text, 'N'::text, 'O'::text, 'P'::text])) AND substr(c.cellname, 2, 2) = 'BA'::text THEN '2100 F1'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['E'::text, 'F'::text, 'G'::text, 'H'::text, 'I'::text, 'J'::text, 'K'::text, 'L'::text, 'U'::text, 'V'::text, 'W'::text, 'X'::text])) AND substr(c.cellname, 2, 2) = 'BA'::text THEN '2100 F2'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['1'::text, '2'::text, '3'::text, '4'::text])) AND substr(c.cellname, 2, 2) = 'ES'::text THEN '850 F1'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['0'::text, '1'::text, '2'::text, '3'::text])) AND substr(c.cellname, 2, 2) = 'MG'::text THEN '2100 F1'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['I'::text, 'J'::text, 'K'::text, 'L'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['MG'::text, 'PR'::text, 'SC'::text])) THEN '2100 F2'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['M'::text, 'N'::text, 'O'::text, 'P'::text])) AND substr(c.cellname, 2, 2) = 'MG'::text THEN '2100 F3'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['A'::text, 'B'::text, 'C'::text, 'D'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['PR'::text, 'SC'::text])) THEN '2100 F1'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['E'::text, 'F'::text, 'G'::text, 'H'::text])) AND (substr(c.cellname, 2, 2) = ANY (ARRAY['PR'::text, 'SC'::text])) THEN '2100 F2'::text
            WHEN ("right"(c.cellname, 1) = ANY (ARRAY['Q'::text, 'R'::text, 'S'::text, 'T'::text])) AND substr(c.cellname, 2, 2) = 'PR'::text THEN '1900 F1'::text
            ELSE NULL::text
        END AS carrier,
    a.cellid AS "STATUS OSS",
        CASE
            WHEN p.azimuth IS NULL AND ("right"(c.cellname, 1) = ANY (ARRAY['A'::text, 'D'::text, 'E'::text, 'H'::text, 'I'::text, 'L'::text, 'M'::text, 'P'::text, 'Q'::text, 'T'::text, 'U'::text, 'X'::text, 'Y'::text])) THEN 0::real
            WHEN p.azimuth IS NULL AND ("right"(c.cellname, 1) = ANY (ARRAY['B'::text, 'F'::text, 'J'::text, 'N'::text, 'R'::text, 'V'::text, 'Y'::text])) THEN 120::real
            WHEN p.azimuth IS NULL AND ("right"(c.cellname, 1) = ANY (ARRAY['C'::text, 'G'::text, 'K'::text, 'O'::text, 'S'::text, 'W'::text, 'Z'::text])) THEN 240::real
            ELSE p.azimuth
        END AS azimuth,
    p.antenna AS ant_model,
        CASE
            WHEN p.bandwidth IS NULL THEN 60::real
            ELSE p.bandwidth
        END AS ant_beamwidth,
    p.etilt AS mec_tilt,
    p.mtilt AS elec_tilt,
    p.height AS ant_height,
        CASE
            WHEN b.cellname IS NULL THEN 'Borda'::text
            ELSE 'Core'::text
        END AS "Core & Borda"
   FROM umts_configuration.ucellsetup c
     LEFT JOIN nodeb_locus l ON l.nodebname = "left"(c.cellname, 8)
     LEFT JOIN umts_configuration.ucell a ON a.cellid = c.cellid AND a.rncid = c.rncid
     LEFT JOIN umts_cell_physical_parameter p ON c.cellname = p.cellname
     LEFT JOIN cell_border b ON c.cellname = b.cellname;

ALTER TABLE common_gis.cells_database
  OWNER TO postgres;
