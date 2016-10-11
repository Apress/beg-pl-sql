create or replace PACKAGE BODY LOGICAL_ASSIGNMENT_TS as
/*
logical_assignment_ts.pkb
by Donald J. Bales on 12/15/2006
Table LOGICAL_ASSIGNMENT_T's methods
*/


FUNCTION get_id
return                                LOGICAL_ASSIGNMENT_T.id%TYPE is

n_id                                  LOGICAL_ASSIGNMENT_T.id%TYPE;

begin
  select LOGICAL_ASSIGNMENT_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


FUNCTION get_logical_workplace(
ain_worker_id                  in     LOGICAL_ASSIGNMENT_T.worker_id%TYPE,
aid_on                         in     LOGICAL_ASSIGNMENT_T.active_date%TYPE)
return                                LOGICAL_WORKPLACE_T%ROWTYPE is

r_logical_workplace                   LOGICAL_WORKPLACE_T%ROWTYPE;

begin
  select *
  into   r_logical_workplace
  from   LOGICAL_WORKPLACE_T
  where  id = (
  select logical_workplace_id
  from   LOGICAL_ASSIGNMENT_T
  where  worker_id = ain_worker_id
  and    aid_on between active_date and nvl(inactive_date, DATES.d_MAX) );
  
  return r_logical_workplace;
end get_logical_workplace;


FUNCTION get_logical_workplace(
ain_worker_id                  in     LOGICAL_ASSIGNMENT_T.worker_id%TYPE)
return                                LOGICAL_WORKPLACE_T%ROWTYPE is

begin
  return get_logical_workplace(ain_worker_id, SYSDATE);
end get_logical_workplace;


FUNCTION get_row(
air_logical_assignment         in     LOGICAL_ASSIGNMENT_T%ROWTYPE)
return                                LOGICAL_ASSIGNMENT_T%ROWTYPE is

r_logical_assignment                  LOGICAL_ASSIGNMENT_T%ROWTYPE;

begin
  if    air_logical_assignment.id is not NULL then
    -- retrieve the row by the primary key
    select *
    into   r_logical_assignment
    from   LOGICAL_ASSIGNMENT_T
    where  id = air_logical_assignment.id;
  else
    -- retrieve the row by the worker_id and active_date
    select *
    into   r_logical_assignment
    from   LOGICAL_ASSIGNMENT_T
    where  worker_id   = air_logical_assignment.worker_id
    and    active_date = air_logical_assignment.active_date;
  end if;  
  return r_logical_assignment;
exception
  when NO_DATA_FOUND then
    raise;
  when OTHERS then
    raise_application_error(-20001, SQLERRM||
      ' on select LOGICAL_ASSIGNMENT_T'||
      ' in LOGICAL_ASSIGNMENT_TS.get_row()');
end get_row;  


PROCEDURE help is

begin
  pl('No help yet!');
end help;


FUNCTION is_active(
ain_worker_id                  in     LOGICAL_ASSIGNMENT_T.worker_id%TYPE,
aid_on                         in     date)
return                                boolean is

pragma AUTONOMOUS_TRANSACTION;

n_count                               number;

begin
 select count(1)
 into   n_count
 from   LOGICAL_ASSIGNMENT_T
 where  worker_id       = ain_worker_id
 and    aid_on    between active_date 
                      and nvl(inactive_date, DATES.d_MAX);

 if nvl(n_count,0) > 0 then
  return TRUE;
 else
  return FALSE;
 end if;

 commit;
end is_active;


FUNCTION is_active(
ain_worker_id                  in     LOGICAL_ASSIGNMENT_T.worker_id%TYPE)
return                                boolean is

begin
 return is_active(ain_worker_id, SYSDATE);
end is_active;


PROCEDURE set_row(
aior_logical_assignment        in out LOGICAL_ASSIGNMENT_T%ROWTYPE) is

d_null                       constant date        := DATES.d_MIN;
n_null                       constant number      := 0;
v_null                       constant varchar2(1) := ' ';
r_logical_assignment                  LOGICAL_ASSIGNMENT_T%ROWTYPE;

begin
  -- get the existing row
  begin
    r_logical_assignment := get_row(aior_logical_assignment);
  exception
    when NO_DATA_FOUND then
      r_logical_assignment := NULL;
  end;
  -- if a row exists, update it if needed
  if r_logical_assignment.id is not NULL then
    aior_logical_assignment.id := r_logical_assignment.id;
    aior_logical_assignment.worker_id             := r_logical_assignment.worker_id;
    aior_logical_assignment.active_date           := r_logical_assignment.active_date;
    if nvl(r_logical_assignment.logical_workplace_id, n_null) <> nvl(aior_logical_assignment.logical_workplace_id, n_null) or
       nvl(r_logical_assignment.inactive_date,        d_null) <> nvl(aior_logical_assignment.inactive_date,        d_null) then
      begin
        update LOGICAL_ASSIGNMENT_T
        set    logical_workplace_id  = aior_logical_assignment.logical_workplace_id,
               inactive_date         = aior_logical_assignment.inactive_date
        where  id = aior_logical_assignment.id;

        n_updated := nvl(n_updated, 0) + nvl(sql%rowcount, 0);
      exception
        when OTHERS then
          raise_application_error( -20002, SQLERRM||
            ' on update LOGICAL_ASSIGNMENT_T'||
            ' in LOGICAL_ASSIGNMENT_TS.set_row()' );
      end;
    end if;
  else
  -- add the row if it does not exist
    begin
      if aior_logical_assignment.id is NULL then
        aior_logical_assignment.id := get_id();
      end if;
      insert into LOGICAL_ASSIGNMENT_T (
             id,
             worker_id,
             logical_workplace_id,
             active_date,
             inactive_date )
      values (
             aior_logical_assignment.id,
             aior_logical_assignment.worker_id,
             aior_logical_assignment.logical_workplace_id,
             aior_logical_assignment.active_date,
             aior_logical_assignment.inactive_date );

      n_inserted := nvl(n_inserted, 0) + nvl(sql%rowcount, 0);
    exception
      when OTHERS then
        raise_application_error( -20003, SQLERRM||
          ' on insert LOGICAL_ASSIGNMENT_T'||
          ' in LOGICAL_ASSIGNMENT_TS.set_row()' );
    end;
  end if;
end set_row;


PROCEDURE test is

n_logical_workplace_id                LOGICAL_WORKPLACE_T.id%TYPE;
n_logical_workplace_id_1              LOGICAL_WORKPLACE_T.id%TYPE;
n_logical_workplace_id_2              LOGICAL_WORKPLACE_T.id%TYPE;
n_worker_id                           WORKER_T.id%TYPE;
n_worker_id_1                         WORKER_T.id%TYPE;
n_worker_id_2                         WORKER_T.id%TYPE;
r_worker                              WORKER_T%ROWTYPE;
r_logical_workplace                   LOGICAL_WORKPLACE_T%ROWTYPE;
r_logical_assignment                  LOGICAL_ASSIGNMENT_T%ROWTYPE;

begin
  pl('LOGICAL_ASSIGNMENT_TS.test()');
  
  TEST_TS.clear('LOGICAL_ASSIGNMENT_TS');
  
  -- In order to make entries into an Intersection table
  -- you first have to have entries in the two tables
  -- for which an entry will create an intersection
  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'DELETE', 0, 
    'Delete existing test entries from LOGICAL_ASSIGNMENT_T');
  begin
    delete LOGICAL_ASSIGNMENT_T
    where  logical_workplace_id in (
    select logical_workplace_id
    from   LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 ) );

    delete LOGICAL_ASSIGNMENT_T
    where  worker_id in (
    select worker_id
    from   WORKER_T
    where  external_id in (  
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 ) );
      
    TEST_TS.ok();
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'DELETE', 1, 
    'Delete existing test entries from LOGICAL_WORKPLACE_T');
  begin
    delete LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 );
  
    delete LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30 );
  
    TEST_TS.ok;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'DELETE', 2, 
    'Delete existing test entries from WORKER_T');
  begin
    delete WORKER_T
    where  external_id in (  
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 );
  
    TEST_TS.ok();
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'INSERT', 3, 
    'Insert WORKER_T test entries using set_row()');
  begin
    r_worker.id             := WORKER_TS.get_id();
    r_worker.worker_type_id := WORKER_TYPE_TS.get_id('E');
    r_worker.external_id    := TEST_TS.v_TEST_30;
    r_worker.first_name     := TEST_TS.v_TEST_30;
    r_worker.middle_name    := TEST_TS.v_TEST_30;
    r_worker.last_name      := TEST_TS.v_TEST_30;
    r_worker.name           := WORKER_TS.get_formatted_name(
      r_worker.first_name,
      r_worker.middle_name,
      r_worker.last_name);
    r_worker.birth_date     := to_date('19800101', 'YYYYMMDD');   
    r_worker.gender_id      := GENDER_TS.get_id('M');
    WORKER_TS.set_row(r_worker);
    n_worker_id             := r_worker.id;

    r_worker.id             := WORKER_TS.get_id();
    r_worker.worker_type_id := WORKER_TYPE_TS.get_id('E');
    r_worker.external_id    := TEST_TS.v_TEST_30_1;
    r_worker.first_name     := TEST_TS.v_TEST_30_1;
    r_worker.middle_name    := TEST_TS.v_TEST_30_1;
    r_worker.last_name      := TEST_TS.v_TEST_30_1;
    r_worker.name           := WORKER_TS.get_formatted_name(
      r_worker.first_name,
      r_worker.middle_name,
      r_worker.last_name);
    r_worker.birth_date     := to_date('19700101', 'YYYYMMDD');   
    r_worker.gender_id      := GENDER_TS.get_id('F');
    WORKER_TS.set_row(r_worker);
    n_worker_id_1           := r_worker.id;

    r_worker.id             := WORKER_TS.get_id();
    r_worker.worker_type_id := WORKER_TYPE_TS.get_id('C');
    r_worker.external_id    := TEST_TS.v_TEST_30_2;
    r_worker.first_name     := TEST_TS.v_TEST_30_2;
    r_worker.middle_name    := TEST_TS.v_TEST_30_2;
    r_worker.last_name      := TEST_TS.v_TEST_30_2;
    r_worker.name           := WORKER_TS.get_formatted_name(
      r_worker.first_name,
      r_worker.middle_name,
      r_worker.last_name);
    r_worker.birth_date     := to_date('19600101', 'YYYYMMDD');   
    r_worker.gender_id      := GENDER_TS.get_id('M');
    WORKER_TS.set_row(r_worker);
    n_worker_id_2           := r_worker.id;
  
    TEST_TS.ok();
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'INSERT', 4, 
    'Insert LOGICAL_WORKPLACE_T test entries using set_row()');
  begin
    r_logical_workplace.id                   := 
      LOGICAL_WORKPLACE_TS.get_id();
    r_logical_workplace.parent_id            := NULL;
    r_logical_workplace.id_context           := 
      LOGICAL_WORKPLACE_TS.create_id_context(
        r_logical_workplace.parent_id,
        r_logical_workplace.id);
    r_logical_workplace.workplace_type_id    := 
      WORKPLACE_TYPE_TS.get_id('C');
    r_logical_workplace.code                 := TEST_TS.v_TEST_30;
    r_logical_workplace.name                 := TEST_TS.v_TEST_80;
    r_logical_workplace.active_date          := TEST_TS.d_TEST_19000101;
    r_logical_workplace.inactive_date        := NULL;
    LOGICAL_WORKPLACE_TS.set_row(r_logical_workplace);
    n_logical_workplace_id                   :=
      r_logical_workplace.id;

    r_logical_workplace.id                   := 
      LOGICAL_WORKPLACE_TS.get_id();
    r_logical_workplace.parent_id            := 
      n_logical_workplace_id;
    r_logical_workplace.id_context           := 
      LOGICAL_WORKPLACE_TS.create_id_context(
        r_logical_workplace.parent_id,
        r_logical_workplace.id);
    r_logical_workplace.workplace_type_id    := 
      WORKPLACE_TYPE_TS.get_id('B');
    r_logical_workplace.code                 := TEST_TS.v_TEST_30_1;
    r_logical_workplace.name                 := TEST_TS.v_TEST_80;
    r_logical_workplace.active_date          := TEST_TS.d_TEST_19000101;
    r_logical_workplace.inactive_date        := NULL;
    LOGICAL_WORKPLACE_TS.set_row(r_logical_workplace);
    n_logical_workplace_id_1                 :=
      r_logical_workplace.id;

    r_logical_workplace.id := 
      LOGICAL_WORKPLACE_TS.get_id();
    r_logical_workplace.parent_id            := 
      n_logical_workplace_id;
    r_logical_workplace.id_context           := 
      LOGICAL_WORKPLACE_TS.create_id_context(
        r_logical_workplace.parent_id,
        r_logical_workplace.id);
    r_logical_workplace.workplace_type_id    := 
      WORKPLACE_TYPE_TS.get_id('B');
    r_logical_workplace.code                 := TEST_TS.v_TEST_30_2;
    r_logical_workplace.name                 := TEST_TS.v_TEST_80;
    r_logical_workplace.active_date          := TEST_TS.d_TEST_19000101;
    r_logical_workplace.inactive_date        := NULL;
    LOGICAL_WORKPLACE_TS.set_row(r_logical_workplace);
    n_logical_workplace_id_2                 :=
      r_logical_workplace.id;

    TEST_TS.ok();
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  -- Now that I have entries in the two tables being intersected
  -- I can now start testing this package...
  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'get_id()', 5, 
    'Allocate the next primary key value using get_id()');
  begin
    r_logical_assignment.id := 
      LOGICAL_ASSIGNMENT_TS.get_id();
    
    if nvl(r_logical_assignment.id, 0) > 0 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'set_row()', 6, 
    'Insert history for v_TEST_30 using set_row()');
  begin
    r_logical_assignment.worker_id            := n_worker_id;
    r_logical_assignment.logical_workplace_id := 
      n_logical_workplace_id_2;
    r_logical_assignment.active_date          := 
      to_date('20000101', 'YYYYMMDD');
    r_logical_assignment.inactive_date        := NULL;
    LOGICAL_ASSIGNMENT_TS.set_row(r_logical_assignment);
  
    TEST_TS.ok;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'set_row()', 7, 
    'Insert history for V_TEST_30_1 using set_row()');
  begin
    r_logical_assignment.id := 
      LOGICAL_ASSIGNMENT_TS.get_id();
    r_logical_assignment.worker_id            := n_worker_id_1;
    r_logical_assignment.logical_workplace_id := 
      n_logical_workplace_id_1;
    r_logical_assignment.active_date          := 
      to_date('19900101', 'YYYYMMDD');
    r_logical_assignment.inactive_date        := 
      to_date('19991231', 'YYYYMMDD');
    LOGICAL_ASSIGNMENT_TS.set_row(r_logical_assignment);
  
    r_logical_assignment.id := 
      LOGICAL_ASSIGNMENT_TS.get_id();
    r_logical_assignment.worker_id            := n_worker_id_1;
    r_logical_assignment.logical_workplace_id := 
      n_logical_workplace_id_2;
    r_logical_assignment.active_date          := 
      to_date('20000101', 'YYYYMMDD');
    r_logical_assignment.inactive_date        := NULL;
    LOGICAL_ASSIGNMENT_TS.set_row(r_logical_assignment);
  
    TEST_TS.ok;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'set_row()', 8, 
    'Insert history for V_TEST_30_2 using set_row()');
  begin
    r_logical_assignment.id := 
      LOGICAL_ASSIGNMENT_TS.get_id();
    r_logical_assignment.worker_id            := n_worker_id_2;
    r_logical_assignment.logical_workplace_id := 
      n_logical_workplace_id_1;
    r_logical_assignment.active_date          := 
      to_date('19800101', 'YYYYMMDD');
    r_logical_assignment.inactive_date        := 
      to_date('19891231', 'YYYYMMDD');
    LOGICAL_ASSIGNMENT_TS.set_row(r_logical_assignment);
  
    r_logical_assignment.id := 
      LOGICAL_ASSIGNMENT_TS.get_id();
    r_logical_assignment.worker_id            := n_worker_id_2;
    r_logical_assignment.logical_workplace_id := 
      n_logical_workplace_id_2;
    r_logical_assignment.active_date          := 
      to_date('19900101', 'YYYYMMDD');
    r_logical_assignment.inactive_date        := 
      to_date('19901231', 'YYYYMMDD');
    LOGICAL_ASSIGNMENT_TS.set_row(r_logical_assignment);
  
    TEST_TS.ok;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  -- Commit the deletes and inserts
  commit;
  
  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 
    'get_logical_workplace()', 9, 
    'Get the current logical workplace for v_TEST_30');
  begin
    r_logical_workplace := NULL;
    r_logical_workplace := get_logical_workplace(n_worker_id);
  
    if nvl(r_logical_workplace.id, 0) > 0 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 
    'get_logical_workplace()', 10, 
    'Get the logical workplace on 6/30/1995 for v_TEST_30_1');
  begin
    r_logical_workplace := NULL;
    r_logical_workplace := get_logical_workplace(
      n_worker_id_1,
      to_date('19950630', 'YYYYMMDD'));
  
    if nvl(r_logical_workplace.id, 0) > 0 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 
    'get_logical_workplace()', 11, 
    'Get the logical workplace on 6/30/1995 for v_TEST_30_2');
  begin
    -- this should fail
    r_logical_workplace := NULL;
    r_logical_workplace := get_logical_workplace(
      n_worker_id_2,
      to_date('19950630', 'YYYYMMDD'));
  
    if nvl(r_logical_workplace.id, 0) > 0 then
      TEST_TS.error();
    else
      TEST_TS.ok();
    end if;
  exception
    when NO_DATA_FOUND then
      TEST_TS.ok();
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'help()', 12, 
    'Test help()');
  begin
    help();  
  
    TEST_TS.ok;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'is_active()', 13, 
    'Is there an active assignment on 6/30/1995 for v_TEST_30?');
    -- No
  begin
    if is_active(n_worker_id, to_date('19950630', 'YYYYMMDD')) then
      TEST_TS.error();
    else
      TEST_TS.ok();
    end if;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'is_active()', 14, 
    'Is there an active assignment on 6/30/1995 for v_TEST_30_1?');
    -- Yes
  begin
    if is_active(n_worker_id_1, to_date('19950630', 'YYYYMMDD')) then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'is_active()', 15, 
    'Is there currently an active assignment for v_TEST_30_2?');
    -- No
  begin
    if is_active(n_worker_id_2) then
      TEST_TS.error();
    else
      TEST_TS.ok();
    end if;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  -- Now clean up after the tests by deleting the test entries
  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'DELETE', 16, 
    'Delete existing test entries from LOGICAL_ASSIGNMENT_T');
  begin
    delete LOGICAL_ASSIGNMENT_T
    where  logical_workplace_id in (
    select logical_workplace_id
    from   LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 ) );

    delete LOGICAL_ASSIGNMENT_T
    where  worker_id in (
    select worker_id
    from   WORKER_T
    where  external_id in (  
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 ) );
      
    TEST_TS.ok();
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'DELETE', 17, 
    'Delete existing test entries from LOGICAL_WORKPLACE_T');
  begin
    delete LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 );
  
    delete LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30 );
  
    TEST_TS.ok;
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', 'DELETE', 18, 
    'Delete existing test entries from WORKER_T');
  begin
    delete WORKER_T
    where  external_id in (  
      TEST_TS.v_TEST_30,
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2 );
  
    TEST_TS.ok();
  exception
    when OTHERS then 
      TEST_TS.error(SQLERRM);
  end;

  commit;
  TEST_TS.set_test('LOGICAL_ASSIGNMENT_TS', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end LOGICAL_ASSIGNMENT_TS;
/
@be.sql LOGICAL_ASSIGNMENT_TS
