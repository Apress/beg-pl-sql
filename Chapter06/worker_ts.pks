create or replace PACKAGE      WORKER_TS as
/*
worker_ts.pks
by Don Bales on 12/15/2006
Table WORKER_T's methods.
*/

-- Keep track of the number of inserts and updates
n_inserted                            number := 0;
n_updated                             number := 0;


FUNCTION get_age(
aid_birth_date                 in     WORKER_T.birth_date%TYPE,
aid_on                         in     date)
return                                number;


FUNCTION get_age(
aid_birth_date                 in     WORKER_T.birth_date%TYPE)
return                                number;


FUNCTION get_age(
ain_id                         in     WORKER_T.id%TYPE,
aid_on                         in     date)
return                                number;


FUNCTION get_age(
ain_id                         in     WORKER_T.id%TYPE) 
return                                number;


FUNCTION get_birth_date(
ain_id                         in     WORKER_T.id%TYPE) 
return                                WORKER_T.birth_date%TYPE;


FUNCTION get_external_id            
return                                WORKER_T.external_id%TYPE;


FUNCTION get_id
return                                WORKER_T.id%TYPE;


FUNCTION get_id(
aiv_external_id                in     WORKER_T.external_id%TYPE) 
return                                WORKER_T.id%TYPE;


FUNCTION get_formatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE; 


FUNCTION get_formatted_name(
ain_id                         in     WORKER_T.id%TYPE) 
return                                WORKER_T.name%TYPE;


FUNCTION get_row(
air_worker                     in     WORKER_T%ROWTYPE)
return                                WORKER_T%ROWTYPE;  


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


/*
Test-based help for this package.  "set serveroutput on" in SQL*Plus.
*/
PROCEDURE help;


PROCEDURE set_row(
aior_worker                    in out WORKER_T%ROWTYPE);


PROCEDURE test;


end WORKER_TS;
/
@se.sql WORKER_TS

