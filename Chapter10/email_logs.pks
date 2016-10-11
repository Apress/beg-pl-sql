create or replace package EMAIL_LOGS as
/*
email_logs.pks
by Donald J. Bales on 12/15/2006
Table EMAIL_LOG's package
*/

FUNCTION get_id 
return                                EMAIL_LOG.id%TYPE;


PROCEDURE set_text(
aiv_text                       in     EMAIL_LOG.text%TYPE);


end EMAIL_LOGS;
/
@se.sql EMAIL_LOGS;
