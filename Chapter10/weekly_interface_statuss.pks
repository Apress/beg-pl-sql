create or replace package WEEKLY_INTERFACE_STATUSS as
/*
weekly_interface_statuss.pks
by Donald J. Bales on 12/15/2006
Table WEEKLY_INTERFACE_STATUS' routines
*/


FUNCTION get_week
return                                number;


FUNCTION is_downloaded
return                                boolean;


FUNCTION is_uploaded
return                                boolean;


PROCEDURE set_downloaded;


PROCEDURE set_uploaded;


end WEEKLY_INTERFACE_STATUSS;
/
@se.sql WEEKLY_INTERFACE_STATUSS
