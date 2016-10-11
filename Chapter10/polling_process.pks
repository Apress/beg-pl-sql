create or replace package POLLING_PROCESS as
/*
polling_process.pks
by Donald J. Bales on 12/15/2006
An example of a polling data processing package
*/


PROCEDURE enable;


PROCEDURE disable;


PROCEDURE process;


PROCEDURE quit;


PROCEDURE status;


end POLLING_PROCESS;
/
@se.sql POLLING_PROCESS
