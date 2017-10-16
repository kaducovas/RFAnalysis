-- Table: umts_control.cells_database

-- DROP TABLE umts_control.cells_database;

CREATE TABLE umts_control.cells_database
(
  cellid integer,
  locell integer,
  cell text,
  nodeb text,
  region text,
  uf text,
  rnc text,
  cluster text,
  cidade text,
  ibge integer,
  bairro text,
  latitude real,
  longitude real,
  rncid integer,
  "LAC" bigint,
  uarfcnuplink integer,
  uarfcndownlink integer,
  psc integer,
  band text,
  carrier text,
  "STATUS OSS" integer,
  azimuth real,
  ant_model text,
  ant_beamwidth real,
  mec_tilt real,
  elec_tilt real,
  ant_height real,
  core_borda text,
  network text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE umts_control.cells_database
  OWNER TO postgres;

-- Index: umts_control.cells_database_cellid_idx

-- DROP INDEX umts_control.cells_database_cellid_idx;

CREATE INDEX cells_database_cellid_idx
  ON umts_control.cells_database
  USING btree
  (cellid);

-- Index: umts_control.cells_database_cidade_idx

-- DROP INDEX umts_control.cells_database_cidade_idx;

CREATE INDEX cells_database_cidade_idx
  ON umts_control.cells_database
  USING btree
  (cidade COLLATE pg_catalog."default");

-- Index: umts_control.cells_database_cluster_idx

-- DROP INDEX umts_control.cells_database_cluster_idx;

CREATE INDEX cells_database_cluster_idx
  ON umts_control.cells_database
  USING btree
  (cluster COLLATE pg_catalog."default");

-- Index: umts_control.cells_database_ibge_idx

-- DROP INDEX umts_control.cells_database_ibge_idx;

CREATE INDEX cells_database_ibge_idx
  ON umts_control.cells_database
  USING btree
  (ibge);

-- Index: umts_control.cells_database_nodeb_idx

-- DROP INDEX umts_control.cells_database_nodeb_idx;

CREATE INDEX cells_database_nodeb_idx
  ON umts_control.cells_database
  USING btree
  (nodeb COLLATE pg_catalog."default");

-- Index: umts_control.cells_database_rnc_idx

-- DROP INDEX umts_control.cells_database_rnc_idx;

CREATE INDEX cells_database_rnc_idx
  ON umts_control.cells_database
  USING btree
  (rnc COLLATE pg_catalog."default");

-- Index: umts_control.cells_database_uf_idx

-- DROP INDEX umts_control.cells_database_uf_idx;

CREATE INDEX cells_database_uf_idx
  ON umts_control.cells_database
  USING btree
  (uf COLLATE pg_catalog."default");

