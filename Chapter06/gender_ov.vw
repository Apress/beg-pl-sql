rem gender_ov.vw
rem by Donald J. Bales on 12/15/2006
rem Create an object view for table GENDER_T

create view GENDER_OV of GENDER_O 
with object identifier (id) as
select id,      
       code,           
       description,    
       active_date,    
       inactive_date
from   GENDER_T;
