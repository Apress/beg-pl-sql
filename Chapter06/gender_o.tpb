create or replace TYPE BODY gender_o as
/*
gender_o.tpb
by Don Bales on 12/15/2006
Type GENDER_O's attributes and methods
*/

CONSTRUCTOR FUNCTION gender_o(
self                           in out gender_o)
return                                self as result is

begin
  id            := NULL;
  code          := NULL;
  description   := NULL;
  active_date   := NULL;
  inactive_date := NULL;
  return;
end gender_o;


CONSTRUCTOR FUNCTION gender_o(
self                           in out gender_o,
aiv_code                              varchar2,
aiv_description                       varchar2)
return                                self as result is

begin
  id            := get_id();
  code          := aiv_code;
  description   := aiv_description;
  active_date   := SYSDATE;
  inactive_date := NULL;
  return;
end gender_o;


STATIC PROCEDURE get_code_descr(
ain_id                         in     number,
aov_code                          out varchar2,
aov_description                   out varchar2 ) is

begin
  select code,
         description
  into   aov_code,
         aov_description
  from   GENDER_OT       
  where  id = ain_id;
end get_code_descr;


STATIC PROCEDURE get_code_id_descr(
aiov_code                      in out varchar2,
aon_id                            out number,
aov_description                   out varchar2,
aid_on                         in     date ) is

v_code                                varchar2(30);

begin
  select id,
         description
  into   aon_id,
         aov_description
  from   GENDER_OT       
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
    from   GENDER_OT
    where  code like aiov_code||'%'
    and    aid_on between active_date and nvl(inactive_date, DATES.d_MAX);
    aiov_code := v_code;
end get_code_id_descr;


STATIC PROCEDURE get_code_id_descr(
aiov_code                      in out varchar2,
aon_id                            out number,
aov_description                   out varchar2 ) is

begin
 get_code_id_descr(
  aiov_code,
  aon_id,
  aov_description,
  SYSDATE );
end get_code_id_descr;


MEMBER FUNCTION get_id
return                                number is

n_id                                  number;

begin
  select GENDER_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


STATIC FUNCTION get_id(
aiv_code                       in     varchar2 ) 
return                                number is

n_id                                  number;

begin
  select id 
  into   n_id
  from   GENDER_OT
  where  code = aiv_code;
 
  return n_id;
end get_id;


STATIC PROCEDURE help is

begin
 pl('No help at this time.');
end help;


STATIC PROCEDURE test is

begin
  pl('No tests coded at this time');  
end test;


MAP MEMBER FUNCTION to_varchar2
return                                varchar2 is

begin
  return description||to_char(active_date, 'YYYYMMDDHH24MISS');
end to_varchar2;


end;
/
@be.sql GENDER_O
