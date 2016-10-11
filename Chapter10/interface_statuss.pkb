create or replace package body INTERFACE_STATUSS as
/*
interface_statuss.pkb
by Donald J. Bales on 12/15/2006
Table INTERFACE_STATUS' routines
*/


-- This function will be used for the primary key instead of get_id

FUNCTION get_week
return                                number is

begin
  return to_char(SYSDATE, 'YYYYWW');
end get_week;


FUNCTION is_downloaded
return                                boolean is

pragma autonomous_transaction;

d_download_date                       INTERFACE_STATUS.download_date%TYPE;

begin
  begin
    select download_date
    into   d_download_date
    from   INTERFACE_STATUS
    where  id = INTERFACE_STATUSS.get_week;
  exception
    when NO_DATA_FOUND then
      d_download_date := NULL;
  end;
  
  if d_download_date is not NULL then
    return TRUE;
  else
    return FALSE;
  end if;
end is_downloaded;


FUNCTION is_uploaded 
return                                boolean is

pragma autonomous_transaction;

d_upload_date                         INTERFACE_STATUS.upload_date%TYPE;

begin
  begin
    select upload_date
    into   d_upload_date
    from   INTERFACE_STATUS
    where  id = INTERFACE_STATUSS.get_week;
  exception
    when NO_DATA_FOUND then
      d_upload_date := NULL;
  end;
  
  if d_upload_date is not NULL then
    return TRUE;
  else
    return FALSE;
  end if;
end is_uploaded;


PROCEDURE set_downloaded is

pragma autonomous_transaction;

begin
  update INTERFACE_STATUS
  set    download_date       = SYSDATE,
         update_user         = USER,
         update_date         = SYSDATE
  where  id = INTERFACE_STATUSS.get_week;

  if nvl(sql%rowcount, 0) = 0 then
    insert into INTERFACE_STATUS (
           id,
           download_date )
    values (
           INTERFACE_STATUSS.get_week,
           SYSDATE );
  end if;
  
  commit;
end set_downloaded;


PROCEDURE set_uploaded is

pragma autonomous_transaction;

begin
  update INTERFACE_STATUS
  set    upload_date         = SYSDATE,
         update_user         = USER,
         update_date         = SYSDATE
  where  id = INTERFACE_STATUSS.get_week;

  if nvl(sql%rowcount, 0) = 0 then
    insert into INTERFACE_STATUS (
           id,
           upload_date )
    values (
           INTERFACE_STATUSS.get_week,
           SYSDATE );
  end if;
  
  commit;
end set_uploaded;


end INTERFACE_STATUSS;
/
@be.sql INTERFACE_STATUSS
