create or replace package body TOP_100_NAMES as
/*
top_100_names.pkb
by Donald J. Bales on 12/15/2006

Data Migration:
  Seed the Worker table with the top 100 names
  100 last x 100 first x 26 middle = 260,000 entries
*/


-- Here, I declare four psuedo-constants to hold the
-- ID values from the code tables, rather than look
-- them up repeatedly during the insert process.
n_G_FEMALE                            GENDER_T.id%TYPE;
n_G_MALE                              GENDER_T.id%TYPE;
n_WT_CONTRACTOR                       WORKER_TYPE_T.id%TYPE;
n_WT_EMPLOYEE                         WORKER_TYPE_T.id%TYPE;



FUNCTION create_birth_date( 
aiv_name                       in     WORKER_T.name%TYPE) 
return                                WORKER_T.birth_date%TYPE is

n_day                                 number;
n_name                                number := 0;
n_month                               number;
n_year                                number;

begin
  for i in 1..length(aiv_name) loop
    n_name  := n_name + ascii(substr(aiv_name, i, 1));
  end loop;
  n_year    := n_name + 1000;
  loop
    if n_year between 1939 and 1990 then
      exit;
    end if;
    n_year  := round(n_year/2, 0);
    if n_year < 1939 then
      n_year := n_year * 3;
    end if;
  end loop;
  n_month   := n_name;
  loop
    if n_month between 1 and 12 then
      exit;
    end if;
    n_month := round(n_month/2, 0);
    if n_month < 1 then
      n_month := 1;
    end if;
  end loop;
  n_day     := n_name;
  loop
    if n_day between 1 and 28 then
      exit;
    end if;
    n_day   := round(n_day/2, 0);
    if n_day < 1 then
      n_day := 1;
    end if;
  end loop;
  return to_date(
    to_char(n_month)||'/'||
    to_char(n_day)||'/'||
    to_char(n_year), 
    'MM/DD/YYYY');
end create_birth_date;


PROCEDURE Initialize is

begin
  -- Get the ID values for these codes
  n_G_FEMALE      := GENDER_TS.get_id('F');
  n_G_MALE        := GENDER_TS.get_id('M');
  n_WT_CONTRACTOR := WORKER_TYPE_TS.get_id('C');
  n_WT_EMPLOYEE   := WORKER_TYPE_TS.get_id('E');
exception
  when OTHERS then
    raise_application_error(-20000, SQLERRM||
      ' on initialization'||
      ' in TOP_100_NAMES.initialize()');
end Initialize;


PROCEDURE help is

begin
  TEXT_HELP.process('TOP_100_NAMES');
end help;


PROCEDURE Process is

-- This is the cursor for the last names.
cursor c_last is
select last_name
from   TOP_100_LAST_NAME
order by 1;

-- This is the cursor for the first names.
cursor c_first is
select first_name,
       gender_code
from   TOP_100_FIRST_NAME
order by 1;

-- This is the cursor for the middle initials.
cursor c_middle is
select letter
from   A_THRU_Z
order by 1;

-- This is the number of seconds since midnight
-- I'll use it to profile my code's performance.
n_start                               number := 
  to_number(to_char(SYSDATE, 'SSSSS'));

-- I'll use this to keep track of how many rows were selected
n_selected                            number := 0;

-- Here, I declare a record anchored to the table so
-- I can set the column values and then insert using
-- the record.
r_worker                              WORKER_T%ROWTYPE;

begin
  -- Reset the insert/update counters for set_row()
  WORKER_TS.n_inserted := 0;
  WORKER_TS.n_updated  := 0;
  
  -- Loop through the last names
  for r_last in c_last loop

    -- While looping through the last names,
    -- loop through the first names
    for r_first in c_first loop

      -- While looping through the last and first names
      -- loop through the 26 letters in the English
      -- Alphabet in order to get middle initials
      for r_middle in c_middle loop
        n_selected                := n_selected + 1;
        -- Initialize the record

        -- Set the PK to NULL so set_row() determines
        -- whether or not the entry already exists
        -- by it's unique keys
        r_worker.id               := NULL;

        -- Flip flop from contractor to employee and back again
        if r_worker.worker_type_id = n_WT_CONTRACTOR then
          r_worker.worker_type_id := n_WT_EMPLOYEE;
        else  
          r_worker.worker_type_id := n_WT_CONTRACTOR;
        end if;

        -- Set the External ID, UK1, to NULL so set_row() determines
        -- whether or not the entry already exists
        -- by it's unique keys
        r_worker.external_id      := NULL;

        -- The first, middle, and last names come from the cursors
        r_worker.first_name       := r_first.first_name;
        r_worker.middle_name      := r_middle.letter||'.';
        r_worker.last_name        := r_last.last_name;

        -- get the name using the table's package
        r_worker.name             := WORKER_TS.get_formatted_name(
          r_worker.first_name, r_worker.middle_name, r_worker.last_name);

        -- get the date from determinate function create_birth_date()
        r_worker.birth_date       := create_birth_date(r_worker.name);

        -- select the corresponding ID value
        if r_first.gender_code = 'F' then
          r_worker.gender_id      := n_G_FEMALE;
        else
          r_worker.gender_id      := n_G_MALE;
        end if;

        -- Insert the row into the database
        begin
          WORKER_TS.set_row(r_worker);
        exception
          when OTHERS then
            raise_application_error(-20001, SQLERRM||
              ' on call WORKER_TS.set_row()'||
              ' in TOP_100_NAMES.process()');
        end;
      end loop; -- c_middle

      commit;  -- commit every 26 rows
    
    end loop; -- c_first
    
  end loop; -- c_last

  -- Display the results
  pl(to_char(n_selected)||' rows selected');
  pl(to_char(WORKER_TS.n_inserted)||' rows inserted');
  pl(to_char(WORKER_TS.n_updated)||' rows updated');
  pl('in '||to_char(to_number(to_char(SYSDATE, 'SSSSS')) - n_start)||
    ' seconds.');
end process;


PROCEDURE test is

d_birth_date_1                        date;
d_birth_date_2                        date;

begin
  -- Send feedback that the test ran
  pl('TOP_100_NAMES.test()');
  
  -- Clear the last set of test results
  TEST_TS.clear('TOP_100_NAMES');
  
  -- Tests
  TEST_TS.set_test('TOP_100_NAMES', 'initialize()', 0, 
    'Package Initialization');
  begin
    initialize();
    
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('TOP_100_NAMES', 'create_birth_date()', 1, 
    'Is create_birth_date a determinate function?');
  begin
    d_birth_date_1 := create_birth_date('Bales, Donald J.');
    d_birth_date_2 := create_birth_date('Bales, Donald J.');
    
    if d_birth_date_1 = d_birth_date_2 then
      TEST_TS.ok();
    else
      TEST_TS.error();
    end if;
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('TOP_100_NAMES', 'process()', 2, 
    'This method cannot be tested by test(), please test it manually.');
  begin
    TEST_TS.ok();
  exception
    when OTHERS then
      TEST_TS.error(SQLERRM);
  end;
  
  TEST_TS.set_test('TOP_100_NAMES', NULL, NULL, NULL);
  TEST_TS.success();
end test;


begin
  -- Initialize the package
  initialize();
end TOP_100_NAMES;
/
@be.sql
