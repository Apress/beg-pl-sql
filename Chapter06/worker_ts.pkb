create or replace PACKAGE BODY WORKER_TS as
/*
worker_ts.pkb
by Don Bales on 12/15/2006
Table WORKER_T's methods
*/


-- FUNCTIONS

FUNCTION get_age(
aid_birth_date                 in     WORKER_T.birth_date%TYPE,
aid_on                         in     date)
return                                number is

begin
 if aid_birth_date is not NULL and
    aid_on         is not NULL then
   return trunc(months_between(aid_on, aid_birth_date) / 12);
 else
   return NULL;
 end if;
exception
 when OTHERS then
   return NULL;
end get_age;


FUNCTION get_age(
aid_birth_date                 in     WORKER_T.birth_date%TYPE)
return                                number is

begin
  return get_age(aid_birth_date, SYSDATE);
end get_age;


FUNCTION get_age(
ain_id                         in     WORKER_T.id%TYPE,
aid_on                         in     date)
return                                number is

begin
  return get_age(get_birth_date(ain_id), aid_on);
end get_age;


FUNCTION get_age(
ain_id                         in     WORKER_T.id%TYPE) 
return                                number is

begin
  return get_age(get_birth_date(ain_id));
end get_age;


FUNCTION get_birth_date(
ain_id                         in     WORKER_T.id%TYPE) 
return                                WORKER_T.birth_date%TYPE is

d_birth_date                          WORKER_T.birth_date%TYPE;

begin
  select birth_date
  into   d_birth_date
  from   WORKER_T
  where  id = ain_id;
 
  return d_birth_date;
end get_birth_date;


FUNCTION get_external_id
return                                WORKER_T.external_id%TYPE is

v_external_id                         WORKER_T.external_id%TYPE;

begin
  select lpad(to_char(EXTERNAL_ID_SEQ.nextval), 9, '0')
  into   v_external_id
  from   SYS.DUAL;

  return v_external_id;
end get_external_id;


FUNCTION get_id
return                                WORKER_T.id%TYPE is

n_id                                  WORKER_T.id%TYPE;

begin
  select WORKER_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


FUNCTION get_id(
aiv_external_id                in     WORKER_T.external_id%TYPE) 
return                                WORKER_T.id%TYPE is

n_id                                  WORKER_T.id%TYPE;
 
begin
  select id 
  into   n_id
  from   WORKER_T
  where  external_id = aiv_external_id;
 
  return n_id;
end get_id;


FUNCTION get_formatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE is

begin
 return aiv_last_name||', '||aiv_first_name||' '||aiv_middle_name;
end get_formatted_name; 


FUNCTION get_formatted_name(
ain_id                         in     WORKER_T.id%TYPE) 
return                                WORKER_T.name%TYPE is

v_first_name                          WORKER_T.first_name%TYPE;
v_middle_name                         WORKER_T.middle_name%TYPE;
v_last_name                           WORKER_T.last_name%TYPE;

begin
  select first_name,
         middle_name,
         last_name
  into   v_first_name,
         v_middle_name,
         v_last_name
  from   WORKER_T       
  where  id = ain_id;

  return get_formatted_name(
          v_first_name,
          v_middle_name,
          v_last_name);
end get_formatted_name;


FUNCTION get_row(
air_worker                     in     WORKER_T%ROWTYPE)
return                                WORKER_T%ROWTYPE is

r_worker                              WORKER_T%ROWTYPE;

begin
  if    air_worker.id is not NULL then
    -- retrieve the row by the primary key
    select *
    into   r_worker
    from   WORKER_T
    where  id = air_worker.id;
  elsif air_worker.external_id is not NULL then
    -- retrieve the row by the external unique key
    select *
    into   r_worker
    from   WORKER_T
    where  external_id = air_worker.external_id;
  else
    -- retrieve the row by the name, birth_date, and gender
    select *
    into   r_worker
    from   WORKER_T
    where  name       = get_unformatted_name(
                          air_worker.first_name, 
                          air_worker.middle_name, 
                          air_worker.last_name) 
    and    birth_date = air_worker.birth_date
    and    gender_id  = air_worker.gender_id;
  end if;  
  return r_worker;
exception
  when NO_DATA_FOUND then
    raise;
  when OTHERS then
    raise_application_error(-20001, SQLERRM||
      ' on select WORKER_T'||
      ' in WORKER_TS.get_row()');
end get_row;  


FUNCTION get_unformatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE is

begin
  return upper(replace(replace(replace(replace(replace(
    aiv_last_name||aiv_first_name||aiv_middle_name,
      '''', NULL), ',', NULL), '-', NULL), '.', NULL), ' ', NULL));
end get_unformatted_name; 


FUNCTION is_duplicate(
aiv_name                       in     WORKER_T.name%TYPE,
aid_birth_date                 in     WORKER_T.birth_date%TYPE,
ain_gender_id                  in     WORKER_T.gender_id%TYPE)
return                                boolean is

n_selected                            number;

begin
  select count(1)
  into   n_selected
  from   WORKER_T
  where  name       = aiv_name
  and    birth_date = aid_birth_date
  and    gender_id  = ain_gender_id;

  if nvl(n_selected, 0) > 0 then
    return TRUE;
  else
    return FALSE;
  end if;
end is_duplicate;


-- PROCEDURES

PROCEDURE help is

begin
--   12345678901234567890123456789012345678901234567890123456789012345678901234567890 
  pl('=================================== PACKAGE ====================================');
  pl(chr(9));
  pl('WORKER_TS');
  pl(chr(9));
  pl('----------------------------------- FUNCTIONS ----------------------------------');
  pl(chr(9));
  pl('YOU GOTTA CODE THIS BUDDY WORKER_TS.get_id');
  pl('return                                WORKER_T.id%TYPE;');
  pl(chr(9)||'Returns a newly allocated sequence value for id.');
  pl(chr(9));
  pl('WORKER_TS.get_id(');
  pl('aiv_external_id                       in     WORKER_T.external_id%TYPE )');
  pl('return                                WORKER_T.id%TYPE;');
  pl(chr(9)||'Returns the corresponding id for the specified external_id.');
  pl(chr(9));
  pl('----------------------------------- PROCEDURES ---------------------------------');
  pl(chr(9));
  pl('WORKER_TS.get_external_id_descr(');
  pl('ain_id                         in     WORKER_T.id%TYPE,');
  pl('aov_external_id                   out WORKER_T.external_id%TYPE,');
  pl('aov_description                   out WORKER_T.description%TYPE );');
  pl(chr(9)||'Gets the corresponding external_id and description for the specified');
  pl(chr(9)||'id.');
  pl(chr(9));
  pl('WORKER_TS.get_external_id_id_descr(');
  pl('aiov_external_id                      in out WORKER_T.external_id%TYPE,');
  pl('aon_id                            out WORKER_T.id%TYPE,');
  pl('aov_description                   out WORKER_T.description%TYPE,');
  pl('aid_on                         in     WORKER_T.active%TYPE );');
  pl(chr(9)||'Gets the corresponding external_id, id, and description for');
  pl(chr(9)||'the specified external_id.  First it trys to find an exact match.  If one');
  pl(chr(9)||'cannot be found, it trys to find a like match.  It may throw a');
  pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
  pl(chr(9)||'found for the specified external_id and point in time.');
  pl(chr(9));
  pl('WORKER_TS.get_external_id_id_descr(');
  pl('aiov_external_id               in out WORKER_T.external_id%TYPE,');
  pl('aon_id                            out WORKER_T.id%TYPE,');
  pl('aov_description                   out WORKER_T.description%TYPE );');
  pl(chr(9)||'Gets the corresponding external_id, id, and description for');
  pl(chr(9)||'the specified external_id.  First it trys to find an exact match.  If one');
  pl(chr(9)||'cannot be found, it trys to find a like match.  It may throw a');
  pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
  pl(chr(9)||'found for the specified external_id at the current point in time.');
  pl(chr(9));
  pl('WORKER_TS.help( );');
  pl(chr(9)||'Displays this help text if set serveroutput is on.');
  pl(chr(9));
  pl('WORKER_TS.test( );');
  pl(chr(9)||'Built-in test unit.  It will report success or error for each test if set');
  pl(chr(9)||'serveroutput is on.');
  pl(chr(9));
end help;


PROCEDURE set_row(
aior_worker                    in out WORKER_T%ROWTYPE) is

d_null                       constant date        := DATES.d_MIN;
n_null                       constant number      := 0;
v_null                       constant varchar2(1) := ' ';
r_worker                              WORKER_T%ROWTYPE;

begin
  -- set the unformatted name
  aior_worker.name := get_unformatted_name(
                        aior_worker.first_name, 
                        aior_worker.middle_name, 
                        aior_worker.last_name); 
  -- get the existing row
  begin
    r_worker := get_row(aior_worker);
  exception
    when NO_DATA_FOUND then
      r_worker := NULL;
  end;
  -- if a row exists, update it if needed
  if r_worker.id is not NULL then
    aior_worker.id          := r_worker.id;
    aior_worker.external_id := r_worker.external_id;
    if nvl(r_worker.worker_type_id, n_null) <> nvl(aior_worker.worker_type_id, n_null) or
       nvl(r_worker.external_id,    n_null) <> nvl(aior_worker.external_id,    n_null) or
       nvl(r_worker.first_name,     v_null) <> nvl(aior_worker.first_name,     v_null) or
       nvl(r_worker.middle_name,    v_null) <> nvl(aior_worker.middle_name,    v_null) or
       nvl(r_worker.last_name,      v_null) <> nvl(aior_worker.last_name,      v_null) or
       nvl(r_worker.birth_date,     d_null) <> nvl(aior_worker.birth_date,     d_null) or
       nvl(r_worker.gender_id,      n_null) <> nvl(aior_worker.gender_id,      n_null) then
      begin
        update WORKER_T
        set    worker_type_id = aior_worker.worker_type_id,
               external_id    = aior_worker.external_id,
               first_name     = aior_worker.first_name,
               middle_name    = aior_worker.middle_name,
               last_name      = aior_worker.last_name,
               name           = aior_worker.name,
               birth_date     = aior_worker.birth_date,
               gender_id      = aior_worker.gender_id
        where  id             = aior_worker.id;

        n_updated := nvl(n_updated, 0) + nvl(sql%rowcount, 0);
      exception
        when OTHERS then
          raise_application_error( -20002, SQLERRM||
            ' on update WORKER_T'||
            ' in WORKER_TS.set_row()' );
      end;
    end if;
  else
  -- add the row if it does not exist
    begin
      if aior_worker.id is NULL then
        aior_worker.id := get_id();
      end if;
      if aior_worker.external_id is NULL then
        aior_worker.external_id := get_external_id();
      end if;
      insert into WORKER_T (
             id,
             worker_type_id,
             external_id,
             first_name,
             middle_name,
             last_name,
             name,
             birth_date,
             gender_id )
      values (
            aior_worker.id,
            aior_worker.worker_type_id,
            aior_worker.external_id,
            aior_worker.first_name,
            aior_worker.middle_name,
            aior_worker.last_name,
            aior_worker.name,
            aior_worker.birth_date,
            aior_worker.gender_id );

      n_inserted := nvl(n_inserted, 0) + nvl(sql%rowcount, 0);
    exception
      when OTHERS then
        raise_application_error( -20003, SQLERRM||
          ' on insert WORKER_T'||
          ' in WORKER_TS.set_row()' );
    end;
  end if;
end set_row;


PROCEDURE test is

begin
  pl('=================================== PACKAGE ====================================');
  pl(chr(9));
  pl('WORKER_TS');
  pl(chr(9));
  pl(chr(9)||'No tests for WORKER_TS at this time');  
end test;


end WORKER_TS;
/
@be.sql WORKER_TS

