SELECT c.cellname, n.cellname, round(st_distance(n.coordinate,b.coordinate)::numeric,2)
   FROM umts_gis.polygon_coverage c
   LEFT JOIN ( SELECT DISTINCT s.rncid, s.cellid, s.cellname, s.uarfcndownlink ,l.coordinate
               FROM umts_configuration.ucellsetup s
               LEFT JOIN umts_gis.nodeb_locus l ON s.nodebname = l.nodebname
               WHERE l.coordinate IS NOT NULL) n
   ON substr(c.cellname, 2, 2) = substr(n.cellname, 2, 2) AND substr(c.cellname, 2, 7) <> substr(n.cellname, 2, 7)
   left join umts_gis.nodeb_locus b ON left(c.cellname,-1) = b.nodebname
  LEFT JOIN umts_configuration.ucellsetup u ON c.cellname = u.cellname
  LEFT JOIN umts_configuration.uintrafreqncell i ON u.cellid = i.cellid and u.rncid = i.rncid and n.cellid = i.ncellid and n.rncid = i.ncellrncid 
  WHERE n.uarfcndownlink = u.uarfcndownlink
   and st_covers(c.coverage, n.coordinate)
 AND i.cellid is null