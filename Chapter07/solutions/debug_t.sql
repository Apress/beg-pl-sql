define unique_session_id=&1;

set feedback off;

declare

cursor c1(
ain_id                         in     number,
aiv_unique_session_id          in     varchar2) is
select id,
       text
from   DEBUG_T
where  id                > ain_id
and    unique_session_id = upper(aiv_unique_session_id)
order by id;

begin
  for r1 in c1(DEBUG_TS.n_id, '&unique_session_id') loop
    pl(r1.text);
    DEBUG_TS.n_id := r1.id;
  end loop;
end;
/
