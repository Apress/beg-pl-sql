rem data_length_histogram.sql
rem by Donald J. Bales on 12/15/2006
rem Create a histogram of VARCHAR2 data lengths in use

column data_type format a13;

set linesize  1000;
set newpage   1;
set pagesize  32767;
set trimspool on;

spool data_length_histogram.txt;

select column_name, 
       min(data_length) min,
       avg(data_length) avg,
       max(data_length) max,
       count(1) occurs
from   SYS.ALL_TAB_COLUMNS
where  owner = USER
and    data_type like 'VARCHAR%'
and    table_name not in (
       'AUTHOR',
       'AUTHOR_PUBLICATION',
       'A_THRU_Z',
       'DEBUG_OT',
       'DEBUG_T',
       'PLAN_TABLE',
       'PLSQL_PROFILER_RUNS',
       'PLSQL_PROFILER_UNITS',
       'PLSQL_PROFILER_DATA',
       'TOP_100_FIRST_NAME',
       'TOP_100_LAST_NAME' )
group by column_name
order by max(data_length),
       column_name
/

spool off;
