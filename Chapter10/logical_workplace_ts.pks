create or replace PACKAGE      LOGICAL_WORKPLACE_TS as
/*
logical_workplace_ts.pks <br/>
Copyright by Don Bales on 12/15/2006 <br/>
Table LOGICAL_WORKPLACE_T's methods.  Contains all the supporting service 
methods (functions and procedures) for table LOGICAL_WORKPLACE_T.
*/

-- GLOBAL VARIABLES

-- Keep track of the number of inserts and updates to made by set_row( ).
n_inserted                            number := 0;
n_updated                             number := 0;


/*
Returns an id_context for the specified parent_id and logical_workplace_id.
Whatever creates a new row must also call this mehtod to create an appropriate
id_context value.  Method set_row( ) does this for you.
*/
FUNCTION create_id_context(
ain_parent_id                  in     LOGICAL_WORKPLACE_T.parent_id%TYPE,
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) 
return                                varchar2;


/*
Returns a new primary key id value for a row.
*/
FUNCTION get_id
return                                LOGICAL_WORKPLACE_T.id%TYPE;


/*
Returns the value of a context for the code values in the logical workplace assignment.
*/
FUNCTION get_code_context(
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) 
return                                varchar2;


/*
Returns the value of a context for the id values in the logical workplace assignment.
*/
FUNCTION get_id_context(
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) 
return                                varchar2;


/*
Returns the value of a context for the name values in the logical workplace assignment.
*/
FUNCTION get_name_context(
ain_id                         in     LOGICAL_WORKPLACE_T.id%TYPE) 
return                                varchar2;


/* 
Returns a LOGICAL_WORKPLACE row for the specified criteria.

There are three sets of criteria.  You can retrieve a row by specifying:<br/>
1. the primary key: id<br/>
2. the unique id_context<br/>
3. the code, name, and active_date<br/>

If a match is found the function returns the corresponding row, otherwise
it returns NULL.  It will raise any exceptions except NO_DATA_FOUND.
*/
FUNCTION get_row(
air_logical_workplace          in     LOGICAL_WORKPLACE_T%ROWTYPE)
return                                LOGICAL_WORKPLACE_T%ROWTYPE;  


/*
Test-based help for this package.  "set serveroutput on" in SQL*Plus.
*/
PROCEDURE help;


/* 
Updates or inserts a row matching the passed parameters into table LOGICAL_WORKPLACE_T.
See PROCEDURE set_row( ).
*/
FUNCTION set_row(
ain_parent_id                  in     LOGICAL_WORKPLACE_T.parent_id%TYPE,
ain_workplace_type_id          in     LOGICAL_WORKPLACE_T.workplace_type_id%TYPE,
aiv_code                       in     LOGICAL_WORKPLACE_T.code%TYPE,
aiv_name                       in     LOGICAL_WORKPLACE_T.name%TYPE,
aid_active_date                in     LOGICAL_WORKPLACE_T.active_date%TYPE)
return                                LOGICAL_WORKPLACE_T.id%TYPE;


/* 
Updates or inserts a row matching the passed row into table LOGICAL_WORKPLACE_T.

First, set_row() calls get row to try to find a matching row that already
exists in the database.  So you need to set the id, id_context,
and code, name and active_date appropriately in order to prperly detect an
existing row.

Next, if an existing row is found, any non-key data items are updated to match
the passed row.  Otherwise, and new row is inserted, including the allocation of 
a new primary key and id_context value.  Upon inserting a new value, the 
id and id_context values are updated in the passed row.
See PROCEDURE get_row( );
*/
PROCEDURE set_row(
aior_logical_workplace         in out LOGICAL_WORKPLACE_T%ROWTYPE);


/*
Performs unit tests for this package.
*/
PROCEDURE test;


end LOGICAL_WORKPLACE_TS;
/
@se.sql LOGICAL_WORKPLACE_TS

