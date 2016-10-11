rem bulk_collect_the_doe_family.sql
rem by Donald J. Bales on 12/15/2006
rem An anonymous PL/SQL procedure to select
rem the first names for the Doe family from
rem the Worker table.

set serveroutput on size 1000000;

declare

TYPE worker_table is table of WORKER_T.first_name%TYPE
index by binary_integer;

t_worker                              worker_table;

begin
  select first_name
  BULK COLLECT 
  into   t_worker
  from   WORKER_T
  where  last_name like 'DOE%'
  order by id;

  for i in t_worker.first..t_worker.last loop
    pl(t_worker(i));
  end loop;
end;
/
