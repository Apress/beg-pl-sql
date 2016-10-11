create or replace PACKAGE BODY WORKPLACE_TYPE_TS as
/*
workplace_type_ts.pkb
by Donald J. Bales on 12/15/2006
Table WORKPLACE_TYPE_T's methods
*/


-- FUNCTIONS

FUNCTION get_id
return                                WORKPLACE_TYPE_T.id%TYPE is

n_id                                  WORKPLACE_TYPE_T.id%TYPE;

begin
  select WORKPLACE_TYPE_ID_SEQ.nextval 
  into   n_id
  from   SYS.DUAL;

  return n_id;
end get_id;


FUNCTION get_id(
aiv_code                       in     WORKPLACE_TYPE_T.code%TYPE ) 
return                                WORKPLACE_TYPE_T.id%TYPE is

n_id                                  WORKPLACE_TYPE_T.id%TYPE;

begin
  select id 
  into   n_id
  from   WORKPLACE_TYPE_T
  where  code = aiv_code;
 
  return n_id;
end get_id;


-- PROCEDURES

PROCEDURE get_code_descr(
ain_id                         in     WORKPLACE_TYPE_T.id%TYPE,
aov_code                          out WORKPLACE_TYPE_T.code%TYPE,
aov_description                   out WORKPLACE_TYPE_T.description%TYPE ) is

begin
  select code,
         description
  into   aov_code,
         aov_description
  from   WORKPLACE_TYPE_T       
  where  id = ain_id;
end get_code_descr;


PROCEDURE get_code_id_descr(
aiov_code                      in out WORKPLACE_TYPE_T.code%TYPE,
aon_id                            out WORKPLACE_TYPE_T.id%TYPE,
aov_description                   out WORKPLACE_TYPE_T.description%TYPE,
aid_on                         in     WORKPLACE_TYPE_T.active_date%TYPE ) is

v_code                                WORKPLACE_TYPE_T.code%TYPE;

begin
  select id,
         description
  into   aon_id,
         aov_description
  from   WORKPLACE_TYPE_T       
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
    from   WORKPLACE_TYPE_T
    where  code like aiov_code||'%'
    and    aid_on between active_date and nvl(inactive_date, DATES.d_MAX);

    aiov_code := v_code;
end get_code_id_descr;


PROCEDURE get_code_id_descr(
aiov_code                      in out WORKPLACE_TYPE_T.code%TYPE,
aon_id                            out WORKPLACE_TYPE_T.id%TYPE,
aov_description                   out WORKPLACE_TYPE_T.description%TYPE ) is

begin
 get_code_id_descr(
  aiov_code,
  aon_id,
  aov_description,
  SYSDATE );
end get_code_id_descr;

PROCEDURE help is

begin
--   12345678901234567890123456789012345678901234567890123456789012345678901234567890 
 pl('=================================== PACKAGE ====================================');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS');
 pl(chr(9));
 pl('----------------------------------- FUNCTIONS ----------------------------------');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS.get_id');
 pl('return                                WORKPLACE_TYPE_T.id%TYPE;');
 pl(chr(9)||'Returns a newly allocated sequence value for id.');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS.get_id(');
 pl('aiv_code                       in     WORKPLACE_TYPE_T.code%TYPE )');
 pl('return                                WORKPLACE_TYPE_T.id%TYPE;');
 pl(chr(9)||'Returns the corresponding id for the specified code.');
 pl(chr(9));
 pl('----------------------------------- PROCEDURES ---------------------------------');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS.get_code_descr(');
 pl('ain_id             in     WORKPLACE_TYPE_T.id%TYPE,');
 pl('aov_code                          out WORKPLACE_TYPE_T.code%TYPE,');
 pl('aov_description                   out WORKPLACE_TYPE_T.description%TYPE );');
 pl(chr(9)||'Gets the corresponding code and description for the specified');
 pl(chr(9)||'id.');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS.get_code_id_descr(');
 pl('aiov_code                      in out WORKPLACE_TYPE_T.code%TYPE,');
 pl('aon_id                out WORKPLACE_TYPE_T.id%TYPE,');
 pl('aov_description                   out WORKPLACE_TYPE_T.description%TYPE,');
 pl('aid_on                         in     WORKPLACE_TYPE_T.active_date%TYPE );');
 pl(chr(9)||'Gets the corresponding code, id, and description for');
 pl(chr(9)||'the specified code.  First it trys to find an exact match.  If one');
 pl(chr(9)||'cannot be found, it trys to find a like match.  It may throw a');
 pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
 pl(chr(9)||'found for the specified code and point in time.');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS.get_code_id_descr(');
 pl('aiov_code                      in out WORKPLACE_TYPE_T.code%TYPE,');
 pl('aon_id                out WORKPLACE_TYPE_T.id%TYPE,');
 pl('aov_description                   out WORKPLACE_TYPE_T.description%TYPE );');
 pl(chr(9)||'Gets the corresponding code, id, and description for');
 pl(chr(9)||'the specified code.  First it trys to find an exact match.  If one');
 pl(chr(9)||'cannot be found, it trys to find a like match.  It may throw a');
 pl(chr(9)||'NO_DATA_FOUND or a TOO_MANY_ROWS exception if a match cannot be');
 pl(chr(9)||'found for the specified code at the current point in time.');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS.help( );');
 pl(chr(9)||'Displays this help text if set serveroutput is on.');
 pl(chr(9));
 pl('WORKPLACE_TYPE_TS.test( );');
 pl(chr(9)||'Built-in test unit.  It will report success or error for each test if set');
 pl(chr(9)||'serveroutput is on.');
 pl(chr(9));
end help;


PROCEDURE test is

begin
  pl('=================================== PACKAGE ====================================');
  pl(chr(9));
  pl(chr(9)||'No tests coded at this time');  
end test;


end WORKPLACE_TYPE_TS;
/
@be.sql WORKPLACE_TYPE_TS

