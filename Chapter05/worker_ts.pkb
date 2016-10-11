create or replace PACKAGE BODY WORKER_TS as
/*
worker_ts.pkb
by Don Bales on 12/15/2006
Table WORKER_T's methods
*/


-- FUNCTIONS

FUNCTION get_id
return                                WORKER_T.id%TYPE is

n_id                                  WORKER_T.id%TYPE;

begin
  select WORKER_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


end WORKER_TS;
/
@be.sql WORKER_TS
