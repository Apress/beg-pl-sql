create or replace package REPORT_WKHSTS as
/*
report_wkhsts.pks
by Donald Bales on 12/15/2006
Worker History Report
*/

FUNCTION get_report(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE)
return                                REPORT_WKHST.report_wkhst_id%TYPE;


PROCEDURE report(
ain_worker_id                  in     REPORT_WKHST.worker_id%TYPE,
aiv_to                         in     varchar2);


end REPORT_WKHSTS;
/
@se.sql REPORT_WKHSTS
