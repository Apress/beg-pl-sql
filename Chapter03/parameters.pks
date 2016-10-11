create or replace package PARAMETERS as
/*
parameters.pks
by Donald J. Bales on 12/15/2006
A packge to test parameter scope
*/

-- A function that execises the scope of parameters
FUNCTION in_out_inout(
aiv_in                         in     varchar2,
aov_out                           out varchar2,
aiov_inout                     in out varchar2)
return                                varchar2;


-- A procedure that execises the scope of parameters
PROCEDURE in_out_inout(
aiv_in                         in     varchar2,
aov_out                           out varchar2,
aiov_inout                     in out varchar2);


end PARAMETERS;
/
@se.sql PARAMETERS
