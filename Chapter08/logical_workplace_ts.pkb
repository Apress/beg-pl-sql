create or replace PACKAGE BODY LOGICAL_WORKPLACE_TS as
/*
logical_workplace_ts.pkb
by Donald J. Bales on 12/15/2006
Table LOGICAL_WORKPLACE_T's methods
*/

-- FORWARD DECLARATIONS

FUNCTION get_parent_id_context(
ain_parent_id                  in     LOGICAL_WORKPLACE_T.parent_id%TYPE) 
return                                varchar2;


FUNCTION create_id_context(
ain_parent_id                  in     LOGICAL_WORKPLACE_T.parent_id%TYPE,
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) 
return                                varchar2 is

v_id_context                          LOGICAL_WORKPLACE_T.id_context%TYPE;

begin
  v_id_context := get_parent_id_context(ain_parent_id);
  
  if v_id_context is not NULL then
    return substr(v_id_context||'.'||to_char(ain_id), 1, 2000);
  else
    return to_char(ain_id);
  end if;
end create_id_context;


FUNCTION get_id
return                                LOGICAL_WORKPLACE_T.id%TYPE is

n_id                                  LOGICAL_WORKPLACE_T.id%TYPE;

begin
  select LOGICAL_WORKPLACE_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


FUNCTION get_code_context(
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) 
return                                varchar2 is

cursor c_code_context(
ain_id       in     LOGICAL_WORKPLACE_T.id%TYPE) is
select upper(code) code
from   LOGICAL_WORKPLACE_T
connect by prior parent_id = id
start with       id        = ain_id
order by level desc;

v_code_context                        varchar2(2000);

begin
  for r_code_context in c_code_context(ain_id) loop
    v_code_context := substr(v_code_context||'.'||r_code_context.code, 1, 2000);
  end loop;
  return v_code_context;
end get_code_context;


FUNCTION get_name_context(
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) 
return                                varchar2 is

cursor c_name_context(
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) is
select initcap(name) name
from   LOGICAL_WORKPLACE_T
connect by prior parent_id = id
start with       id        = ain_id
order by level desc;

v_name_context                        varchar2(2000);

begin
  for r_name_context in c_name_context(ain_id) loop
    v_name_context := substr(v_name_context||'.'||r_name_context.name, 1, 2000);
  end loop;
  return v_name_context;
end get_name_context;


FUNCTION get_parent_id_context(
ain_parent_id                  in     LOGICAL_WORKPLACE_T.parent_id%TYPE) 
return                                varchar2 is

v_id_context                          LOGICAL_WORKPLACE_T.id_context%TYPE;

begin
  if ain_parent_id is not NULL then
    select id_context
    into   v_id_context
    from   LOGICAL_WORKPLACE_T
    where  id = ain_parent_id;
  end if;

  return v_id_context;
end get_parent_id_context;


FUNCTION get_row(
air_logical_workplace          in     LOGICAL_WORKPLACE_T%ROWTYPE)
return                                LOGICAL_WORKPLACE_T%ROWTYPE is

r_logical_workplace                   LOGICAL_WORKPLACE_T%ROWTYPE;

begin
  if    air_logical_workplace.id is not NULL then
    --pl('retrieve the row by the primary key');
    select *
    into   r_logical_workplace
    from   LOGICAL_WORKPLACE_T
    where  id = air_logical_workplace.id;
  elsif air_logical_workplace.id_context is not NULL then
    --pl('retrieve the row by the id_context unique key');
    select *
    into   r_logical_workplace
    from   LOGICAL_WORKPLACE_T
    where  id_context = air_logical_workplace.id_context;
  else
    --pl('retrieve the row by the code, name, and active_date');
    select *
    into   r_logical_workplace
    from   LOGICAL_WORKPLACE_T
    where  code        = air_logical_workplace.code
    and    name        = air_logical_workplace.name
    and    active_date = air_logical_workplace.active_date;
  end if;  
  return r_logical_workplace;
exception
  when NO_DATA_FOUND then
    raise;
  when OTHERS then
    raise_application_error(-20001, SQLERRM||
      ' on select LOGICAL_WORKPLACE_T'||
      ' in LOGICAL_WORKPLACE_TS.get_row()');
end get_row;  


FUNCTION set_row(
ain_parent_id                  in     LOGICAL_WORKPLACE_T.parent_id%TYPE,
ain_workplace_type_id          in     LOGICAL_WORKPLACE_T.workplace_type_id%TYPE,
aiv_code                       in     LOGICAL_WORKPLACE_T.code%TYPE,
aiv_name                       in     LOGICAL_WORKPLACE_T.name%TYPE,
aid_active_date                in     LOGICAL_WORKPLACE_T.active_date%TYPE)
return                                LOGICAL_WORKPLACE_T.id%TYPE is

r_logical_workplace                   LOGICAL_WORKPLACE_T%ROWTYPE;

begin
  r_logical_workplace.id                := NULL;
  r_logical_workplace.id_context        := NULL;
  r_logical_workplace.parent_id         := ain_parent_id;
  r_logical_workplace.workplace_type_id := ain_workplace_type_id;
  r_logical_workplace.code              := aiv_code;
  r_logical_workplace.name              := aiv_name;
  r_logical_workplace.active_date       := aid_active_date;
  set_row(r_logical_workplace);

  return r_logical_workplace.id;
end set_row;


-- PROCEDURES

PROCEDURE help is

begin
  pl('No help coded yet.');
end help;


PROCEDURE set_row(
aior_logical_workplace         in out LOGICAL_WORKPLACE_T%ROWTYPE) is

d_null                       constant date        := DATES.d_MIN;
n_null                       constant number      := 0;
v_null                       constant varchar2(1) := ' ';
r_logical_workplace                   LOGICAL_WORKPLACE_T%ROWTYPE;

begin
  -- get the existing row
  begin
    r_logical_workplace := get_row(aior_logical_workplace);
  exception
    when NO_DATA_FOUND then
      r_logical_workplace := NULL;
  end;
  -- if a row exists, update it if needed
  if r_logical_workplace.id is not NULL then
    aior_logical_workplace.id         := r_logical_workplace.id;
    aior_logical_workplace.parent_id  := r_logical_workplace.parent_id;
    aior_logical_workplace.id_context := r_logical_workplace.id_context;
    if nvl(r_logical_workplace.workplace_type_id, n_null) <> nvl(aior_logical_workplace.workplace_type_id, n_null) or
       nvl(r_logical_workplace.code,              v_null) <> nvl(aior_logical_workplace.code,              v_null) or
       nvl(r_logical_workplace.name,              v_null) <> nvl(aior_logical_workplace.name,              v_null) or
       nvl(r_logical_workplace.active_date,       d_null) <> nvl(aior_logical_workplace.active_date,       d_null) or
       nvl(r_logical_workplace.inactive_date,     d_null) <> nvl(aior_logical_workplace.inactive_date,     d_null) then
      begin
        update LOGICAL_WORKPLACE_T
        set    workplace_type_id    = aior_logical_workplace.workplace_type_id,
               code                 = aior_logical_workplace.code,
               name                 = aior_logical_workplace.name,
               active_date          = aior_logical_workplace.active_date,
               inactive_date        = aior_logical_workplace.inactive_date
        where  id = aior_logical_workplace.id;

        n_updated := nvl(n_updated, 0) + nvl(sql%rowcount, 0);
      exception
        when OTHERS then
          raise_application_error( -20002, SQLERRM||
            ' on update LOGICAL_WORKPLACE_T'||
            ' in LOGICAL_WORKPLACE_TS.set_row()' );
      end;
    end if;
  else
  -- add the row if it does not exist
    begin
      if aior_logical_workplace.id is NULL then
        aior_logical_workplace.id := get_id();
      end if;
      aior_logical_workplace.id_context := 
        create_id_context(
          aior_logical_workplace.parent_id,
          aior_logical_workplace.id );
      insert into LOGICAL_WORKPLACE_T (
             id,
             parent_id,
             id_context,
             workplace_type_id,
             code,
             name,
             active_date,
             inactive_date )
      values (
             aior_logical_workplace.id,
             aior_logical_workplace.parent_id,
             aior_logical_workplace.id_context,
             aior_logical_workplace.workplace_type_id,
             aior_logical_workplace.code,
             aior_logical_workplace.name,
             aior_logical_workplace.active_date,
             aior_logical_workplace.inactive_date );

      n_inserted := nvl(n_inserted, 0) + nvl(sql%rowcount, 0);
    exception
      when OTHERS then
        raise_application_error( -20003, SQLERRM||
          ' on insert LOGICAL_WORKPLACE_T'||
          ' in LOGICAL_WORKPLACE_TS.set_row()' );
    end;
  end if;
end set_row;


PROCEDURE test is

/*
LOGICAL_WORKPLACE_T
 Name                                     Null?    Type
 ---------------------------------------- -------- -------------
 LOGICAL_WORKPLACE_ID                     NOT NULL NUMBER
 PARENT_ID                                         NUMBER
 ID_CONTEXT                               NOT NULL VARCHAR2(100)
 WORKPLACE_TYPE_ID                        NOT NULL NUMBER
 CODE                                     NOT NULL VARCHAR2(30)
 NAME                                     NOT NULL VARCHAR2(80)
 ACTIVE_DATE                              NOT NULL DATE
 INACTIVE_DATE                                     DATE
*/

v_id_context                       
  LOGICAL_WORKPLACE_T.id_context%TYPE;
r_logical_workplace                   LOGICAL_WORKPLACE_T%ROWTYPE;

begin
  pl('LOGICAL_WORKPLACE_TS.test()');

  TEST_TS.clear('LOGICAL_WORKPLACE_TS');
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'DELETE', 0, 
    'Delete existing test entries');
  begin
    delete LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2);

    delete LOGICAL_WORKPLACE_T
    where  code = TEST_TS.v_TEST_30;
      
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'get_id()', 1, 
    'Allocate the next primary key value');
  begin
    r_logical_workplace.id := get_id();
    
    if r_logical_workplace.id > 0 then    
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 
    'create_id_context()', 2, 'Create an ID context value');
  begin
    r_logical_workplace.parent_id            := NULL;
    r_logical_workplace.id_context           := 
      create_id_context(
        r_logical_workplace.parent_id,
        r_logical_workplace.id);
    
    if r_logical_workplace.id_context = 
      to_char(r_logical_workplace.id) then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'set_row()', 3, 
    'Insert parent test entry');
  begin
    r_logical_workplace.workplace_type_id    := 
      WORKPLACE_TYPE_TS.get_id('C');
    r_logical_workplace.code                 :=
      TEST_TS.v_TEST_30;
    r_logical_workplace.name                 := 
      TEST_TS.v_TEST_80;
    r_logical_workplace.active_date          := 
      TEST_TS.d_TEST_19000101;
    r_logical_workplace.inactive_date        := NULL;
    set_row(r_logical_workplace);    
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'set_row()', 4, 
    'Insert child entries');
  begin
    r_logical_workplace.parent_id            := 
      r_logical_workplace.id;
    r_logical_workplace.id                   := get_id();
    r_logical_workplace.id_context           := 
      create_id_context(
        r_logical_workplace.parent_id,
        r_logical_workplace.id);
    -- save this value for testing get_row()
    v_id_context                             := 
      r_logical_workplace.id_context;
    r_logical_workplace.workplace_type_id    := 
      WORKPLACE_TYPE_TS.get_id('B');
    r_logical_workplace.code                 :=
      TEST_TS.v_TEST_30_1;
    r_logical_workplace.name                 := 
      TEST_TS.v_TEST_80;
    set_row(r_logical_workplace);

    
    r_logical_workplace.id                   := get_id();
    r_logical_workplace.id_context           := 
      create_id_context(
        r_logical_workplace.parent_id,
        r_logical_workplace.id);
    r_logical_workplace.code                 :=
      TEST_TS.v_TEST_30_2;
    set_row(r_logical_workplace);
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'get_code_context()', 5, 
    'Get the code context for v_TEST_30_2');
  begin
    pl(get_code_context(
      r_logical_workplace.id));
      
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'get_name_context()', 6, 
    'Get the name context for v_TEST_30_2');
  begin
    pl(get_name_context(
      r_logical_workplace.id));
      
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'get_row()', 7, 
    'Get the row using the id for v_TEST_30_2');
  begin
--    r_logical_workplace.id                   := NULL;
    r_logical_workplace.parent_id            := NULL;
    r_logical_workplace.id_context           := NULL;
    r_logical_workplace.workplace_type_id    := NULL;
    r_logical_workplace.code                 := NULL;
    r_logical_workplace.name                 := NULL;
    r_logical_workplace.active_date          := NULL;
    r_logical_workplace.inactive_date        := NULL;

    r_logical_workplace := get_row(r_logical_workplace);

    if r_logical_workplace.id_context is not NULL then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'get_row()', 8, 
    'Get the row using the id_context for v_TEST_30_1');
  begin
    r_logical_workplace.id                   := NULL;
    r_logical_workplace.parent_id            := NULL;
    r_logical_workplace.id_context           := 
      v_id_context;
    r_logical_workplace.workplace_type_id    := NULL;
    r_logical_workplace.code                 := NULL;
    r_logical_workplace.name                 := NULL;
    r_logical_workplace.active_date          := NULL;
    r_logical_workplace.inactive_date        := NULL;

    r_logical_workplace := get_row(r_logical_workplace);

    if r_logical_workplace.id is not NULL then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      pl('v_id_context="'||v_id_context||'"');
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'get_row()', 9, 
    'Get the row using the code for v_TEST_30');
  begin
    r_logical_workplace.id                   := NULL;
    r_logical_workplace.parent_id            := NULL;
    r_logical_workplace.id_context           := NULL;
    r_logical_workplace.workplace_type_id    := NULL;
    r_logical_workplace.code                 := 
      TEST_TS.v_TEST_30;
    r_logical_workplace.name                 := 
      TEST_TS.v_TEST_80;
    r_logical_workplace.active_date          := 
      TEST_TS.d_TEST_19000101;
    r_logical_workplace.inactive_date        := NULL;

    r_logical_workplace := get_row(r_logical_workplace);

    if r_logical_workplace.id is not NULL then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'help()', 10, 
    'Display the help text');
  begin
    help();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', 'DELETE', 11, 
    'Delete test entries');
  begin
    delete LOGICAL_WORKPLACE_T
    where  code in (
      TEST_TS.v_TEST_30_1,
      TEST_TS.v_TEST_30_2);

    delete LOGICAL_WORKPLACE_T
    where  code = TEST_TS.v_TEST_30;
      
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  commit;
  TEST_TS.set_test('LOGICAL_WORKPLACE_TS', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end LOGICAL_WORKPLACE_TS;
/
@be.sql LOGICAL_WORKPLACE_TS

