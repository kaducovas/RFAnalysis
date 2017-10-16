SELECT 
       distinct uarfcndownlink, @(@(200000/left(uarfcndownlink::text,-2)::integer + right(uarfcndownlink::text,2)::integer) - 3000) - 1200
  FROM umts_configuration.ucellsetup
  order by uarfcndownlink;
