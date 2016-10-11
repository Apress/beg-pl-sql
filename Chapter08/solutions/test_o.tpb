create or replace type body TEST_O as 
/*
test_o.tpb
by Donald J. Bales on 12/15/2006
A Type for logging test results
*/

STATIC PROCEDURE clear(
aiv_object_name                       varchar2) is

pragma autonomous_transaction;

begin
  delete TEST_OT
  where  object_name       = aiv_object_name
  and    unique_session_id = SYS.DBMS_SESSION.unique_session_id;
  
  commit;
end clear;


STATIC FUNCTION get_id
return                                number is

n_id                                  number;

begin
  select TEST_ID_SEQ.nextval
  into   n_id
  from   SYS.DUAL;
  
  return n_id;
end get_id;


STATIC FUNCTION get_test_19000101
return                                date is

begin
  return to_date('19000101', 'YYYYMMDD');
end get_test_19000101;


STATIC FUNCTION get_test_19991231
return                                date is

begin
  return to_date('19991231', 'YYYYMMDD');
end get_test_19991231;


STATIC FUNCTION get_test_n 
return                                varchar2 is

begin
  return 'N';
end get_test_n;


STATIC FUNCTION get_test_y 
return                                varchar2 is

begin
  return 'Y';
end get_test_y;


STATIC FUNCTION get_test_30 
return                                varchar2 is

begin
  return 'TEST TEST TEST TEST TEST TESTx';
end get_test_30;


STATIC FUNCTION get_test_30_1 
return                                varchar2 is

begin
  return 'TEST1 TEST1 TEST1 TEST1 TEST1x';
end get_test_30_1;


STATIC FUNCTION get_test_30_2 
return                                varchar2 is

begin
  return 'TEST2 TEST2 TEST2 TEST2 TEST2x';
end get_test_30_2;


STATIC FUNCTION get_test_80 
return                                varchar2 is

begin
  return 'Test Test Test Test Test Test Test Test '||  
         'Test Test Test Test Test Test Test Testx';
end get_test_80;


STATIC FUNCTION get_test_100 
return                                varchar2 is

begin
  return 'Test Test Test Test Test Test Test Test Test Test '||  
         'Test Test Test Test Test Test Test Test Test Testx';
end get_test_100;


STATIC FUNCTION get_test_2000 
return                                varchar2 is
--                 1         2         3         4         5
--        12345678901234567890123456789012345678901234567890
begin
  return 'Test Test Test Test Test Test Test Test Test Test '||  
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
end get_test_2000;


STATIC PROCEDURE help is
begin
  pl('You''re on your own buddy.');
end help;


MEMBER PROCEDURE error is

begin
  set_result('ERROR');
end error;


MEMBER PROCEDURE error(
aiv_result                     in     varchar2) is

begin
  set_result(aiv_result);
end error;


MEMBER PROCEDURE ok is

begin
  set_result('OK');
end ok;

  
MEMBER PROCEDURE set_result(
aiv_result                     in     varchar2) is

pragma autonomous_transaction;

begin
  result := aiv_result;
  
  update TEST_OT
  set    result = self.result
  where  id     = self.id;
  
  if nvl(sql%rowcount, 0) = 0 then
    raise_application_error(-20000, 'Can''t find test'||
      to_char(self.id)||
      ' on update TEST'||
      ' in TEST_TS.test');
  end if;
  
  self := new test_o();

  commit;
end set_result;


MEMBER PROCEDURE set_test(
aiv_object_name                in     varchar2,
aiv_method_name                in     varchar2,
ain_test_number                in     number,
aiv_description                in     varchar2) is

pragma autonomous_transaction;

begin
  self.id                := TEST_O.get_id();
  self.object_name       := upper(aiv_object_name);
  self.method_name       := upper(aiv_method_name);
  self.test_number       := ain_test_number;
  self.description       := aiv_description;
  self.result            := NULL;
  self.unique_session_id := SYS.DBMS_SESSION.unique_session_id;
  self.insert_user       := USER;
  self.insert_date       := SYSDATE;
  
  begin
    insert into TEST_OT values (self);
  exception
    when OTHERS then
      raise_application_error(-20000, SQLERRM||
        ' on insert TEST_OT'||
        ' in TEST_O.set_test');
  end;
  commit;
end set_test;


MEMBER PROCEDURE success is

begin
  set_result('SUCCESS');
end success;

  
STATIC PROCEDURE test is

n_number                              number;
o_test                                TEST_O;

begin
  pl('TEST_O.test()');

  -- A defect requires the schema owner
  &_USER..TEST_O.clear('TEST_O');

  o_test := new TEST_O();
  o_test.set_test('TEST_O', NULL, 1, 
    'Is get_test_N equal to N?');
  if TEST_O.get_test_N = 'N' then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 2, 
    'Is the length of get_test_N equal to 1?');
  if nvl(length(TEST_O.get_test_N), 0) = 1 then
    o_test.success();
  else
    o_test.error();
  end if;

  o_test.set_test('TEST_O', NULL, 3, 
    'Is get_test_Y equal to Y?');
  if TEST_O.get_test_Y = 'Y' then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 4, 
    'Is the length of get_test_Y equal to 1?');
  if nvl(length(TEST_O.get_test_Y), 0) = 1 then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 5, 
    'Is the length of get_test_30 equal to 30?');
  if nvl(length(TEST_O.get_test_30), 0) = 30 then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 6, 
    'Is the length of get_test_30_1 equal to 30?');
  if nvl(length(TEST_O.get_test_30_1), 0) = 30 then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 7, 
    'Is the length of get_test_30_2 equal to 30?');
  if nvl(length(TEST_O.get_test_30_2), 0) = 30 then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 8, 
    'Is the length of get_test_80 equal to 80?');
  if nvl(length(TEST_O.get_test_80), 0) = 80 then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 9, 
    'Is the length of get_test_100 equal to 100?');
  if nvl(length(TEST_O.get_test_100), 0) = 100 then
    o_test.success();
  else
    o_test.error();
  end if;
    
  o_test.set_test('TEST_O', NULL, 10, 
    'Is the length of get_test_2000 equal to 2000?');
  if nvl(length(TEST_O.get_test_2000), 0) = 2000 then
    o_test.success();
  else
    o_test.error();
  end if;

  o_test.set_test('TEST_O', 'get_id', 11, 
    'Does get_id() work?');
  begin
    n_number := TEST_O.get_id();
    if n_number > 0 then
      o_test.success();
    else
      o_test.error();
    end if;
  exception
    when OTHERS then
      o_test.error(SQLERRM);
  end;

  o_test.set_test('TEST_O', 'help', 12, 
    'Does help() work?');
  begin
    &_USER..TEST_O.help();
    raise_application_error(-20999, 'Testing the error routine');
    o_test.success();
  exception
    when OTHERS then
      o_test.error(SQLERRM);
  end;

  o_test.set_test('TEST_O', NULL, NULL, NULL);
  o_test.success();
end test;


MAP MEMBER FUNCTION to_map
return                                number is

begin
  return self.id;
end to_map;


CONSTRUCTOR FUNCTION test_o(
self                           in out nocopy test_o)
return                                self as result is

begin
  self.id                := NULL;
  self.object_name       := NULL;
  self.method_name       := NULL;
  self.test_number       := NULL;
  self.description       := NULL;
  self.result            := NULL;
  self.unique_session_id := NULL;
  self.insert_user       := NULL;
  self.insert_date       := NULL;

  return;
end test_o;


CONSTRUCTOR FUNCTION test_o(
self                           in out nocopy test_o,
ain_id                         in     number,
aiv_object_name                in     varchar2,
aiv_method_name                in     varchar2,
ain_test_number                in     number,
aiv_description                in     varchar2)
return                                self as result is

begin
  self.id                := ain_id;
  self.object_name       := aiv_object_name;
  self.method_name       := aiv_method_name;
  self.test_number       := ain_test_number;
  self.description       := aiv_description;
  self.result            := NULL;
  self.unique_session_id := SYS.DBMS_SESSION.unique_session_id;
  self.insert_user       := USER;
  self.insert_date       := SYSDATE;

  return;
end test_o;


end;
/
@be.sql TEST_O
