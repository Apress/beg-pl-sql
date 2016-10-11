set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
@pl.prc
@test_t.tab
@test_ts.pks
@test_ts.pkb
@logical_assignment_ts.pks
@logical_workplace_ts.pks
@worker_type_ts.pks
@logical_assignment_ts.pkb
@logical_workplace_ts.pkb
@worker_type_ts.pkb
@.\solutions\test_o.tps
@.\solutions\test_ot.tab
@.\solutions\test_o.tpb
@.\solutions\gender_ts.pks
@.\solutions\physical_assignment_ts.pks
@.\solutions\physical_workplace_ts.pks
@.\solutions\gender_ts.pkb
@.\solutions\physical_assignment_ts.pkb
@.\solutions\physical_workplace_ts.pkb
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
