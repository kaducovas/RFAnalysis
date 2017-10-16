select b.nodebname, max(c.cellcount), sum(h.hsdpaue), sum(h.hsupaue)
from umts_inventory.nodeb_board as b
left join (select nodebname,count(*) as cellcount from umts_configuration.ucellsetup group by nodebname) as c on c.nodebname = b.nodebname
left join umts_control.reference_hspaue as h on b.boardtype ilike '%' || h.board || '%' or b.boardname = h.board
where h.hsdpaue is not null
group by b.nodebname;