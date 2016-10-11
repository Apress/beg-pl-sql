create or replace package POLLING_PROCESS_QUEUES as
/*
polling_process_queues.pks
by Donald J. Bales on 12/15/2006
Table POLLING_PROCESS_QUEUE's routines
*/

v_DISABLE                   constant  POLLING_PROCESS_QUEUE.command%TYPE := 'DISABLE';
v_ENABLE                    constant  POLLING_PROCESS_QUEUE.command%TYPE := 'ENABLE';
v_QUIT                      constant  POLLING_PROCESS_QUEUE.command%TYPE := 'QUIT';


PROCEDURE disable;


PROCEDURE enable;


FUNCTION get_id 
return                                POLLING_PROCESS_QUEUE.id%TYPE;


FUNCTION get_next(
air_polling_process_queue      in     POLLING_PROCESS_QUEUE%ROWTYPE)
return                                POLLING_PROCESS_QUEUE%ROWTYPE;


PROCEDURE quit;


PROCEDURE set_next(
aiv_command                    in     POLLING_PROCESS_QUEUE.command%TYPE);


end POLLING_PROCESS_QUEUES;
/
@se.sql POLLING_PROCESS_QUEUES
