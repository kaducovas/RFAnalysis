copy(
select cdb1.region,cdb1.cluster,cdb1.cidade,cdb1.rnc,cdb1.nodeb,cdb1.cell,cdb2.cell cocell,cdb1.cellid,cdb2.cellid cocellid,cdb1.locell,cdb1.azimuth,cdb1.band,cdb1.uarfcnuplink,cdb1.uarfcndownlink,cdb1.band,cdb1.carrier,
case 
when
cdb1.band= cdb2.band AND cdb1.azimuth = cdb2.azimuth
then 'COCELL'::TEXT
else 'NOT_COCELL'::TEXT
end as is_cocell,
'NOT_CONFIGURED'::TEXT as is_configured,
case 
when
cdb1.band= cdb2.band AND cdb1.azimuth = cdb2.azimuth
then 
concat('ADD UINTERFREQNCELL:RNCID=',cdb1.rncid,',CELLID=',cdb1.cellid,',NCELLRNCID=',cdb2.rncid,',NCellId=',cdb2.cellid,',SIB11IND=TRUE,SIB12IND=FALSE,TPENALTYHCSRESELECT=D0,HOCOVPRIO=1,BLINDHOFLAG=TRUE,BLINDHOQUALITYCONDITION=-80,NPRIOFLAG=FALSE,DRDECN0THRESHHOLD=-8,INTERNCELLQUALREQFLAG=FALSE,CLBFLAG=FALSE;')
else
concat('ADD UINTERFREQNCELL:RNCID=',cdb1.rncid,',CELLID=',cdb1.cellid,',NCELLRNCID=',cdb2.rncid,',NCellId=',cdb2.cellid,',SIB11IND=TRUE,SIB12IND=FALSE,TPENALTYHCSRESELECT=D0,BLINDHOFLAG=FALSE,NPRIOFLAG=FALSE,INTERNCELLQUALREQFLAG=FALSE,CLBFLAG=FALSE;')
end as mml
from
umts_control.cells_database cdb1
inner join 
umts_control.cells_database cdb2
on cdb1.nodebname_norm =cdb2.nodebname_norm  and cdb1.rnc = cdb2.rnc and cdb1.uarfcndownlink != cdb2.uarfcndownlink
WHERE
(cdb1.rncid,cdb1.cellid,cdb2.rncid,cdb2.cellid) not in 
(select RNCID,CELLID,NCELLRNCID,NCELLID from umts_configuration.UINTERFREQNCELL) 

union

select cdb1.region,cdb1.cluster,cdb1.cidade,cdb1.rnc,cdb1.nodeb,cdb1.cell,cdb2.cell cocell,cdb1.cellid,cdb2.cellid cocellid,cdb1.locell,cdb1.azimuth,cdb1.band,cdb1.uarfcnuplink,cdb1.uarfcndownlink,cdb1.band,cdb1.carrier,
case 
when
cdb1.band= cdb2.band AND cdb1.azimuth = cdb2.azimuth
then 'COCELL'::TEXT
else 'NOT_COCELL'::TEXT
end as is_cocell,
'CONFIGURED'::TEXT as is_configured,
case 
when
cdb1.band= cdb2.band AND cdb1.azimuth = cdb2.azimuth
then 
concat('MOD UINTERFREQNCELL:RNCID=',cdb1.rncid,',CELLID=',cdb1.cellid,',NCELLRNCID=',cdb2.rncid,',NCellId=',cdb2.cellid,',SIB11IND=TRUE,SIB12IND=FALSE,TPENALTYHCSRESELECT=D0,HOCOVPRIO=1,BLINDHOFLAG=TRUE,BLINDHOQUALITYCONDITION=-80,NPRIOFLAG=FALSE,DRDECN0THRESHHOLD=-8,INTERNCELLQUALREQFLAG=FALSE,CLBFLAG=FALSE;')
else
concat('MOD UINTERFREQNCELL:RNCID=',cdb1.rncid,',CELLID=',cdb1.cellid,',NCELLRNCID=',cdb2.rncid,',NCellId=',cdb2.cellid,',SIB11IND=TRUE,SIB12IND=FALSE,TPENALTYHCSRESELECT=D0,BLINDHOFLAG=FALSE,NPRIOFLAG=FALSE,INTERNCELLQUALREQFLAG=FALSE,CLBFLAG=FALSE;')
end as mml
from
umts_control.cells_database cdb1
inner join 
umts_control.cells_database cdb2
on cdb1.nodebname_norm =cdb2.nodebname_norm  and cdb1.rnc = cdb2.rnc and cdb1.uarfcndownlink != cdb2.uarfcndownlink
WHERE
(cdb1.rncid,cdb1.cellid,cdb2.rncid,cdb2.cellid) in 
(select RNCID,CELLID,NCELLRNCID,NCELLID from umts_configuration.UINTERFREQNCELL) 

) to '/home/postgres/dump/add_mod_uinterfreqncell.csv' delimiter ';' csv header
