select * from
(select c1.cellname, round(100*(st_area(st_intersection(c1.coverage,c2.coverage))/st_area(c1.coverage))::numeric,2) as oh1, c2.cellname, round(100*(st_area(st_intersection(c1.coverage,c2.coverage))/st_area(c2.coverage))::numeric,2) as oh2
from umts_gis.polygon_coverage c1
left join umts_gis.polygon_coverage c2 on substr(c1.cellname,2,2) = substr(c2.cellname,2,2) and substr(c1.cellname,2,7) <> substr(c2.cellname,2,7)
where st_intersects(c1.coverage,c2.coverage)
and st_area(c1.coverage) > 1
and st_area(c2.coverage) > 1) r
where oh1 > 40
or oh2> 40