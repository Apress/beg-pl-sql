@pl.prc
@drop_if_exists.prc
@drop_relational.sql
set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
@a_thru_z.tab
@gender_t.tab
@gender_t.ins
@hazard_level_t.tab
@hazard_level_t.ins
@substance_t.tab
@substance_t.ins
@top_100_first_name.tab
@top_100_last_name.tab
@worker_type_t.tab
@worker_type_t.ins
@workplace_type_t.tab
@workplace_type_t.ins
@worker_t.tab
@logical_workplace_t.tab
@logical_workplace_t.ins
@logical_assignment_t.tab
@physical_workplace_t.tab
@physical_assignment_t.tab
@task_t.tab
@task_substance_t.tab
@work_t.tab
@work_task_t.tab
@work_assignment_t.tab
@dates.pks
@logical_workplace_ts.pks
@workplace_type_ts.pks
@dates.pkb
@logical_workplace_ts.pkb
@workplace_type_ts.pkb
@wait.prc
@to_number_or_null.fun
@.\solutions\pl.prc
@.\solutions\numbers.pks
@.\solutions\numbers.pkb
@.\solutions\to_mmsddsyyyy_or_null.fun
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
