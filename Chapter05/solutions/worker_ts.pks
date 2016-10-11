create or replace PACKAGE WORKER_TS as
/*
worker_ts.pks
by Don Bales on 12/15/2006
Table WORKER_T's methods
*/


FUNCTION get_external_id
return                                WORKER_T.external_id%TYPE;


FUNCTION get_id
return                                WORKER_T.id%TYPE;


FUNCTION get_formatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE; 


FUNCTION get_unformatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE; 


FUNCTION is_duplicate(
aiv_name                       in     WORKER_T.name%TYPE,
aid_birth_date                 in     WORKER_T.birth_date%TYPE,
ain_gender_id                  in     WORKER_T.gender_id%TYPE)
return                                boolean;


end WORKER_TS;
/
@se.sql WORKER_TS

