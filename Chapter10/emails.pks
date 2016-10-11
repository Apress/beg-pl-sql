create or replace package EMAILS as
/*
emails.pks
by Donald J. Bales on 12/15/2006
Package to send emails
*/


TYPE LINES is table of varchar2(2000) index by binary_integer;


FUNCTION get_domain
return                                varchar2;


FUNCTION get_host
return                                varchar2;


FUNCTION get_username
return                                varchar2;


PROCEDURE send(
aiv_from                       in     varchar2,
aiv_to                         in     varchar2,
aiv_subject                    in     varchar2,
ait_lines                      in     LINES);


PROCEDURE set_domain(
aiv_domain                     in     varchar2);


PROCEDURE set_host(
aiv_host                       in     varchar2);


PROCEDURE set_password(
aiv_password                   in     varchar2);


PROCEDURE set_username(
aiv_username                   in     varchar2);


PROCEDURE test;


end EMAILS;
/
@be.sql EMAILS
