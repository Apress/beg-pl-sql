create or replace package DEBUG_OTS as
/*
debug_ots.pks
by Donald J. Bales on 12/15/2006
Object Table DEBUG_OT's package
*/

-- Disable debug logging for the specified program unit
PROCEDURE disable(
aiv_program_unit               in     varchar2);

-- Enable debug logging for the specified program unit
PROCEDURE enable(
aiv_program_unit               in     varchar2);

-- Conditionally log the debug information for the specified 
-- program unit, if it is enabled
PROCEDURE set_text(
aiv_program_unit               in     varchar2,
aiv_text                       in     DEBUG_OT.text%TYPE);


end DEBUG_OTS;
/
@se.sql DEBUG_OTS;
