insert into WORKER_T (
       id,      
       worker_type_id,
       external_id,    
       first_name,     
       middle_name,    
       last_name,      
       name,           
       birth_date,     
       gender_id)
select WORKER_ID_SEQ.nextval,      
       decode(mod(WORKER_ID_SEQ.currval, 2), 
         0, c1.worker_type_id, c2.worker_type_id),
       lpad(to_char(EXTERNAL_ID_SEQ.nextval), 9, '0'),
       first_name,     
       letter||'.',    
       last_name,
       WORKER_TS.get_formatted_name(
         first_name, letter||'.', last_name),          
       DATES.random(
         to_number(to_char(SYSDATE, 'YYYY')) - 65, 
         to_number(to_char(SYSDATE, 'YYYY')) - 18),     
       decode(gender_code, 'F', c3.gender_id, c4.gender_id)
from   TOP_100_LAST_NAME,
       TOP_100_FIRST_NAME,
       A_THRU_Z,
       WORKER_TYPE_T c1,
       WORKER_TYPE_T c2,
       GENDER_T c3,
       GENDER_T c4
where  c1.code = 'E'
and    c2.code = 'C'
and    c3.code = 'F'
and    c4.code = 'M';
