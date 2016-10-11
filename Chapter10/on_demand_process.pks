create or replace package ON_DEMAND_PROCESS as
/*
on_demand_process.pks
by Donald J. Bales on 12/15/2006

On-demand Data Processing (ON_DEMAND):
An example of an on-demand data processing package
designed to truncate report staging tables
*/

PROCEDURE help;


PROCEDURE process;


PROCEDURE test;


end ON_DEMAND_PROCESS;
/
@se.sql
