create or replace package body POLLING_PROCESS_STATUSS as
/*
polling_process_statuss.pkb
by Donald J. Bales on 12/15/2006
Table POLLING_PROCESS_STATUS's routines
*/


FUNCTION get_status 
return                                
  POLLING_PROCESS_STATUS.status%TYPE is

v_status                              
  POLLING_PROCESS_STATUS.status%TYPE;

begin
  select status
  into   v_status
  from   POLLING_PROCESS_STATUS;
  
  return v_status;
exception
  when NO_DATA_FOUND then
    return 'UNKNOWN';
  when OTHERS then
    raise_application_error(-20001, SQLERRM||
      ' on select POLLING_PROCESS_STATUS'||
      ' in POLLING_PROCESS_STATUSS.get_status()');
end get_status;


PROCEDURE set_status(
aiv_status                     in     
  POLLING_PROCESS_STATUS.status%TYPE) is

pragma autonomous_transaction;

begin
  update POLLING_PROCESS_STATUS
  set    status      = aiv_status,
         update_user = USER,
         update_date = SYSDATE;
  
  if nvl(sql%rowcount, 0) = 0 then
    insert into POLLING_PROCESS_STATUS (
           status,
           update_user,
           update_date )
    values (
           aiv_status,
           USER,
           SYSDATE );
  end if;
  
  commit;
exception
  when OTHERS then
    raise_application_error(-20002, SQLERRM||
      ' on update or insert POLLING_PROCESS_STATUS'||
      ' in POLLING_PROCESS_STATUSS.set_status()');
end set_status;


end POLLING_PROCESS_STATUSS;
/
@be.sql POLLING_PROCESS_STATUSS
