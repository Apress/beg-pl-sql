create or replace function INCR(
ain_number                     in out number)
return                                number is
/*
incr.fun
by Donald J. Bales on 12/15/2006
A function that increments a numeric variable
*/

begin
  ain_number := nvl(ain_number, 0) + 1;
  return ain_number;
end INCR;
/
@fe.sql INCR
