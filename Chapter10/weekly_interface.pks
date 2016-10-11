create or replace package WEEKLY_INTERFACE as
/*
weekly_interface.pks
by Donald J. Bales on 12/15/2006
An example of a weekly interface process
*/


PROCEDURE download;


FUNCTION is_downloaded 
return                                number;


PROCEDURE process;


PROCEDURE set_downloaded;


PROCEDURE upload;


FUNCTION is_verified
return                                boolean;


end WEEKLY_INTERFACE;
/
@se.sql WEEKLY_INTERFACE;
