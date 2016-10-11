create or replace type body DEBUG_O as
/* 
debug_o.tpb
by Donald Bales on 12/15/2006
Type DEBUG_O's implementation
A type for logging debug information
*/

STATIC FUNCTION get_id
return                                number is

n_id                                  number;

begin
  select DEBUG_ID_SEQ.nextval
  into   n_id
  from   SYS.DUAL;
  
  return n_id;
end get_id;


CONSTRUCTOR FUNCTION debug_o(
self                           in out nocopy debug_o)
return                                self as result is

begin
  pl('debug_o(zero param)');
  self.id                := NULL;
  self.text              := NULL;
  self.unique_session_id := NULL;
  self.insert_user       := NULL;
  self.insert_date       := NULL;

  return;
end debug_o;


CONSTRUCTOR FUNCTION debug_o(
self                           in out nocopy debug_o,
ain_id                         in     number,
aiv_text                       in     varchar2)
return                                self as result is

begin
  pl('debug_o(two params)');
  self.id                := ain_id;
  self.text              := aiv_text;
  self.unique_session_id := SYS.DBMS_SESSION.unique_session_id;
  self.insert_user       := USER;
  self.insert_date       := SYSDATE;

  return;
end debug_o;


-- Override the default constructor.  To do so, you must 
-- use the same attributes names for the parameter names
-- and use them in the order specified in the type spec.
CONSTRUCTOR FUNCTION debug_o(
self                           in out nocopy debug_o,
id                             in     number,
text                           in     varchar2,
unique_session_id              in     varchar2,
insert_user                    in     varchar2,
insert_date                    in     date)
return                                self as result is

begin
  pl('debug_o(five params)');
  self.id                := id;
  self.text              := text;
  self.unique_session_id := unique_session_id;
  self.insert_user       := insert_user;
  self.insert_date       := insert_date;

  return;
end debug_o;


STATIC PROCEDURE set_text(
aiv_program_unit               in     varchar2,
aiv_text                       in     varchar2) is

pragma autonomous_transaction;

v_text                                varchar2(256);

begin
  v_text := substrb(aiv_program_unit||': '||aiv_text, 1, 256);
  
  insert into DEBUG_OT 
  values (DEBUG_O(DEBUG_ID_SEQ.nextval, aiv_text));
-- A defect in SQL prevents me from using the function
-- get_id() as follows:
--values (DEBUG_O(DEBUG_O.get_id(), aiv_text));
  commit;
end set_text;


MAP MEMBER FUNCTION to_map
return                                number is

begin
  return id;
end to_map;


end;
/
@be.sql DEBUG_O
