create or replace PACKAGE WORKER_TYPE_TS as
/*
worker_type_ts.pks
by Don Bales on 12/15/2006
Code Table WORKER_TYPE_T's methods.
*/


-- Returns the id for the specified code value.

FUNCTION get_id(
aiv_code                       in     WORKER_TYPE_T.code%TYPE ) 
return                                WORKER_TYPE_T.id%TYPE;


end WORKER_TYPE_TS;
/
@se.sql WORKER_TYPE_TS

