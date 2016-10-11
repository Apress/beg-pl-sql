create or replace package body NUMBERS as
/*
numbers.pkb
by Donald J. Bales on 12/15/2006
A utility package for the data type NUMBER
*/

FUNCTION to_number_or_null (
aiv_number                     in     varchar2 )
return                                number is
begin
  return to_number(aiv_number);
exception
  when OTHERS then
    return NULL;
end to_number_or_null;

end NUMBERS;
/
@be.sql
