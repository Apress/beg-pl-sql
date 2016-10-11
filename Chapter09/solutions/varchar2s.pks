create or replace package VARCHAR2S as
/*
varchar2s.pks
Copyright by Donald J. Bales on 12/15/2006
VARCHAR2 data type utilities
*/

-- Returns a randomly generated character between the specificed starting and 
-- ending character values.
FUNCTION random(
aiv_starting_character                varchar2,
aiv_ending_character                  varchar2)
return                                varchar2;

-- This package's test units
PROCEDURE test;


end VARCHAR2S;
/
@se.sql VARCHAR2S
