declare

n_major                               number;
n_minor                               number;

begin
  DBMS_PROFILER.get_version(n_major, n_minor);
  
  pl('DBMS_PROFILER Version '||
    to_char(n_major)||'.'||
    to_char(n_minor));
    
  pl(DBMS_PROFILER.internal_version_check);
end;
/
