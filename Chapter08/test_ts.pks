create or replace package TEST_TS as 
/*
test_ts.pks
by Donald J. Bales on 12/15/2006
A Testing package
*/

-- Result constants
v_TEST_ERROR                constant  varchar2(5) := 'ERROR';
v_TEST_OK                   constant  varchar2(2) := 'OK';
v_TEST_SUCCESS              constant  varchar2(7) := 'SUCCESS';

-- Testing constants
d_TEST_19000101             constant  date        := 
  to_date('19000101', 'YYYYMMDD');
d_TEST_19991231             constant  date        := 
  to_date('19000101', 'YYYYMMDD');
  
v_TEST_N                    constant  varchar2(1) := 'N';

v_TEST_Y                    constant  varchar2(1) := 'Y';

v_TEST_30                   constant  varchar2(30) := 
  'TEST TEST TEST TEST TEST TESTx';

v_TEST_30_1                 constant  varchar2(30) := 
  'TEST1 TEST1 TEST1 TEST1 TEST1x';

v_TEST_30_2                 constant  varchar2(30) := 
  'TEST2 TEST2 TEST2 TEST2 TEST2x';

v_TEST_80                   constant  varchar2(80) :=  
  'Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Testx';

v_TEST_100                  constant  varchar2(100) :=  
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Testx';
  
v_TEST_2000                 constant  varchar2(2000) :=  
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Test '||
  'Test Test Test Test Test Test Test Test Test Test '||  
  'Test Test Test Test Test Test Test Test Test Testx';
  
--          1         2         3         4         5
-- 12345678901234567890123456789012345678901234567890

-- Clear the results of the last test
PROCEDURE clear(
aiv_object_name                       TEST_T.object_name%TYPE);


-- Set the result of the last test to v_TEST_ERROR
PROCEDURE error;


-- Set the result of the last test to the passed Oracle error
PROCEDURE error(
aiv_result                     in     TEST_T.result%TYPE);


-- Display help text
PROCEDURE help;


-- Instantiate the package
PROCEDURE initialize;


-- Set the result of the last test to v_TEST_OK
PROCEDURE ok;


-- Update the test with it's results
PROCEDURE set_result(
aiv_result                     in     TEST_T.result%TYPE);


-- Add a test
PROCEDURE set_test(
aiv_object_name                in     TEST_T.object_name%TYPE,
aiv_method_name                in     TEST_T.method_name%TYPE,
ain_test_number                in     TEST_T.test_number%TYPE,
aiv_description                in     TEST_T.description%TYPE);


-- Set the result of the last test to v_TEST_SUCCESS
PROCEDURE success;


-- Test unit
PROCEDURE test;


end TEST_TS;
/
@se.sql TEST_TS
