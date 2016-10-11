create or replace FUNCTION to_boolean_number(
aib_boolean                    in     boolean )
return                                number is
/*
to_boolean_number.fun
by Donald J. Bales on 12/15/2006
A method to return a numeric value for false (0) and true (1).
This is very handy for calling functions that return boolean
values from JDBC, which can't handle boolean database values.
*/
begin
  if aib_boolean is not null then
    if aib_boolean then
      return 1;
    else
      return 0;
    end if;
  else
    return NULL;
  end if;
end to_boolean_number;
/
@fe.sql TO_BOOLEAN_NUMBER
