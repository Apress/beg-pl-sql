create or replace PACKAGE BODY WORKER_TYPE_TS as
/*
worker_type_ts.pkb
by Don Bales on 12/15/2006
Table WORKER_TYPE_T's methods
*/


-- FUNCTIONS

FUNCTION get_id(
aiv_code                       in     WORKER_TYPE_T.code%TYPE ) 
return                                WORKER_TYPE_T.id%TYPE is

n_id                                  WORKER_TYPE_T.id%TYPE;

begin
  select id 
  into   n_id
  from   WORKER_TYPE_T
  where  code = aiv_code;
 
  return n_id;
end get_id;


end WORKER_TYPE_TS;
/
@be.sql WORKER_TYPE_TS

