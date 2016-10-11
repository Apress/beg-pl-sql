rem insert_with_sql_detection.sql
rem by Donald J. Bales on 12/15/2006
rem An anonymous PL/SQL procedure to insert
rem values using PL/SQL literals and variables

set serveroutput on size 1000000;

declare

v_first_name                          WORKER_T.first_name%TYPE;        
v_middle_name                         WORKER_T.middle_name%TYPE;       
v_last_name                           WORKER_T.last_name%TYPE;         
v_name                                WORKER_T.name%TYPE;              
d_birth_date                          WORKER_T.birth_date%TYPE;        

-- I'll use this variable to hold the result
-- of the SQL insert statement.
n_count                               number;

begin
  -- Since I use these values more than once,
  -- I set them here, and then use the variables
  v_first_name  := 'JOHN';        
  v_middle_name := 'J.';       
  v_last_name   := 'DOE';         
  v_name        := 
    rtrim(v_last_name||', '||v_first_name||' '||v_middle_name);
  d_birth_date  := 
    to_date('19800101', 'YYYYMMDD'); -- I'm guessing

  -- Now I can just let SQL do all the work.  Who needs PL/SQL!
  begin
    insert into WORKER_T (
           id,      
           worker_type_id,
           external_id,    
           first_name,     
           middle_name,    
           last_name,      
           name,           
           birth_date,     
           gender_id )
    select WORKER_ID_SEQ.nextval,
           c1.worker_type_id, 
           lpad(to_char(EXTERNAL_ID_SEQ.nextval), 9, '0'),    
           v_first_name,     
           v_middle_name,    
           v_last_name,      
           v_name,           
           d_birth_date,     
           c2.gender_id
    from   WORKER_TYPE_T c1,
           GENDER_T c2
    where  c1.code = 'C'
    and    c2.code = 'M'
    and not exists (
      select 1
      from   WORKER_T x
      where  x.name = v_name
      and    x.birth_date = d_birth_date
      and    x.gender_id  = c2.gender_id );

    n_count := sql%rowcount;
  exception
    when OTHERS then
      raise_application_error(-20006, SQLERRM||
        ' on insert WORKER_T'||
        ' in filename insert_with_sql_detection.sql');
  end;
  
  pl(to_char(n_count)||' row(s) inserted.');
end;
/

commit;
