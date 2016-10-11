create or replace PACKAGE      WORKER_TS as
/*
worker_ts.pks
by Don Bales on 12/15/2006
Table WORKER_T's methods.
*/


-- Return the next ID sequence value

FUNCTION get_id
return                                WORKER_T.id%TYPE;


end WORKER_TS;
/
@se.sql WORKER_TS

