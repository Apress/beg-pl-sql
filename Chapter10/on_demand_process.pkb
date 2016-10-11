create or replace package body ON_DEMAND_PROCESS as
/*
on_demand_process.pkb
by Donald J. Bales on 12/15/2006

On-demand Data Processing (ON_DEMAND):
An example of an on-demand data processing package
designed to truncate report staging tables
*/

PROCEDURE help is

begin
  TEXT_HELP.process('ON_DEMAND_PROCESS');
end help;


PROCEDURE process is

n_selected                            number := 0;
n_inserted                            number := 0;
n_updated                             number := 0;
n_deleted                             number := 0;

begin
  ON_DEMAND_PROCESS_LOGS.start_logging('ON_DEMAND_PROCESS', 'process');

  -- *** Now do all your groovy data processing here! ***

  pl('OK man, I did my goovy data processing thing!');
        
  -- *** End of your groovy data processing section.  ***
  
  ON_DEMAND_PROCESS_LOGS.stop_logging(
    n_selected, n_inserted, n_updated, n_deleted, NULL);
exception
  when OTHERS then
    ON_DEMAND_PROCESS_LOGS.stop_logging(
      n_selected, n_inserted, n_updated, n_deleted, SQLERRM);
    raise;
end process;


PROCEDURE test is

begin
  -- Send feedback that the test ran
  pl('ON_DEMAND_PROCESS.test()');
  
  -- Clear the last set of test results
  TEST_TS.clear('ON_DEMAND_PROCESS');
  
  -- Tests
  TEST_TS.set_test('ON_DEMAND_PROCESS', 'help', 0, 
    'Test help');
  begin
    help();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('ON_DEMAND_PROCESS', 'process', 1, 
    'This method cannot be tested by test(), please test it manually.');
  begin
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('ON_DEMAND_PROCESS', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end ON_DEMAND_PROCESS;
/
@be.sql
