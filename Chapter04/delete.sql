rem delete.sql
rem by Donald J. Bales on 12/15/2006
rem An anonymous PL/SQL procedure to delete
rem rows using PL/SQL literals and variables

set serveroutput on size 1000000;

declare

-- I'll use this variable to hold the result
-- of the SQL delete statement.
n_count                               number;

v_code                                GENDER_T.code%TYPE := 'M';

begin

  begin
    delete from WORKER_T d
    where  d.name       = 'DOE, JOHN J.'                   -- a literal
    and    d.birth_date = to_date('19800101', 'YYYYMMDD')  -- a function
    and    d.gender_id  = (                                -- a sub-query
    select c.gender_id
    from   GENDER_T c
    where  c.code       = v_code );                        -- a variable

    n_count := sql%rowcount;
  exception
    when OTHERS then
      raise_application_error(-20001, SQLERRM||
        ' on delete WORKER_T'||
        ' in filename delete.sql');
  end;

  pl(to_char(n_count)||' row(s) deleted.');
end;
/

commit;
