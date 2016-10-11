rem worker_t_ins_insert_timing.sql
rem by Donald J. Bales on 12/15/2006
rem Seed the Worker table with the top 100 names
rem 100 last x 100 first x 26 middle = 260,000 entries

set serveroutput on size 1000000;

declare

-- This is the number of seconds since midnight
-- I'll use it to profile my code's performance.
n_start                               number;

-- Here, I declare four psuedo-constants to hold the
-- ID values from the code tables, rather than look
-- them up repeatedly during the insert process.
n_G_FEMALE                            GENDER_T.gender_id%TYPE;
n_G_MALE                              GENDER_T.gender_id%TYPE;
n_WT_CONTRACTOR                       WORKER_TYPE_T.worker_type_id%TYPE;
n_WT_EMPLOYEE                         WORKER_TYPE_T.worker_type_id%TYPE;

-- I'll use this to keep track of the number of 
-- rows inserted.
n_inserted                            number := 0;

begin
  -- Get the ID values for the codes
  n_G_FEMALE      := GENDER_TS.get_id('F');
  n_G_MALE        := GENDER_TS.get_id('M');
  n_WT_CONTRACTOR := WORKER_TYPE_TS.get_id('C');
  n_WT_EMPLOYEE   := WORKER_TYPE_TS.get_id('E');

  -- Delete any existing entries
  delete WORKER_T;
  
  commit;
  
  -- Use an INSERT INTO SELECT SQL statement
  n_start :=   to_number(to_char(SYSDATE, 'SSSSS'));

  insert into WORKER_T (
         id,      
         worker_type_id,
         external_id,    
         first_name,     
         middle_name,    
         last_name,      
         name,           
         birth_date,     
         gender_id)
  select WORKER_ID_SEQ.nextval,      
         decode(mod(WORKER_ID_SEQ.currval, 2), 
           0, n_WT_EMPLOYEE, n_WT_CONTRACTOR),
         lpad(to_char(EXTERNAL_ID_SEQ.nextval), 9, '0'),
         first_name,     
         letter||'.',    
         last_name,
         WORKER_TS.get_formatted_name(
           first_name, letter||'.', last_name),          
         DATES.random(
           to_number(to_char(SYSDATE, 'YYYY')) - 65, 
           to_number(to_char(SYSDATE, 'YYYY')) - 18),     
         decode(gender_code, 'F', n_G_FEMALE, n_G_MALE)
  from   TOP_100_LAST_NAME,
         TOP_100_FIRST_NAME,
         A_THRU_Z;

  n_inserted := n_inserted + sql%rowcount;

  pl(to_char(n_inserted)||' rows inserted in '||
    (to_number(to_char(SYSDATE, 'SSSSS')) - n_start)||
    ' seconds.');

  commit;
end;
/
