rem last_test_results.sql
rem by Donald J. Bales on 12/15/2006
rem Display the last test results

set linesize 1000;
set newpage  1;
set pagesize 32767;
set trimspool on;

column test         format a34;
column t#           format 99;
column description  format a27;
column result       format a7;

spool last_test_results.txt;

select object_name||
       decode(substr(method_name, -1, 1), ')', '.', ' ')||
       method_name test,
       test_number t#,
       description,
       result
from   TEST_T
where  unique_session_id = SYS.DBMS_SESSION.unique_session_id
and    object_name       = (
select object_name
from   TEST_T
where  unique_session_id = SYS.DBMS_SESSION.unique_session_id
and    test_id           = (
select max(test_id)
from   TEST_T
where  unique_session_id = SYS.DBMS_SESSION.unique_session_id))
order by test_id;

spool off;
