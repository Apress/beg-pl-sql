rem create_relational.sql
rem by Donald J. Bales on 12/15/2006
rem Create all the relational tables

set echo      on;
set linesize  1000;
set newpage   1;
set pagesize  32767;
set trimspool on;

spool create_relational.txt;

@pl.prc
@drop_if_exists.prc
@drop_relational.sql

@top_100_first_name.tab
@a_thru_z.tab
@top_100_last_name.tab

-- tables in order of dependence
@worker_type_t.tab
@gender_t.tab
@worker_t.tab

@workplace_type_t.tab
@logical_workplace_t.tab
@logical_assignment_t.tab
@physical_workplace_t.tab
@physical_assignment_t.tab
@work_t.tab
@work_assignment_t.tab

@substance_t.tab
@hazard_level_t.tab
@task_t.tab
@work_task_t.tab
@task_substance_t.tab

-- codes
@gender_t.ins
@hazard_level_t.ins
@substance_t.ins
@worker_type_t.ins
@workplace_type_t.ins

-- package specs
@dates.pks
@workplace_type_ts.pks
@logical_workplace_ts.pks

-- package bodies
@dates.pkb
@workplace_type_ts.pkb
@logical_workplace_ts.pkb

-- content
@logical_workplace_t.ins

spool off;

set echo off;
@ci.sql
