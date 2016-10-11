rem select_no_data_found.sql
rem by Donald J. Bales on 12/15/2006
rem An anonymous PL/SQL procedure to select
rem values using PL/SQL literals and variables

set serveroutput on size 1000000;

declare

d_birth_date                          WORKER_T.birth_date%TYPE;        
n_gender_id                           WORKER_T.gender_id%TYPE;
n_selected                            number := -1;
n_id                                  WORKER_T.id%TYPE;
v_first_name                          WORKER_T.first_name%TYPE;        
v_last_name                           WORKER_T.last_name%TYPE;         
v_middle_name                         WORKER_T.middle_name%TYPE;       
v_name                                WORKER_T.name%TYPE;              

begin
  v_first_name  := 'JOHN';        
  v_middle_name := 'J.';       
  v_last_name   := 'DOUGH'; -- Wrong DOE, this will raise an exception
  v_name        := 
    rtrim(v_last_name||', '||v_first_name||' '||v_middle_name);
  d_birth_date  := 
    to_date('19800101', 'YYYYMMDD'); -- I'm guessing

  begin
    select gender_id
    into   n_gender_id
    from   GENDER_T
    where  code = 'M';
  exception
    when OTHERS then
      raise_application_error(-20001, SQLERRM||
        ' on select GENDER_T'||
        ' in filename select_no_data_found.sql');
  end;
  
  begin
    select id
    into   n_id
    from   WORKER_T
    where  name       = v_name
    and    birth_date = d_birth_date
    and    gender_id  = n_gender_id;

    n_selected := sql%rowcount;
  exception
    when NO_DATA_FOUND then
      n_selected := sql%rowcount;
      pl('Caught raised exception NO_DATA_FOUND');
    when OTHERS then
      raise_application_error(-20002, SQLERRM||
        ' on select WORKER_T'||
        ' in filename select_no_data_found.sql');
  end;
  
  pl(to_char(n_selected)||' row(s) selected.');
end;
/

