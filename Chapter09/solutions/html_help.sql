rem html_help.sql
rem by Don Bales on 12/15/2006
rem Created by SQL*Plus script create_html_help.sql

set feedback off;
set linesize 1000;
set newpage  1;
set pagesize 32767;
set trimspool on;

spool dates.html;
execute HTML_HELP.create_help('DATES');
spool off;

spool debug_o.html;
execute HTML_HELP.create_help('DEBUG_O');
spool off;

spool debug_ots.html;
execute HTML_HELP.create_help('DEBUG_OTS');
spool off;

spool debug_ts.html;
execute HTML_HELP.create_help('DEBUG_TS');
spool off;

spool emails.html;
execute HTML_HELP.create_help('EMAILS');
spool off;

spool gender_o.html;
execute HTML_HELP.create_help('GENDER_O');
spool off;

spool gender_ts.html;
execute HTML_HELP.create_help('GENDER_TS');
spool off;

spool html_help.html;
execute HTML_HELP.create_help('HTML_HELP');
spool off;

spool logical_assignment_ts.html;
execute HTML_HELP.create_help('LOGICAL_ASSIGNMENT_TS');
spool off;

spool logical_workplace_ts.html;
execute HTML_HELP.create_help('LOGICAL_WORKPLACE_TS');
spool off;

spool numbers.html;
execute HTML_HELP.create_help('NUMBERS');
spool off;

spool on_demand_process.html;
execute HTML_HELP.create_help('ON_DEMAND_PROCESS');
spool off;

spool parameters.html;
execute HTML_HELP.create_help('PARAMETERS');
spool off;

spool physical_assignment_ts.html;
execute HTML_HELP.create_help('PHYSICAL_ASSIGNMENT_TS');
spool off;

spool physical_workplace_ts.html;
execute HTML_HELP.create_help('PHYSICAL_WORKPLACE_TS');
spool off;

spool polling_process.html;
execute HTML_HELP.create_help('POLLING_PROCESS');
spool off;

spool report_staging_tables.html;
execute HTML_HELP.create_help('REPORT_STAGING_TABLES');
spool off;

spool scopes.html;
execute HTML_HELP.create_help('SCOPES');
spool off;

spool sys_yoid0000060409$.html;
execute HTML_HELP.create_help('SYS_YOID0000060409$');
spool off;

spool sys_yoid0000060417$.html;
execute HTML_HELP.create_help('SYS_YOID0000060417$');
spool off;

spool test_o.html;
execute HTML_HELP.create_help('TEST_O');
spool off;

spool test_ts.html;
execute HTML_HELP.create_help('TEST_TS');
spool off;

spool text_help.html;
execute HTML_HELP.create_help('TEXT_HELP');
spool off;

spool top_100_names.html;
execute HTML_HELP.create_help('TOP_100_NAMES');
spool off;

spool varchar2s.html;
execute HTML_HELP.create_help('VARCHAR2S');
spool off;

spool weekly_interface.html;
execute HTML_HELP.create_help('WEEKLY_INTERFACE');
spool off;

spool weekly_interface_statuss.html;
execute HTML_HELP.create_help('WEEKLY_INTERFACE_STATUSS');
spool off;

spool worker_o.html;
execute HTML_HELP.create_help('WORKER_O');
spool off;

spool worker_ts.html;
execute HTML_HELP.create_help('WORKER_TS');
spool off;

spool worker_type_o.html;
execute HTML_HELP.create_help('WORKER_TYPE_O');
spool off;

spool worker_type_ts.html;
execute HTML_HELP.create_help('WORKER_TYPE_TS');
spool off;

spool workplace_type_ts.html;
execute HTML_HELP.create_help('WORKPLACE_TYPE_TS');
spool off;

spool work_assignment_ts.html;
execute HTML_HELP.create_help('WORK_ASSIGNMENT_TS');
spool off;

spool work_ts.html;
execute HTML_HELP.create_help('WORK_TS');
spool off;

spool object_index.html;
execute HTML_HELP.create_index();
spool off;

set feedback on;
set linesize 1000;
set newpage  1;
set pagesize 32767;
set trimspool on;
