rem worker_type_ov.vw
rem by Donald J. Bales on 12/15/2006
rem Create an object view for table WORKER_TYPE_T

create view WORKER_TYPE_OV of WORKER_TYPE_O 
with object identifier (id) as
select id,      
       code,           
       description,    
       active_date,    
       inactive_date
from   WORKER_TYPE_T;
