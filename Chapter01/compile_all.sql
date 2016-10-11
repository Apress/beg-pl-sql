set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
                      
@author.tab
@author_100.ins
@author_200.ins
@author_300.ins
@author.upd

@.\solutions\publication.tab
@.\solutions\publication_100.ins
@.\solutions\publication_200.ins
@.\solutions\publication_300.ins
@.\solutions\publication.upd
@.\solutions\publication_300.del

@author_300.del

@author_publication.vw
@author_publication_from_join.vw
@author_publication_where_join.vw

@pl.prc

@worker_type_t.tab
@worker_type_t.ins
@.\solutions\gender_t.tab
@.\solutions\gender_t.ins
@worker_t.tab
@.\solutions\hazard_level_t.tab
@.\solutions\hazard_level_t.ins
@.\solutions\workplace_type_t.tab
@.\solutions\workplace_type_t.ins
@logical_workplace_t.tab
@logical_assignment_t.tab
@.\solutions\physical_workplace_t.tab
@.\solutions\physical_assignment_t.tab
@.\solutions\work_t.tab
@.\solutions\work_assignment_t.tab

spool off;             
set echo off;          
@ci.sql                
@ci.sql                
