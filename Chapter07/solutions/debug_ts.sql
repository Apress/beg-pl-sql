rem debug_ts.sql
rem by Donald J. Bales on 12/15/2006
rem Test unit for package DEBUG_TS

declare 
  
v_program_unit                        varchar2(30) := 
  'debug_ts.sql';
  
begin
  DEBUG_TS.enable(v_program_unit);
  DEBUG_TS.set_text(v_program_unit, 'before the loop ');
  for i in 1..10 loop
    DEBUG_TS.set_text(v_program_unit, 'loop '||to_char(i)||' before sleep');
    SYS.DBMS_LOCK.sleep(3);
    DEBUG_TS.set_text(v_program_unit, 'loop '||to_char(i)||' after sleep');
  end loop;
  DEBUG_TS.set_text(v_program_unit, 'after the loop ');
  DEBUG_TS.disable(v_program_unit);
  DEBUG_TS.set_text(v_program_unit, 'before the loop ');
  for i in 1..10 loop
    DEBUG_TS.set_text(v_program_unit, 'loop '||to_char(i)||' before sleep');
    -- SYS.DBMS_LOCK.sleep(3);
    DEBUG_TS.set_text(v_program_unit, 'loop '||to_char(i)||' after sleep');
  end loop;
  DEBUG_TS.set_text(v_program_unit, 'after the loop ');
end;
/
