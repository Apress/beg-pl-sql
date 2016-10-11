connect sys as sysdba;
create user bps identified by bps;
alter  user bps default tablespace users temporary tablespace temp;
grant all privileges to bps;
grant execute on SYS.DBMS_LOCK to BPS;
set feedback  off;
set linesize  1000;
set newpage   0;
set pagesize  32767;
set trimspool on;
spool create_user.sub
select 'grant select on '||view_name||' to bps;'
from  SYS.DBA_VIEWS
where owner = 'SYS'
and   view_name like 'DBA\_%' escape '\'
order by 1;
select 'grant select on '||view_name||' to bps;'
from  SYS.DBA_VIEWS
where owner = 'SYS'
and   view_name like 'V\_$%' escape '\'
order by 1;
spool off;
set feedback  on;
set linesize  1000;
set newpage   1;
set pagesize  32767;
set trimspool on;
spool create_user_sub.txt;
@create_user.sub
spool off;
