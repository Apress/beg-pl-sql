create or replace package body WEEKLY_INTERFACE as
/*
weekly_interface.pkb
by Donald J. Bales on 12/15/2006
An example of a weekly interface process
*/


PROCEDURE download is

begin
  pl('Executing download()');
  -- You can code this procedure to move data between systems
  -- using an Oracle database link, loaded JDBC driver and class,
  -- etc.  Or, you can change this message to remind the user
  -- that this is an asynchronous process handled by an external
  -- program.

  set_downloaded();
end download;


FUNCTION is_downloaded 
return                                number is

begin
  -- A function that returns a 1 or 0 from TRUE and FALSE
  -- from WEEKLY_INTERFACE_STATUSS.is_downloaded()
  return to_boolean_number(WEEKLY_INTERFACE_STATUSS.is_downloaded());
end is_downloaded;


PROCEDURE process is

begin
  if not WEEKLY_INTERFACE_STATUSS.is_downloaded() then
    download();
    if not WEEKLY_INTERFACE_STATUSS.is_downloaded() then
      pl('WARNING: download() did not complete successfully.');
    end if;
  end if;
        
  if WEEKLY_INTERFACE_STATUSS.is_downloaded() then
    if not WEEKLY_INTERFACE_STATUSS.is_uploaded() then
      upload();
      if not WEEKLY_INTERFACE_STATUSS.is_uploaded() then
        pl('WARNING: upload() did not complete successfully.');
      end if;
    end if;
  end if;

  pl('process() completed successfully.');
end process;


PROCEDURE set_downloaded is

begin
  WEEKLY_INTERFACE_STATUSS.set_downloaded();
end set_downloaded;


PROCEDURE upload is

-- Add cursor(s) used to loop through the staging data here.

begin
  pl('Executing upload()');
  if is_verified() then

    -- Add your data migration code here.

    WEEKLY_INTERFACE_STATUSS.set_uploaded();
  end if;
end upload;


FUNCTION is_verified
return                                boolean is

begin
  pl('Executing is_verified');

  -- Add your code value mapping verifcation routine here.
  -- You know! They call it a powtaytow, you call it a potato.
  -- This method will verify that translation mapping exist,
  -- where ever they exist, in what ever fashion the exist.
  return TRUE;
end is_verified;


end WEEKLY_INTERFACE;
/
@be.sql WEEKLY_INTERFACE;
