---create smart.csv from claro data
copy common_gis.stg_smart from '/home/postgres/dump/smart.csv' delimiter ';' csv header encoding 'latin2';

--backup nodeb_locus
copy(select * from common_gis.nodeb_locus) to '/home/postgres/dump/xxxxxxxx_nodeb_locus.csv' delimiter ';' csv header;

--truncate common_gis.nodeb_locus;

--insert in the nodeb_locus using data from smart.csv
insert into common_gis.nodeb_locus 
select distinct nodeb as nodebame,
regional,
  uf,
  cluster_rf as cluster,
  city,
  bairro as neighborhoodtext,
  latitude,
  longitude,
    elevation,
  tipo_infraestrutura as type,
ibge,
st_makepoint(longitude,latitude) as coordinate,null::integer,null::integer
from common_gis.stg_smart;

--backup umts_cell_physical_parameter
copy(SELECT * FROM common_gis.umts_cell_physical_parameter) to '/home/postgres/dump/xxxxxxxx_umts_cell_physical_parameter.csv' delimiter ';' csv header;

--truncate common_gis.umts_cell_physical_parameter;



--insert in the umts_cell_physical_parameter using data from smart.csv
insert into common_gis.umts_cell_physical_parameter
select cell_name as cellname, antenna_height as height,azimuth,elec_tilt as etilt,mec_tilt as mtilt, antenna_name as antenna, hz_bw::real as bandwidth
from common_gis.stg_smart;


--truncate common_gis.stg_smart;