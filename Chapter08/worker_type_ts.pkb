create or replace PACKAGE BODY WORKER_TYPE_TS as
/*
worker_type_ts.pkb
by Don Bales on 12/15/2006
Table WORKER_TYPE_T's methods
*/


PROCEDURE get_code_descr(
ain_id                         in     WORKER_TYPE_T.id%TYPE,
aov_code                          out WORKER_TYPE_T.code%TYPE,
aov_description                   out WORKER_TYPE_T.description%TYPE ) is

begin
  select code,
         description
  into   aov_code,
         aov_description
  from   WORKER_TYPE_T       
  where  id = ain_id;
end get_code_descr;


PROCEDURE get_code_id_descr(
aiov_code                      in out WORKER_TYPE_T.code%TYPE,
aon_id                            out WORKER_TYPE_T.id%TYPE,
aov_description                   out WORKER_TYPE_T.description%TYPE,
aid_on                         in     WORKER_TYPE_T.active_date%TYPE ) is

v_code                                WORKER_TYPE_T.code%TYPE;

begin
  select id,
         description
  into   aon_id,
         aov_description
  from   WORKER_TYPE_T       
  where  code = aiov_code
  and    aid_on between active_date and nvl(inactive_date, DATES.d_MAX);
exception
  when NO_DATA_FOUND then
    select id,
           code,
           description
    into   aon_id,
           v_code,
           aov_description
    from   WORKER_TYPE_T
    where  code like aiov_code||'%'
    and    aid_on between active_date and nvl(inactive_date, DATES.d_MAX);

    aiov_code := v_code;
end get_code_id_descr;


PROCEDURE get_code_id_descr(
aiov_code                      in out WORKER_TYPE_T.code%TYPE,
aon_id                            out WORKER_TYPE_T.id%TYPE,
aov_description                   out WORKER_TYPE_T.description%TYPE ) is

begin
 get_code_id_descr(
  aiov_code,
  aon_id,
  aov_description,
  SYSDATE );
end get_code_id_descr;


FUNCTION get_id
return                                WORKER_TYPE_T.id%TYPE is

n_id                                  WORKER_TYPE_T.id%TYPE;

begin
  select WORKER_TYPE_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


FUNCTION get_id(
aiv_code                       in     WORKER_TYPE_T.code%TYPE ) 
return                                WORKER_TYPE_T.id%TYPE is

n_id                                  WORKER_TYPE_T.id%TYPE;

begin
  select id 
  into   n_id
  from   WORKER_TYPE_T
  where  code = aiv_code;
 
  return n_id;
end get_id;


PROCEDURE help is

begin
--   12345678901234567890123456789012345678901234567890123456789012345678901234567890 
 pl('=================================== PACKAGE ====================================');
 pl(chr(9));
 pl('WORKER_TYPE_TS');
 pl(chr(9));
 pl('----------------------------------- FUNCTIONS ----------------------------------');
 pl(chr(9));
 pl('WORKER_TYPE_TS.get_id');
 pl('return                                WORKER_TYPE_T.id%TYPE;');
 pl(chr(9)||'Returns a newly allocated sequence value for id.');
 pl(chr(9));
 pl('WORKER_TYPE_TS.get_id(');
 pl('aiv_code                       in     WORKER_TYPE_T.code%TYPE )');
 pl('return                                WORKER_TYPE_T.id%TYPE;');
 pl(chr(9)||'Returns the corresponding id for the specified code.');
 pl(chr(9));
 pl('----------------------------------- PROCEDURES ---------------------------------');
 pl(chr(9));
 pl('WORKER_TYPE_TS.get_code_descr(');
 pl('ain_id                         in     WORKER_TYPE_T.id%TYPE,');
 pl('aov_code                          out WORKER_TYPE_T.code%TYPE,');
 pl('aov_description                   out WORKER_TYPE_T.description%TYPE );');
 pl(chr(9)||'Gets the corresponding code and description for the specified');
 pl(chr(9)||'id.');
 pl(chr(9));
 pl('WORKER_TYPE_TS.get_code_id_descr(');
 pl('aiov_code                      in out WORKER_TYPE_T.code%TYPE,');
 pl('aon_id                            out WORKER_TYPE_T.id%TYPE,');
 pl('aov_description                   out WORKER_TYPE_T.description%TYPE,');
 pl('aid_on                         in     WORKER_TYPE_T.active_date%TYPE );');
 pl(chr(9)||'Gets the corresponding code, id, and description for');
 pl(chr(9)||'the specified code.  First it trys to find an exact match.  If one');
 pl(chr(9)||'cannot be found, it trys to find a like match.  It may throw a');
 pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
 pl(chr(9)||'found for the specified code and point in time.');
 pl(chr(9));
 pl('WORKER_TYPE_TS.get_code_id_descr(');
 pl('aiov_code                      in out WORKER_TYPE_T.code%TYPE,');
 pl('aon_id                            out WORKER_TYPE_T.id%TYPE,');
 pl('aov_description                   out WORKER_TYPE_T.description%TYPE );');
 pl(chr(9)||'Gets the corresponding code, id, and description for');
 pl(chr(9)||'the specified code.  First it trys to find an exact match.  If one');
 pl(chr(9)||'cannot be found, it trys to find a like match.  It may throw a');
 pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
 pl(chr(9)||'found for the specified code at the current point in time.');
 pl(chr(9));
 pl('WORKER_TYPE_TS.help( );');
 pl(chr(9)||'Displays this help text if set serveroutput is on.');
 pl(chr(9));
 pl('WORKER_TYPE_TS.test( );');
 pl(chr(9)||'Built-in test unit.  It will report success or error for each test if set');
 pl(chr(9)||'serveroutput is on.');
 pl(chr(9));
end help;


PROCEDURE test is

n_id                                  WORKER_TYPE_T.id%TYPE;
v_code                                WORKER_TYPE_T.code%TYPE;
v_description                         WORKER_TYPE_T.description%TYPE;

begin
  -- Send feedback that the test ran
  pl('WORKER_TYPE_TS.test()');
  
  -- Clear the last set of test results
  TEST_TS.clear('WORKER_TYPE_TS');
  
  -- First, we need some test values

  -- Let's make sure they don't already exist: DELETE
  TEST_TS.set_test('WORKER_TYPE_TS', 'DELETE', 0, 
    'Delete test entries');
  begin
    delete WORKER_TYPE_T
    where  code in (
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2);
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  -- Now let's add three test codes: INSERT
  TEST_TS.set_test('WORKER_TYPE_TS', 'INSERT', 1, 
    'Insert 3 test entries');
  begin
    insert into WORKER_TYPE_T (
           id,
           code,           
           description,    
           active_date,    
           inactive_date )  
    values (
           get_id(),
           TEST_TS.v_TEST_30,
           TEST_TS.v_TEST_80,
           TEST_TS.d_TEST_19000101,
           NULL );

    insert into WORKER_TYPE_T (
           id,
           code,           
           description,    
           active_date,    
           inactive_date )  
    values (
           get_id(),
           TEST_TS.v_TEST_30_1,
           TEST_TS.v_TEST_80,
           TEST_TS.d_TEST_19000101,
           TEST_TS.d_TEST_19991231 );

    insert into WORKER_TYPE_T (
           id,
           code,           
           description,    
           active_date,    
           inactive_date )  
    values (
           get_id(),
           TEST_TS.v_TEST_30_2,
           TEST_TS.v_TEST_80,
           TEST_TS.d_TEST_19000101,
           TEST_TS.d_TEST_19991231 );

    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  -- Now that we have test entries, 
  -- let's test the package methods
  TEST_TS.set_test('WORKER_TYPE_TS', 'get_id()', 2, 
    'Get the ID for the specified code');
  begin
    n_id := get_id(TEST_TS.v_TEST_30);
    
    if n_id > 0 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('WORKER_TYPE_TS', 'get_code_descr()', 3, 
    'Get the code and description for the specified ID');
  begin
    get_code_descr(
      n_id,
      v_code,
      v_description);
    if v_code        = TEST_TS.v_TEST_30 and
       v_description = TEST_TS.v_TEST_80 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('WORKER_TYPE_TS', 'get_code_id_descr()', 4, 
    'Get the code, ID, and description for the specified code');
  begin
    v_code := 'TEST';
    get_code_id_descr(
      v_code,
      n_id,
      v_description);
    if v_code           = TEST_TS.v_TEST_30 and
       n_id > 0                 and
       v_description    = TEST_TS.v_TEST_80 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('WORKER_TYPE_TS', 'get_code_id_descr()', 5, 
    'Get the code, ID, and description for the specified date');
  begin
    v_code := 'TEST';
    -- This test should raise a TOO_MANY_ROWS exception
    -- because at least three duplicate values will
    -- on the date specified
    get_code_id_descr(
      v_code,
      n_id,
      v_description,
      TEST_TS.d_TEST_19991231);
    if v_code           = TEST_TS.v_TEST_30 and
       n_id > 0                 and
       v_description    = TEST_TS.v_TEST_80 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when TOO_MANY_ROWS then
      TEST_TS.ok();
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('WORKER_TYPE_TS', 'help()', 6, 
    'Display help');
  begin
    help();
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;

  -- Let's make sure they don't already exist: DELETE
  TEST_TS.set_test('WORKER_TYPE_TS', 'DELETE', 7, 
    'Delete test entries');
  begin
    delete WORKER_TYPE_T
    where  code in (
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2);
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORKER_TYPE_TS', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end WORKER_TYPE_TS;
/
@be.sql WORKER_TYPE_TS
