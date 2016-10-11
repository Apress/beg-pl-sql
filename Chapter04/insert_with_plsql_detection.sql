rem insert_with_plsql_detection.sql
rem by Donald J. Bales on 12/15/2006
rem An anonymous PL/SQL procedure to insert
rem values using PL/SQL literals and variables

set serveroutput on size 1000000;

declare

-- I declared these variables so I can get
-- the required ID values before I insert.
n_id                                  WORKER_T.id%TYPE;
n_worker_type_id                      WORKER_T.worker_type_id%TYPE;
v_external_id                         WORKER_T.external_id%TYPE;
v_first_name                          WORKER_T.first_name%TYPE;        
v_middle_name                         WORKER_T.middle_name%TYPE;       
v_last_name                           WORKER_T.last_name%TYPE;         
v_name                                WORKER_T.name%TYPE;              
d_birth_date                          WORKER_T.birth_date%TYPE;        
n_gender_id                           WORKER_T.gender_id%TYPE;

-- I'll use this variable to hold the result
-- of the SQL insert statement.
n_count                               number;

begin
  v_first_name  := 'JOHN';        
  v_middle_name := 'J.';       
  v_last_name   := 'DOE';         
  v_name        := 
    rtrim(v_last_name||', '||v_first_name||' '||v_middle_name);
  d_birth_date  := 
    to_date('19800101', 'YYYYMMDD'); -- I'm guessing

  -- First, let's get the worker_type_id for a contractor
  begin
    select worker_type_id
    into   n_worker_type_id
    from   WORKER_TYPE_T
    where  code = 'C';
  exception
    when OTHERS then
      raise_application_error(-20002, SQLERRM||
        ' on select WORKER_TYPE_T'||
        ' in filename insert_with_plsql_detection.sql');
  end;
  
  -- Next, let's get the gender_id for a male
  begin
    select gender_id
    into   n_gender_id
    from   GENDER_T
    where  code = 'M';
  exception
    when OTHERS then
      raise_application_error(-20004, SQLERRM||
        ' on select GENDER_T'||
        ' in filename insert_with_plsql_detection.sql');
  end;
  
  -- Detect any existing entries with the unique
  -- combination of columns as in this constraint:
  -- constraint   WORKER_T_UK2
  -- unique (
  -- name,
  -- birth_date,
  -- gender_id )
  begin
    select count(1)
    into   n_count
    from   WORKER_T
    where  name       = v_name
    and    birth_date = d_birth_date
    and    gender_id  = n_gender_id;
  exception
    when OTHERS then
      raise_application_error(-20005, SQLERRM||
        ' on select WORKER_T_T'||
        ' in filename insert_with_plsql_detection.sql');
  end;
  
  -- Conditionally insert the row
  if n_count = 0 then
    -- Now, let's get the next id sequence
    begin
      select WORKER_ID_SEQ.nextval
      into   n_id
      from   SYS.DUAL;
    exception
      when OTHERS then
        raise_application_error(-20001, SQLERRM||
          ' on select WORKER_ID_SEQ.nextval'||
          ' in filename insert_with_plsql_detection.sql');
    end;

    -- And then, let's get the next external_id sequence
    begin
      select lpad(to_char(EXTERNAL_ID_SEQ.nextval), 9, '0')
      into   v_external_id
      from   SYS.DUAL;
    exception
      when OTHERS then
        raise_application_error(-20003, SQLERRM||
          ' on select EXTERNAL_ID_SEQ.nextval'||
          ' in filename insert_with_plsql_detection.sql');
    end;
  
    -- Now that we have all the necessary ID values
    -- we can finally insert a row!
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
      values (
             n_id,      
             n_worker_type_id, 
             v_external_id,    
             v_first_name,     
             v_middle_name,    
             v_last_name,      
             v_name,           
             d_birth_date,     
             n_gender_id );    

      n_count := sql%rowcount;
    exception
      when OTHERS then
        raise_application_error(-20006, SQLERRM||
          ' on insert WORKER_T'||
          ' in filename insert_with_plsql_detection.sql');
    end;
  else
    n_count := 0;
  end if;
  
  pl(to_char(n_count)||' row(s) inserted.');
end;
/

commit;
