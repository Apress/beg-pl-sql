rem usi.sql
rem by Donald J. Bales on 12/15/2007
rem Show me my unique session ID

execute pl('unique_session_id='||SYS.DBMS_SESSION.unique_session_id);
