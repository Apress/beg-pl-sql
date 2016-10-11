create or replace PACKAGE WORKER_TYPE_TS as
/*
worker_type_ts.pks
by Don Bales on 12/15/2006
Code Table WORKER_TYPE_T's methods.
*/


-- Gets the code and decription values for the specified work_type_id.

PROCEDURE get_code_descr(
ain_id                         in     WORKER_TYPE_T.id%TYPE,
aov_code                          out WORKER_TYPE_T.code%TYPE,
aov_description                   out WORKER_TYPE_T.description%TYPE );


-- Verifies the passed aiov_code value is an exact or like match on the date specified.  

PROCEDURE get_code_id_descr(
aiov_code                      in out WORKER_TYPE_T.code%TYPE,
aon_id                            out WORKER_TYPE_T.id%TYPE,
aov_description                   out WORKER_TYPE_T.description%TYPE,
aid_on                         in     WORKER_TYPE_T.active_date%TYPE );


-- Verifies the passed aiov_code value is currently an exact or like match.  

PROCEDURE get_code_id_descr(
aiov_code                      in out WORKER_TYPE_T.code%TYPE,
aon_id                            out WORKER_TYPE_T.id%TYPE,
aov_description                   out WORKER_TYPE_T.description%TYPE );


-- Returns a newly allocated id value.

FUNCTION get_id
return                                WORKER_TYPE_T.id%TYPE;


-- Returns the id for the specified code value.

FUNCTION get_id(
aiv_code                       in     WORKER_TYPE_T.code%TYPE ) 
return                                WORKER_TYPE_T.id%TYPE;



-- Test-based help for this package.  "set serveroutput on" in SQL*Plus.

PROCEDURE help;


-- Test units for this package.  

PROCEDURE test;


end WORKER_TYPE_TS;
/
@se.sql WORKER_TYPE_TS

