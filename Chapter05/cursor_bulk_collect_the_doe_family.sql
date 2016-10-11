rem cursor_bulk_collect_the_doe_family.sql
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

TYPE c_worker_table is table of c_worker%ROWTYPE
index by binary_integer;

t_worker                              c_worker_table;

begin
  open c_worker('DOE');
  loop
    fetch c_worker bulk collect into t_worker limit 2;
    
    exit when t_worker.count = 0;
    
    for i in t_worker.first..t_worker.last loop
      pl(t_worker(i).first_name);
    end loop;
  end loop;
end;
/
