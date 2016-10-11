set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
@gender_o.tps
@gender_ov.vw
@gender_ot.tab
@gender_o.tpb
@gender_ot.ins
@gender_ts.pks
@worker_type_ts.pks
@worker_ts.pks
@gender_ts.pkb
@worker_type_ts.pkb
@worker_ts.pkb
@.\solutions\worker_type_o.tps
@.\solutions\worker_type_ov.vw
@.\solutions\worker_type_ot.tab
@.\solutions\worker_type_o.tpb
@.\solutions\worker_type_ot.ins
@.\solutions\worker_o.tps
@.\solutions\worker_ot.tab
@.\solutions\worker_o.tpb
@.\solutions\worker_ot.ins
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
