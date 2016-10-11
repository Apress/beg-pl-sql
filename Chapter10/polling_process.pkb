create or replace package body POLLING_PROCESS as
/*
polling_process.pkb
by Donald J. Bales on 12/15/2006
An example of a polling data processing package
*/


PROCEDURE disable is

begin
  POLLING_PROCESS_QUEUES.disable();
end disable;


PROCEDURE enable is

begin
  POLLING_PROCESS_QUEUES.enable();
end enable;


PROCEDURE process is

r_polling_process_queue               POLLING_PROCESS_QUEUE%ROWTYPE;

begin
  DEBUG_TS.set_text('POLLING_PROCESS', 'Starting');

  -- perform a manual loop until it recieves a command to quit
  loop
    DEBUG_TS.set_text('POLLING_PROCESS', 'Getting next command');

    -- Get the next command from the queue
    r_polling_process_queue := 
      POLLING_PROCESS_QUEUES.get_next(r_polling_process_queue);
    
    -- If it's time to quit, pool the queue once more to delete 
    -- the quit command, and then exit
    if r_polling_process_queue.command = 
         POLLING_PROCESS_QUEUES.v_QUIT then

      POLLING_PROCESS_STATUSS.set_status('Quiting');
      
      DEBUG_TS.set_text('POLLING_PROCESS', 'Quiting');

      r_polling_process_queue := 
        POLLING_PROCESS_QUEUES.get_next(r_polling_process_queue);
      exit;
    elsif r_polling_process_queue.command = 'DISABLE' then
      DEBUG_TS.disable('POLLING_PROCESS');
    elsif r_polling_process_queue.command = 'ENABLE'  then
      DEBUG_TS.enable('POLLING_PROCESS');
    end if;
  
    -- *** Now do all your groovy data processing here! ***

    POLLING_PROCESS_STATUSS.set_status('Processing');
        
    DEBUG_TS.set_text('POLLING_PROCESS',
      'I''m doing some groovy data processing at '||
      to_char(SYSDATE, 'HH:MI:SS'));  
        
    -- *** End of your groovy data processing section.  ***
  
    POLLING_PROCESS_STATUSS.set_status('Sleeping');

    DEBUG_TS.set_text('POLLING_PROCESS', 'Sleeping');

    -- Sleep for 10 seconds
    SYS.DBMS_LOCK.sleep(10);

    DEBUG_TS.set_text('POLLING_PROCESS', 'Awake');
  end loop;
end process;


PROCEDURE quit is

begin
  POLLING_PROCESS_QUEUES.quit();
end quit;


PROCEDURE status is

begin
  pl(POLLING_PROCESS_STATUSS.get_status);
end status;


end POLLING_PROCESS;
/
@be.sql POLLING_PROCESS
