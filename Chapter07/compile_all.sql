set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
@pl.prc
@debug_o.tps
@debug_ot.tab
@debug_o.tpb
@debug_ots.pks
@debug_ots.pkb
@.\solutions\debug_t.tab
@.\solutions\debug_ts.pks
@.\solutions\debug_ts.pkb
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
