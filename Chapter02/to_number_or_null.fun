create or replace FUNCTION to_number_or_null (
aiv_number                     in     varchar2 )
return                                number is
/*
to_number_or_null.fun
by Donald J. Bales on 12/15/2006
An errorless to_number( ) method
*/
begin
  return to_number(aiv_number);
exception
  when INVALID_NUMBER then
    return NULL;
end to_number_or_null;
/
@fe.sql to_number_or_null;
