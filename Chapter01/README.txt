README.txt for Chapter 1
by Donald J. Bales on 4/15/2007

This is the first of eleven example source directories for the book
"Beginning PL/SQL: From Novice to Professional".  Each example source directory 
for this book contains the source code for the examples in the book, and a
subdirectory solutions that contains the solutions to the exercises.

I doubt that my source code examples are perfect.  So don't assume they are.
I've only tested the source following the text of the book 3 times, so I may 
have missed something.  If you would like to send me a note on any errors, 
please feel free to email me at don@donaldbales.com.  Include the name of the 
source file and a description of the suspected defect.  I will then correct the
problem (given time) and repost my examples.

If you'd like to see more examples of object-relational SQL and PL/SQL, or want
to post your own, please visit http://www.pl-sql.org.


OBJECT NAME                              DESCRIPTION
---------------------------------------  --------------------------------------
author.tab                               Create table AUTHOR

author.upd                               Update table AUTHOR

author_100.ins                           Insert Edgar F Codd into AUTHOR

author_200.ins                           Insert Chris J Date into AUTHOR

author_300.del                           Delete Hugh Darwen from AUTHOR

author_300.ins                           Insert Hugh Darwen into AUTHOR

author_bir.trg                           Create a before insert for each row
                                         trigger against AUTHOR to prevent the 
                                         insert of the name Jonathan Gennick

author_name.sql                          Query author names

author_name_before_1940.sql              Query author names born before 1940

author_pk.pkc                            Create a primary key constraint
                                         against AUTHOR

author_publication.vw                    Create a view of author publications

author_publication_from_join.sql         Query author publications using the
                                         newer table join sytax

author_publication_from_join.vw          Create a view of author publications
                                         using the newer table join syntax

author_publication_where_join.sql        Query author publications using the
                                         traditional table join syntax

author_publication_where_join.vw         Create a view of author publications
                                         using the traditional table join 
                                         syntax

author_uk1.ndx                           Create a unique index against AUTHOR

author_uk1.ukc                           Create a unique constraint against 
                                         AUTHOR

be.sql                                   Show package body compilation errors

ci.sql                                   Compile invalid objects

solutions\coauthor_publication.sql       Query coauthored publications

solutions\coauthor.sql                   Query coauthor names

desc.sql                                 Describe an object

fe.sql                                   Show function compilation errors

solutions\gender_t.ins                   Insert gender code values

solutions\gender_t.tab                   Create table GENDER_T

solutions\hazard_level_t.ins             Insert hazard level code values

solutions\hazard_level_t.tab             Create table HAZARD_LEVEL_T

logical_assignment_t.tab                 Create table LOGICAL_ASSIGNMENT_T

logical_workplace_t.tab                  Create table LOGICAL_WORKPLACE_T

login.sql                                Set my SQL*Plus session defaults

pe.sql                                   Show procedure compilation errors

solutions\physical_assignment_t.tab      Create table PHYSICAL_ASSIGNMENT_T

solutions\physical_workplace_t.tab       Create table PHYSICAL_WORKPLACE_T

pl.sql                                   Stored procedure PL, a short cut for 
                                         calling SYS.DBMS_OUTPUT.put_line()

publication.ins                          Insert publications into PUBLICATION

solutions\publication.tab                Create table PUBLICATION

solutions\publication.upd                Update publications in PUBLICATION

solutions\publication_100.ins            Insert author 100's publications into
                                         PUBLICATION

solutions\publication_200.ins            Insert author 200's publications into
                                         PUBLICATION

solutions\publication_300.del            Delete author 300's publications from
                                         PUBLICATION

solutions\publication_300.ins            Insert author 300's publications into
                                         PUBLICATION

publication_fk1.fkc                      Create a foreign key constraint against
                                         PUBLICATION

solutions\publication_k1.ndx             Create a non-unique index against
                                         PUBLICATION

solutions\publication_pk.pkc             Create a primary key constraint against
                                         PUBLICATION

se.sql                                   Show package specification compilation
                                         errors

solutions\work_assignment_t.tab          Create table WORK_ASSIGNMENT_T

solutions\work_t.tab                     Create table WORK_T

worker_t.tab                             Create table WORKER_T

worker_type_t.ins                        Insert worker type code values

worker_type_t.tab                        Create table WORKER_TYPE_T

solutions\workplace_type_t.ins           Insert workplace type code values

solutions\workplace_type_t.tab           Create table WORKPLACE_TYPE_T
