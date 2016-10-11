rem debug_o.sql
rem by Donald J. Bales on 12/15/2006
rem A test unit for type DEBUG_O

declare 
  
begin
  DEBUG_O.set_text('DEBUG_O.SQL', 'before the loop');
  for i in 1..10 loop
    DEBUG_O.set_text('DEBUG_O.SQL', 'loop '||to_char(i)||' before sleep');
    SYS.DBMS_LOCK.sleep(3);
    DEBUG_O.set_text('DEBUG_O.SQL', 'loop '||to_char(i)||' after sleep');
  end loop;
  DEBUG_O.set_text('DEBUG_O.SQL:', 'after the loop');
end;
/
