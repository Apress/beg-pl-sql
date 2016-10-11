create or replace package NUMBERS as
/*
numbers.pks
by Donald J. Bales on 12/15/2006
A utility package for the data type NUMBER
*/

/*
Returns the passed varchar2 as a number if it represents a number,
otherwise, it returns NULL
*/
FUNCTION to_number_or_null (
aiv_number                     in     varchar2 )
return                                number;

end NUMBERS;
/
@se.sql
