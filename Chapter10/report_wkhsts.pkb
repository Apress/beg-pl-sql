create or replace package body REPORT_WKHSTS as
/*
report_wkhsts.pkb
by Donald Bales on 12/15/2006
Worker History Report
*/

-- FORWARD DECLARATION
PROCEDURE set_report(
aior_report_wkhst              in out REPORT_WKHST%ROWTYPE);


FUNCTION get_id
return                                REPORT_WKHST.report_wkhst_id%TYPE is

n_report_wkhst_id                     REPORT_WKHST.report_wkhst_id%TYPE;

begin
  select REPORT_WKHST_ID_SEQ.nextval
  into   n_report_wkhst_id
  from   SYS.DUAL;
  
  return n_report_wkhst_id;
exception
  when OTHERS then  
    raise_application_error(-20000, SQLERRM||
      ' on select REPORT_WKHST_ID_SEQ.nextval'||
      ' in REPORT_WKHSTS.get_id()');
end get_id;


PROCEDURE get_logical_workplace_name(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE,
aid_active_date                in     REPORT_WKHST.active_date%TYPE,
aov_name                          out REPORT_WKHST.logical_workplace_name%TYPE,
aod_inactive_date                 out REPORT_WKHST.inactive_date%TYPE) is

begin
  select w.name,
         nvl(a.inactive_date, DATES.d_max)
  into   aov_name,
         aod_inactive_date
  from   LOGICAL_ASSIGNMENT_T a,
         LOGICAL_WORKPLACE_T w
  where  a.worker_id            = ain_worker_id
  and    aid_active_date  between a.active_date 
                              and nvl(a.inactive_date, DATES.d_max)
  and    a.logical_workplace_id = w.id;
exception
  when NO_DATA_FOUND then
    aov_name          := NULL;
    aod_inactive_date := DATES.d_max;
  when OTHERS then
    raise_application_error(-20001, SQLERRM||
      ' on select LOGICAL_ASSIGNMENT_T, LOGICAL_WORKPLACE_T'||
      ' in REPORT_WKHSTS.get_logical_workplace_name()');
end get_logical_workplace_name;  


PROCEDURE get_physical_workplace_name(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE,
aid_active_date                in     REPORT_WKHST.active_date%TYPE,
aov_name                          out REPORT_WKHST.physical_workplace_name%TYPE,
aod_inactive_date                 out REPORT_WKHST.inactive_date%TYPE) is

begin
  select w.name,
         nvl(a.inactive_date, DATES.d_max)
  into   aov_name,
         aod_inactive_date
  from   PHYSICAL_ASSIGNMENT_T a,
         PHYSICAL_WORKPLACE_T w
  where  a.worker_id             = ain_worker_id
  and    aid_active_date   between a.active_date 
                               and nvl(a.inactive_date, DATES.d_max)
  and    a.physical_workplace_id = w.id;
exception
  when NO_DATA_FOUND then
    aov_name          := NULL;
    aod_inactive_date := DATES.d_max;
  when OTHERS then
    raise_application_error(-20002, SQLERRM||
      ' on select PHYSICAL_ASSIGNMENT_T, PHYSICAL_WORKPLACE_T'||
      ' in REPORT_WKHSTS.get_physical_workplace_name()');
end get_physical_workplace_name;  


PROCEDURE get_work_name(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE,
aid_active_date                in     REPORT_WKHST.active_date%TYPE,
aov_name                          out REPORT_WKHST.work_name%TYPE,
aod_inactive_date                 out REPORT_WKHST.inactive_date%TYPE) is

begin
  select w.name,
         nvl(a.inactive_date, DATES.d_max) 
  into   aov_name,
         aod_inactive_date
  from   WORK_ASSIGNMENT_T a,
         WORK_T w
  where  a.worker_id           = ain_worker_id
  and    aid_active_date between a.active_date 
                             and nvl(a.inactive_date, DATES.d_max)
  and    a.work_id             = w.id;
exception
  when NO_DATA_FOUND then
    aov_name          := NULL;
    aod_inactive_date := DATES.d_max;
  when OTHERS then
    raise_application_error(-20003, SQLERRM||
      ' on select WORK_ASSIGNMENT_T, WORK_T'||
      ' in REPORT_WKHSTS.get_work_name()');
end get_work_name;  


FUNCTION get_report(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE)
return                                REPORT_WKHST.report_wkhst_id%TYPE is

cursor c_date(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE) is
select v1.active_date 
from ( select active_date
       from   LOGICAL_ASSIGNMENT_T
       where  worker_id = ain_worker_id
       UNION
       select active_date
       from   PHYSICAL_ASSIGNMENT_T
       where  worker_id = ain_worker_id
       UNION
       select active_date
       from   WORK_ASSIGNMENT_T
       where  worker_id = ain_worker_id ) v1
order by 1;

d_logical_inactive_date               REPORT_WKHST.inactive_date%TYPE;
d_physical_inactive_date              REPORT_WKHST.inactive_date%TYPE;
d_work_inactive_date                  REPORT_WKHST.inactive_date%TYPE;

r_worker                              WORKER_T%ROWTYPE;

r_report_wkhst                        REPORT_WKHST%ROWTYPE;

begin
  r_report_wkhst.report_wkhst_id  := get_id();
  r_report_wkhst.report_wkhst_seq := 0;

  r_worker.id                := ain_worker_id;
  r_worker                   := WORKER_TS.get_row(r_worker);
  
  r_report_wkhst.worker_id   := r_worker.id;
  r_report_wkhst.worker_name := 
    WORKER_TS.get_formatted_name(
      r_worker.first_name,
      r_worker.middle_name,
      r_worker.last_name);

  for r_date in c_date(ain_worker_id) loop
    r_report_wkhst.active_date := r_date.active_date;

    get_logical_workplace_name(
      r_report_wkhst.worker_id,      
      r_report_wkhst.active_date,
      r_report_wkhst.logical_workplace_name,
      d_logical_inactive_date);

    get_physical_workplace_name(
      r_report_wkhst.worker_id,      
      r_report_wkhst.active_date,
      r_report_wkhst.physical_workplace_name,
      d_physical_inactive_date);
      
    get_work_name(
      r_report_wkhst.worker_id,      
      r_report_wkhst.active_date,
      r_report_wkhst.work_name,
      d_work_inactive_date);
      
    r_report_wkhst.inactive_date :=
      least(
        d_logical_inactive_date,
        d_physical_inactive_date,
        d_work_inactive_date);
        
    set_report(r_report_wkhst);
  end loop;

  commit;

  return r_report_wkhst.report_wkhst_id;
end get_report;


PROCEDURE report(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE,
aiv_to                         in     varchar2) is

cursor c_report_wkhst(
ain_report_wkhst_id            in     REPORT_WKHST.report_wkhst_id%TYPE) is
select initcap(worker_name) worker_name,            
       active_date,            
       initcap(logical_workplace_name) logical_workplace_name, 
       initcap(physical_workplace_name) physical_workplace_name,
       initcap(work_name) work_name,              
       inactive_date          
from   REPORT_WKHST
where  report_wkhst_id = ain_report_wkhst_id
order by report_wkhst_seq;

n_line                                number;
t_lines                               EMAILS.LINES;
n_report_wkhst_id                     REPORT_WKHST.report_wkhst_id%TYPE;
v_worker_name                         REPORT_WKHST.worker_name%TYPE;

begin
  n_report_wkhst_id := get_report(ain_worker_id);

  t_lines(incr(n_line)) := '</pre><table>';
  for r_report_wkhst in c_report_wkhst(n_report_wkhst_id) loop
    if c_report_wkhst%rowcount = 1 then
      v_worker_name         := r_report_wkhst.worker_name;
      t_lines(incr(n_line)) := '<tr><td align="center" colspan="5">'||
        '<big>Work History Report</big></td></tr>';
      t_lines(incr(n_line)) := '<tr><td align="center" colspan="5">'||
        'for '||v_worker_name||'</td></tr>';
      t_lines(incr(n_line)) := '<tr><td align="center" colspan="5">'||
       '</td></tr>';
      t_lines(incr(n_line)) := '<tr>'||
        '<th align="left">Logical</th>'||
        '<th align="left">Physical</th>'||
        '<th align="left"></th>'||
        '<th align="left">Active</th>'||
        '<th align="left">Inactive</th>'||
        '</tr>';
      t_lines(incr(n_line)) := '<tr>'||
        '<th align="left">Workplace</th>'||
        '<th align="left">Workplace</th>'||
        '<th align="left">Work</th>'||
        '<th align="left">Date</th>'||
        '<th align="left">Date</th>'||
        '</tr>';
    end if;
    t_lines(incr(n_line)) := '<tr>'||
      '<td align="left">'||
        r_report_wkhst.logical_workplace_name||'</td>'||
      '<td align="left">'||
        r_report_wkhst.physical_workplace_name||'</td>'||
      '<td align="left">'||
        r_report_wkhst.work_name||'</td>'||
      '<td align="left">'||
        to_char(r_report_wkhst.active_date, 'MM/DD/YYYY')||'</td>'||
      '<td align="left">'||
        to_char(r_report_wkhst.inactive_date, 'MM/DD/YYYY')||'</td>'||
      '</tr>';
  end loop;
  t_lines(incr(n_line)) := '</table><pre>';

  EMAILS.send(
    EMAILS.get_username,
    aiv_to,
    'Work History Report for '||v_worker_name,
    t_lines);
end report;  


PROCEDURE set_report(
aior_report_wkhst              in out REPORT_WKHST%ROWTYPE) is

begin
  aior_report_wkhst.report_wkhst_seq := aior_report_wkhst.report_wkhst_seq + 1;

  if aior_report_wkhst.inactive_date  = DATES.d_max then
    aior_report_wkhst.inactive_date  := NULL;
  end if;
  
  aior_report_wkhst.insert_user      := USER;
  aior_report_wkhst.insert_date      := SYSDATE;
  
  insert into REPORT_WKHST values aior_report_wkhst;
exception
  when OTHERS then
    raise_application_error(-20004, SQLERRM||
      ' on insert REPORT_WKHST'||
      ' in REPORT_WKHSTS.set_report()');
end;         
  
  
end REPORT_WKHSTS;
/
@be.sql REPORT_WKHSTS
