create or replace package REPORT_STAGING_TABLE_LOGS as
/*
report_staging_table_logs.pks
by Donald J. Bales on 12/15/2006
Table REPORT_STAGING_TABLE_LOG routines
*/


-- Display this packages help text.

PROCEDURE help;

-- Start logging the use of an on-demand data processing process

PROCEDURE start_logging(
aiv_object_name                in     REPORT_STAGING_TABLE_LOG.object_name%TYPE,
aiv_method_name                in     REPORT_STAGING_TABLE_LOG.method_name%TYPE);

-- Stop logging the use of an on-demand data processing process

PROCEDURE stop_logging(
ain_rows_selected              in     REPORT_STAGING_TABLE_LOG.rows_selected%TYPE,
ain_rows_inserted              in     REPORT_STAGING_TABLE_LOG.rows_inserted%TYPE,
ain_rows_updated               in     REPORT_STAGING_TABLE_LOG.rows_updated%TYPE,
ain_rows_deleted               in     REPORT_STAGING_TABLE_LOG.rows_deleted%TYPE,
aiv_result                     in     REPORT_STAGING_TABLE_LOG.result%TYPE);

-- Stop logging the use of an on-demand data processing process

PROCEDURE stop_logging(
aiv_result                     in     REPORT_STAGING_TABLE_LOG.result%TYPE);

-- Stop logging the use of an on-demand data processing process

PROCEDURE stop_logging;

-- Test the methods in this package

PROCEDURE test;


end REPORT_STAGING_TABLE_LOGS;
/
@se.sql
