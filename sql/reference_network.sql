--1-FTP lte on filezilla using ip:10.123.246.10 user:ossuser pass:Changeme_123 path: /export/home/sysm/opt/oss/server/var/fileint/network
--2- download file EAMInfo.xml to ETL(192.168.1.203):/etl/common/eam/raw/ and rename to 10_EAMInfo.xml
--3- run /etl/scripts/auto_eam.sh 
--4-move the 4 files (15,10,atae,40_EAMInfo.xml.csv) from /etl/common/eam/converted to /home/postgres/dump/upload/ on 192.168.1.201

--5--backup previous network reference

copy(select * from umts_control.reference_network) to '/home/postgres/dump/20161005_reference_network.csv' delimiter ';' csv header

--6-truncate table
--truncate umts_control.reference_network

--7-copy each file inside /dump/upload to umts+control.reference_network
copy umts_control.reference_network from '/home/postgres/dump/upload/15_EAMInfo.xml.csv' delimiter ';' csv header;
copy umts_control.reference_network from '/home/postgres/dump/upload/40_EAMInfo.xml.csv' delimiter ';' csv header;
copy umts_control.reference_network from '/home/postgres/dump/upload/atae_EAMInfo.xml.csv' delimiter ';' csv header;
copy umts_control.reference_network from '/home/postgres/dump/upload/10_EAMInfo.xml.csv' delimiter ';' csv header;

--8-check if the new #rows >= previous #rows

select * from umts_control.reference_network