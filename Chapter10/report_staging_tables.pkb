create or replace package body REPORT_STAGING_TABLES as
/*
report_tables.pkb
by Donald J. Bales on 12/15/2006

On-demand Data Processing (ON_DEMAND):
An example of an on-demand data processing package
designed to truncate report staging tables
*/

PROCEDURE help is

begin
  TEXT_HELP.process('REPORT_STAGING_TABLES');
end help;


PROCEDURE Process is

-- Get a list of all the tables that start with REPORT_ in BPS' schema
cursor c_table is
select table_name
from   SYS.ALL_TABLES
where  owner         = 'BPS'
and    table_name like 'REPORT\_%' escape '\'
order by 1;

n_selected                            number := 0;
n_deleted                             number := 0;

begin
  -- Start logging
  ON_DEMAND_PROCESS_LOGS.start_logging(
    'REPORT_STAGING_TABLES', 'process');
  
  -- For each report "staging" table, delete any data over 2 days old
  for r_table in c_table loop
    n_selected := n_selected + 1;
    
    execute immediate 'delete '||
      r_table.table_name||
      ' where insert_date < SYSDATE - 2';
    
    n_deleted := n_deleted + nvl(sql%rowcount, 0);
  end loop;
  
  -- Stop logging
  ON_DEMAND_PROCESS_LOGS.stop_logging(
    n_selected, NULL, NULL, n_deleted, NULL);
exception
  when OTHERS then
    -- Stop logging, but report an error
    ON_DEMAND_PROCESS_LOGS.stop_logging(
      n_selected, NULL, NULL, n_deleted, SQLERRM);
    raise;
end process;


PROCEDURE test is

begin
  -- Send feedback that the test ran
  pl('REPORT_STAGING_TABLES.test()');
  
  -- Clear the last set of test results
  TEST_TS.clear('REPORT_STAGING_TABLES');
  
  -- Tests
  TEST_TS.set_test('REPORT_STAGING_TABLES', 'help', 0, 
    'Test help');
  begin
    help();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('REPORT_STAGING_TABLES', 'process', 1, 
    'This method cannot be tested by test(), please test it manually.');
  begin
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('REPORT_STAGING_TABLES', NULL, NULL, NULL);
  TEST_TS.success();
end test;


end REPORT_STAGING_TABLES;
/
@be.sql
