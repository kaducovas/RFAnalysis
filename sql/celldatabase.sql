select
c.cellname as "CELL",
substr(c.cellname,2,7) as "SITEID",
case when substr(c.cellname,2,2) in ('AL','CE','PB','PE','PI','RN') then 'NE'
when substr(c.cellname,2,2) in ('BA','SE') then 'BASE'
when substr(c.cellname,2,2) in ('AC','DF','GO','MS','MT','RO','TO') then 'CO'
when substr(c.cellname,2,2) in ('ES') then 'ES'
when substr(c.cellname,2,2) in ('PR','SC') then 'PRSC'
when substr(c.cellname,2,2) in ('MG') then 'MG' end as "REGIONAL",
substr(c.cellname,2,2) as "UF",
c.rncname as "RNC",
l.cluster as "CLUSTER",
l.city as "CIDADE",
l.neighborhood as "BAIRRO",
l.latitude as "LATITUDE",
l.longitude as "LONGITUDE",
c.cellid as "CELLID",
c.rncid as "RNCID",
c.lac as "LAC",
c.uarfcndownlink as "UARFCNDOWNLINK",
c.uarfcnuplink as "UARFCNUPLINK",
c.pscrambcode as "PSC",
c.bandind as "BAND",
case when right(c.cellname,1) in ('A','B','C','D') and substr(c.cellname,2,2) in ('AC','AL','CE','DF','GO','MS','MT','PB','PE','PI','RN','RO','TO') then '850 F1'
when right(c.cellname,1) in ('E','F','G','H') and substr(c.cellname,2,2) in ('AC','AL','CE','DF','GO','ES','MS','MT','PB','PE','PI','RN','RO','TO') then '850 F2'
when right(c.cellname,1) in ('I','J','K','L') and substr(c.cellname,2,2) in ('AC','AL','CE','DF','GO','ES','MS','MT','PB','PE','PI','RN','RO','TO') then '2100 F1'
when right(c.cellname,1) in ('M','N','O','P') and substr(c.cellname,2,2) in ('AC','AL','CE','DF','GO','ES','MS','MT','PB','PE','PI','RN','RO','TO') then '2100 F2'
when right(c.cellname,1) in ('U','V','W','X') and substr(c.cellname,2,2) in ('AC','AL','CE','DF','GO','ES','PE','RN') then '2100 F3'
when right(c.cellname,1) in ('A','B','C','D','M','N','O','P') and substr(c.cellname,2,2) in ('BA') then '2100 F1'
when right(c.cellname,1) in ('E','F','G','H','I','J','K','L','U','V','W','X') and substr(c.cellname,2,2) in ('BA') then '2100 F2'
when right(c.cellname,1) in ('1','2','3','4') and substr(c.cellname,2,2) in ('ES') then '850 F1'
when right(c.cellname,1) in ('0','1','2','3') and substr(c.cellname,2,2) in ('MG') then '2100 F1'
when right(c.cellname,1) in ('I','J','K','L') and substr(c.cellname,2,2) in ('MG','PR','SC') then '2100 F2'
when right(c.cellname,1) in ('M','N','O','P') and substr(c.cellname,2,2) in ('MG') then '2100 F3'
when right(c.cellname,1) in ('A','B','C','D') and substr(c.cellname,2,2) in ('PR','SC') then '2100 F1'
when right(c.cellname,1) in ('E','F','G','H') and substr(c.cellname,2,2) in ('PR','SC') then '2100 F2'
when right(c.cellname,1) in ('Q','R','S','T') and substr(c.cellname,2,2) in ('PR') then '1900 F1' end as "CARRIER",
a.cellid as "STATUS OSS",
p.azimuth as "AZIMUTH",
p.antenna as "ANT_MODEL",
p.bandwidth as "ANTBEAMWIDTH",
p.etilt as "TILT_MEC",
p.mtilt as "TILT_ELE",
p.height as "HEIGHT",
case when b.cellname is null then 'Core' else 'Borda' end as "Core & Borda"
from umts_configuration.ucellsetup c
left join umts_gis.nodeb_locus l on l.nodebname = left(c.cellname,8)
left join umts_configuration.ucell a on a.cellid = c.cellid and a.rncid = c.rncid
left join umts_gis.cell_physical_parameter p on c.cellname = p.cellname
left join umts_gis.polygon_border_cell b on c.cellname = b.cellname