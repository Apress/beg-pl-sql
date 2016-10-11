execute drop_if_exists('table','WORKER_OT');
execute drop_if_exists('view','WORKER_OV');
execute drop_if_exists('type','WORKER_O');
create type WORKER_O as object (
/*
worker_o.tps
by Don Bales on 12/15/2006
Type WORKER_O's attributes and methods.
*/
id                                    number,
worker_type_id                        number,
external_id                           varchar2(30),
first_name                            varchar2(30),
middle_name                           varchar2(30),
last_name                             varchar2(30),
name                                  varchar2(100),
birth_date                            date,
gender_id                             number,
/*
Get the worker's current age.
*/
MEMBER FUNCTION get_age 
return                                number,
/*
Get the worker's age on the specified date.
*/
MEMBER FUNCTION get_age(
aid_on                                date)
return                                number,
/*
Calculate a worker's age for the given birth date
and point in time.
*/
STATIC FUNCTION get_age(
aid_birth_date                 in     date,
aid_on                         in     date)
return                                number,
/*
Calculate a worker's current age for the given bith date.
*/
STATIC FUNCTION get_age(
aid_birth_date                 in     date)
return                                number,
/*
Get the specified worker's age at the given point in time.
*/
STATIC FUNCTION get_age(
ain_id                         in     number,
aid_on                         in     date)
return                                number,
/*
Get the specified worker's current age.
*/
STATIC FUNCTION get_age(
ain_id                         in     number) 
return                                number,
/*
Get the specified worker's birth date.
*/
STATIC FUNCTION get_birth_date(
ain_id                         in     number) 
return                                date,
/*
Get the specified worker's external ID.
*/
STATIC FUNCTION get_external_id
return                                varchar2,
/*
Calculate the locale specific formatted name.
*/
STATIC FUNCTION get_formatted_name(
aiv_first_name                 in     varchar2,
aiv_middle_name                in     varchar2,
aiv_last_name                  in     varchar2)
return                                varchar2,
/*
Get the specified worker's formatted name.
*/
STATIC FUNCTION get_formatted_name(
ain_id                         in     number) 
return                                varchar2,
/*
Get the next primary key value for the table.
*/
STATIC FUNCTION get_id
return                                number,
/*
Get the specified worker's internal ID.
*/
STATIC FUNCTION get_id(
aiv_external_id                in     varchar2) 
return                                number,
/*
Get the specified worker's row object.
*/
STATIC FUNCTION get_row(
aio_worker                     in     WORKER_O)
return                                WORKER_O,
/*
Calculate the non-locale specific unformmated name.
*/
STATIC FUNCTION get_unformatted_name(
aiv_first_name                 in     varchar2,
aiv_middle_name                in     varchar2,
aiv_last_name                  in     varchar2)
return                                varchar2,
/*
Display the help text for this TYPE.
*/
MEMBER PROCEDURE help,
/*
Check to see if a worker with the same name, birth_date and 
gender already exists in the database.
*/
STATIC FUNCTION is_duplicate(
aiv_name                       in     varchar2,
aid_birth_date                 in     varchar2,
ain_gender_id                  in     varchar2)
return                                boolean,
/*
Set the specified worker's row object.
*/
STATIC PROCEDURE set_row(
aioo_worker                    in out WORKER_O),
/*
Execute the test unit for this TYPE.
*/
MEMBER PROCEDURE test,
/*
The MAP function for this TYPE.
*/
MAP MEMBER FUNCTION to_varchar2
return                                varchar2,
/*
A convenience constructor for this TYPE.
*/
CONSTRUCTOR FUNCTION worker_o(
self                           in out worker_o,
ain_worker_type_id             in     number,
aiv_first_name                 in     varchar2,
aiv_middle_name                in     varchar2,
aiv_last_name                  in     varchar2,
aid_birth_date                 in     date,
ain_gender_id                  in     number)
return                                self as result,
/* 
A NULL values constructor for this TYPE.
*/
CONSTRUCTOR FUNCTION worker_o(
self                           in out worker_o)
return                                self as result
);
/
@se.sql
