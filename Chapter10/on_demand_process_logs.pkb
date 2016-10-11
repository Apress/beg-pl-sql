create or replace package body ON_DEMAND_PROCESS_LOGS as
/*
on_demand_process_logs.pkb
by Donald J. Bales on 12/15/2006

Table ON_DEMAND_PROCESS_LOG routines
*/


-- Instance variables to hold log information between start and stop

n_id                                  ON_DEMAND_PROCESS_LOG.id%TYPE;
n_start                               number;


FUNCTION get_id 
return                                ON_DEMAND_PROCESS_LOG.id%TYPE is

n_id                                  ON_DEMAND_PROCESS_LOG.id%TYPE;

begin
  select ON_DEMAND_PROCESS_LOG_ID_SEQ.nextval
  into   n_id
  from   SYS.DUAL;
  
  return n_id;
end get_id;


PROCEDURE help is

begin
  TEXT_HELP.process('ON_DEMAND_PROCESS_LOGS');
end help;


PROCEDURE start_logging(
aiv_object_name                in     ON_DEMAND_PROCESS_LOG.object_name%TYPE,
aiv_method_name                in     ON_DEMAND_PROCESS_LOG.method_name%TYPE) is

pragma autonomous_transaction;

begin
  n_start := to_number(to_char(SYSDATE, 'SSSSS'));
  n_id    := get_id();

  insert into ON_DEMAND_PROCESS_LOG (
         id,
         object_name,
         method_name )
  values (
         n_id,
         upper(aiv_object_name),
         upper(aiv_method_name) );
  commit;
end start_logging;
  

PROCEDURE stop_logging(
ain_rows_selected              in     ON_DEMAND_PROCESS_LOG.rows_selected%TYPE,
ain_rows_inserted              in     ON_DEMAND_PROCESS_LOG.rows_inserted%TYPE,
ain_rows_updated               in     ON_DEMAND_PROCESS_LOG.rows_updated%TYPE,
ain_rows_deleted               in     ON_DEMAND_PROCESS_LOG.rows_deleted%TYPE,
aiv_result                     in     ON_DEMAND_PROCESS_LOG.result%TYPE) is

pragma autonomous_transaction;

n_elapsed_time                        number;

begin
  n_elapsed_time := to_number(to_char(SYSDATE, 'SSSSS')) - n_start;

  update ON_DEMAND_PROCESS_LOG 
  set    rows_selected            = ain_rows_selected,
         rows_inserted            = ain_rows_inserted,
         rows_updated             = ain_rows_updated,
         rows_deleted             = ain_rows_deleted,
         result                   = aiv_result,
         elapsed_time             = n_elapsed_time,
         update_user              = USER,
         update_date              = SYSDATE
  where  id = n_id;
  commit;
  
  n_id := NULL;

  -- Display the results
  if ain_rows_selected is not null then
    pl(to_char(ain_rows_selected)||' rows selected.');
  end if;
  if ain_rows_inserted is not null then
    pl(to_char(ain_rows_inserted)||' rows inserted.');
  end if;
  if ain_rows_updated is not null then
    pl(to_char(ain_rows_updated)||' rows updated.');
  end if;
  if ain_rows_deleted is not null then
    pl(to_char(ain_rows_deleted)||' rows deleted.');
  end if;
  if aiv_result is not null then
    pl(aiv_result);
  end if;
  pl('Elapsed time: '||to_char(n_elapsed_time)||' seconds.');
end stop_logging;


PROCEDURE stop_logging(
aiv_result                     in     ON_DEMAND_PROCESS_LOG.result%TYPE) is

begin
  stop_logging(NULL, NULL, NULL, NULL, aiv_result);
end stop_logging;


PROCEDURE stop_logging is

begin
  stop_logging(NULL, NULL, NULL, NULL, NULL);
end stop_logging;


PROCEDURE test is

begin
  -- Send feedback that the test ran
  pl('ON_DEMAND_PROCESS_LOGS.test()');
  
  -- Clear the last set of test results
  TEST_TS.clear('ON_DEMAND_PROCESS_LOGS');
  
  -- Tests
  TEST_TS.set_test('ON_DEMAND_PROCESS_LOGS', 'start_logging()', 0, 
    'start logging');
  begin
    start_logging('ON_DEMAND_PROCESS_LOGS', 'test');
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('ON_DEMAND_PROCESS_LOGS', 'stop_logging()', 1, 
    'stop logging');
  begin
    SYS.DBMS_LOCK.sleep(3);
    
    stop_logging();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('ON_DEMAND_PROCESS_LOGS', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end ON_DEMAND_PROCESS_LOGS;
/
@be.sql
