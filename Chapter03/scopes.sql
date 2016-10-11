rem scopes.sql
rem by Donald J. Bales on 12/15/2006
rem Test unit for package scopes

declare

-- ANONYMOUS PL/SQL BLOCK'S DECLARATION SECTION --

v_scope                               varchar2(40) :=
  'I''m a local variable';

-- This is a local (or embedded) function
FUNCTION my_scope_is_local
return                                varchar2 is
v_answer_0                            varchar2(3) := 'Yes';
begin
  return v_answer_0;
end my_scope_is_local;

-- This is a local (or embedded) procedure
PROCEDURE my_scope_is_local is
v_answer                              varchar2(3) := 'Yes';
begin
  pl(v_answer);
end my_scope_is_local;

begin

-- ANONYMOUS PL/SQL BLOCK'S EXECUTABLE SECTION --

  pl('Can I access my local variable?');
  pl(v_scope);
  pl('Can I access SCOPES'' global variable?');
  pl(SCOPES.gv_scope);
  pl('Can I access SCOPES'' instance variable?');
  --pl(SCOPES.iv_scope);
  pl('No!');

  pl('Can I access my local function?');
  pl(my_scope_is_local());
  pl('Can I access SCOPES'' global function?');
  pl(SCOPES.my_scope_is_global());
  pl('Can I access SCOPES'' instance function?');
  --pl(SCOPES.my_scope_is_instance());
  pl('No!');
  
  pl('Can I access my local procedure?');
  my_scope_is_local();
  pl('Can I access SCOPES'' global procedure?');
  SCOPES.my_scope_is_global();
  pl('Can I access SCOPES'' instance procedure?');
  --SCOPES.my_scope_is_instance();
  pl('No!');
    
end;
/
