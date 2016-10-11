update WORKER_T u
set   ( u.worker_type_id,  u.gender_id ) = (
select c1.worker_type_id, c2.gender_id
from   WORKER_TYPE_T c1,
       GENDER_T c2
where  c1.code = decode(instr(u.first_name, 'JOHN'), 0, 'E', 'C')
and    c2.code = decode(instr(u.first_name, 'JOHN'), 0, 'F', 'M') )
where  u.last_name = 'DOE';
