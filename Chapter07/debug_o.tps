execute drop_if_exists('table','DEBUG_OT');
execute drop_if_exists('view','DEBUG_OV');
execute drop_if_exists('type','DEBUG_O');
create type  DEBUG_O as object (
/* 
debug_o.tps
by Donald Bales on 12/15/2006
Type DEBUG_O's specification:     
A type for logging debug information
*/
id                                    number,       
text                                  varchar2(256),
unique_session_id                     varchar2(24),
insert_user                           varchar2(30), 
insert_date                           date,
-- Get the next primary key value
STATIC FUNCTION get_id
return                                number,
-- A NULL values constructor
CONSTRUCTOR FUNCTION debug_o(
self                           in out nocopy debug_o)
return                                self as result,
-- A convenience constructor
CONSTRUCTOR FUNCTION debug_o(
self                           in out nocopy debug_o,
ain_id                         in     number,
aiv_text                       in     varchar2)
return                                self as result, 
-- Override the default constructor
CONSTRUCTOR FUNCTION debug_o(
self                           in out nocopy debug_o,
id                             in     number,
text                           in     varchar2,
unique_session_id              in     varchar2,
insert_user                    in     varchar2,
insert_date                    in     date)
return                                self as result, 
-- Write to the debug object table
STATIC PROCEDURE set_text(
aiv_program_unit               in     varchar2,
aiv_text                       in     varchar2),
-- A map function 
MAP MEMBER FUNCTION to_map
return                                number
) not final;
/
@se.sql
