rem worker_type_ot.sql
rem by Donald J. Bales on 12/15/2006
rem test unit for object table WORKER_TYPE_OT

declare
-- Declare a variable of the user-define type
o_worker_type                         WORKER_TYPE_O;

begin
  -- Insert a test object using the convenience constructor
  insert into WORKER_TYPE_OT
  values ( WORKER_TYPE_O( 'T', 'Test') );
  
  -- Now update the inactive date on the object
  update WORKER_TYPE_OT
  set    inactive_date = SYSDATE
  where  code          = 'T';
  
  -- Retrieve the object in order to show its values
  select value(g)
  into   o_worker_type
  from   WORKER_TYPE_OT g
  where  code          = 'T';
  
  -- Show the object's values
  pl('o_worker_type.id             = '||o_worker_type.id);
  pl('o_worker_type.code           = '||o_worker_type.code);
  pl('o_worker_type.description    = '||o_worker_type.description);
  pl('o_worker_type.active_date    = '||o_worker_type.active_date);
  pl('o_worker_type.inactive_date  = '||o_worker_type.inactive_date);
  
  -- Delete the test object
  delete WORKER_TYPE_OT
  where  code          = 'T';

  -- This time insert the test object using the instance variable
  insert into WORKER_TYPE_OT
  values ( o_worker_type );
  
  -- Last, delete the object from the relational table
  delete WORKER_TYPE_OT
  where  code          = 'T';
  
  -- Commit all these operations
  commit;
  
  -- Confirm that the test completed successfully
  pl('Test completed successfully.');
end;
/
