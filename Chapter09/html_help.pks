create or replace PACKAGE HTML_HELP as
/*
html_help.pks
by Donald J. Bales on 12/15/2006
Package to create HTML-based help files for packages.
*/

-- Creates a "object_index" html file for the current USER.

PROCEDURE create_index;


-- Creates a "<object_name>" html for each package for the current USER.

PROCEDURE create_help(
aiv_object_name                in     varchar2);


-- Text-based help for this package.  "set serveroutput on" in SQL*Plus.

PROCEDURE help;


PROCEDURE test;


end HTML_HELP;
/
@se.sql HTML_HELP
