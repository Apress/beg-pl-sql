rem insert_with_plsql_cursor_detection_for_update.sql
rem by Donald J. Bales on 12/15/2006
rem An anonymous PL/SQL procedure to insert
rem values using PL/SQL literals and variables

set serveroutput on size 1000000;

declare

cursor c_worker_type(
aiv_code                       in     WORKER_TYPE_T.code%TYPE) is
select id
from   WORKER_TYPE_T
where  code = aiv_code;

cursor c_gender(
aiv_code                       in     GENDER_T.code%TYPE) is
select id
from   GENDER_T
where  code = aiv_code;

cursor c_worker(
aiv_name                       in     WORKER_T.name%TYPE,
aid_birth_date                 in     WORKER_T.birth_date%TYPE,
ain_gender_id                  in     WORKER_T.gender_id%TYPE) is
select id
from   WORKER_T
where  name       = aiv_name
and    birth_date = aid_birth_date
and    gender_id  = ain_gender_id;

cursor c_worker_id is
select WORKER_ID_SEQ.nextval worker_id
from   SYS.DUAL;

cursor c_external_id is
select lpad(to_char(EXTERNAL_ID_SEQ.nextval), 9, '0') external_id
from   SYS.DUAL;

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

-- I'll use these variables to hold the result
-- of the SQL insert and update statements.
n_inserted                            number := 0;
n_updated                             number := 0;

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
    open  c_worker_type('C');
    fetch c_worker_type 
    into  n_worker_type_id;
    if    c_worker_type%notfound then
     raise_application_error(-20001, 
       'Can''t find the worker type ID for Contractor.'||
       ' on select WORKER_TYPE_T'||
       ' in filename insert_with_plsql_cursor_detection_for_update.sql');
    end if;
    close c_worker_type;
  exception
    when OTHERS then
      raise_application_error(-20002, SQLERRM||
        ' on select WORKER_TYPE_T'||
        ' in filename insert_with_plsql_cursor_detection_for_update.sql');
  end;
  
  -- Next, let's get the gender_id for a male
  begin
    open  c_gender('M');
    fetch c_gender 
    into  n_gender_id;
    if    c_gender%notfound then
     raise_application_error(-20003, 
       'Can''t find the gender ID for Male.'||
       ' on select GENDER_T'||
       ' in filename insert_with_plsql_cursor_detection_for_update.sql');
    end if;
    close c_gender;
  exception
    when OTHERS then
      raise_application_error(-20004, SQLERRM||
        ' on select GENDER_T'||
        ' in filename insert_with_plsql_cursor_detection_for_update.sql');
  end;
  
  -- Detect any existing entries with the unique
  -- combination of columns as in this constraint:
  -- constraint   WORKER_T_UK2
  -- unique (
  -- name,
  -- birth_date,
  -- gender_id )
  begin
    open  c_worker(v_name, d_birth_date, n_gender_id);
    fetch c_worker 
    into  n_id;
    if    c_worker%notfound then
      n_id := NULL;
    end if;
    close c_worker;
  exception
    when OTHERS then
      raise_application_error(-20005, SQLERRM||
        ' on select WORKER_T'||
        ' in filename insert_with_plsql_cursor_detection_for_update.sql');
  end;
  
  -- Conditionally insert the row
  if n_id is NULL then
    -- Now, let's get the next worker_id sequence
    begin
    open  c_worker_id;
    fetch c_worker_id 
    into  n_id;
    close c_worker_id;
    exception
      when OTHERS then
        raise_application_error(-20006, SQLERRM||
          ' on select WORKER_ID_SEQ.nextval'||
          ' in filename insert_with_plsql_cursor_detection_for_update.sql');
    end;

    -- And then, let's get the next external_id sequence
    begin
    open  c_external_id;
    fetch c_external_id 
    into  v_external_id;
    if    c_external_id%notfound then
      v_external_id := NULL;
    end if;
    close c_external_id;
    exception
      when OTHERS then
        raise_application_error(-20006, SQLERRM||
          ' on select EXTERNAL_ID_SEQ.nextval'||
          ' in filename insert_with_plsql_cursor_detection_for_update.sql');
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

      n_inserted := sql%rowcount;
    exception
      when OTHERS then
        raise_application_error(-20007, SQLERRM||
          ' on insert WORKER_T'||
          ' in filename insert_with_plsql_cursor_detection_for_update.sql');
    end;
  else
    begin
      update WORKER_T
      set    worker_type_id  = n_worker_type_id
      where  id              = n_id;
      
      n_updated := sql%rowcount;
    exception
      when OTHERS then
        raise_application_error(-20008, SQLERRM||
          ' on update WORKER_T'||
          ' in filename insert_with_plsql_cursor_detection_for_update.sql');
    end;
  end if;
  
  pl(to_char(n_inserted)||' row(s) inserted.');
  pl(to_char(n_updated)||' row(s) updated.');
end;
/

commit;
