create or replace PACKAGE WORK_TS as
/*
work_ts.pks <br/>
by Donald Bales on 12/15/2006 <br/>
Table WORK_T's methods.  Contains all the supporting service 
methods (functions and procedures) for table WORK_T.
*/

-- GLOBAL VARIABLES

-- Keep track of the number of inserts and updates to made by set_row( ).
n_inserted                            number := 0;
n_updated                             number := 0;

/*
Returns a new primary key id value for a row.
*/
FUNCTION get_id
return                                WORK_T.id%TYPE;

/* 
Returns a WORK row for the specified criteria.

There are three sets of criteria.  You can retrieve a row by specifying:<br/>
1. the primary key: work_id<br/>
2. the unique id_context<br/>
3. the code, name, and active_date<br/>

If a match is found the function returns the corresponding row, otherwise
it returns NULL.  It will raise any exceptions except NO_DATA_FOUND.
*/
FUNCTION get_row(
air_work                       in     WORK_T%ROWTYPE)
return                                WORK_T%ROWTYPE;  

/*
Text-based help for this package.
*/
PROCEDURE help;

/* 
Updates or inserts a row matching the passed row into table WORK_T.

First, set_row() calls get row to try to find a matching row that already
exists in the database.  So you need to set the work_id, id_context,
and code, name and active_date appropriately in order to prperly detect an
existing row.

Next, if an existing row is found, any non-key data items are updated to match
the passed row.  Otherwise, and new row is inserted, including the allocation of 
a new primary key and id_context value.  Upon inserting a new value, the 
work_id and id_context values are updated in the passed row.
See PROCEDURE get_row( );
*/
PROCEDURE set_row(
aior_work                      in out WORK_T%ROWTYPE);

/*
Parametric version of set_row()
*/
PROCEDURE set_row(
aiv_code                       in     WORK_T.code%TYPE,
aiv_name                       in     WORK_T.name%TYPE,
aid_active_date                in     WORK_T.active_date%TYPE,
aid_inactive_date              in     WORK_T.inactive_date%TYPE);

/*
Performs unit tests for this package.
*/
PROCEDURE test;


end WORK_TS;
/
@se.sql WORK_TS
