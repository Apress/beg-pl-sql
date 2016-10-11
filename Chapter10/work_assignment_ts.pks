create or replace PACKAGE WORK_ASSIGNMENT_TS as
/*
work_assignment_ts.pks
by Donald J. Bales on 12/15/2006
Table WORK_ASSIGNMENT_T's methods
*/

-- GLOBAL VARIABLES
-- Keep track of the number of inserts and updates to made by set_row().
n_inserted                            number := 0;
n_updated                             number := 0;

/*
Returns a new primary key id value for a row.
*/
FUNCTION get_id
return                                WORK_ASSIGNMENT_T.id%TYPE;

/*
Returns a the WORK row for the specified worker_id and on the specified date.
*/
FUNCTION get_work(
ain_worker_id                  in     WORK_ASSIGNMENT_T.worker_id%TYPE,
aid_on                         in     WORK_ASSIGNMENT_T.active_date%TYPE)
return                                WORK_T%ROWTYPE;

/*
Returns a the current WORK row for the specified worker_id.
*/
FUNCTION get_work(
ain_worker_id                  in     WORK_ASSIGNMENT_T.worker_id%TYPE)
return                                WORK_T%ROWTYPE;

/* 
Returns a WORK_ASSIGNMENT row for the specified criteria.
<br/>
There are two sets of criteria.  You can retrieve a row by specifying:<br/>
1. the primary key: id<br/>
2. the woker_id and active_date<br/>
<br/>
If a match is found the function returns the corresponding row, otherwise
it returns NULL.  It will raise any exceptions except NO_DATA_FOUND.
*/
FUNCTION get_row(
air_work_assignment            in     WORK_ASSIGNMENT_T%ROWTYPE)
return                                WORK_ASSIGNMENT_T%ROWTYPE;  

/*
 Test-based help for this package.  "set serveroutput on" in SQL*Plus.
*/
PROCEDURE help;

/*
Returns TRUE if the worker has a work assignment on the specified date, otherwise FALSE.
*/
FUNCTION is_active(
ain_worker_id                  in     WORK_ASSIGNMENT_T.worker_id%TYPE,
aid_on                         in     date)
return                                boolean;

/*
Returns TRUE if the worker currently has a work assignment, otherwise FALSE.
*/
FUNCTION is_active(
ain_worker_id                  in     WORK_ASSIGNMENT_T.worker_id%TYPE)
return                                boolean;

/* 
Updates or inserts a row matching the passed row into table WORK_WORKPLACE_T.
<br/>
First, set_row( ) calls get_row( ) to try to find a matching row that already
exists in the database.  So you need to set the id, or worked_id
and active_date appropriately in order to properly detect an existing row.<br/>
<br/>
Next, if an existing row is found, any non-key data items are updated to match
the passed row.  Otherwise a new row is inserted, including the allocation of 
a new primary key value.  Upon inserting a new value, the id 
value is updated in the passed row.<br/>
See PROCEDURE get_row( );
*/
PROCEDURE set_row(
aior_work_assignment           in out WORK_ASSIGNMENT_T%ROWTYPE);

/*
The test unit for this package.
*/
PROCEDURE test;


end WORK_ASSIGNMENT_TS;
/
@be.sql WORK_ASSIGNMENT_TS
