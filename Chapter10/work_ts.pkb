create or replace PACKAGE BODY WORK_TS as
/*
work_ts.pkb
by Donald J. Bales on 12/15/2006
Table WORK_T's methods
*/


FUNCTION get_id
return                                WORK_T.id%TYPE is

n_id                                  WORK_T.id%TYPE;

begin
  select WORK_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


FUNCTION get_row(
air_work                       in     WORK_T%ROWTYPE)
return                                WORK_T%ROWTYPE is

r_work                                WORK_T%ROWTYPE;

begin
  if    air_work.id is not NULL then
    --pl('retrieve the row by the primary key');
    select *
    into   r_work
    from   WORK_T
    where  id = air_work.id;
  else
    --pl('retrieve the row by the code, name, and active_date');
    select *
    into   r_work
    from   WORK_T
    where  code        = air_work.code
    and    name        = air_work.name
    and    active_date = air_work.active_date;
  end if;  
  return r_work;
exception
  when NO_DATA_FOUND then
    raise;
  when OTHERS then
    raise_application_error(-20001, SQLERRM||
      ' on select WORK_T'||
      ' in WORK_TS.get_row()');
end get_row;  


PROCEDURE inactivate(
ain_id                         in     WORK_T.id%TYPE,
aid_inactive_date              in     WORK_T.inactive_date%TYPE) is

begin
  update WORK_T
  set    inactive_date = aid_inactive_date
  where  id       = ain_id;
end inactivate;
  

FUNCTION is_duplicate(
aiv_code                       in     WORK_T.code%TYPE,
aiv_name                       in     WORK_T.name%TYPE,
aid_active_date                in     WORK_T.active_date%TYPE)
return                                boolean is

n_count                               number;

begin
  --pl('retrieve the row by the code, name, and active_date');
  select count(1)
  into   n_count
  from   WORK_T
  where  code               = aiv_code
  and    name               = aiv_name
  and    trunc(active_date) = trunc(aid_active_date);

  if nvl(n_count, 0) > 0 then
    return TRUE;
  else
    return FALSE;
  end if;  
end is_duplicate;


PROCEDURE help is

begin
  TEXT_HELP.process('WORK_TS');
end help;


PROCEDURE set_row(
aior_work                      in out WORK_T%ROWTYPE) is

d_null                       constant date        := DATES.d_MIN;
n_null                       constant number      := 0;
v_null                       constant varchar2(1) := ' ';
r_work                                WORK_T%ROWTYPE;

begin
  -- get the existing row
  begin
    r_work := get_row(aior_work);
  exception
    when NO_DATA_FOUND then
      r_work := NULL;
  end;
  -- if a row exists, update it if needed
  if r_work.id is not NULL then
    aior_work.id := r_work.id;
    if nvl(r_work.code,          v_null) <> nvl(aior_work.code,          v_null) or
       nvl(r_work.name,          v_null) <> nvl(aior_work.name,          v_null) or
       nvl(r_work.active_date,   d_null) <> nvl(aior_work.active_date,   d_null) or
       nvl(r_work.inactive_date, d_null) <> nvl(aior_work.inactive_date, d_null) then
      begin
        update WORK_T
        set    code          = aior_work.code,
               name          = aior_work.name,
               active_date   = aior_work.active_date,
               inactive_date = aior_work.inactive_date
        where  id       = aior_work.id;

        n_updated := nvl(n_updated, 0) + nvl(sql%rowcount, 0);
      exception
        when OTHERS then
          raise_application_error( -20002, SQLERRM||
            ' on update WORK_T'||
            ' in WORK_TS.set_row()' );
      end;
    end if;
  else
  -- add the row if it does not exist
    begin
      if aior_work.id is NULL then
        aior_work.id := get_id();
      end if;
      insert into WORK_T (
             id,
             code,
             name,
             active_date,
             inactive_date )
      values (
             aior_work.id,
             aior_work.code,
             aior_work.name,
             aior_work.active_date,
             aior_work.inactive_date );

      n_inserted := nvl(n_inserted, 0) + nvl(sql%rowcount, 0);
    exception
      when OTHERS then
        raise_application_error( -20003, SQLERRM||
          ' on insert WORK_T'||
          ' in WORK_TS.set_row()' );
    end;
  end if;
end set_row;


PROCEDURE set_row(
aiv_code                       in     WORK_T.code%TYPE,
aiv_name                       in     WORK_T.name%TYPE,
aid_active_date                in     WORK_T.active_date%TYPE,
aid_inactive_date              in     WORK_T.inactive_date%TYPE) is

r_work                                WORK_T%ROWTYPE;

begin
  r_work.id            := NULL;
  r_work.code          := aiv_code;
  r_work.name          := aiv_name;
  r_work.active_date   := aid_active_date;
  r_work.inactive_date := aid_inactive_date;
  
  set_row(r_work);
end set_row;


PROCEDURE test is

r_work                                WORK_T%ROWTYPE;

begin
  pl('WORK_TS.test()');

  TEST_TS.clear('WORK_TS');
  
  TEST_TS.set_test('WORK_TS', 'DELETE', 0, 
    'Delete existing test entries');
  begin
    delete WORK_T
    where  code in (
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2);

    delete WORK_T
    where  code = TEST_TS.v_TEST_30;
      
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'get_id()', 1, 
    'Allocate the next primary key value');
  begin
    r_work.id       := get_id();
    
    if r_work.id > 0 then    
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'set_row()', 2, 
    'Insert a test entry');
  begin
    r_work.code          := TEST_TS.v_TEST_30;
    r_work.name          := TEST_TS.v_TEST_80;
    r_work.active_date   := TEST_TS.d_TEST_19000101;
    r_work.inactive_date := NULL;

    set_row(r_work);    
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'set_row()', 3, 
    'Insert addistional entries');
  begin
    r_work.id       := get_id();
    r_work.code          := TEST_TS.v_TEST_30_1;
    r_work.name          := TEST_TS.v_TEST_80;

    set_row(r_work);
    
    r_work.id       := get_id();
    r_work.code          := TEST_TS.v_TEST_30_2;

    set_row(r_work);
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'get_row()', 4, 
    'Get the row using the id for v_TEST_30_2');
  begin
--    r_work.id       := NULL;
    r_work.code          := NULL;
    r_work.name          := NULL;
    r_work.active_date   := NULL;
    r_work.inactive_date := NULL;

    r_work := get_row(r_work);

    if r_work.code is not NULL then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'get_row()', 5, 
    'Get the row using the code for v_TEST_30');
  begin
    r_work.id       := NULL;
    r_work.code          := TEST_TS.v_TEST_30;
    r_work.name          := TEST_TS.v_TEST_80;
    r_work.active_date   := TEST_TS.d_TEST_19000101;
    r_work.inactive_date := NULL;

    r_work := get_row(r_work);

    if r_work.id is not NULL then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'help()', 6, 
    'Display the help text');
  begin
    help();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'is_duplicate()', 7, 
    'Is this a duplicate?  It should be!');
  begin
    if is_duplicate(
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_80,
      TEST_TS.d_TEST_19000101) then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('WORK_TS', 'DELETE', 8, 
    'Delete test entries');
  begin
    delete WORK_T
    where  code in (
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2);

    delete WORK_T
    where  code = TEST_TS.v_TEST_30;
      
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  commit;
  TEST_TS.set_test('WORK_TS', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end WORK_TS;
/
@be.sql WORK_TS
