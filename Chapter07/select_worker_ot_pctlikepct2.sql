select /*+ INDEX(WORKER_OT WORKER_OT_UK2) */
       *
from   WORKER_OT 
where  name like '%DOE%'
order by 1;
