rem report_wkhsts.get_report.sql
rem by Donald J. Bales on 12/15/2006
rem Test Unit for REPORT_WKHST_TS.get_report()

column worker_name             format a21 trunc;
column logical_workplace_name  format a11 trunc;
column physical_workplace_name format a11 trunc;
column work_name               format a11 trunc;
column active_date             format a8;
column inactive_date           format a8;

execute pl('report_wkhst_id='||to_char(REPORT_WKHSTS.get_report(11649889)));

select worker_name,
       logical_workplace_name,
       physical_workplace_name,
       work_name,
       to_char(active_date,   'YYYYMMDD') active_date,
       to_char(inactive_date, 'YYYYMMDD') inactive_date
from   REPORT_WKHST
where  report_wkhst_id = &report_wkhst_id
order by report_wkhst_seq;
