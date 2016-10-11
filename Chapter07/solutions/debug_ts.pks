create or replace package DEBUG_TS as
/*
debug_ts.pks
by Donald J. Bales on 12/15/2006
Table DEBUG_T's package
*/

-- Gets the next primary key value for the table
FUNCTION get_id
return                                DEBUG_T.id%TYPE;

-- Enable debug output for the specified program unit
PROCEDURE enable(
aiv_program_unit               in     varchar2);

-- Disable debug output for the specified program unit
PROCEDURE disable(
aiv_program_unit               in     varchar2);

-- Log debug output if enabled for the specified program unit
PROCEDURE set_text(
aiv_program_unit               in     varchar2,
aiv_text                       in     DEBUG_T.text%TYPE);


end DEBUG_TS;
/
@se.sql DEBUG_TS;
