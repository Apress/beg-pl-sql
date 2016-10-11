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

select t.object_name||
       decode(substr(t.method_name, -1, 1), ')', '.', ' ')||
       t.method_name test,
       t.test_number t#,
       t.description,
       t.result
from   TEST_T t
where  t.unique_session_id = SYS.DBMS_SESSION.unique_session_id
and    t.object_name       = (
select e.object_name
from   TEST_T e
where  e.unique_session_id = SYS.DBMS_SESSION.unique_session_id
and    e.id                = (
select max(x.id)
from   TEST_T x
where  x.unique_session_id = SYS.DBMS_SESSION.unique_session_id))
order by t.test_id;

spool off;
