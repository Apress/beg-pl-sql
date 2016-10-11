create or replace PACKAGE WORKPLACE_TYPE_TS as
/*
workplace_type_ts.pks
by Donald J. Bales on 12/15/2006
Table WORKPLACE_TYPE_T's methods.
*/

/*
Gets the code and decription values for the specified id.
*/
PROCEDURE get_code_descr(
ain_id                         in     WORKPLACE_TYPE_T.id%TYPE,
aov_code                          out WORKPLACE_TYPE_T.code%TYPE,
aov_description                   out WORKPLACE_TYPE_T.description%TYPE);

/*
Verifies that the passed code value is an exact or like match on the date specified.  
*/
PROCEDURE get_code_id_descr(
aiov_code                      in out WORKPLACE_TYPE_T.code%TYPE,
aon_id                            out WORKPLACE_TYPE_T.id%TYPE,
aov_description                   out WORKPLACE_TYPE_T.description%TYPE,
aid_on                         in     WORKPLACE_TYPE_T.active_date%TYPE);

/*
Verifies that the passed code value is currently an exact or like match.  
*/
PROCEDURE get_code_id_descr(
aiov_code                      in out WORKPLACE_TYPE_T.code%TYPE,
aon_id                            out WORKPLACE_TYPE_T.id%TYPE,
aov_description                   out WORKPLACE_TYPE_T.description%TYPE);

/*
Returns a new primary key id value for a row.
*/
FUNCTION get_id
return                                WORKPLACE_TYPE_T.id%TYPE;

/*
Returns the id for the specified code value.
*/
FUNCTION get_id(
aiv_code                       in     WORKPLACE_TYPE_T.code%TYPE) 
return                                WORKPLACE_TYPE_T.id%TYPE;

/*
Test-based help for this package.  "set serveroutput on" in SQL*Plus.
*/
PROCEDURE help;

/*
Test units for this package.  
*/
PROCEDURE test;


end WORKPLACE_TYPE_TS;
/
@se.sql WORKPLACE_TYPE_TS
