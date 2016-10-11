create or replace PACKAGE BODY TEXT_HELP as
/*
test_help.pkb
by Donald J. Bales on 12/15/2006
A package to produce text based help
*/

PROCEDURE help is

begin
  TEXT_HELP.process('TEXT_HELP');
end help;


/*
A procedure to output formatted package or TYPE text
*/
PROCEDURE out(
aiv_text                       in    varchar2) is

v_text                               varchar(255);
n_text                               number := 1;

begin
  if nvl(length(aiv_text), 0) < 256 then
    v_text := aiv_text;
  else  
    v_text := substr(aiv_text, 1, 252)||'...';
  end if;
  if nvl(substr(v_text, 1, 1), chr(32)) = chr(32) then
    if length(v_text) > 0 then
      for i in 1..length(v_text) loop
        if nvl(substr(v_text, i, 1), chr(32)) <> chr(32) then
          n_text := i;
          exit;
        end if;
      end loop;
    end if;
    SYS.DBMS_OUTPUT.put_line(chr(9)||substr(v_text, n_text));
  else
    SYS.DBMS_OUTPUT.put_line(v_text);
  end if;
end out;


PROCEDURE process(
aiv_object_name               in     varchar2) is

cursor c1(
aiv_object_name               in     varchar2) is
select text
from   SYS.USER_SOURCE
where  name = upper(aiv_object_name)
and    type in ('PACKAGE', 'TYPE')
order by line;

b_method                              boolean := FALSE;
b_comment                             boolean := FALSE;
v_text                                SYS.USER_SOURCE.text%TYPE;

begin
  for r1 in c1(aiv_object_name) loop
    v_text := replace(replace(r1.text, chr(13), NULL), chr(10), NULL);
    if    substr(ltrim(v_text), 1, 3) = '/* '                      then
      if nvl(instr(v_text, '*/'), 0) = 0 then
        b_comment := TRUE;
      end if;
      out(substr(ltrim(v_text), 4));
    elsif substr(ltrim(v_text), 1, 2) = '/*'                       then
      if nvl(instr(v_text, '*/'), 0) = 0 then
        b_comment := TRUE;
      end if;
      out(substr(ltrim(v_text), 3));
    elsif b_comment                                                and
          substr(rtrim(v_text), -2, 2) = '*/'                      then
      b_comment := FALSE;
      out(substr(rtrim(v_text), 1, length(rtrim(v_text)) - 2));
    elsif b_comment                                                then
      out(v_text);
    elsif substr(ltrim(v_text), 1, 3) = '-- '                      then
      out(substr(ltrim(v_text), 4));
    elsif substr(ltrim(v_text), 1, 2) = '--'                       then
      out(substr(ltrim(v_text), 3));
    elsif upper(substr(ltrim(v_text), 1,  8)) = 'FUNCTION'         or
          upper(substr(ltrim(v_text), 1,  9)) = 'PROCEDURE'        or
          upper(substr(ltrim(v_text), 1, 15)) = 'MEMBER FUNCTION'  or
          upper(substr(ltrim(v_text), 1, 16)) = 'MEMBER PROCEDURE' or
          upper(substr(ltrim(v_text), 1, 16)) = 'STATIC FUNCTION'  or
          upper(substr(ltrim(v_text), 1, 16)) = 'STATIC PROCEDURE' then
      if nvl(instr(v_text, ';'), 0) = 0 then
        b_method := TRUE;
      end if;
      out(v_text);
    elsif b_method                                                 and
          substr(rtrim(v_text), -1, 1) = ';'                       then
      b_method := FALSE;
      out(v_text);
    elsif b_method                                                 then
      out(v_text);
    elsif c1%rowcount = 1                                          then
      out(v_text);
    elsif upper(substr(ltrim(v_text), 1, 3)) = 'END'               then
      out(chr(12)); -- form feed
      exit;
    else
      out(v_text);
    end if;
  end loop;
  SYS.DBMS_OUTPUT.new_line();
end process;


PROCEDURE test is

begin
  pl('TEXT_HELP.test()');
  
  TEST_TS.clear('TEXT_HELP');
  
  TEST_TS.set_test('TEXT_HELP', 'help()', 1, 
    'Test method help()' );
  begin
    help();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('TEXT_HELP', 'process()', 2, 
    'Test method help()' );
  begin
    process('TEXT_HELP');
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('TEXT_HELP', NULL, NULL, NULL);
  TEST_TS.success();
end test;
  

end text_help;
/
@be.sql
