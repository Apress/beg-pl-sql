delete work_assignment_t;
commit;
delete work_t;
commit;
delete physical_assignment_t;
commit;
delete physical_workplace_t;
commit;
delete logical_assignment_t;
commit;
delete logical_workplace_t;
commit;

@logical_workplace_t.ins
@logical_assignment_t.ins
@physical_workplace_t.ins
@physical_assignment_t.ins
@work_t.ins
@work_assignment_t.ins

column worker format a18;
column work   format a18;

select r.worker_id,
       r.name worker,
       k.name work,
       a.active_date,
       a.inactive_date
from   WORKER_T r,
       WORK_T k,
       WORK_ASSIGNMENT_T a
where  a.worker_id = r.worker_id
and    a.work_id   = k.work_id
and    2 < (
select count(1)
from   WORK_ASSIGNMENT_T g
where  g.worker_id = a.worker_id)
and exists (
select 1
from   WORK_ASSIGNMENT_T x
where  x.worker_id = a.worker_id
and    x.inactive_date is NULL)
and rownum < 21
order by 1, 3;


