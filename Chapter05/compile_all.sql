set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt;                       
@a_thru_z.tab
@top_100_first_name.tab
@top_100_last_name.tab
@dates.pks
@gender_ts.pks
@worker_type_ts.pks
@worker_ts.pks
@dates.pkb
@gender_ts.pkb
@worker_type_ts.pkb
@worker_ts.pkb
@.\solutions\worker_ts.pks
@.\solutions\worker_ts.pkb
delete worker_t;
commit;
@.\solutions\worker_t_cursor_for_loop.ins
delete worker_t;
commit;
@.\solutions\worker_t_bulk_collect.ins
delete worker_t;
commit;
@worker_t_forall.ins
delete worker_t;
commit;
@worker_t.ins
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
