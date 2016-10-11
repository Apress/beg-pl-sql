create or replace package POLLING_PROCESS_STATUSS as
/*
polling_process_statuss.pks
by Donald J. Bales on 12/15/2006
Table POLLING_PROCESS_STATUS's routines
*/


FUNCTION get_status 
return                                POLLING_PROCESS_STATUS.status%TYPE;


PROCEDURE set_status(
aiv_status                     in     POLLING_PROCESS_STATUS.status%TYPE);


end POLLING_PROCESS_STATUSS;
/
@se.sql POLLING_PROCESS_STATUSS
