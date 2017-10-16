-- Table: umts_control.cells_db

-- DROP TABLE umts_control.cells_db;

CREATE TABLE umts_control.cells_db
(
  cellid integer,
  locell integer,
  cellname text,
  nodeb text,
  nodebname text,
  regional text,
  uf character varying(2),
  rnc text,
  cluster text,
  cidade text,
  ibge integer,
  bairro text,
  latitude real,
  longitude real,
  rncid integer,
  lac bigint,
  uarfcnuplink integer,
  uarfcndownlink integer,
  psc integer,
  band text,
  carrier text,
  status_oss integer,
  azimuth integer,
  ant_model text,
  ant_beamwidth real,
  mec_tilt real,
  elec_tilt real,
  ant_height real,
  core_borda text,
  nodeb_status text,
  cellname_status text,
  antenna text,
  antenna_status text,
  rru text,
  rru_status text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE umts_control.cells_db
  OWNER TO postgres;

-- Index: umts_control.cells_db_cellid_idx

-- DROP INDEX umts_control.cells_db_cellid_idx;

CREATE INDEX cells_db_cellid_idx
  ON umts_control.cells_db
  USING btree
  (cellid);

-- Index: umts_control.cells_db_ibge_idx

-- DROP INDEX umts_control.cells_db_ibge_idx;

CREATE INDEX cells_db_ibge_idx
  ON umts_control.cells_db
  USING btree
  (ibge);

-- Index: umts_control.cells_db_nodeb_idx

-- DROP INDEX umts_control.cells_db_nodeb_idx;

CREATE INDEX cells_db_nodeb_idx
  ON umts_control.cells_db
  USING btree
  (nodeb COLLATE pg_catalog."default");

-- Index: umts_control.cells_db_rnc_idx

-- DROP INDEX umts_control.cells_db_rnc_idx;

CREATE INDEX cells_db_rnc_idx
  ON umts_control.cells_db
  USING btree
  (rnc COLLATE pg_catalog."default");

