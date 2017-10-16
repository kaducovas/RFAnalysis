select c.rnc, c.cellid, u.cellname,
case when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then 0
when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then 120
when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then 240
else p.azimuth end,
case when p.bandwidth is null then 60 else p.bandwidth end,
l.latitude, l.longitude,
c.vs_tp_ue_0, c.vs_tp_ue_1, c.vs_tp_ue_2, c.vs_tp_ue_3, c.vs_tp_ue_4, c.vs_tp_ue_5, c.vs_tp_ue_6_9, c.vs_tp_ue_10_15, c.vs_tp_ue_16_25, c.vs_tp_ue_26_35, c.vs_tp_ue_36_55, c.vs_tp_ue_more55,
(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55),
case when 100*((c.vs_tp_ue_0)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 234
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 468
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 706
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 936
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 1170
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 1404
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 2340
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 3744
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 6084
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 8424
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 13104
when 100*((c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)/(c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55)) >= 90 then 15000 else 0 end as distance
from umts_counter.fss_67109365_daily c
left join umts_configuration.ucellsetup u on c.rnc = u.rncname and c.cellid = u.cellid
left join umts_gis.cell_physical_parameter p on u.cellname = p.cellname
left join umts_gis.nodeb_locus l on l.nodebname = left(u.cellname,8)
where c.date = '2016-01-03'
and l.latitude is not null
and l.longitude is not null
and (c.vs_tp_ue_0 + c.vs_tp_ue_1 + c.vs_tp_ue_2 + c.vs_tp_ue_3 + c.vs_tp_ue_4 + c.vs_tp_ue_5 + c.vs_tp_ue_6_9 + c.vs_tp_ue_10_15 + c.vs_tp_ue_16_25 + c.vs_tp_ue_26_35 + c.vs_tp_ue_36_55 + c.vs_tp_ue_more55) <> 0;
