create or replace package ON_DEMAND_PROCESS_LOGS as
/*
on_demand_process_logs.pks
by Donald J. Bales on 12/15/2006
Table ON_DEMAND_PROCESS_LOG routines
*/


-- Display this packages help text.

PROCEDURE help;

-- Start logging the use of an on-demand data processing process

PROCEDURE start_logging(
aiv_object_name                in     ON_DEMAND_PROCESS_LOG.object_name%TYPE,
aiv_method_name                in     ON_DEMAND_PROCESS_LOG.method_name%TYPE);

-- Stop logging the use of an on-demand data processing process

PROCEDURE stop_logging(
ain_rows_selected              in     ON_DEMAND_PROCESS_LOG.rows_selected%TYPE,
ain_rows_inserted              in     ON_DEMAND_PROCESS_LOG.rows_inserted%TYPE,
ain_rows_updated               in     ON_DEMAND_PROCESS_LOG.rows_updated%TYPE,
ain_rows_deleted               in     ON_DEMAND_PROCESS_LOG.rows_deleted%TYPE,
aiv_result                     in     ON_DEMAND_PROCESS_LOG.result%TYPE);

-- Stop logging the use of an on-demand data processing process

PROCEDURE stop_logging(
aiv_result                     in     ON_DEMAND_PROCESS_LOG.result%TYPE);

-- Stop logging the use of an on-demand data processing process

PROCEDURE stop_logging;

-- Test the methods in this package

PROCEDURE test;


end ON_DEMAND_PROCESS_LOGS;
/
@se.sql
