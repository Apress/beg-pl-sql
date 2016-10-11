rem cursor_the_doe_family.sql
rem by Donald J. Bales on 12/15/2006
rem An anonymous PL/SQL procedure to select
rem the first names for the Doe family from
rem the Worker table.

set serveroutput on size 1000000;

declare

cursor c_worker(
aiv_last_name                  in     WORKER_T.last_name%TYPE) is
select first_name
from   WORKER_T
where  last_name like aiv_last_name||'%'
order by id;

v_first_name                          WORKER_T.first_name%TYPE;

begin
  open c_worker('DOE');
  loop
    fetch c_worker into v_first_name;

    if c_worker%notfound then 
      close c_worker;
      exit;
    end if;

    pl(v_first_name);
  end loop;
end;
/
