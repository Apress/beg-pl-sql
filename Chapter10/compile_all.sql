set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
@pl.prc
@incr.fun
@to_boolean_number.fun
@email_log.tab
@interface_status.tab
@on_demand_process_log.tab
@polling_process_queue.tab
@polling_process_status.tab
@report_staging_table_log.tab
@report_wkhst.tab
@weekly_interface_status.tab
@worker_type_t.tab
@email_logs.pks
@emails.pks
@interface_statuss.pks
@logical_assignment_ts.pks
@logical_workplace_ts.pks
@on_demand_process.pks
@on_demand_process_logs.pks
@physical_assignment_ts.pks
@physical_workplace_ts.pks
@polling_process.pks
@polling_process_queues.pks
@polling_process_statuss.pks
@report_staging_table_logs.pks
@report_staging_tables.pks
@report_wkhsts.pks
@top_100_names.pks
@weekly_interface.pks
@weekly_interface_statuss.pks
@work_assignment_ts.pks
@work_ts.pks
@email_logs.pkb
@emails.pkb
@interface_statuss.pkb
@logical_assignment_ts.pkb
@logical_workplace_ts.pkb
@on_demand_process.pkb
@on_demand_process_logs.pkb
@physical_assignment_ts.pkb
@physical_workplace_ts.pkb
@polling_process.pkb
@polling_process_queues.pkb
@polling_process_statuss.pkb
@report_staging_table_logs.pkb
@report_staging_tables.pkb
@report_wkhsts.pkb
@top_100_names.pkb
@weekly_interface.pkb
@weekly_interface_statuss.pkb
@work_assignment_ts.pkb
@work_ts.pkb
@worker_ts.pkb
@worker_type_ts.pkb
@logical_workplace_t.ins
@logical_assignment_t.ins
@physical_workplace_t.ins
@physical_assignment_t.ins
@work_t.ins
@work_assignment_t.ins
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
