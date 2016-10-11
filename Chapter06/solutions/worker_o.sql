declare

o_worker                              worker_o;

begin
  o_worker := new worker_o();
  o_worker.first_name  := 'JOHN';
  o_worker.middle_name := 'J.';
  o_worker.last_name   := 'DOE';
  o_worker.name        := worker_o.get_formatted_name(
    o_worker.first_name,
    o_worker.middle_name,
    o_worker.last_name );
  o_worker.birth_date  := trunc(SYSDATE - (40*365.25));

  pl(o_worker.to_varchar2);
  
  o_worker.test();  
end;
/
