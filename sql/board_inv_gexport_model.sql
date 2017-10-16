-- View: umts_inventory.vw_inventory_board_gexport

-- DROP VIEW umts_inventory.vw_inventory_board_gexport;

CREATE OR REPLACE VIEW umts_inventory.vw_inventory_board_gexport AS 
 SELECT DISTINCT b.node,
    count(*) AS boardnum,
    sum(
        CASE
            WHEN b.boardname = 'HBBU'::text THEN 1
            ELSE 0
        END) AS hbbu,
    sum(
        CASE
            WHEN b.boardname = 'EBBC'::text THEN 1
            ELSE 0
        END) AS ebbc,
    sum(
        CASE
            WHEN b.boardname = 'UMPT'::text THEN 1
            ELSE 0
        END) AS umpt,
    sum(
        CASE
            WHEN b.boardname = 'WMPT'::text THEN 1
            ELSE 0
        END) AS wmpt,
    sum(
        CASE
            WHEN b.boardtype ~~ '%WBBPB3%'::text THEN 1
            ELSE 0
        END) AS wbbpb3,
    sum(
        CASE
            WHEN b.boardtype ~~ '%WBBPB4%'::text THEN 1
            ELSE 0
        END) AS wbbpb4,
    sum(
        CASE
            WHEN b.boardtype ~~ '%WBBPD1%'::text THEN 1
            ELSE 0
        END) AS wbbpd1,
    sum(
        CASE
            WHEN b.boardtype ~~ '%WBBPD2%'::text THEN 1
            ELSE 0
        END) AS wbbpd2,
    sum(
        CASE
            WHEN b.boardtype ~~ '%WBBPD3%'::text THEN 1
            ELSE 0
        END) AS wbbpd3,
    sum(
        CASE
            WHEN b.boardtype ~~ '%WBBPF3%'::text THEN 1
            ELSE 0
        END) AS wbbpf3,
    sum(
        CASE
            WHEN b.boardtype ~~ '%WBBPF4%'::text THEN 1
            ELSE 0
        END) AS wbbpf4,
    sum(
        CASE
            WHEN b.boardname = 'WBBP'::text AND b.boardtype ~~ ''::text THEN 1
            ELSE 0
        END) AS wbbp_typenull,
    sum(
        CASE
            WHEN b.boardname = 'UBBP'::text and (bbp.bbws like '%UMTS-1%' or bbp.bbws = 'GSM-0&LTE_FDD-0&LTE_TDD-0&UMTS-0') THEN 1
            ELSE 0
        END) AS ubbp,
    sum(
        CASE
            WHEN b.boardname = 'UTRP'::text THEN 1
            ELSE 0
        END) AS utrp
   FROM 
   
(select distinct * from
(SELECT distinct * FROM nodeb_configuration.inventoryboard
        UNION
         SELECT distinct *
           FROM sran_configuration.inventoryboard
) b1 ) b
           
           --where b.boardname= 'UBBP'
           --order by node           
--5615


                  --    where bbp.type = 'UBBP'
            left join 
            
(select distinct * from
  (SELECT distinct * FROM nodeb_configuration.bbp
        UNION
         SELECT distinct *
           FROM sran_configuration.bbp
) bbp1) bbp
          on b.node = bbp.node and b.boardname=bbp.type and b.slotno = bbp.sn   
   
  WHERE b.boardtype ~ similar_escape('%(WMPT|UTRP|UMPT|WBBP|HBBU|EBBC|UBBP)%'::text, NULL::text)
  GROUP BY b.node