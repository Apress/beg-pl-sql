rem debug_ot.sql
rem by Donald J. Bales on 12/15/2006
rem Query DEBUG_OT the specified unique session ID

define unique_session_id=&1;

select id,
       text
from   DEBUG_OT
where  unique_session_id = upper('&unique_session_id')
and    insert_date       > SYSDATE - (10/(24*60))
order by id;
