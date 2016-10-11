create or replace package body POLLING_PROCESS_QUEUES as
/*
polling_process_queues.pkb
by Donald J. Bales on 12/15/2006
Table POLLING_PROCESS_QUEUE's routines
*/


FUNCTION get_id 
return                                POLLING_PROCESS_QUEUE.id%TYPE is

id                                    POLLING_PROCESS_QUEUE.id%TYPE;

begin
  select POLLING_PROCESS_QUEUE_ID_SEQ.nextval
  into   id
  from   SYS.DUAL;
  
  return id;
end get_id;


FUNCTION get_next(
air_polling_process_queue      in     POLLING_PROCESS_QUEUE%ROWTYPE)
return                                POLLING_PROCESS_QUEUE%ROWTYPE is

pragma autonomous_transaction;

r_polling_process_queue               POLLING_PROCESS_QUEUE%ROWTYPE;

begin
  delete POLLING_PROCESS_QUEUE
  where  id = 
    air_polling_process_queue.id;
    
  begin
    select q.*
    into   r_polling_process_queue
    from   POLLING_PROCESS_QUEUE q
    where  q.id = (
    select min(n.id) 
    from   POLLING_PROCESS_QUEUE n);
  exception
    when NO_DATA_FOUND then
      r_polling_process_queue := NULL;
  end;
  
  commit;

  return r_polling_process_queue;
end get_next;


PROCEDURE disable is

pragma autonomous_transaction;

begin
  begin
    insert into POLLING_PROCESS_QUEUE (
           id,
           command,
           insert_user,
           insert_date )
    values (       
           -3,
           v_DISABLE,
           USER,
           SYSDATE );
    pl('Queued to disable logging.');
  exception
    when DUP_VAL_ON_INDEX then
      pl('Already queued to disable logging.');
  end;    

  commit;
end disable;


PROCEDURE enable is

pragma autonomous_transaction;

begin
  begin
    insert into POLLING_PROCESS_QUEUE (
           id,
           command,
           insert_user,
           insert_date )
    values (       
           -2,
           v_ENABLE,
           USER,
           SYSDATE );
    pl('Queued to enable logging.');
  exception
    when DUP_VAL_ON_INDEX then
      pl('Already queued enable logging.');
  end;    

  commit;
end enable;


PROCEDURE quit is

pragma autonomous_transaction;

begin
  begin
    insert into POLLING_PROCESS_QUEUE (
           id,
           command,
           insert_user,
           insert_date )
    values (       
           -1,
           v_QUIT,
           USER,
           SYSDATE );
    pl('Queued to quit.');
  exception
    when DUP_VAL_ON_INDEX then
      pl('Already queued to quit.');
  end;    

  commit;
end quit;


PROCEDURE set_next(
aiv_command                    in     POLLING_PROCESS_QUEUE.command%TYPE) is

pragma autonomous_transaction;

begin
  insert into POLLING_PROCESS_QUEUE (
         id,
         command,
         insert_user,
         insert_date )
  values (       
         get_id(),
         aiv_command,
         USER,
         SYSDATE );

  commit;
end set_next;


end POLLING_PROCESS_QUEUES;
/
@be.sql POLLING_PROCESS_QUEUES
