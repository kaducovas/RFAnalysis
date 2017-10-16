--select * from umts_baseline.baseline_audit('baseline')

CREATE OR REPLACE FUNCTION umts_baseline.baseline_audit(id text)
  RETURNS SETOF consistency_check AS
$BODY$
declare
  cur_row record;
  cur_row_par record;
  r consistency_check;
schema_name text := '';
main_element_name text := '';  
begin 



	for cur_row in execute format('select * from umts_baseline.rules where id = ''%1$s'' and act = true order by mo',id)

		loop

		
		  if (cur_row.element = 'rncname' or cur_row.element = 'cellid') then
		    schema_name := 'umts_configuration';
		    main_element_name := 'rncname';
		ELSIF (cur_row.element = 'nodeb' or cur_row.element = 'ulocellid' or cur_row.element = 'locell') then
		    schema_name := 'umts_nodeb_configuration';
		    main_element_name := 'nodeb';	    		    
		  end if;
		
		  for cur_row_par in execute format('select *,%1$s::TEXT as configured,%2$s::TEXT as node,%3$s::TEXT as element_id from %4$s.%5$s',cur_row.parameter,main_element_name,cur_row.element,schema_name,cur_row.mo)
		  
			LOOP
			r.baseline_date := now()::date ;
			r.datetime := cur_row_par.datetime; 
				r.id := cur_row.id;
			  r.node := cur_row_par.node;
			  r.element_id := cur_row_par.element_id;
			  r.mo := cur_row.mo;		  
			  r.parameter := cur_row.parameter;
			  r.baseline := cur_row.value;
			  r.configured := cur_row_par.configured;
			  

			
			
			 -- start normal verifications
		  if (cur_row.subparameter = false) then
			if(cur_row.operator = '=') then
				  if (lower(cur_row.value::text) = lower(cur_row_par.configured::text)) then
					r.status := 'OK';
					r.mml = '';
				  else r.status := 'NOK';
				  r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				  end if;
			else 
			 if(lower(cur_row.value::text) like ('%' || lower(cur_row_par.configured::text) || '%')) then
					r.status := 'OK';
					r.mml = '';
				  else r.status := 'NOK';
				  r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				  end if;
			end if;
		  else 	  
			 if(lower(cur_row_par.configured::text) like ('%' || lower(cur_row.value::text) || '%')) then --contains
				r.status := 'OK';
				r.mml = '';
				ELSIF(lower(cur_row_par.configured::text) like ('%' || lower(split_part(cur_row.value::text, '-', 1)::text) || '%')) then 
					r.status := 'NOK';
				  r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
			 else 	
				r.status := 'OK';
				r.mml = '';	
			end if;
		  end if;


			  --exception for MG. Futurely we should verify such rules QQUALMIN
		  if(substring(cur_row_par.node,4,2) = 'MG' and lower(cur_row.parameter) = 'qqualmin') then 
				if(cur_row_par.configured in ('-16','-18')) then
					r.status := 'OK';
					r.mml = '';
				else 
					r.status := 'NOK';
					r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				end if;
			end if;
			
			  --exception for MG we should verify such rules QRXLEVELMIN

		  if(substring(cur_row_par.node,4,2) IN ('MG') and lower(cur_row.parameter) = 'qrxlevmin') then 
				if(cur_row_par.configured in ('-58','-48','-53')) then
					r.status := 'OK';
					r.mml = '';
				else 
					r.status := 'NOK';
					r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				end if;
			end if;

			  --exception for PRSC, BA we should verify such rules QRXLEVELMIN

		  if(substring(cur_row_par.node,4,2) IN ('BA','PR','SC') and lower(cur_row.parameter) = 'qrxlevmin') then 
				if(cur_row_par.configured in ('-58','-53')) then
					r.status := 'OK';
					r.mml = '';
				else 
					r.status := 'NOK';
					r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				end if;
			end if;
			
			  --exception for MG. Futurely we should verify such rules BGN
		  if(substring(cur_row_par.node,4,2) = 'MG' and lower(cur_row.parameter) = 'bgnswitch') then 
				if(cur_row_par.configured in ('ON','OFF') ) then
					r.status := 'OK';
					r.mml = '';
				else 
					r.status := 'NOK';
					r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				end if;
			end if;			
			  
			  --exception for UINTRAFREQNCELL and UINTERFREQNCELL. Futurely we should verify such rules IDLEQOFFSET2SN
		  if(lower(cur_row.parameter) = 'idleqoffset2sn' or lower(cur_row.parameter) = 'idleqoffset1sn') then 
				if(lower(cur_row.value::text) like ('%' || lower(cur_row_par.configured::text) || '%')) then
--				if(cur_row_par.configured in ('-16','-18')) then
					r.status := 'OK';
					r.mml = '';
				else 
					r.status := 'NOK';
					r.mml = concat(replace(replace(replace(replace(replace(replace(cur_row.mml,'%RNCID%'::text,cur_row_par.rncid),
					'%CELLID%'::text,cur_row_par.element_id),
					'%NCELLRNCID%'::text,cur_row_par.ncellrncid),
					'%NCELLID%'::text,cur_row_par.ncellid),
					'%IDLEQOFFSET1SN%'::text,cur_row_par.idleqoffset1sn),
					'%IDLEQOFFSET2SN%'::text,cur_row_par.idleqoffset2sn),
					'{',cur_row_par.node,'}');
--					r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				end if;
			end if;

			  --exception for U2GNCELL. Futurely we should verify such rules "QOFFSET1SN"
		  if(lower(cur_row.parameter) = 'qoffset1sn' and lower(cur_row.mo) = 'u2gncell') then 
				if(lower(cur_row.value::text) like ('%' || lower(cur_row_par.configured::text) || '%')) then
--				if(cur_row_par.configured in ('-16','-18')) then
					r.status := 'OK';
					r.mml = '';
				else 
					r.status := 'NOK';
					r.mml = concat(replace(replace(replace(cur_row.mml,'%RNCID%'::text,cur_row_par.rncid),
					'%CELLID%'::text,cur_row_par.element_id),
					'%GSMCELLINDEX%'::text,cur_row_par.gsmcellindex),
					'{',cur_row_par.node,'}');
--					r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				end if;
			end if;	

			  --exception for UCELLINTERRATHOCOV,UCELLINTRAFREQHO,UCELLINTERFREQHOCOV. Futurely we should verify such rules {cellid was used as parameter to make sure all cells should remove such MOs}
		  if((lower(cur_row.mo) = 'ucellinterrathocov' or lower(cur_row.mo) = 'ucellintrafreqho' or lower(cur_row.mo) = 'ucellinterfreqhocov') and lower(cur_row.parameter) = 'cellid') then 
				if(lower(cur_row.value::text) like ('%' || lower(cur_row_par.configured::text) || '%')) then
--				if(cur_row_par.configured in ('-16','-18')) then
					r.status := 'OK';
					r.mml = '';
				else 
					r.status := 'NOK';
					r.mml = concat(replace(replace(cur_row.mml,'%RNCID%',cur_row_par.element_id),
					'%CELLID%',cur_row_par.element_id),
					'{',cur_row_par.node,'}');
--					r.mml = concat(replace(cur_row.mml,'%CELLID%',cur_row_par.element_id),'{',cur_row_par.node,'}');
				end if;
			end if;			
		  
		  return next r;
		  end loop;
	  end loop;

end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION umts_baseline.baseline_audit(text)
  OWNER TO postgres;
