rem worker_type_ov.sql
rem by Donald J. Bales on 12/15/2006
rem test unit for object view WORKER_TYPE_OV

declare
-- Declare a variable of the user-define type
o_worker_type                         WORKER_TYPE_O;
-- Declare a variable for t6he under-lying table
r_worker_type                         WORKER_TYPE_T%ROWTYPE;

begin
  -- Insert a test object using the convenience constructor
  insert into WORKER_TYPE_OV
  values ( WORKER_TYPE_O( 'T', 'Test') );
  
  -- Now update the inactive date on the object
  update WORKER_TYPE_OV
  set    inactive_date = SYSDATE
  where  code          = 'T';
  
  -- Retrieve the object in order to show its values
  select value(g)
  into   o_worker_type
  from   WORKER_TYPE_OV g
  where  code          = 'T';
  
  -- Show the object's values
  pl('o_worker_type.id             = '||o_worker_type.id);
  pl('o_worker_type.code           = '||o_worker_type.code);
  pl('o_worker_type.description    = '||o_worker_type.description);
  pl('o_worker_type.active_date    = '||o_worker_type.active_date);
  pl('o_worker_type.inactive_date  = '||o_worker_type.inactive_date);
  
  -- Delete the test object
  delete WORKER_TYPE_OV
  where  code          = 'T';

  -- This time insert the test object using the instance variable
  insert into WORKER_TYPE_OV
  values ( o_worker_type );
  
  -- Now, select the values from the under-lying relational table
  select *
  into   r_worker_type
  from   WORKER_TYPE_T
  where  code          = 'T';
  
  -- Show the record's values
  pl('r_worker_type.id             = '||r_worker_type.id);
  pl('r_worker_type.code           = '||r_worker_type.code);
  pl('r_worker_type.description    = '||r_worker_type.description);
  pl('r_worker_type.active_date    = '||r_worker_type.active_date);
  pl('r_worker_type.inactive_date  = '||r_worker_type.inactive_date);

  -- Last, delete the object from the relational table
  delete WORKER_TYPE_T
  where  code          = 'T';
  
  -- Commit all these operations
  commit;
  
  -- Confirm that the test completed successfully
  pl('Test completed successfully.');
end;
/
