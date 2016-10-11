create or replace PACKAGE BODY WORKER_TS as
/*
worker_ts.pkb
by Don Bales on 12/15/2006
Table WORKER_T's methods
*/


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


FUNCTION get_formatted_name(
aiv_first_name                 in     WORKER_T.first_name%TYPE,
aiv_middle_name                in     WORKER_T.middle_name%TYPE,
aiv_last_name                  in     WORKER_T.last_name%TYPE)
return                                WORKER_T.name%TYPE is

begin
 return aiv_last_name||', '||aiv_first_name||' '||aiv_middle_name;
end get_formatted_name; 


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


end WORKER_TS;
/
@be.sql WORKER_TS

