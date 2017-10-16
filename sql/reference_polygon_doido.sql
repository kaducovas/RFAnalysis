truncate umts_gis.polygon_coverage
insert into umts_gis.polygon_coverage


select c.rncname, c.cellid, p.cellname, case when p.bandwidth = 360 then st_buffer(st_makepoint(l.longitude::double precision,l.latitude::double precision)::geography,(@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision) else st_geogfromtext('POLYGON((' || l.longitude::double precision || ' ' || l.latitude::double precision || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi1))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi1)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi1)))) || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi2))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi2)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi2)))) || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi3))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi3)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi3)))) || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi4))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi4)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi4)))) || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi5))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi5)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi5)))) || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi6))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi6)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi6)))) || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi7))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi7)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi7)))) || ',' ||
degrees(radians(l.longitude::double precision) + atan2(sin(radians(azi8))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(l.latitude::double precision)),cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)-sin(radians(l.latitude::double precision))*sin(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi8)))))) || ' ' ||
degrees(asin(sin(radians(l.latitude::double precision))*cos((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000) + cos(radians(l.latitude::double precision))*sin((@(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200)::double precision/6371000)*cos(radians(azi8)))) || ',' || l.longitude::double precision || ' ' || l.latitude::double precision || '))')
end as polygon
from umts_configuration.ucellsetup c
left join (select u.rncname, u.cellname, u.cellid,u.uarfcndownlink,p.azimuth,p.bandwidth,
case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 360-(60*7/14)
		else (360-(p.bandwidth*7/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120-(60*7/14)
		else (120-(p.bandwidth*7/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240-(60*7/14)
		else (240-(p.bandwidth*7/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth-(60*7/14)) < 0 then (p.azimuth-(60*7/14))+360
			else (p.azimuth-(60*7/14))
			end
		else case
			when (azimuth-(bandwidth*7/14)) < 0 then (azimuth-(bandwidth*7/14))+360
			else (azimuth-(bandwidth*7/14))
			end
		end
	end azi1,
case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 360-(60*5/14)
		else (360-(p.bandwidth*5/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120-(60*5/14)
		else (120-(p.bandwidth*5/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240-(60*5/14)
		else (240-(p.bandwidth*5/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth-(60*5/14)) < 0 then (p.azimuth-(60*5/14))+360
			else (p.azimuth-(60*5/14))
			end
		else case
			when (azimuth-(bandwidth*5/14)) < 0 then (azimuth-(bandwidth*5/14))+360
			else (azimuth-(bandwidth*5/14))
			end
		end
	end azi2,
	case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 360-(60*3/14)
		else (360-(p.bandwidth*3/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120-(60*3/14)
		else (120-(p.bandwidth*3/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240-(60*3/14)
		else (240-(p.bandwidth*3/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth-(60*3/14)) < 0 then (p.azimuth-(60*3/14))+360
			else (p.azimuth-(60*3/14))
			end
		else case
			when (azimuth-(bandwidth*3/14)) < 0 then (azimuth-(bandwidth*3/14))+360
			else (azimuth-(bandwidth*3/14))
			end
		end
	end azi3,
	case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 360-(60*1/14)
		else (360-(p.bandwidth*1/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120-(60*1/14)
		else (120-(p.bandwidth*1/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240-(60*1/14)
		else (240-(p.bandwidth*1/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth-(60*1/14)) < 0 then (p.azimuth-(60*1/14))+360
			else (p.azimuth-(60*1/14))
			end
		else case
			when (azimuth-(bandwidth*1/14)) < 0 then (azimuth-(bandwidth*1/14))+360
			else (azimuth-(bandwidth*1/14))
			end
		end
	end azi4,
case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then (60*1/14)
		else (0+(p.bandwidth*1/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120+(60*1/14)
		else (120+(p.bandwidth*1/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240+(60*1/14)
		else (240+(p.bandwidth*1/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth+(60*1/14)) > 360 then (p.azimuth+(60*1/14))-360
			else (p.azimuth+(60*1/14))
			end
		else case
			when (azimuth+(bandwidth*1/14)) > 360 then (azimuth+(bandwidth*1/14))-360
			else (azimuth+(bandwidth*1/14))
			end
		end
	end azi5,
case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then (60*3/14)
		else (0+(p.bandwidth*3/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120+(60*3/14)
		else (120+(p.bandwidth*3/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240+(60*3/14)
		else (240+(p.bandwidth*3/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth+(60*3/14)) > 360 then (p.azimuth+(60*3/14))-360
			else (p.azimuth+(60*3/14))
			end
		else case
			when (azimuth+(bandwidth*3/14)) > 360 then (azimuth+(bandwidth*3/14))-360
			else (azimuth+(bandwidth*3/14))
			end
		end
	end azi6,
case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then (60*5/14)
		else (0+(p.bandwidth*5/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120+(60*5/14)
		else (120+(p.bandwidth*5/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240+(60*5/14)
		else (240+(p.bandwidth*5/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth+(60*5/14)) > 360 then (p.azimuth+(60*5/14))-360
			else (p.azimuth+(60*5/14))
			end
		else case
			when (azimuth+(bandwidth*5/14)) > 360 then (azimuth+(bandwidth*5/14))-360
			else (azimuth+(bandwidth*5/14))
			end
		end
	end azi7,
case
	when p.azimuth is null and right(u.cellname,1) in ('A', 'D', 'E', 'H', 'I', 'L', 'M', 'P', 'Q', 'T', 'U', 'X', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then (60*7/14)
		else (0+(p.bandwidth*7/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('B', 'F', 'J', 'N', 'R', 'V', 'Y') then case
		when p.bandwidth is null or p.bandwidth = 0 then 120+(60*7/14)
		else (120+(p.bandwidth*7/14))
		end
	when p.azimuth is null and right(u.cellname,1) in ('C', 'G', 'K', 'O', 'S', 'W', 'Z') then case
		when p.bandwidth is null or p.bandwidth = 0 then 240+(60*7/14)
		else (240+(p.bandwidth*7/14))
		end
	else case
		when p.bandwidth is null or p.bandwidth = 0 then case 
			when (p.azimuth+(60*7/14)) > 360 then (p.azimuth+(60*7/14))-360
			else (p.azimuth+(60*7/14))
			end
		else case
			when (azimuth+(bandwidth*7/14)) > 360 then (azimuth+(bandwidth*7/14))-360
			else (azimuth+(bandwidth*7/14))
			end
		end
	end azi8
from umts_configuration.ucellsetup u
left join umts_gis.cell_physical_parameter p on u.cellname = p.cellname) p on c.rncname = p.rncname and c.cellid = p.cellid
left join umts_gis.nodeb_locus l on l.nodebname = left(p.cellname,8)
where l.latitude::double precision is not null
and l.longitude::double precision is not null
