create or replace package body EMAIL_LOGS as
/*
email_logs.pkb
by Donald J. Bales on 12/15/2006
Table EMAIL_LOG's package
*/

FUNCTION get_id 
return                                EMAIL_LOG.id%TYPE is

n_id                                  EMAIL_LOG.id%TYPE;

begin
  select EMAIL_LOG_ID_SEQ.nextval
  into   n_id
  from   SYS.DUAL;
  
  return n_id;
end get_id;


PROCEDURE set_text(
aiv_text                       in     EMAIL_LOG.text%TYPE) is

pragma autonomous_transaction;

begin
  insert into EMAIL_LOG (
         id,
         text,
         unique_session_id )
  values (
         EMAIL_LOGS.get_id(),
         aiv_text,
         SYS.DBMS_SESSION.unique_session_id);
  commit;
end set_text;


end EMAIL_LOGS;
/
@be.sql EMAIL_LOGS;
