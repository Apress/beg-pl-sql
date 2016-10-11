rem parameters.sql
rem by Donald J. Bales on 12/15/2006
rem A test unit for package PARAMETERS

declare

v_in                         varchar2(30) := 'IN';
v_out                        varchar2(30) := 
  'Na na, you can''t see me!';
v_inout                      varchar2(30) := 
  'But you can see me!';
v_return                     varchar2(30);

begin
  pl('Before calling the function...');
  pl('Inside test unit parameters v_in    = '||v_in);
  pl('Inside test unit parameters v_out   = '||v_out);
  pl('Inside test unit parameters v_inout = '||v_inout);
  pl('Test function PARAMETERS.in_out_inout(v_in, v_out, v_inout).');
  v_return := PARAMETERS.in_out_inout(v_in, v_out, v_inout);
  pl(v_return);
  pl('After calling the function...');
  pl('Inside test unit parameters v_in    = '||v_in);
  pl('Inside test unit parameters v_out   = '||v_out);
  pl('Inside test unit parameters v_inout = '||v_inout);
  pl('Resetting initial values...');  
  v_out   := 'Na na, you can''t see me!';
  v_inout := 'But you can see me!';
  pl('Before calling the procedure...');
  pl('Inside test unit parameters v_in    = '||v_in);
  pl('Inside test unit parameters v_out   = '||v_out);
  pl('Inside test unit parameters v_inout = '||v_inout);
  pl('Test procedure PARAMETERS.in_out_inout(v_in, v_out, v_inout).');
  PARAMETERS.in_out_inout(v_in, v_out, v_inout);
  pl('OK');
  pl('After calling the procedure...');
  pl('Inside test unit parameters v_in    = '||v_in);
  pl('Inside test unit parameters v_out   = '||v_out);
  pl('Inside test unit parameters v_inout = '||v_inout);
end;
/
