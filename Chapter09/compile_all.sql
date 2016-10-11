set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
@pl.prc
@html_help.pks
@text_help.pks
@html_help.pkb
@text_help.pkb
@.\solutions\test_ts.pks
@.\solutions\dates.pks
@.\solutions\gender_ts.pks
@.\solutions\logical_assignment_ts.pks
@.\solutions\logical_workplace_ts.pks
@.\solutions\numbers.pks
@.\solutions\physical_assignment_ts.pks
@.\solutions\physical_workplace_ts.pks
@.\solutions\top_100_names.pks
@.\solutions\varchar2s.pks
@.\solutions\work_assignment_ts.pks
@.\solutions\work_ts.pks
@.\solutions\worker_ts.pks
@.\solutions\worker_type_ts.pks
@.\solutions\workplace_type_ts.pks
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
