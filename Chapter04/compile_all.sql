set echo      on;      
set linesize  1000;    
set newpage   1;       
set pagesize  32767;   
set trimspool on;      
spool compile_all.txt; 
spool off;             
set echo off;          
@ci.sql                
@ci.sql                
