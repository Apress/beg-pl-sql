rem drop_relational.sql
rem by Donald J. Bales on 12/15/2006
rem Drop the relational tables

set feedback off;

rem create the procedure drop_if_exists used in this script

@drop_if_exists.prc

rem drop package specs

exec drop_if_exists('PACKAGE', 'TASK_SUBSTANCE_TS');
exec drop_if_exists('PACKAGE', 'WORK_TASK_TS');
exec drop_if_exists('PACKAGE', 'TASK_TS');
exec drop_if_exists('PACKAGE', 'HAZARD_LEVEL_TS');
exec drop_if_exists('PACKAGE', 'SUBSTANCE_TS');
exec drop_if_exists('PACKAGE', 'WORK_ASSIGNMENT_TS');
exec drop_if_exists('PACKAGE', 'WORK_TS');
exec drop_if_exists('PACKAGE', 'PHYSICAL_ASSIGNMENT_TS');
exec drop_if_exists('PACKAGE', 'PHYSICAL_WORKPLACE_TS');
exec drop_if_exists('PACKAGE', 'LOGICAL_ASSIGNMENT_TS');
exec drop_if_exists('PACKAGE', 'LOGICAL_WORKPLACE_TS');
exec drop_if_exists('PACKAGE', 'WORKPLACE_TYPE_TS');
exec drop_if_exists('PACKAGE', 'WORKER_TS');
exec drop_if_exists('PACKAGE', 'GENDER_TS');
exec drop_if_exists('PACKAGE', 'WORKER_TYPE_TS');

rem drop relational tables, indexes, and foreign keys

exec drop_if_exists('TABLE', 'TASK_SUBSTANCE_T');
exec drop_if_exists('TABLE', 'WORK_TASK_T');
exec drop_if_exists('TABLE', 'TASK_T');
exec drop_if_exists('TABLE', 'HAZARD_LEVEL_T');
exec drop_if_exists('TABLE', 'SUBSTANCE_T');
exec drop_if_exists('TABLE', 'WORK_ASSIGNMENT_T');
exec drop_if_exists('TABLE', 'WORK_T');
exec drop_if_exists('TABLE', 'PHYSICAL_ASSIGNMENT_T');
exec drop_if_exists('TABLE', 'PHYSICAL_WORKPLACE_T');
exec drop_if_exists('TABLE', 'LOGICAL_ASSIGNMENT_T');
exec drop_if_exists('TABLE', 'LOGICAL_WORKPLACE_T');
exec drop_if_exists('TABLE', 'WORKPLACE_TYPE_T');
exec drop_if_exists('TABLE', 'WORKER_T');
exec drop_if_exists('TABLE', 'GENDER_T');
exec drop_if_exists('TABLE', 'WORKER_TYPE_T');

rem drop sequences

exec drop_if_exists('SEQUENCE', 'TASK_SUBSTANCE_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'WORK_TASK_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'TASK_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'HAZARD_LEVEL_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'SUBSTANCE_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'WORK_ASSIGNMENT_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'WORK_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'PHYSICAL_ASSIGNMENT_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'PHYSICAL_WORKPLACE_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'LOGICAL_ASSIGNMENT_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'LOGICAL_WORKPLACE_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'WORKPLACE_TYPE_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'EXTERNAL_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'WORKER_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'GENDER_ID_SEQ');
exec drop_if_exists('SEQUENCE', 'WORKER_TYPE_ID_SEQ');

set feedback on;
