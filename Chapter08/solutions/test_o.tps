execute drop_if_exists('TABLE','TEST_OT');
execute drop_if_exists('VIEW','TEST_OV');
execute drop_if_exists('TYPE','TEST_O');
create type TEST_O as object (
/*
test_o.tps
by Donald J. Bales on 12/15/2006
A Type for logging test results
*/
-- Type TEST_O's attributes
id                                    number,
object_name                           varchar2(30),
method_name                           varchar2(30),
test_number                           number,
description                           varchar2(80),
result                                varchar2(256),
unique_session_id                     varchar2(24),
insert_user                           varchar2(30),
insert_date                           date,

-- Allocate the next primary key value fir id
STATIC FUNCTION get_id
return                                number,

-- Get the test value for January 1, 1900
STATIC FUNCTION get_test_19000101
return                                date,

-- Get the test value for December 31, 1999
STATIC FUNCTION get_test_19991231
return                                date,

-- Get the test value N for any indicators
STATIC FUNCTION get_test_n
return                                varchar2,

-- Get the test value Y for any indicators
STATIC FUNCTION get_test_y 
return                                varchar2,

-- Get the 30 character test value
STATIC FUNCTION get_test_30
return                                varchar2,

-- Get the first 30 character test value duplicate for LIKE
STATIC FUNCTION get_test_30_1
return                                varchar2,

-- Get the second 30 character test value duplicate for LIKE
STATIC FUNCTION get_test_30_2
return                                varchar2,

-- Get the 80 character test value
STATIC FUNCTION get_test_80
return                                varchar2,

-- Get the 100 character test value
STATIC FUNCTION get_test_100
return                                varchar2,

-- Get the 2000 character test value
STATIC FUNCTION get_test_2000
return                                varchar2,

-- Clear any previous test run for the specified object name
STATIC PROCEDURE clear(
aiv_object_name                       varchar2),

-- Set the result to ERROR
MEMBER PROCEDURE error,

-- Set the result to Oracle ERROR
MEMBER PROCEDURE error(
aiv_result                     in     varchar2),

-- Set the result to the specified result value
MEMBER PROCEDURE set_result(
aiv_result                     in     varchar2),

-- Show the help text for this object
STATIC PROCEDURE help,

-- Set the result to OK
MEMBER PROCEDURE ok,

-- Set the result of the execution of test() to SUCCESS
MEMBER PROCEDURE success,

-- Test this object
STATIC PROCEDURE test,

-- Set the test about to be performed
MEMBER PROCEDURE set_test(
aiv_object_name                in     varchar2,
aiv_method_name                in     varchar2,
ain_test_number                in     number,
aiv_description                in     varchar2),

-- Get the map value
MAP MEMBER FUNCTION to_map
return                                number,

-- Parameter-less constructor
CONSTRUCTOR FUNCTION test_o(
self                           in out nocopy test_o)
return                         self as result,

-- Convenience constructor
CONSTRUCTOR FUNCTION test_o(
self                           in out nocopy test_o,
ain_id                         in     number,
aiv_object_name                in     varchar2,
aiv_method_name                in     varchar2,
ain_test_number                in     number,
aiv_description                in     varchar2)
return                                self as result
);
/
@se.sql

grant execute on TEST_O to public;
