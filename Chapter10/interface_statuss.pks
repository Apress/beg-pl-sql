create or replace package INTERFACE_STATUSS as
/*
interface_statuss.pks
by Donald J. Bales on 12/15/2006
Table INTERFACE_STATUS' routines
*/


-- This function will be used for the primary key instead of get_id
FUNCTION get_week
return                                number;

-- Return true if the interface has already downloaded
FUNCTION is_downloaded
return                                boolean;

-- Return true if the interface has already uploaded
FUNCTION is_uploaded
return                                boolean;

-- Set the status to downloaded
PROCEDURE set_downloaded;

-- Set the status to uploaded
PROCEDURE set_uploaded;


end INTERFACE_STATUSS;
/
@se.sql INTERFACE_STATUSS
