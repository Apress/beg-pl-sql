rem gender_ov.sql
rem by Donald J. Bales on 12/15/2006
rem test unit for object view GENDER_OV

declare
-- Declare a variable of the user-define type
o_gender                              GENDER_O;
-- Declare a variable for t6he under-lying table
r_gender                              GENDER_T%ROWTYPE;

begin
  -- Insert a test object using the convenience constructor
  insert into GENDER_OV
  values ( GENDER_O( 'T', 'Test') );
  
  -- Now update the inactive date on the object
  update GENDER_OV
  set    inactive_date = SYSDATE
  where  code          = 'T';
  
  -- Retrieve the object in order to show its values
  select value(g)
  into   o_gender
  from   GENDER_OV g
  where  code          = 'T';
  
  -- Show the object's values
  pl('o_gender.id            = '||o_gender.id);
  pl('o_gender.code          = '||o_gender.code);
  pl('o_gender.description   = '||o_gender.description);
  pl('o_gender.active_date   = '||o_gender.active_date);
  pl('o_gender.inactive_date = '||o_gender.inactive_date);
  
  -- Delete the test object
  delete GENDER_OV
  where  code          = 'T';

  -- This time insert the test object using the instance variable
  insert into GENDER_OV
  values ( o_gender );
  
  -- Now, select the values from the under-lying relational table
  select *
  into   r_gender
  from   GENDER_T
  where  code          = 'T';
  
  -- Show the record's values
  pl('r_gender.id            = '||r_gender.id);
  pl('r_gender.code          = '||r_gender.code);
  pl('r_gender.description   = '||r_gender.description);
  pl('r_gender.active_date   = '||r_gender.active_date);
  pl('r_gender.inactive_date = '||r_gender.inactive_date);

  -- Last, delete the object from the relational table
  delete GENDER_T
  where  code          = 'T';
  
  -- Commit all these operations
  commit;
  
  -- Confirm that the test completed successfully
  pl('Test completed successfully.');
end;
/
