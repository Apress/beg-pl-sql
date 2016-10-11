create or replace package TOP_100_NAMES as
/*
top_100_names.pks
by Donald J. Bales on 12/15/2006

Data Migration:
  Seed the Worker table with the top 100 names
  100 last x 100 first x 26 middle = 260,000 entries
*/

/*
Display the help text for this package.
*/
PROCEDURE help;

/*
Initializes package pseudo-constants, it is called 
by the package body's initialization section.
*/
PROCEDURE Initialize;

/*
Migrates data (inserts or updates) from tables TOP_100_LAST_NAME,
TOP_100_FIRST_NAME, and A_THRU_Z to table WORKER_TS
*/ 
PROCEDURE Process;

/*
Test the methods in this package
*/
PROCEDURE test;

end TOP_100_NAMES;
/
@se.sql
