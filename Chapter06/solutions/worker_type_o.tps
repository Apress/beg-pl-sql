execute drop_if_exists('table','WORKER_TYPE_OT');
execute drop_if_exists('view','WORKER_TYPE_OV');
execute drop_if_exists('type','WORKER_TYPE_O');
create TYPE WORKER_TYPE_O as object (
/*
worker_type_o.tps
by Don Bales on 12/15/2006
Type WORKER_TYPE_O's attributes and methods.
*/
id                                    number,
code                                  varchar2(30),
description                           varchar2(80),
active_date                           date,
inactive_date                         date,
-- Gets the code and decription values for the specified work_type_id.
STATIC PROCEDURE get_code_descr(
ain_id                         in     number,
aov_code                          out varchar2,
aov_description                   out varchar2 ),
-- Verifies the passed aiov_code value is an exact or like match on the 
-- date specified.  
STATIC PROCEDURE get_code_id_descr(
aiov_code                      in out varchar2,
aon_id                            out number,
aov_description                   out varchar2,
aid_on                         in     date ),
-- Verifies the passed aiov_code value is currently an exact or like match.  
STATIC PROCEDURE get_code_id_descr(
aiov_code                      in out varchar2,
aon_id                            out number,
aov_description                   out varchar2 ),
-- Returns a newly allocated id value.
MEMBER FUNCTION get_id
return                                number,
-- Returns the id for the specified code value.
STATIC FUNCTION get_id(
aiv_code                       in     varchar2 ) 
return                                number,
-- Test-based help for this package.  "set serveroutput on" in SQL*Plus.
STATIC PROCEDURE help,
-- Test units for this package.  
STATIC PROCEDURE test,
-- A MAP function for sorting at the object level. 
MAP MEMBER FUNCTION to_varchar2
return                                varchar2,
-- A constructor for creating a new instance of type WORKER_TYPE_O 
-- with NULL values.
CONSTRUCTOR FUNCTION worker_type_o(
self                           in out worker_type_o)
return                                self as result,
-- A constructor for creating a new instance of type WORKER_TYPE_O
-- for insert.
CONSTRUCTOR FUNCTION worker_type_o(
self                           in out worker_type_o,
aiv_code                       in     varchar2,
aiv_description                in     varchar2)
return                                self as result
);
/
@se.sql WORKER_TYPE_O
