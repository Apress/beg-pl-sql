rem debug_ots.sql
rem by Donald J. Bales on 12/15/2006
rem A test unit for type DEBUG_O's package

declare 
  
begin
  -- Enable debug output
  DEBUG_OTS.enable('DEBUG_OTS.SQL');
  -- Test
  DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'before the loop ');
  for i in 1..10 loop
    DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'loop '||to_char(i)||' before sleep');
    SYS.DBMS_LOCK.sleep(3);
    DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'loop '||to_char(i)||' after sleep');
  end loop;
  DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'after the loop ');

  -- Disable debug output
  DEBUG_OTS.disable('DEBUG_OTS.SQL');
  -- Test
  DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'before the loop ');
  for i in 1..10 loop
    DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'loop '||to_char(i)||' before sleep');
    -- SYS.DBMS_LOCK.sleep(3);
    DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'loop '||to_char(i)||' after sleep');
  end loop;
  DEBUG_OTS.set_text('DEBUG_OTS.SQL', 'after the loop ');
end;
/
