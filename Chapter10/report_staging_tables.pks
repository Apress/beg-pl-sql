create or replace package REPORT_STAGING_TABLES as
/*
report_staging_tables.pks
by Donald J. Bales on 12/15/2006

On-demand Data Processing (ODP):
An example of an on-demand data processing package
designed to truncate report staging tables
*/

-- Display this package's help text.

PROCEDURE help;


-- Delete any data more than two days old from the report staging tables.

PROCEDURE process;


-- Test this package's methods.

PROCEDURE test;


end REPORT_STAGING_TABLES;
/
@be.sql
