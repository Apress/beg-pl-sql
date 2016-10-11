create or replace PACKAGE      WORKER_TS as
/*
worker_ts.pks
Copyright by Don Bales on 12/15/2006
Table WORKER_T's methods.
*/

-- Keep track of the number of inserts and updates
n_inserted                            number := 0;
n_updated                             number := 0;

-- Calculate age based on the specified birth data and day
FUNCTION get_age(
aid_birth_date                 in     WORKER_T.birth_date%TYPE,
aid_on                         in     date)
return                                number;

-- Calcualte age based on the specified birth date and today
FUNCTION get_age(
aid_birth_date                 in     WORKER_T.birth_date%TYPE)
return                                number;

-- Returns the age of the specified worker on the specified day
FUNCTION get_age(
ain_id                         in     WORKER_T.id%TYPE,
aid_on                         in     date)
return                                number;

-- Returns the age of the specified worker as of today
FUNCTION get_age(
ain_id                         in     WORKER_T.id%TYPE) 
return                                number;

-- Returns the specified worker's birth date
FUNCTION get_birth_date(
ain_id                         in     WORKER_T.id%TYPE) 
return                                WORKER_T.birth_date%TYPE;

-- Returns the next available external ID value from its sequence
FUNCTION get_external_id            
return                                WORKER_T.external_id%TYPE;

-- Returns the next available primar key ID value from its sequence
FUNCTION get_id
return                                WORKER_T.id%TYPE;

-- Returns the primary key ID value for the specified external ID value
FUNCTION get_id(
aiv_external_id                in     WORKER_T.external_id%TYPE) 
return                                WORKER_T.id%TYPE;

-- Returns a name properly formatted for the current locale
FUNCTION get_formatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE; 

-- Returns a name for the specified worker properly formatted for the current locale
FUNCTION get_formatted_name(
ain_id                         in     WORKER_T.id%TYPE) 
return                                WORKER_T.name%TYPE;

-- Returns a matching worker row
FUNCTION get_row(
air_worker                     in     WORKER_T%ROWTYPE)
return                                WORKER_T%ROWTYPE;  

-- Returns an unformmated name
FUNCTION get_unformatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE; 

-- Returns TRUE if the specified combination of name, birth_date and 
-- gender already exists in the database
FUNCTION is_duplicate(
aiv_name                       in     WORKER_T.name%TYPE,
aid_birth_date                 in     WORKER_T.birth_date%TYPE,
ain_gender_id                  in     WORKER_T.gender_id%TYPE)
return                                boolean;


-- Text-based help for this package.  "set serveroutput on" in SQL*Plus.
PROCEDURE help;

-- Insert or update the specified row into the database
PROCEDURE set_row(
aior_worker                    in out WORKER_T%ROWTYPE);

-- This package's test units
PROCEDURE test;


end WORKER_TS;
/
@se.sql WORKER_TS

