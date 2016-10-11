rem create_html_help.sql
rem by Don Bales on 12/15/2006
rem SQL*Plus script to create a SQL*Plus script to create html help for 
rem the current user.

set feedback off;
set linesize 1000;
set newpage  1;
set pagesize 0;
set trimspool on;
set serveroutput on size 1000000;

spool html_help.sql;

prompt rem html_help.sql
prompt rem by Don Bales on 12/15/2006
prompt rem Created by SQL*Plus script create_html_help.sql
prompt; 
prompt set feedback off;;
prompt set linesize 1000;;
prompt set newpage  1;;
prompt set pagesize 32767;;
prompt set trimspool on;;
prompt; 
select 'spool '||lower(name)||'.html;'||
  chr(10)||'execute HTML_HELP.create_help('''||name||''');'||
  chr(10)||'spool off;'||chr(10)
from   SYS.USER_SOURCE
where  type in ('PACKAGE', 'TYPE')
group by name
order by name;

prompt spool object_index.html;;
prompt execute HTML_HELP.create_index();;
prompt spool off;;
prompt;
prompt set feedback on;;
prompt set linesize 1000;;
prompt set newpage  1;;
prompt set pagesize 32767;;
prompt set trimspool on;;

spool off;

@html_help.sql
